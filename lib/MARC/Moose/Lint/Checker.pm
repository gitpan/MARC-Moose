package MARC::Moose::Lint::Checker;
# ABSTRACT: A base-class to 'lint' biblio record
$MARC::Moose::Lint::Checker::VERSION = '1.0.17';
use Moose;
use Modern::Perl;
use YAML;


sub check {
    my ($self, $record) = @_;
    return ();
}


__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

MARC::Moose::Lint::Checker - A base-class to 'lint' biblio record

=head1 VERSION

version 1.0.17

=head1 DESCRIPTION

A MARC biblio record, MARC21, UNIMARC, whatever, can be validated against
rules. By extending this class, you defines your own validation rules.

=head1 METHODS

=head2 check( I<record> )

This method checks a biblio record, based on the current 'lint' object. The
biblio record is a L<MARC::Moose::Record> object. An array of validation
errors/warnings is returned. Those errors are just plain text explanation on
the reasons why the record doesn't comply with validation rules.

=head1 SEE ALSO

=over 4

=item *

L<MARC::Moose>

=item *

L<MARC::Moose::Lint::Checker::RulesFile>

=item *

L<MARC::Moose::Lint::Processor>

=back

=head1 AUTHOR

Frédéric Demians <f.demians@tamil.fr>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Frédéric Demians.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
