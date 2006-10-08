#!/usr/bin/perl

use strict;
use warnings;

use Test::More no_plan => 1;

use Data::Dumper;

BEGIN {
    use_ok('Path::Router');
}

my $router = Path::Router->new;
isa_ok($router, 'Path::Router');

# create some routes

$router->add_route(':controller/:action');

$router->add_route(':controller/:id/:action' => {
    id     => qr/\d+/,
});

# THIS:

# /people/         (:action => 'index')
# /people/new
# /people/create
# /people/56/      (:action => 'show' by default)
# /people/56/edit
# /people/56/remove
# /people/56/update

# SHOULD BE POSSIBLE WITH THIS:
 
# $router->add_route(':controller/?:action' => {
#     action => 'index'
# });
# 
# $router->add_route(':controller/:id/?:action' => {
#     action => 'show',
#     id     => qr/\d+/,
# });

# IT CAN BE REVERSABLE IF WE CHECK 
# DEFAULT VALUES IN THE REVERSE FUNCTION
# AND IF CURRENT VALUE MATCHES THE DEFAULT
# WE CAN OMIT IT  

my %passing_tests = (
	'people/new' => {
		controller => 'people',
		action     => 'new',
	},
	'people/create' => {
		controller => 'people',
		action     => 'create',
	},
	'people/56/edit' => {
		controller => 'people',
		action     => 'edit',
		id         => 56,		
	},
	'people/56/remove' => {
		controller => 'people',
		action     => 'remove',
		id         => 56,		
	},
	'people/56/update' => {
		controller => 'people',
		action     => 'update',
		id         => 56,		
	},
); 

foreach my $path (keys %passing_tests) {
    # the path generated from the hash
    # is the same as the path supplied
    is(
        $path, 
        $router->uri_for(%{$passing_tests{$path}}), 
        '... round-tripping the light fantasitc for ' .  $path   
    );
    # the path supplied produces the
    # same match as the hash supplied 
    is_deeply(
        $router->match($path),
        $passing_tests{$path},
        '... dont call it a comeback, I been here for years ' . $path
    );    
}

1;




