#!perl

use strict;
use warnings;

use Apache::Test;
use Apache::TestRunPerl;
Apache::TestRunPerl->new->run (@ARGV);
