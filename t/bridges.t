#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;

use Forward::Routes;

use Test::More tests => 12;


#############################################################################
### bridges

my $r = Forward::Routes->new;
my $bridge = $r->bridge('admin')->to('check#authentication');

$bridge->add_route('foo')->to('no#placeholders');
$bridge->add_route(':foo/:bar')->to('two#placeholders');

my $m = $r->match(get => 'foo');
is $m, undef;


# no placeholders
$m = $r->match(get => 'admin/foo');
is_deeply $m->[0]->params, {controller => 'check', action => 'authentication'};
is $m->[0]->is_bridge, 1;
is_deeply $m->[1]->params, {controller => 'no', action => 'placeholders'};
is $m->[1]->is_bridge, undef;


# missing bridge pattern in path
$m = $r->match(get => '/hello/there');
is $m, undef;


# two placeholders
# captures are available in bridge match object
$m = $r->match(get => '/admin/hello/there');

is $m->[0]->is_bridge, 1;
is $m->[1]->is_bridge, undef;

is_deeply $m->[0]->params, {controller => 'check', action => 'authentication',
  foo => 'hello', bar => 'there'};
is_deeply $m->[1]->params, {controller => 'two', action => 'placeholders',
  foo => 'hello', bar => 'there'};

is_deeply $m->[0]->captures, {foo => 'hello', bar => 'there'};
is_deeply $m->[1]->captures, {foo => 'hello', bar => 'there'};