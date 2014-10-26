package Marc::Formater::Iso2709;
# ABSTRACT: Marc record formater into ISO 2709 format

use namespace::autoclean;
use Moose;

extends 'Marc::Formater';

use Marc::Field::Control;
use Marc::Field::Std;



override 'format' => sub {
    my ($self, $record) = @_;

    my ( $directory, $fields, $from ) = ( '', '', 0 );
    use YAML;
    for my $field ( @{$record->fields} ) {
        my $str = do {
            if ( ref($field) eq 'Marc::Field::Control' ) {
                $field->value . "\x1E";
            }
            else {
                my $str = '';
                $str .= "\x1F" . $_->[0] . $_->[1]  for @{$field->subf};
                $str = $field->ind1 . $field->ind2 . $str . "\x1E";
            }
        };
        $fields .= $str;
        my $len = bytes::length($str);
        $directory .= sprintf( "%03s%04d%05d", $field->tag, $len, $from );
        $from += $len;
    }

    # Update leader with calculated offset (data begining) and total length of
    # record
    my $offset = 24 + 12 * @{$record->fields} + 1;
    my $length = $offset + $from + 1;
    $record->set_leader_length( $length, $offset );

    return $record->leader . $directory . "\x1E" . $fields . "\x1D";
};

__PACKAGE__->meta->make_immutable;

1;


__END__
=pod

=head1 NAME

Marc::Formater::Iso2709 - Marc record formater into ISO 2709 format

=head1 VERSION

version 0.004

=head1 AUTHOR

Frederic Demians <f.demians@tamil.fr>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Frederic Demians.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

