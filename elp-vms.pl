#!/usr/bin/perl

# ===
# VMS
# ===

sub init {
    return;
}

sub check_read {
    if($rstate == 0 && $rcount == 58) {
        if($rline eq "1234567890123456789012345678901234567890123456789012345678901234567890" .
                     "12345678901234567890123456789012345678901234567890123456789012\f") {
            $end_of_job = $readpt;
        }
    }
}

sub check_print {
    if($pstate == 0) {
        if(substr($pline, 0, 1) == '\f') {
            $pline = "";
        }
        ++$pstate;
    } elsif($pstate == 1 && $pcount == 53) {
        @jobw = split ' ', $pline;
        $jobname = $jobw[1];
        $jobid = sprintf("%04d", substr($jobw[2], 1, -1));
        $userid = substr($jobw[11], 0, -1);
        $jobdate = $jobw[7];
        @jobtime = split ':', $jobw[8];
        $print_time   = sprintf("%02d", $jobtime[0]) . ":" .
                        sprintf("%02d", $jobtime[1]);
        $print_time_f = sprintf("%02d", $jobtime[0]) .
                        sprintf("%02d", $jobtime[1]);
        $file_name = $prtid . "_" . $jobid . "_" . 
                     $userid . "_" . 
                     $jobname . "_" .
                     $jobdate . "_" .
                     $print_time_f;
        $title = $logid . " " .
                 $userid . " " .
                 $jobname . " " .
                 $jobdate . " " .
                 $print_time;
        ++$pstate;
    } elsif($printpt == $end_of_job) {
        $pline = substr($pline, 0, -1) . "\n";
    }
}

1;
