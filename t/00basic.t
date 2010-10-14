# -*- mode: cperl; -*-
use strict;
use warnings;

use Test::More 'no_plan';
use Test::Exception;

# Apache2::Router and Apache2::Router::Parameters cannot be tested directly
# because they require to be run within mod_perl
BEGIN { use_ok ('Apache2::Router::Routes'); }
require_ok ('Apache2::Router::Routes');

# Apache2::Router::Routes::map_resolve_subs
my $fun = \&Apache2::Router::Routes::map_resolve_subs;
is ($fun->(), 0, 'calling with arguments');
dies_ok { $fun->('wrong') } 'dies with function names outside package scope';
$fun->('foo bar::also wrong')
