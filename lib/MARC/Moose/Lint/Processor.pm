package MARC::Moose::Lint::Processor;
# ABSTRACT: Processor to lint iso2709 file
$MARC::Moose::Lint::Processor::VERSION = '1.0.12';
use Moose;
use Modern::Perl;
use MARC::Moose::Reader::File::Iso2709;
use MARC::Moose::Writer;
use MARC::Moose::Lint::Checker;

extends 'AnyEvent::Processor';

has lint => (is => 'rw', isa => 'MARC::Moose::Lint::Checker');


has file => (is => 'rw' );


has cleaner => (is => 'rw', isa => 'MARC::Moose::Formater');


has reader => (is => 'rw');
has writer_ok => (is => 'rw');
has count_ok => (is => 'rw', isa => 'Int', default => 0);
has writer_bad => (is => 'rw');
has count_bad => (is => 'rw', isa => 'Int', default => 0);
has fh_log => (is => 'rw');



sub BUILD {
    my $self = shift;

    my $file = $self->file;
    $self->reader( MARC::Moose::Reader::File::Iso2709->new(
        file => $file ) );
    $self->writer_ok( MARC::Moose::Writer->new(
        formater => MARC::Moose::Formater::Iso2709->new(),
        fh => IO::File->new("$file.ok", ">:encoding(utf8)")
    ) );
    $self->writer_bad( MARC::Moose::Writer->new(
        formater => MARC::Moose::Formater::Iso2709->new(),
        fh => IO::File->new("$file.bad", ">:encoding(utf8)")
    ) );
    $self->fh_log( IO::File->new("$file.log", ">:encoding(utf8)") );
};


sub process {
    my $self = shift;

    my $record = $self->reader->read();
    return unless $record;

    $record = $self->cleaner->format($record) if $self->cleaner;

    if ( my @result = $self->lint->check($record) ) {
        $self->writer_bad->write($record);
        my $rectext = $record->as('Text');
        chop $rectext;
        my $fh = $self->fh_log;
        print $fh $rectext, '-' x 80, "\n", join("\n", @result), "\n\n";
        $self->count_bad( $self->count_bad + 1 );
    }
    else {
        $self->writer_ok->write($record);
        $self->count_ok( $self->count_ok + 1 );
    }
    $self->SUPER::process();
}


sub start_message {
    say "Start linting biblio records";
}

sub process_message {
    my $self = shift;
    say $self->count, " - OK ", $self->count_ok, " - BAD ", $self->count_bad;
}

sub end_message {
    my $self = shift;
    my $file = $self->file;
    say "Processed records: ", $self->count, "\n",
        "Valid records:     ", $self->count_ok, "\n",
        "Invalid records:   ", $self->count_bad, "\n",
        "Lint result files: $file.ok, $file.bad, $file.log", ;
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

MARC::Moose::Lint::Processor - Processor to lint iso2709 file

=head1 VERSION

version 1.0.12

=head1 ATTRIBUTES

=head2 lint

A L<MARC::Moose::Lint::Checker> to be used to validate biblio record.

=head2 file

The name of the ISO2709 file containing biblio records to control.

=head2 cleaner

A L<MARC::Moose::Formater> which transform a L<MARC::Moose::Record> into
another L<MARC::Moose::Record>. Using a cleaner, it's possible to clean biblio
records before validating them.

=head1 SYNOPSYS

 package PeterCleaner;
 
 use Moose;
 
 extends 'MARC::Moose::Formater';
 
 override 'format' => sub {
     my ($self, $record) = @_;
 
     for my $field (@{$record->fields}) {
        # clean content
     }
     return $record;
 };
 
 package Main;
 
 my $processor = MARC::Moose::Lint::Processor->new(
     lint => MARC::Moose::Lint::Checker->new( file => 'unimarc.rules',
     file => 'biblio.mrc',
     cleaner => PeterCleaner->new(),
     verbose => 1,
 };
 $processor->run();

The above script validates an ISO2709 file named C<biblio.mrc> on a rules file
named C<unimarc.rules>. As a result, 3 files are created: (1) C<biblio.mrc.ok>,
an ISO2709 containing biblio records complying to the rules, (2)
C<biblio.mrc.bad> containing biblios violating the rules, and (3)
C<biblio.mrc.log> containing a textual representation of biblio records
violating the rules + a description of violated rules.

=head1 SEE ALSO

=over 4

=item *

L<MARC::Moose>

=item *

L<MARC::Moose::Lint::Checker

=back

=head1 AUTHOR

Frédéric Demians <f.demians@tamil.fr>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Frédéric Demians.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
