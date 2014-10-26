package MARC::Moose::Formater::Marcxml;
{
  $MARC::Moose::Formater::Marcxml::VERSION = '0.026';
}
#ABSTRACT: MARC::Moose record formater into MARCXML

use Moose;

extends 'MARC::Moose::Formater';

use MARC::Moose::Field::Control;
use MARC::Moose::Field::Std;
use XML::Writer 0.606;


override 'begin' => sub {
    return "<collection>\n";
};


override 'end' => sub {
    return "</collection>\n";
};


override 'format' => sub {
    my ($self, $record) = @_;

    my $str = '';
    my $w = XML::Writer->new( OUTPUT => \$str, DATA_MODE => 1, DATA_INDENT => 2 );

    $w->startTag( 'record' );
    $w->startTag( 'leader' );
    $w->characters( $record->leader );
    $w->endTag();

    for my $field ( @{$record->fields} ) {
        if ( ref($field) eq 'MARC::Moose::Field::Control' ) {
            $w->startTag( "controlfield", tag => $field->tag );
            $w->characters( $field->value );
            $w->endTag();
        }
        else {
            $w->startTag(
                "datafield", tag => $field->tag, ind1 => $field->ind1,
                ind2 => $field->ind2 );
            for my $sf ( @{$field->subf} ) {
                $w->startTag( "subfield", code => $sf->[0] );
                $w->characters( $sf->[1] );
                $w->endTag();
            }
            $w->endTag();
        }
    }
    $w->endTag();
    return $str . "\n";
};

__PACKAGE__->meta->make_immutable;

1;

__END__
=pod

=encoding UTF-8

=head1 NAME

MARC::Moose::Formater::Marcxml - MARC::Moose record formater into MARCXML

=head1 VERSION

version 0.026

=head1 AUTHOR

Frédéric Demians <f.demians@tamil.fr>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Frédéric Demians.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

