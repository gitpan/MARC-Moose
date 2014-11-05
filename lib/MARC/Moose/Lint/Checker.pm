package MARC::Moose::Lint::Checker;
# ABSTRACT: A class to 'lint' biblio record based on a rules file
$MARC::Moose::Lint::Checker::VERSION = '1.0.9';
use Moose;
use Modern::Perl;
use YAML;


has file => (is => 'rw');

has rules => (is => 'rw');

has table => (is => 'rw', isa => 'HashRef', default => sub { {} });


sub BUILD {
    my $self = shift;

    my $file = $self->file;
    unless (-f $file) {
        say "$file: isn't a file";
        exit;
    }
    open my $fh, "<", $file;
    my @rules;
    my @parts;
    my $linenumber = 0;
    while (<$fh>) {
        $linenumber++;
        chop;
        s/ *$//;
        last if /^====/;

        if ( length($_) ) {
            push @parts, $_;
            next;
        }
        #say;
        if (@parts < 4 && @parts != 1) {
            say;
            say "Line $linenumber: Invalid rule: must contain at least four parts: $_";
            exit;
        }
        my ($tag, $ind1, $ind2) = (shift @parts, shift @parts, shift @parts);
        my @rule = ();
        if ( $tag !~ /^[0-9]{3}[_|\+]*/ ) {
            say;
            say "Line $linenumber: Invalid tag portion";
            exit;
        }

        $tag =~ /([0-9]{3})/;
        push @rule, $1;
        push @rule, $tag =~ /_/ ? 1 : 0;
        push @rule, $tag =~ /\+/ ? 1 : 0;

        push @rule, [$ind1, $ind2];

        my @subf = map {
            my @letter;
            /^([a-zA-Z0-9\+_A-Z]*) *(.*)$/;
            my ($letter, $regexp) = ($1, $2);
            push @letter, substr($letter, 0, 1);
            push @letter, $letter =~ /_/ ? 1 : 0;
            push @letter, $letter =~ /\+/ ? 1 : 0;
            push @letter, ($letter =~ /([A-Z]+)/ ? $1 : 0);
            push @letter, $regexp if $regexp;
            \@letter;
        } @parts;
        push @rule, \@subf;
        #say Dump(\@rule);

        push @rules, \@rule;
        @parts = ();
    }
    $self->rules(\@rules);

    my $code;
    if ( /^====/ ) {
        while (1) {
            if (/^==== *([A-Z]*)/) {
                ($code) = $1;
            }
            else {
                $self->table->{$code}->{$_} = 1;
            }
            while (<$fh>) {
                chop;
                last if $_;
            }
            last unless $_;
            s/^ *//;
            s/ *$//;
        }
    }
}


sub check {
    my ($self, $record) = @_;

    my @ret;
    my $tag;        # Current tag
    my @fields;     # Array of fields;
    my $i_field;    # Indice in the current array of fields
    my $append = sub {
        my @text = ($tag);
        push @text, "($i_field)" if @fields > 1;
        push @text, ": ", shift;
        push @ret, join('', @text);
    };
    for my $rule (@{$self->rules}) {
        my ($mandatory, $repeatable, $ind, $subf);
        ($tag, $mandatory, $repeatable, $ind, $subf) = @$rule;
        @fields = $record->field($tag);
        unless (@fields) {
            push @ret, "$tag: missing mandatory field" if $mandatory;
            next;
        }
        push @ret, "$tag: non-repeatable field"  if !$repeatable && @fields > 1;

        $i_field = 1;
        for my $field (@fields) {
            if ( $tag ge '010' ) {
                for (my $i=1; $i <=2 ; $i++) {
                    my $value = $i == 1 ? $field->ind1 : $field->ind2;
                    my $regexp = $ind->[$i-1];
                    $regexp =~ s/#/ /g;
                    $regexp =~ s/,/|/g;
                    $append->("invalid indicator $i, must be " . $ind->[$i-1])
                        if $value !~ /[$regexp]/;
                }
            }
            for (@$subf) {
                my ($letter, $mand, $repet, $table, $regexp) = @$_;
                my @values = $field->subfield($letter);
                $append->("\$$letter mandatory subfield is missing")
                    if @values == 0 && $mand;
                $append->("\$$letter is repeated") if @values > 1 && !$repet;
                if ($regexp) {
                    my $i = 1;
                    my $multi = @values > 1;
                    for my $value (@values) {
                        if ( $table && ! $self->table->{$table}->{$value} ) {
                            $append->(
                                "invalid subfield '\$$letter" .
                                ($multi ? "($i)" : "") .
                                " $value' not in $table table");
                        }
                        if ( $value !~ /$regexp/ ) {
                            $append->(
                                "invalid subfield \$$letter" .
                                ($multi ? "($i)" : "") .
                                ", should be $regexp");
                        }
                        $i++;
                    }
                }
            }
            $i_field++;
        }
    }

    return @ret;
}


