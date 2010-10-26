# -*- mode: cperl; -*-
use strict;
use warnings;

use Test::More;

my $tests;
BEGIN { $tests = 0; }

# Apache2::Router and Apache2::Router::Parameters cannot be tested directly
# because they require to be run within mod_perl
{
  BEGIN { $tests += 2; }
  use_ok ('Apache2::Router::Routes');
  require_ok ('Apache2::Router::Routes');
}

{
  BEGIN { $tests += 2; }
  use_ok ('Apache2::Router::Util');
  require_ok ('Apache2::Router::Util');
}

BEGIN { plan tests => $tests; }
