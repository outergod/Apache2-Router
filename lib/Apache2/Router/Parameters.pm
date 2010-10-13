package Apache2::Router::Parameters;

=head1 NAME

Apache2::Router::Parameters - Custom Apache2::Router httpd.conf parameters

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

use Apache2::Module;
use Apache2::CmdParms;
use Apache2::Const -compile => qw (RSRC_CONF ITERATE);

use Exporter;
use base qw (Exporter);
our @EXPORT = qw (module_config);

Apache2::Module::add (__PACKAGE__, [{
  name => 'RouteFiles',
  req_override => Apache2::Const::RSRC_CONF,
  args_how     => Apache2::Const::ITERATE,
  errmsg       => 'RouteFiles file [file...]'
}, {
  name => 'RouteDebug',
  req_override => Apache2::Const::RSRC_CONF,
  errmsg       => 'RouteDebug 0|1'
}]);

sub RouteFiles { push_val ('RouteFiles', @_) }
sub RouteDebug { set_val  ('RouteDebug', @_) }

sub srv_cfg
  {
    my ($self, $parms) = @_;
    Apache2::Module::get_config ($self, $parms->server);
  }

sub set_val
  {
    my ($key, $self, $parms, $arg) = @_;
    srv_cfg ($self, $parms)->{$key} = $arg;
  }

sub push_val
  {
    my ($key, $self, $parms, $arg) = @_;
    push @{srv_cfg ($self, $parms)->{$key}}, $arg;
  }

sub module_config
  {
    my ($r, $key) = @_;
    my $srv_cfg = Apache2::Module::get_config (__PACKAGE__, $r->server);
    $srv_cfg->{$key}
  }

1
