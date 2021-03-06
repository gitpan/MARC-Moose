package MARC::Moose::Reader::File::Isis;
# ABSTRACT: A file reader for ISIS (DOS) encoded records
$MARC::Moose::Reader::File::Isis::VERSION = '1.0.19';
use Moose;

use Carp;
use MARC::Moose::Record;
use MARC::Moose::Parser::Isis;

extends 'MARC::Moose::Reader::File';




override 'read' => sub {
    my $self = shift;

    $self->SUPER::read();

    my $fh = $self->fh;
    my $raw;
    while ( <$fh> ) {
        s/\x0a|\x0d//g;
        $raw .= $_;
        last if /\x1d/; # End of record separator
    }
    return 0 unless $raw;

    return $self->parser->parse( $raw );
};

__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

MARC::Moose::Reader::File::Isis - A file reader for ISIS (DOS) encoded records

=head1 VERSION

version 1.0.19

=head1 DESCRIPTION

Read next available L<MARC::Moose::Record> from reader file using
L<MARC::Moose::Parser::Isis> parser.

=head1 ATTRIBUTES

=head2 parser

By default, use L<MARC::Moose::Parser::Isis> to read L<MARC::Moose::Record>
records from a file.

has '+parser' => ( default => sub { MARC::Moose::Parser::Isis->new() } );

=head1 SEE ALSO

=over 4

=item *

L<MARC::Moose>

=item *

L<MARC::Moose::Reader::File>

=item *

L<MARC::Moose::Parser::Isis>

=back

=head1 AUTHOR

Frédéric Demians <f.demians@tamil.fr>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Frédéric Demians.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
