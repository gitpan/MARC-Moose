package Marc;
# ABSTRACT: MARC bibliographic records set of tools

use namespace::autoclean;
use Moose 1.00;

use Carp;


__PACKAGE__->meta->make_immutable;

1;


__END__
=pod

=head1 NAME

Marc - MARC bibliographic records set of tools

=head1 VERSION

version 0.004

=head1 DESCRIPTION

=head1 SYNOPSYS

 use Marc::Record;
 use Marc::Reader::File;
 use Marc::Parser::Iso2709;
 use Marc::Formater::Text;

 my $reader = Marc::Reader::File->new(
     file   => 'biblio.iso',
     parser => Marc::Parser::Iso2709->new()
 );
 my $formater = Marc::Formater::Text->new();
 while ( my $record = $reader->read() ) {
     print $formater->format( $record );
 }

=head1 SEE ALSO

=over 4

=item *

L<Marc>

=item *

L<Marc::Record>

=item *

L<Marc::Field>

=item *

L<Marc::Field::Std>

=item *

L<Marc::Field::Control>

=item *

L<Marc::Reader>

=item *

L<Marc::Reader::File>

=item *

L<Marc::Reader::File::Iso2709>

=item *

L<Marc::Reader::File::Isis>

=item *

L<Marc::Writer>

=item *

L<Marc::Writer:File>

=item *

L<Marc::Parser>

=item *

L<Marc::Parser::Iso2709>

=item *

L<Marc::Parser::Isis>

=item *

L<Marc::Formater>

=item *

L<Marc::Formater::Iso2709>

=item *

L<Marc::Formater::Marcxml>

=item *

L<Marc::Formater::Text>

=item *

L<Marc::Formater::Yaml>

=back

=head1 AUTHOR

Frederic Demians <f.demians@tamil.fr>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Frederic Demians.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

