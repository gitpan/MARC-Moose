package MARC::Moose::Field::Control;
{
  $MARC::Moose::Field::Control::VERSION = '0.020';
}
# ABSTRACT: Control Marc field (tag < 010)

use namespace::autoclean;
use Moose;

extends 'MARC::Moose::Field';

has value => ( is => 'rw', isa => 'Str' );

override 'as_formatted' => sub {
    my $self = shift;

    join ' ', ( $self->tag, $self->value );
};

__PACKAGE__->meta->make_immutable;

1;


__END__
=pod

=encoding UTF-8

=head1 NAME

MARC::Moose::Field::Control - Control Marc field (tag < 010)

=head1 VERSION

version 0.020

=head1 AUTHOR

Frédéric Demians <f.demians@tamil.fr>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Frédéric Demians.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

