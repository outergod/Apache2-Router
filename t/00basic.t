# -*- mode: cperl; -*-
use strict;
use warnings;

use Test::More 'no_plan';
use Test::Exception;

# Apache2::Router and Apache2::Router::Parameters cannot be tested directly
# because they require to be run within mod_perl
BEGIN { use_ok ('Apache2::Router::Routes'); }
require_ok ('Apache2::Router::Routes');

# Apache2::Router::Routes::croak_broken_sub
my $fun = \&Apache2::Router::Routes::croak_broken_sub;
dies_ok { $fun->('bla') } 'sub really croaks';

# Apache2::Router::Routes::map_resolve_subs
$fun = \&Apache2::Router::Routes::map_resolve_subs;
is ($fun->(), 0, 'calling with arguments returns 0');

eval
  {
    dies_ok { $fun->('wrong') } 'dies with invalid function names 1';
    dies_ok { $fun->('print', 'wrong') } 'dies with invalid function names anywhere 2';
    lives_ok { $fun->('print') } 'dies with invalid function names anywhere 2';
  } or die $@;

$fun->('foo bar::also wrong')
