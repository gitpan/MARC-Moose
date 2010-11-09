package Marc::Field;
# ABSTRACT: Marc field base object

use namespace::autoclean;
use Moose;
use Moose::Util::TypeConstraints;


subtype 'Tag'
    => as 'Str'
    => where { $_ =~ /^\d{3}$/ }
    => message { 'A 3 digit is required' };

has tag => ( is => 'rw', isa => 'Tag', required => 1, );


sub as_formatted {
    my $self = shift;
    return $self->tag;
}

__PACKAGE__->meta->make_immutable;

1;

__END__
=pod

=head1 NAME

Marc::Field - Marc field base object

=head1 VERSION

version 0.001

=head1 AUTHOR

Frédéric Demians <f.demians@tamil.fr>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Frédéric Demians.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

