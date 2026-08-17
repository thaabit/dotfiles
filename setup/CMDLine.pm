#!/usr/bin/perl
use warnings;
use strict;
use parent 'Exporter';

use Data::Debug qw(debug);
use Term::ANSIColor qw(:constants);
use File::Path qw(make_path);
use File::Copy;

# Exported by default
our @EXPORT_OK = qw(runcmd readprompt inform done install_package package_installed binary_installed create_and_write);

my $RESET = RESET;
my $COLOR_SUCCESS = GREEN.BOLD;
my $COLOR_WARN    = YELLOW.BOLD;
my $COLOR_INFORM  = WHITE.BOLD;
my $COLOR_PROMPT  = BLUE.BOLD;

sub runcmd {
    my $cmd = shift;
    print "${COLOR_PROMPT}$cmd${RESET}\n";
    system($cmd) == 0 or die "Failed to run $cmd: $?";
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

sub create_and_write {
    my $path = shift;
    my $contents = shift;
    die "need to run as sudo" unless &is_sudo;
    my $folder = $path =~ s{/[^/]+$}{}r;
    make_path($folder, { verbose => 1, mode => 0755 });
    copy($path, "$path.old") or die "cannot copy $path: $!" if -e $path;
    open(my $fh, '>', $path);
    $contents = &trim($contents);
    print $fh $contents;
    close $fh;
}

sub trim {
    my $string = shift;
    return $string =~ s/^\s+|\s+$//gr;
}

sub is_sudo { return $> == 0 }

1;
