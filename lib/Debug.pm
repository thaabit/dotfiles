package Debug;
use strict;
use base qw(Exporter);
use vars qw(@EXPORT_OK);
use Data::Dumper;

BEGIN {
    @EXPORT_OK = qw(dump debug);
}

sub dump {
    my $package = (caller)[0];
    my $level = ($package eq __PACKAGE__) ? 1 : 0;
    my ($file, $line_num) = (caller($level))[1,2];
    my @vars;
    if (-e $file) {
        open( my $FILE, '<', $file) or die $!;
        read $FILE, my $caller, -s $file;
        close $FILE;
        $line_num--;
        my ($line) = $caller =~ /(?:.*?\n){$line_num}(.*?)\n/;
        $line =~ s/^.*?(?:dump|debug|warn)\s*(.*?);.*?$/$1/;
        $line =~ s|\\||g;
        @vars = split /\s*,\s*/, $line;
    }
    my $shell = $ENV{'SHELL'};
    my $s =  '';
    $s .= '<pre>' unless $shell;
    $s .= '<b>' unless $shell;
    $line_num++;
    $s .= "From line $line_num of $file:\n";
    $s .= "</b>" unless $shell;
    my $d = Data::Dumper->new([@_], [@vars]);
    $d->Quotekeys(0);
    $d->Sortkeys(1);
    $s .= $d->Dump;
    $s .= '</pre><hr>' unless $shell;
    $s .= "\n\n";
    return $s;
}

sub debug {
    print &dump;
}

1;
