package Marc::Parser;

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

Marc::Parser

=head1 VERSION

version 0.001

=head1 AUTHOR

Frédéric Demians <f.demians@tamil.fr>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Frédéric Demians.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

