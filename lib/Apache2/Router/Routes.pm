package Apache2::Router::Routes;

=head1 NAME

Apache2::Router::Routes - Route handling

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

use Apache2::Const -compile => qw (:log);
use Apache2::Log;
use Apache2::Module;
use Apache2::Router::Parameters qw (module_config);
use Carp qw (croak);
use Config::Any;
use Router::Simple;

use Exporter;
use base qw (Exporter);
our @EXPORT = qw (router);

sub map_resolve_subs
  {
    map
      {
        my ($package) = $_ =~ m/(.*)::[^:]+$/;
        eval "require $package; 1" or do { croak $@ };
        \&$_;
      } @_;
  }

sub read_files
  {
    my $r = shift;

    my $config = Config::Any->load_files ({files => module_config ($r, 'RouteFiles') || [], use_ext => 1});

    my @routes;
    for (@$config)
      {
        my ($path, $data) = %$_;

        $r->log_error ("no such file or directory: $path") unless -f $path;
        push @routes, @$data;
      }

    @routes
  }

sub router
  {
    my $r = shift;

    my $router = Router::Simple->new ();
    for (read_files ($r))
      {
        my ($path, $route) = each %$_;

        # resolve symbolic function references
        while (my ($handler, $functions) = each %{$route->{handlers}})
          { $route->{handlers}->{$handler} = [map_resolve_subs (@$functions)]; }

        $router->connect ($path, $route);
      }

    $router
  }

1
