#!/usr/bin/perl

# =====
# MUSIC
# =====

sub init {
    return;
}

sub check_read {
    if($rstate == 0) {
        if($rcount == 61 && substr($rline, 0, 10) eq "END OF JOB") {
            ++$rstate;
        }
    } elsif($rstate == 1) {
        if($rcount == 62) {
            $end_of_job = $readpt;
        }
    }
}

sub check_print {
    if ($pstate == 0) {
        if(substr($pline, 0, 1) eq "\n") {
            $pline = "";
        }
        ++$pstate;
    } elsif($pstate == 1) {
        if(substr($pline, 0, 1) eq "\f") {
            $pline = "";
        }
        ++$pstate;
    } elsif($pstate == 2) {
        if(substr($pline, 0, 10) eq "END OF JOB") {
            $userid = rtrim(substr($pline, 27, 8));
            $jobid = rtrim(substr($pline, 11, 8));
            $now_string = strftime "%Y-%m-%d_%H.%M.%S", localtime;
            $file_name = $prtid . "_" . $now_string . "_" .
                         $userid . "_" . 
                         $jobid;
            $now_string =~ tr/_/ /;
            $title = $logid . " " . $now_string . " " .
                     $userid . " " .
                     $jobid;
        ++$pstate;
        }
    }
}

1;
