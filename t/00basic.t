# -*- mode: cperl; -*-
use strict;
use warnings;
no warnings 'once';

use File::Basename qw (basename);
use File::Temp qw (tempdir tempfile);
use Test::More qw (no_plan);
use Test::Exception;

# Apache2::Router and Apache2::Router::Parameters cannot be tested directly
# because they require to be run within mod_perl
BEGIN { use_ok ('Apache2::Router::Routes'); }
require_ok ('Apache2::Router::Routes');

# Apache2::Router::Routes::croak_broken_sub
my $fun = \&Apache2::Router::Routes::croak_broken_sub;
dies_ok { $fun->('X X X') } 'sub really croaks';

# Apache2::Router::Routes::map_resolve_subs
$fun = \&Apache2::Router::Routes::map_resolve_subs;
is ($fun->(), 0, 'calling with arguments returns 0');

sub foo {}
dies_ok { $fun->('wrong') } 'invalid subroutine names';
dies_ok { $fun->('print') } 'builtin function names';
lives_ok { $fun->('main::foo') } 'valid subroutine names';
dies_ok { $fun->('main::foo', 'wrong') } 'invalid function names anywhere';
undef &foo;

package bar;
sub baz {};
package main;
lives_ok { $fun->('bar::baz') } 'subroutines in explicitly created packages';

*abcd::efgh = sub {};
lives_ok { $fun->('abcd::efgh') } 'subroutines in implicitly created packages';
undef &abcd::efgh;

*test::foo = sub { 'a' };
*test::bar = sub { 'b' };
*test::baz = sub { 'c' };
is_deeply ([map { $_->() } $fun->('test::foo', 'test::bar', 'test::baz')], ['a', 'b', 'c'], 'calling resolved subs');

# Apache2::Router::Routes::preload_packages
$fun = \&Apache2::Router::Routes::preload_packages;
is ($fun->(), 1, 'calling with arguments returns 1');

dies_ok { $fun->('totally::wrong') } 'unfindable package names';

package baz;
package main;
dies_ok { $fun->('baz') } 'inline packages';

sub
  {
    local @INC = @INC;
    my $path = tempdir;
    push @INC, $path;

    my ($fh, $filename) = tempfile (DIR => $path, SUFFIX => '.pm');
    my $package = basename ($filename, '.pm');

    print $fh 1;
    close $fh;

    lives_ok { $fun->($package) } 'load required packages';
  }->();

# Apache2::Router::Routes::router
