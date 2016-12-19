=head1 NAME

AnyEvent::Impl::Prima - Prima event loop adapter for AnyEvent

=head1 SYNOPSIS

  use Prima;
  use AnyEvent::Impl::Prima;
  
  my $mw = Prima::MainWindow->new();
  
  my $timer = AnyEvent->timer(
      after => 10,
      cb => sub { $mw->close; },
  );

  Prima->run;
  
=cut

{

package AnyEvent::Impl::Prima; 
use strict;
use feature 'signatures';
no warnings 'experimental::signatures';

use vars '$VERSION';
$VERSION = '0.01';

use Prima;
use Prima::Application;

sub io($s,%r) { 
    Prima::File->new(
        file        => $r{fh}, 
        mask        => ("w" eq $r{poll} ? fe::Write() : fe::Read()) | fe::Exception(),
        onRead      => $r{cb},
        onWrite     => $r{cb},
        onException => $r{cb}
    )
} 

sub timer( $s, %r ) { 
    my($c,$g) = $r{cb};
    
    my $next = $r{ after } || $r{ interval };
    my $repeat = delete $r{ interval };
    
    # Convert to miliseconds for Prima
    $next *= 1000;
    $repeat *= 1000 if $repeat;
    
    my %timer_params = (
        timeout => $next,
    );
    
    my $res = Prima::Timer->new(
        timeout => $next,
        onTick  => sub( $self ) {
            if( $repeat ) {
                $self->timeout( $repeat );
            } else {
                $self->stop;
            };
            &$c()
        }
    );
    $res->start;
    $res
}

sub poll {
    require Prima::Application;
    $::application->yield;
}

sub AnyEvent::CondVar::Base::_wait {
    require Prima::Application;
    $::application->yield until exists $_[0]{_ae_sent};
}

push @AnyEvent::REGISTRY,["Prima",__PACKAGE__]; 

}
__END__

=head1 AUTHORS

Zsban Ambrus

Max Maischein