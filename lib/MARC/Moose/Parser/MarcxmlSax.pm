package MARC::Moose::Parser::MarcxmlSax;
BEGIN {
  $MARC::Moose::Parser::MarcxmlSax::VERSION = '0.018';
}
# ABSTRACT: Parser for MARXML records using SAX parser

use namespace::autoclean;
use Moose;

extends 'MARC::Moose::Parser';

use MARC::Moose::Field::Control;
use MARC::Moose::Field::Std;
use MARC::Moose::Parser::MarcxmlSaxHandler;
use XML::SAX qw(Namespaces Validation);;
use YAML;


has parser => (
    is => 'rw',
    default => sub {
        my $self = shift;
        my $factory = XML::SAX::ParserFactory->new();
        my $parser = $factory->parser(
            Handler => MARC::Moose::Parser::MarcxmlSaxHandler->new(),
        );
        $self->parser( $parser );
    },
);


override 'parse' => sub {
    my ($self, $raw) = @_;

    return unless $raw;

    $self->parser->parse_string( $raw );
    my $record = $self->parser->{Handler}->{record};
    return $record;
};

__PACKAGE__->meta->make_immutable;

1;


__END__
=pod

=head1 NAME

MARC::Moose::Parser::MarcxmlSax - Parser for MARXML records using SAX parser

=head1 VERSION

version 0.018

=head1 SEE ALSO

=over 4

=item *

L<MARC::Moose>

=item *

L<MARC::Moose::Parser>

=item *

L<MARC::Moose::Parser::Marcxml>

=back

=head1 AUTHOR

Frederic Demians <f.demians@tamil.fr>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Frederic Demians.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
