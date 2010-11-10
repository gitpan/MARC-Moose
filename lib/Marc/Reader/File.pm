package Marc::Reader::File;
# ABSTRACT: A Marc::Reader from a file

use namespace::autoclean;
use Moose;

use Carp;
use Marc::Record;

extends 'Marc::Reader';

has file => (
    is => 'rw',
    isa => 'Str',
    trigger => sub {
        my ($self, $file) = @_; 
        unless ( -e $file ) { 
            croak "File doesn't exist: " . $file;
        }   
        $self->{file} = $file;
    }   
);

has fh => ( is => 'rw' );


sub BUILD {
    my $self = shift;

    open my $fh, '<',$self->file
         or croak "Impossible to open file: " . $self->file;
    $self->fh($fh);
}


sub read {
    my $self = shift;

    $self->SUPER::read();
}

__PACKAGE__->meta->make_immutable;

1;


__END__
=pod

=head1 NAME

Marc::Reader::File - A Marc::Reader from a file

=head1 VERSION

version 0.003

=head1 ATTRIBUTES

=head2 file

Name of the file to read Marc::Record from. A error is thrown if the file
does't exist.

=head1 SEE ALSO

=over 4

=item *

L<Marc>

=item *

L<Marc::Reader>

=back

=head1 AUTHOR

Frederic Demians <f.demians@tamil.fr>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Frederic Demians.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

