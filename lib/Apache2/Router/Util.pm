package Apache2::Router::Util;

=head1 NAME

Apache2::Router::Util - Helper for Apache2::Router

=head1 SYNOPSIS

Blablabla.

=head1 DESCRIPTION

Blablabla.

=head1 COPYRIGHT

Copyright (C) 2010  Alexander Kahl <e-user@fsfe.org>

Apache2-Router is free software; you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation; either version 3 of the
License, or (at your option) any later version.

Apache2-Router is distributed in the hope that it will be useful,
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

use Apache2::Const -compile => qw (:log);
use Apache2::Log;
use APR::Const     -compile => qw (:error SUCCESS);
use Apache2::ServerUtil;

use Exporter;
use base qw (Exporter);
our @EXPORT = qw (log);

sub log
  {
    my $message = shift;

    if (Apache2::ServerUtil->can ('server'))
      {
        Apache2::ServerUtil->server->log_serror (Apache2::Log->LOG_MARK, Apache2::Const->LOG_DEBUG, APR::Const->SUCCESS, $message);
      }
    else
      {
        warn $message;
      }
  }

1
