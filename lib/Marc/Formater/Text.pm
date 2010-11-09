package Marc::Formater::Text;

use namespace::autoclean;
use Moose;

extends 'Marc::Formater';

use Marc::Field::Control;
use Marc::Field::Std;


override 'format' => sub {
    my ($self, $record) = @_;

    my $text = join "\n",
         $record->leader,
         map {
             $_->tag .
             ( ref($_) eq 'Marc::Field::Control' 
               ? $_->value
               : ' ' . $_->ind1 . $_->ind2 . ' '  .
               join ' ', map { ('$' . $_->[0], $_->[1] ) } @{$_->subf}
             );
         } @{ $record->fields };
    return $text . "\n\n"; 
};

__PACKAGE__->meta->make_immutable;

1;

__END__
=pod

=head1 NAME

Marc::Formater::Text

=head1 VERSION

version 0.001

=head1 AUTHOR

Frédéric Demians <f.demians@tamil.fr>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Frédéric Demians.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

