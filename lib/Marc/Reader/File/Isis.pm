package Marc::Reader::File::Isis;
# ABSTRACT: Marc file reader for ISIS (DOS) encoded records

use namespace::autoclean;
use Moose;

use Carp;
use Marc::Record;
use Marc::Parser::Isis;

extends 'Marc::Reader::File';


has parser => ( 
    is => 'rw', 
    isa => 'Marc::Parser',
    default => sub { Marc::Parser::Isis->new() },
);


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

=head1 NAME

Marc::Reader::File::Isis - Marc file reader for ISIS (DOS) encoded records

=head1 VERSION

version 0.003

=head1 METHODS

=head2 read

Read next available L<Marc::Record> from reader file using
L<Marc::Parser::Isis> parser.

=head1 SEE ALSO

=over 4

=item *

L<Marc>

=item *

L<Marc::Reader::File>

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

