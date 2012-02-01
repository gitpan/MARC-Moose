package MARC::Moose::Reader;
{
  $MARC::Moose::Reader::VERSION = '0.020';
}
# ABSTRACT: Base class for a reader returning MARC::Moose records

use namespace::autoclean;
use Moose;


has count => (
    is => 'rw',
    isa => 'Int',
    default => 0
);



has parser => (
    is => 'rw', isa => 'MARC::Moose::Parser',
);



sub read {
    my $self = shift;

    $self->count( $self->count + 1 );
    return 1;
}

__PACKAGE__->meta->make_immutable;

1;


__END__
=pod

=encoding UTF-8

=head1 NAME

MARC::Moose::Reader - Base class for a reader returning MARC::Moose records

=head1 VERSION

version 0.020

=head1 ATTRIBUTES

=head2 count

Number of records that have been read with L<read> method.

=head2 parser

L<MARC::Moose::Parser> parser used to parse record that have been read.

=head1 METHODS

=head2 read

Read one L<MARC::Moose::Record> record from the underlying data stream, and
return it. This base class return 1.

=head1 AUTHOR

Frédéric Demians <f.demians@tamil.fr>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Frédéric Demians.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

