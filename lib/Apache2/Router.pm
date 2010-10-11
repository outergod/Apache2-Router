package Apache2::Router;

=head1 NAME

Apache2::Router - ROR style mod_perl router/dispatcher

=head1 SYNOPSIS

Blablabla.

=head1 DESCRIPTION

Blablabla.

=head1 COPYRIGHT

Copyright (C) 2010  Alexander Kahl <e-user@fsfe.org>

FSFE-Web is free software; you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation; either version 3 of the
License, or (at your option) any later version.

FSFE-Web is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

=head1 AUTHOR

Alexander Kahl <e-user@fsfe.org>

=cut

use 5.008;
use strict;
use warnings;

use Apache2::Const -compile => qw (DECLINED OK :log);
use APR::Const     -compile => qw (:error SUCCESS FINFO_NORM);

use Apache2::Log;
use Apache2::RequestRec;

my $routes;
my $routes_gracetime = 60;
my $routes_mtime = 0;

sub router
  {
    my ($self, $r) = @_;

    Apache2::Const::OK
  }

1
