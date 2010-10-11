package FSFE::Web;

=head1 NAME

FSFE::Web - Dynamic web interface for the FSFE website

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
use APR::Finfo;
use Exporter;

use base qw (Exporter);

my $routes;
my $routes_gracetime = 60;
my $routes_mtime = 0;

sub import
  {
    my $self = shift;

    my %opts = @_;
    $routes = delete $opts{-routes};
    $routes_gracetime = delete $opts{-gracetime} if defined $opts{-gracetime};

    die sprintf ('%s must be loaded with -routes set', __PACKAGE__) unless defined $routes;

    $self->SUPER::import (%_);
  }

sub build_handler
  {
    my ($self, $r) = @_;

    my $path = $r->filename ();
    if (! -f $path)
      {
        open (my $fh, '>', $path) or $r->log_error ("opening $path for writing failed");
        print $fh 'hello world!';
        close $fh; # Must be closed before stat cache ist refreshed!

        # Refresh stat cache, see Apache2::RequestRec::filename documentation
        $r->finfo (APR::Finfo::stat ($path, APR::Const::FINFO_NORM, $r->pool));
      }

    Apache2::Const::OK
  }

1
