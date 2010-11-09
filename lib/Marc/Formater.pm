package Marc::Formater;
# ABSTRACT: Base class to format Marc record

use namespace::autoclean;
use Moose;


# FIXME Experimental. Not used yet.
#has converter => (
#    is      => 'rw',
#    isa     => 'Text::IconvPtr',
#    default => sub { Text::Iconv->new( "cp857", "utf8" ) }
#);


sub begin { }

sub end { }


sub format {
    my ($self, $record) = @_;
    return "Marc Record";
};

__PACKAGE__->meta->make_immutable;

1;


__END__
=pod

=head1 NAME

Marc::Formater - Base class to format Marc record

=head1 VERSION

version 0.001

=head1 DESCRIPTION

A Marc formater is used by any writer to transform a Marc record into something
undestandable by human (text readable format) or by machine (standartized format
like ISO2709 or MARCXML).

=head1 SEE ALSO

=over 4



=back

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

