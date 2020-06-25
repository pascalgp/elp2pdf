#!/usr/bin/perl

# ======
# DOS/VS
# ======

sub init {
    return;
}

sub check_read {
    if($rstate == 0) {
        if($rcount == 58 && substr($rline, 0, 28) eq "********************     END") {
            ++$rstate;
        }
    } elsif($rstate == 1) {
        if($rcount == 40) {
            $end_of_job = $readpt;
        }
    }
}

sub check_print {
    if($pstate == 0) {
        if(substr($pline, 0, 1) eq "\f") {
            $pline = "";
        }
        ++$pstate;
    } elsif($pstate == 1) {
        if(substr($pcount == 58 && $pline, 0, 28) eq "********************     END") {
            $jobname = rtrim(substr($pline, 31, 10));
            $jobnum = rtrim(substr($pline, 42, 5));
            $job_date = rtrim(substr($pline, 77, 9));
            $job_date =~ tr/ /-/;
            $job_time = rtrim(substr($pline, 89, 8));
            $file_name = $prtid . "_" .
                         $jobnum . "_" . 
                         $jobname . "_" .
                         $job_date . "_" .
                         $job_time;
            $title = $logid . " " .
                     $jobnum . " " .
                     $jobname . " " .
                     $job_date . " " .
                     $job_time;
        } elsif($printpt == $end_of_job) {
            if(substr($pline, 0, 1) eq "\f") {
                $pline = "";
            }
        } 
    }
}

1;
