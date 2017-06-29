#!perl -w
use Test::More tests => 1;
BEGIN {
if( $^O !~ /mswin|darwin/i ) {
    if( ! $ENV{DISPLAY} ) {
        SKIP: {
            skip "Need a display for the tests", 1;
        };
        exit;
    };
};
}
use AnyEvent::Impl::Prima;
use AnyEvent;
use AnyEvent::HTTP;
use Prima;
use Prima::Application;

use Test::HTTP::LocalServer;

my $server = Test::HTTP::LocalServer->spawn();

my $mw = Prima::MainWindow->new();

use Data::Dumper;
my $res;
my $w = http_get $server->url,
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
