package MARC::Moose::Writer;
BEGIN {
  $MARC::Moose::Writer::VERSION = '0.008';
}
# ABSTRACT: A base object to write somewhere MARC::Moose records

use namespace::autoclean;
use Moose;

has count => (
    is      => 'rw',
    isa     => 'Int',
    default => 0
);


has formater => (
    is      => 'rw',
    isa     => 'MARC::Moose::Formater',
    default => sub { MARC::Moose::Formater::Text->new() }
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

MARC::Moose::Writer - A base object to write somewhere MARC::Moose records

=head1 VERSION

version 0.008

=head1 AUTHOR

Frederic Demians <f.demians@tamil.fr>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Frederic Demians.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

