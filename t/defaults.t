#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;

use Forward::Routes;

use Test::More tests => 2;


#############################################################################
### defaults

my $r = Forward::Routes->new;
$r->add_route('articles')->defaults(first_name => 'foo', last_name => 'bar')->name('one');

my $m = $r->match(get => 'articles');
is_deeply $m->[0]->params => {first_name => 'foo', last_name => 'bar'};


is $r->build_path('one')->{path}, 'articles';
