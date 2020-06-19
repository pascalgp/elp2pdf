#!/usr/bin/perl

# ===============
# Default printer
# ===============

sub init {
    return;
}

sub check_read() {
    return;
}

sub check_print() {
    if($pstate == 0) {
        if(substr($pline, 0, 1) eq "\f") {
            $pline = "";
        }
        ++$pstate;
    } elsif($pstate == 1) {
        if($printpt == $end_of_job) {
            if(substr($pline, 0, 1) eq "\f") {
                $pline = "";
            }
        }
    }
}

1;
