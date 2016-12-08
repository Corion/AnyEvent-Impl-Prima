#!perl -w
use Prima;
use Test::More tests => 1;
use AnyEvent;
use Prima::Application;
use AnyEvent::Impl::Prima;

my $mw = Prima::MainWindow->new();

my $called;
my $t = AnyEvent->timer(
    cb => sub { $called++; $mw->close if $called > 1 },
    after => 4,
    interval => 1,
);

Prima->run;

is $called, 2, "We catch repeating timers";

done_testing;