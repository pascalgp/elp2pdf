#!/usr/bin/perl

# ======
# OS/VS1
# ======

sub init {
    return;
}

sub check_read() {
    if($rstate == 0) {
        if($rline =~ /\/\/\S*\s+JOB.*/) {
            $end_of_job = $readpt - $rcount - 1;
           ++$rstate;
        }
    }
}

sub check_print() {
    if($pstate == 0) {
        if(substr($pline, 0, 1) eq "\r" || substr($pline, 0, 1) eq "\n") {
            $pline = "";
        } elsif(substr($pline, 0, 1) eq "\f") {
            $pline = "";
            ++$pstate;
        }
    } elsif($pstate == 1) {
        if($pline =~ /\/\/(\S*)\s+JOB.*/) {
            $jobname = $1;
            ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
            $now_string = strftime "%Y-%m-%d-%H.%M.%S", localtime;
            $file_name = $prtid . "_" . $now_string . "_" . $jobname;
            $now_string = strftime "%Y-%m-%d %H:%M:%S", localtime;
            $title = $logid . " " . $now_string . " " . $jobname;
            ++$pstate;
        }
    }
}

1;
