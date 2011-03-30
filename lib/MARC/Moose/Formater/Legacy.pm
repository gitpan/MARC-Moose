package MARC::Moose::Formater::Legacy;
BEGIN {
  $MARC::Moose::Formater::Legacy::VERSION = '0.013';
}
# ABSTRACT: Record formater into the legacy MARC::Record object

use namespace::autoclean;
use Moose;

extends 'MARC::Moose::Formater';

use MARC::Moose::Field::Control;
use MARC::Moose::Field::Std;
use MARC::Record;


override 'format' => sub {
    my ($self, $record) = @_;

    my $marc = MARC::Record->new;
    $marc->leader( $record->leader );
    for my $field ( @{$record->fields} ) {
        $marc->append_fields(
            $field->tag < 10
            ? MARC::Field->new( $field->tag, $field->value )
            : MARC::Field->new( $field->tag, $field->ind1, $field->ind2, map { ($_->[0], $_->[1]) } @{$field->subf} )
        );
    }
    return $marc;
};

__PACKAGE__->meta->make_immutable;

1;

__END__
=pod

=head1 NAME

MARC::Moose::Formater::Legacy - Record formater into the legacy MARC::Record object

=head1 VERSION

version 0.013

=head1 AUTHOR

Frederic Demians <f.demians@tamil.fr>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Frederic Demians.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

