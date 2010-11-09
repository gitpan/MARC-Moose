package Marc::Reader::File::Iso2709;

use namespace::autoclean;
use Moose;

use Carp;
use Marc::Record;
use Marc::Parser::Iso2709;

extends 'Marc::Reader::File';


has parser => ( 
    is => 'rw', 
    isa => 'Marc::Parser',
    default => sub { Marc::Parser::Iso2709->new() },
);


override 'read' => sub {
    my $self = shift;

    $self->SUPER::read();

    my $fh = $self->{fh};

    my $reclen;
    return if eof($fh);

    local $/ = "\x1D"; # End of record
    my $raw = <$fh>;

    # remove illegal garbage that sometimes occurs between records
    $raw =~ s/^[ \x00\x0a\x0d\x1a]+//;

    return $self->parser->parse( $raw );
};

__PACKAGE__->meta->make_immutable;

1;


__END__
=pod

=head1 NAME

Marc::Reader::File::Iso2709

=head1 VERSION

version 0.001

=head1 AUTHOR

Frédéric Demians <f.demians@tamil.fr>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Frédéric Demians.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

