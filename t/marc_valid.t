#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 26;

use Marc::Record;
use Marc::Field;
use Marc::Field::Control;
use Marc::Field::Std;
use YAML;


my $record = Marc::Record->new();
ok( length($record->leader) == 24, 'new Marc::Record has 24 length leader');
ok( @{$record->fields} == 0, 'new Marc::Record has 0 fields' );

ok( $record->set_leader_length(100, 10), 'fix record leader length' );

my $field_100 = Marc::Field::Std->new(
    tag  => '100',
    subf => [ [ a => 'Demians, Frédéric' ], [ e => 'Editor' ] ]
);
ok( $field_100, 'new Marc::Field' );
ok( $field_100->tag eq '100', "right tag" );
is( @{$field_100->subf}, 2, "right number of subfields" );
ok( $field_100->subf->[0][0] eq 'a', "right first letter" );
ok( $field_100->subf->[0][1] eq 'Demians, Frédéric', "right first subfield value" );

ok( $field_100->subfield('a') eq 'Demians, Frédéric', "subfield method in scalar context" );
ok( $field_100->subfield('e') eq 'Editor', "subfield method on 2nd letter in scalar context" );

ok( $record->append($field_100), "append a field to the record" );
my $back;
ok( $back = $record->field('100'), "get back the field by its tag" );
cmp_ok( $field_100, '~~', $back, 'return field is the same' );

my $field_245 = Marc::Field::Std->new(
    tag  => '245',
    subf => [ [ a => 'Best live: '], [ b => 'In wonderfull land' ] ]
);
ok( $field_245, "create a second field" );
ok( $record->append($field_245), "append a second field to the record" );
ok( $back = $record->field('245'), "get back the second field" );
is( $field_245, $back, "it's the right field" );

ok( $back = $record->field('2..'), "get a field with regex" );
is( $field_245, $back, "it's the right field" );

my @fields;
ok( @fields = $record->field('...'), "get all fields" );
ok( $fields[0] == $field_100 && $fields[1] == $field_245, "get the right fields in valid order" );

my $field_110 = Marc::Field::Std->new(
    tag  => '110', 
    subf => [ [ a => 'Tamil s.a.r.l.' ] ]
);
ok( $record->append($field_110), "append 110 field" ); 
ok( @fields = $record->field('1..'), "get 1.. fields");
ok( @fields == 2, "2 fields returned (100 and 110)" );
ok( $fields[0] == $field_100 && $fields[1] == $field_110, "is the right order" );

@fields = $record->field('...');
ok( $fields[0] == $field_100 && $fields[1] == $field_110 && $fields[2] == $field_245,
    "all 2 subfields in order" );
