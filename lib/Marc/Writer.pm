package Marc::Writer;

use namespace::autoclean;
use Moose;

has count => (
    is      => 'rw',
    isa     => 'Int',
    default => 0
);


has formater => (
    is      => 'rw',
    isa     => 'Marc::Formater',
    default => sub { Marc::Formater::Text->new() }
);


sub begin {
    my $self = shift;
    $self->parser->begin();
}


sub end {
    my $self = shift;
    $self->parser->end();
}


sub write {
    my ($self, $record) = shift;

    $self->count( $self->count + 1 );

    print $self->formater->format($record);
}

__PACKAGE__->meta->make_immutable;

1;


__END__
=pod

=head1 NAME

Marc::Writer

=head1 VERSION

version 0.001

=head1 AUTHOR

Frédéric Demians <f.demians@tamil.fr>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Frédéric Demians.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

