package Marc::Parser::Marcxml;
# ABSTRACT: Parser for MARXML Marc records

use namespace::autoclean;
use Moose;

extends 'Marc::Parser';

use Marc::Field::Control;
use Marc::Field::Std;
use XML::Simple;

has 'xs' => ( is => 'rw', default => sub {  XML::Simple->new() } );


override 'parse' => sub {
    my ($self, $raw) = @_;

    return unless $raw;

    my $ref = eval { $self->xs->XMLin($raw, forcearray => [ 'subfield' ] ) };
    return undef if $@;

    my $record = Marc::Record->new();
    $record->_leader( $ref->{leader} );
    my @fields_control = map {
        Marc::Field::Control->new( tag => $_->{tag}, value => $_->{content} );
    } @{$ref->{controlfield}};
    my @fields_std = map {
        my @sf = map { [ $_->{code}, $_->{content} ] }  @{$_->{subfield}};
        Marc::Field::Std->new(
            tag  => $_->{tag},
            ind1 => $_->{ind1},
            ind2 => $_->{ind2},
            subf => \@sf,
        ); 
    } @{$ref->{datafield}};
    $record->fields( [ @fields_control, @fields_std ] );

    return $record;
};

__PACKAGE__->meta->make_immutable;

1;


__END__
=pod

=head1 NAME

Marc::Parser::Marcxml - Parser for MARXML Marc records

=head1 VERSION

version 0.004

=head1 SEE ALSO
=for :list
* L<Marc>
* L<Marc::Parser>

=head1 AUTHOR

Frederic Demians <f.demians@tamil.fr>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Frederic Demians.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

