#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;

use Forward::Routes;

use Test::More tests => 20;


#############################################################################
### singular resources

my $r = Forward::Routes->new;

$r->add_resource('geocoder');

my $m = $r->match(get => 'geocoder/new');
is_deeply $m->[0]->params => {controller => 'geocoder', action => 'create_form'};

$m = $r->match(post => 'geocoder');
is_deeply $m->[0]->params => {controller => 'geocoder', action => 'create'};

$m = $r->match(get => 'geocoder');
is_deeply $m->[0]->params => {controller => 'geocoder', action => 'show'};

$m = $r->match(get => 'geocoder/edit');
is_deeply $m->[0]->params => {controller => 'geocoder', action => 'update_form'};

$m = $r->match(put => 'geocoder');
is_deeply $m->[0]->params => {controller => 'geocoder', action => 'update'};

$m = $r->match(delete => 'geocoder');
is_deeply $m->[0]->params => {controller => 'geocoder', action => 'delete'};


is ref $r->find_route('geocoder_create_form'), 'Forward::Routes';
is $r->find_route('geocoder_foo'), undef;
is $r->find_route('geocoder_create_form')->name, 'geocoder_create_form';
is $r->find_route('geocoder_create')->name, 'geocoder_create';
is $r->find_route('geocoder_show')->name, 'geocoder_show';
is $r->find_route('geocoder_update_form')->name, 'geocoder_update_form';
is $r->find_route('geocoder_update')->name, 'geocoder_update';
is $r->find_route('geocoder_delete')->name, 'geocoder_delete';

is $r->build_path('geocoder_create_form')->{path} => 'geocoder/new';
is $r->build_path('geocoder_create')->{path} => 'geocoder';
is $r->build_path('geocoder_show', id => 456)->{path} => 'geocoder';
is $r->build_path('geocoder_update_form', id => 789)->{path} => 'geocoder/edit';
is $r->build_path('geocoder_update', id => 987)->{path} => 'geocoder';
is $r->build_path('geocoder_delete', id => 654)->{path} => 'geocoder';
