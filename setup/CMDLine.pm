#!/usr/bin/perl
use parent 'Exporter';
use warnings;
use strict;
use Data::Debug qw(debug);

use Term::ANSIColor qw(:constants);

# Exported by default
our @EXPORT_OK = qw(runcmd readprompt inform done install_package package_installed binary_installed);

my $RESET = RESET;
my $COLOR_SUCCESS = GREEN.BOLD;
my $COLOR_WARN    = YELLOW.BOLD;
my $COLOR_INFORM  = WHITE.BOLD;
my $COLOR_PROMPT  = BLUE.BOLD;

sub runcmd {
    my $cmd = shift;
    print "${COLOR_PROMPT}$cmd${RESET}\n";
    print `$cmd`;
    print "\n";
}

sub inform {
    my $msg = shift;
    print "${COLOR_INFORM}$msg${RESET}"
}

sub done {
    my $msg = shift || "done";
    print "\n${COLOR_SUCCESS}${msg}${RESET}\n"
}

sub binary_installed {
    my $bin = shift;
    return `command -v "$bin"`;
}

sub package_installed {
    my $pkg = shift;
    my $installed = `dpkg-query -W -f='\${Status}' $pkg 2>/dev/null | grep -q "ok installed" && echo 1 || echo 0`;
    chomp($installed);
    if ($installed) {
        inform("$pkg already installed\n");
        return 1;
    }
    return 0;
}

sub install_package {
    my $pkg = shift;
    my $cmd = "sudo apt-get install -y $pkg";
    runcmd($cmd);
}

sub readprompt {
    my $prompt = shift;
    print "$prompt: ";
    my $resp = <STDIN>;
    chomp $resp;
    return $resp;
}

1;
