package MARC::Moose::Parser::MarcxmlSaxHandler;
BEGIN {
  $MARC::Moose::Parser::MarcxmlSaxHandler::VERSION = '0.011';
}
# ABSTRACT: SAX handler for parsing MARXML records

use strict;
use warnings;
use feature ":5.10";

use XML::SAX;
use base qw( XML::SAX::Base );

use MARC::Moose::Field::Control;
use MARC::Moose::Field::Std;


sub new {
    my $class = shift;
    return bless {}, ref($class) || $class;
}


sub start_element {
    my ($self, $element) = @_;
    $self->{data} = '';
    given ( $element->{LocalName} ) {
        when ( 'record' ) {
            $self->{record} = MARC::Moose::Record->new();
            $self->{fields} = [];
        }
        when ( 'controlfield' ) {
            $self->{field} = MARC::Moose::Field::Control->new(
                tag => $element->{Attributes}{'{}tag'}{Value} );
        }
        when ( 'datafield' ) {
            my $attr = $element->{Attributes};
            $self->{field} = MARC::Moose::Field::Std->new(
                tag  => $attr->{'{}tag'}{Value},
                ind1 => $attr->{'{}ind1'}{Value},
                ind2 => $attr->{'{}ind2'}{Value},
            );
        }
        when ( 'subfield' ) {
            $self->{code} = $element->{Attributes}{'{}code'}{Value}
        }
    }
}


sub end_element {
    my ($self, $element) = @_;
    given ( $element->{Name} ) {
        when ( 'leader' ) {
            my $record = $self->{record};
            $record->_leader( $self->{data} );
        }
        when ( 'controlfield' ) {
            my $field = $self->{field};
            $field->value( $self->{data} );
            push @{$self->{fields}}, $field;
        }
        when ( 'datafield' ) {
            push @{$self->{fields}}, $self->{field};
        }
        when ( 'subfield' ) {
            my $field = $self->{field};
            push @{$field->{subf}}, [ $self->{code}, $self->{data} ];
        }
        when ( 'record' ) {
            my $record = $self->{record};
            $record->fields( $self->{fields} );
        }
    }
}


sub characters {
    my ($self, $characters) = @_;
    $self->{data} .= $characters->{Data};
}

1;


__END__
=pod

=head1 NAME

MARC::Moose::Parser::MarcxmlSaxHandler - SAX handler for parsing MARXML records

=head1 VERSION

version 0.011

=head1 AUTHOR

Frederic Demians <f.demians@tamil.fr>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Frederic Demians.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

