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

version 0.001

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



=back

* L<Marc>
* L<Marc::Record>
* L<Marc::Field>
* L<Marc::Field::Std>
* L<Marc::Field::Control>
* L<Marc::Reader>
* L<Marc::Reader::File>
* L<Marc::Reader::File::Iso2709>
* L<Marc::Reader::File::Isis>
* L<Marc::Writer>
* L<Marc::Writer:File>
* L<Marc::Parser>
* L<Marc::Parser::Iso2709>
* L<Marc::Parser::Isis>
* L<Marc::Formater>
* L<Marc::Formater::Iso2709>
* L<Marc::Formater::Marcxml>
* L<Marc::Formater::Text>
* L<Marc::Formater::Yaml>

=head1 AUTHOR

Frédéric Demians <f.demians@tamil.fr>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Frédéric Demians.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