__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

MARC::Moose::Lint::Checker - A class to 'lint' biblio record based on a rules file

=head1 VERSION

version 1.0.9

=head1 ATTRIBUTES

=head2 file

Name of the file containing validation rules based on which a biblio record can
be validated.

=head1 METHODS

=head2 check( I<record> )

This method checks a biblio record, based on the current 'lint' object. The
biblio record is a L<MARC::Moose::Record> object. An array of validation
errors/warnings is returned. Those errors are just plain text explanation on
the reasons why the record doesn't comply with validation rules.

=head1 SYNOPSYS

 use MARC::Moose::Record;
 use MARC::Moose::Reader::File::Iso2709;
 use MARC::Moose::Lint::Checker;

 # Read an ISO2709 file, and dump found errors
 my $reader = MARC::Moose::Reader::File::Iso2709->new(
     file => 'biblio.mrc' );
 my $lint = MARC::Moose::Lint::Checker->new(
     file => 'unimarc.rules' );
 while ( my $record = $reader->read() ) {
     if ( my @result = $lint->check($record) ) {
         say "Biblio record #", $record->field('001')->value;
         say join("\n", @result), "\n";
     }
 }

=head1 VALIDATION RULES

Validation rules are defined in a textual form. The file is composed of two
parts: (1) field rules, (2) validation tables.

(1) Field rules define validation rules for each tag. A blank line separates
tags. For example:

 102+
 #
 #
 a+CTRY
 b+
 c+
 2+

Line 1 contains the field tag. If a + is present, the field is repeatable. If a
_ is present, the field is mandatory. Line 2 and 3 contains a regular
expression on which indicators 1 and 2 are validated. # means a blank
indicator.  Line 4 and the following define rules for validating subfields. A
first part contains subfield's letter, and + (repeatable) and/or _ (mandatory),
followed by an optional validation table name. A blank separates the first part
from the second part. The second part contains a reular expression on which
subfield content is validated.

(2) Validation tables part of the file allow to define several validation
tables. The table name begins with ==== TABLE NAME in uppercase. Then each line
is a code in the validation table.

This is for example, a simplified standard UNIMARC validation rules file:

 100_
 #
 #
 a ^[0-9]{8}[a-ku][0-9 ]{8}[abcdeklu ]{3}[a-huyz][01 ][a-z]{3}[a-cy][01|02|03|04|05|06|07|08|09|10|11|50]{2}
 
 101
 0,1,2
 #
 a+LANG ^[a-z]{3}$
 b+LANG ^[a-z]{3}$
 c+LANG ^[a-z]{3}$
 d+ :^[a-z]{3}$
 f+ ^[a-z]{3}$
 g+ ^[a-z]{3}$
 h+ ^[a-z]{3}$
 i+ ^[a-z]{3}$
 j+ ^[a-z]{3}$
 
 102
 #
 #
 a+CTRY
 b+
 c+
 2+
 
 105
 #
 #
 a ^.{13}$
 
 106
 #
 #
 a ^.{1}$
 
 200_
 0|1
 #|1
 a_+
 b+
 c+
 d+
 e+
 f+
 g+
 h+
 i+
 v
 z+
 5+
 
 205+
 #
 #      
 a 
 b+ 
 d+ 
 f+ 
 g+
 
 206+
 #|0     
 #      
 a 
 b+ 
 c 
 d 
 e 
 f
 
 207   
 #       
 0|1    
 a+
 z+ ^.{7}$
 
 ==== CTRY
 AF
 AL
 DZ
 GG
 GN
 GW
 GY
 HT
 HM
 VE
 VN
 VG
 VI
 ZM
 ZW
 
 ==== LANG
 aar
 afh
 afr
 afa
 ain
 aka
 akk

=head1 SEE ALSO

=over 4

=item *

L<MARC::Moose>

=back

=head1 AUTHOR

Frédéric Demians <f.demians@tamil.fr>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Frédéric Demians.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
