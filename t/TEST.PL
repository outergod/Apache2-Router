#!perl

use strict;
use warnings;

use Cwd qw (abs_path);
use File::Basename qw (dirname);

my $root;
BEGIN { $root = dirname (dirname (abs_path (__FILE__))) }

use lib sprintf '%s/lib', $root;

use Apache::TestRunPerl;
Apache::TestRunPerl->new->run (@ARGV);
