package Marc::Formater::Yaml;

use namespace::autoclean;
use Moose;

extends 'Marc::Formater';

use Marc::Field::Control;
use Marc::Field::Std;
use YAML;



override 'format' => sub {
    my ($self, $record) = @_;

    return Dump($record);
};

__PACKAGE__->meta->make_immutable;

1;

__END__
=pod

=head1 NAME

Marc::Formater::Yaml

=head1 VERSION

version 0.001

=head1 AUTHOR

Frédéric Demians <f.demians@tamil.fr>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Frédéric Demians.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

