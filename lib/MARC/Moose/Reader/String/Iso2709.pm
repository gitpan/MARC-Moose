package MARC::Moose::Reader::String::Iso2709;
BEGIN {
  $MARC::Moose::Reader::String::Iso2709::VERSION = '0.018';
}
# ABSTRACT: File reader for MARC::Moose record from ISO2709 string

use namespace::autoclean;
use Moose;

use Carp;
use MARC::Moose::Record;
use MARC::Moose::Parser::Iso2709;

extends 'MARC::Moose::Reader::String';


has parser => ( 
    is => 'rw', 
    isa => 'MARC::Moose::Parser',
    default => sub { MARC::Moose::Parser::Iso2709->new() },
);

# An arrayref of all ISO2709 MARC record found in the string
has records => ( is => 'rw', isa => 'ArrayRef' );


sub BUILD {
    my $self = shift;

    my @records = split /\x1d/, $self->string;
    $self->records( \@records );

    # Pop last entry which empty
    if ( @records ) { pop @records };
}



override 'read' => sub {
    my $self = shift;

    my $count = $self->count;
    return if $count == @{ $self->records };

    my $raw = $self->records->[$count];
    # remove illegal garbage that sometimes occurs between records
    $raw =~ s/^[ \x00\x0a\x0d\x1a]+//;
    my $record = $self->parser->parse( $raw );
    $count++;
    $self->count( $count );
    return $record;
};

__PACKAGE__->meta->make_immutable;

1;


__END__
=pod

=head1 NAME

MARC::Moose::Reader::String::Iso2709 - File reader for MARC::Moose record from ISO2709 string

=head1 VERSION

version 0.018

=head1 AUTHOR

Frederic Demians <f.demians@tamil.fr>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Frederic Demians.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

