#!perl -w
use Prima;
use Test::More tests => 1;
use Prima::Application;
use AnyEvent::Impl::Prima;
use AnyEvent;
use AnyEvent::HTTP;

my $mw = Prima::MainWindow->new();

use Data::Dumper;
my $res;
my $w = http_get 'http://www.google.de',
    sub { $res = $_[1]; print Dumper $res; $mw->close },
;

my $timeout;
my $t = AnyEvent->timer(
    cb => sub { $timeout++; $mw->close if $timeout; },
    after => 10,
);

Prima->run;

is $timeout, undef, "No timeout";

done_testing;