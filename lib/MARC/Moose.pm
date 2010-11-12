package MARC::Moose;
# ABSTRACT: Moose based MARC records set of tools

use namespace::autoclean;
use Moose 1.00;

use Carp;


__PACKAGE__->meta->make_immutable;

1;


__END__
=pod

=head1 NAME

MARC::Moose - Moose based MARC records set of tools

=head1 VERSION

version 0.006

=head1 DESCRIPTION

=head1 SYNOPSYS

 use MARC::Moose::Record;
 use MARC::Moose::Reader::File;
 use MARC::Moose::Parser::Iso2709;
 use MARC::Moose::Formater::Text;

 my $reader = MARC::Moose::Reader::File->new(
     file   => 'biblio.iso',
     parser => MARC::Moose::Parser::Iso2709->new()
 );
 my $formater = MARC::Moose::Formater::Text->new();
 while ( my $record = $reader->read() ) {
     print $formater->format( $record );
 }

=head1 WARNINGS

MARC records are expected to be UTF-8 encoded. It won't work if it isn't.
Parsed records MUST be UTF-8. If you don't have UTF-8 records, write a specific
reader or use a generic tool like yaz-marcdump before loading records.

=head1 SEE ALSO

=over 4

=item *

L<MARC::Moose>

=item *

L<MARC::Moose::Record>

=item *

L<MARC::Moose::Field>

=item *

L<MARC::Moose::Field::Std>

=item *

L<MARC::Moose::Field::Control>

=item *

L<MARC::Moose::Reader>

=item *

L<MARC::Moose::Reader::File>

=item *

L<MARC::Moose::Reader::File::Iso2709>

=item *

L<MARC::Moose::Reader::File::Marcxml>

=item *

L<MARC::Moose::Reader::File::Isis>

=item *

L<MARC::Moose::Writer>

=item *

L<MARC::Moose::Writer:File>

=item *

L<MARC::Moose::Parser>

=item *

L<MARC::Moose::Parser::Iso2709>

=item *

L<MARC::Moose::Parser::Marcxml>

=item *

L<MARC::Moose::Parser::MarcxmlSax>

=item *

L<MARC::Moose::Parser::Isis>

=item *

L<MARC::Moose::Formater>

=item *

L<MARC::Moose::Formater::Iso2709>

=item *

L<MARC::Moose::Formater::Marcxml>

=item *

L<MARC::Moose::Formater::Text>

=item *

L<MARC::Moose::Formater::Yaml>

=back

=head1 AUTHOR

Frederic Demians <f.demians@tamil.fr>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Frederic Demians.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
