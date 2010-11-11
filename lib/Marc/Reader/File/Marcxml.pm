package Marc::Reader::File::Marcxml;
# ABSTRACT: File reader for Marc record from MARCXML file

use namespace::autoclean;
use Moose;

use Carp;
use Marc::Record;
use Marc::Parser::Marcxml;

extends 'Marc::Reader::File';


has parser => ( 
    is => 'rw', 
    isa => 'Marc::Parser',
    default => sub { Marc::Parser::Marcxml->new() },
);


override 'read' => sub {
    my $self = shift;

    $self->SUPER::read();

    my $fh = $self->{fh};

    return if eof($fh);

    local $/ = "</record>"; # End of record
    my $raw = <$fh>;
    
    # Skip <collection if present
    $raw =~ s/<(\/*)collection.*>//;

    return $self->parser->parse( $raw );
};

__PACKAGE__->meta->make_immutable;

1;


__END__
=pod

=head1 NAME

Marc::Reader::File::Marcxml - File reader for Marc record from MARCXML file

=head1 VERSION

version 0.004

=head1 AUTHOR

Frederic Demians <f.demians@tamil.fr>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Frederic Demians.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

