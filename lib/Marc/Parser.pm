package Marc::Parser;
# ABSTRACT: A Marc record parser base class

use namespace::autoclean;
use Moose;


# FIXME Experimental. Not used yet.
#has converter => (
#    is      => 'rw',
#    isa     => 'Text::IconvPtr',
#    default => sub { Text::Iconv->new( "cp857", "utf8" ) }
#);


sub begin {
    return "";
}


sub end {
    return "";
}


sub parse {
    return Marc::Record->new();
};

__PACKAGE__->meta->make_immutable;

1;


__END__
=pod

=head1 NAME

Marc::Parser - A Marc record parser base class

=head1 VERSION

version 0.002

=head1 METHODS

=head2 begin

=head2 end

=head2 parse

Return a Marc::Record object build from a parsed string

=head1 SEE ALSO

=over 4

=item *

L<Marc>

=item *

L<Marc::Parser::Iso2709>

=item *

L<Marc::Parser::Marcxml>

=item *

L<Marc::Parser::Isis>

=back

=head1 AUTHOR

Frederic Demians <f.demians@tamil.fr>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Frederic Demians.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
