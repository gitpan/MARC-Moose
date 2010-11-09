package Marc::Formater::Yaml;
# ABSTRACT: Marc record formater into YAML representation

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

Marc::Formater::Yaml - Marc record formater into YAML representation

=head1 VERSION

version 0.002

=head1 AUTHOR

Frederic Demians <f.demians@tamil.fr>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Frederic Demians.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
