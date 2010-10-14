package Apache2::Router::Routes;

=head1 NAME

Apache2::Router::Routes - Route handling

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
        croak "function name [$_] not within package scope" unless defined $package;
        eval "require $package; 1" or do { croak $@ };
        \&$_;
      } @_;
  }

sub read_files
  {
    my ($r, $files) = @_;

    my $config = Config::Any->load_files ({files => $files || [], use_ext => 1});

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
    my ($r, $files) = @_;

    my $router = Router::Simple->new ();
    for (read_files ($r, $files))
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
