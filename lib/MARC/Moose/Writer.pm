package MARC::Moose::Writer;
{
  $MARC::Moose::Writer::VERSION = '0.019';
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
    print $self->formater->begin();
}



sub end {
    my $self = shift;
    print $self->formater->end();
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

=encoding UTF-8

=head1 NAME

MARC::Moose::Writer - A base object to write somewhere MARC::Moose records

=head1 VERSION

version 0.019

=head1 ATTRIBUTES

=head2 count

Number of records that have been written with L<write> method.

=head2 formater

A L<MARC::Moose::Formater> to be used to format records to write. By defaut,
it's a L<MARC::Moose::Formater::Text> formater.

=head1 METHODS

=head2 begin

Method to be call before beginning writing record with L<write> method. By
default, this is just a call to the formater C<begin> method.

=head2 end

Method to be call at the end of the writing process, afet the last record has
been written, the last call to L<write>. By default, this is just a call to the
formater C<end> method.

=head2 write($record)

Write L<MARC::Moose::Record> $record into whatever data stream, a file, a
socket, etc. It uses the L<formater> to format the record. In this base class,
the record is printed on STDOUT.

=head1 AUTHOR

Frédéric Demians <f.demians@tamil.fr>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Frédéric Demians.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

