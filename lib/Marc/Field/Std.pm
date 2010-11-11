package Marc::Field::Std;
# ABSTRACT: Standard Marc Field (tag >= 010)

use namespace::autoclean;
use Moose;

extends 'Marc::Field';

use overload
    '%{}' => \&subfield;


has ind1 => (is => 'rw', isa => 'Str', default => ' ');
has ind2 => (is => 'rw', isa => 'Str', default => ' ');

has subf => ( is => 'rw', isa => 'ArrayRef', default => sub { [] } );


override 'as_formatted' => sub {
    my $self = shift;

    join ' ', (
        $self->tag,
        map { ("\$$_->[0]", $_->[1]) } @{$self->subf} );
};


sub subfield {
    my ($self, $letter) = @_;

    my @values;
    for ( @{$self->subf} ) {
        push @values, $_->[1] if $_->[0] eq $letter;
    }

    return wantarray ? @values : $values[0];
}



#__PACKAGE__->meta->make_immutable;

1;


__END__
=pod

=head1 NAME

Marc::Field::Std - Standard Marc Field (tag >= 010)

=head1 VERSION

version 0.004

=head1 AUTHOR

Frederic Demians <f.demians@tamil.fr>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Frederic Demians.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

