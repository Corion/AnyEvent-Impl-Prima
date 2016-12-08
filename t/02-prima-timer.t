#!perl -w
use Prima;
use Test::More tests => 1;
use AnyEvent;
use Prima::Application;
use AnyEvent::Impl::Prima;

my $mw = Prima::MainWindow->new();

my $done;
my $t = AnyEvent->timer(
    cb => sub { $done++; $mw->close },
    after => 1,
);

Prima->run;

ok $done, "A timer catches us and we exit";

done_testing;