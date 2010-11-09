package Marc::Reader::File::Isis;

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

Marc::Reader::File::Isis

=head1 VERSION

version 0.001

=head1 AUTHOR

Frédéric Demians <f.demians@tamil.fr>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Frédéric Demians.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

