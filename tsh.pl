#!/usr/bin/perl

# tsh.pl - simulated taskwarrior shell
#
# Copyright 2013, Fidel Mato.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# http://www.opensource.org/licenses/mit-license.php

#  *************************************************************************************
#  * WARNING : Under developement, not production state. Watch your data: make backups *
#  *************************************************************************************

use strict;
use warnings;
use utf8;
binmode( STDOUT, ":utf8" );    # or use open ":utf8", ":std";

#use Term::ANSIColor;        # Color screen output using ANSI escape sequences
use Term::ReadLine;         # Perl interface to various readline packages.
use Term::ReadLine::Gnu;    # Perl extension for the GNU Readline/History Library.
use Term::UI;               # Term::ReadLine UI made easy
                            #
# use Term::ReadKey;        # MSWindows?

my $STRING_MSG_TIM  = "Running for ";
my $STRING_MSG_BYE  = ". Bye.";

my $intime = time();                                                  # Record time

# ----------------------------------------------------------------------------- goingout()
# goingout( $msg , $retval , $showtime );  does not return, exit function.
# -----------------------------------------------------------------------------
sub goingout {
    use integer;
    my $retval = shift; my $showtime = shift;

    if ( $showtime == 1 ) {
        $_ = time() - $intime;
        my $s = $_ % 60; $_ /= 60;
        my $m = $_ % 60; $_ /= 60; $m = ($m == 0) ? "" : $m."m " ;
        my $h = $_ % 24; $_ /= 24; $h = ($h == 0) ? "" : $h."h " ;
        my $d = $_;                $d = ($d == 0) ? "" : $d."d " ;
        print ( $STRING_MSG_TIM.$d.$h.$m.$s."s $STRING_MSG_BYE\n" );
    }
    exit( $retval );
}

# ------------------------------------------------------------------ Term::Readline object
my $term = Term::ReadLine->new('');
$term->ornaments(0);                 # disable prompt default styling (underline)

#my %features = %{$term->Features};
#print "Features supported by ",$term->ReadLine,"\n";
#foreach (sort keys %features) { print "\t$_ => \t$features{$_}\n"; }; exit 0;

my $line   = '';
my $prompt = 'tsh> ';
print("\n");                                                # blank line
while( 1 ) {                                                # forever
#    $line = $term->get_reply( prompt => $prompt );          # error: needs up arrow twice
    $line = $term->readline($prompt);                       # getting user input (ui)
    if ( !$line ) { $line = ''; }
    $line =~ s/^\s*//; $line =~ s/\s*$//;                   # strip blanks
    if ( $line eq 'q' || $line eq 'exit' ) {
        goingout( 0 , 1 );                                  # bye
    }
    system("task $line");
}   # -------------------------------------------------------------------------- Main Loop
__END__

