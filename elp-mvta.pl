#!/usr/bin/perl

# =======
# MVT ASP
# =======

sub init {
    return;
}

sub check_read {
    if($rstate == 0 && $rcount == 80) {
        if(substr($rline, 10, 14) eq "ASP JOB NO. = ") {
            ++$rstate;
        }
    } elsif($rstate == 1 && substr($rline, 0, 8) eq "********") {
        $rstop = $readpt + 11;
        ++$rstate;
    } elsif($rstate == 2 && $readpt == $rstop) {
        $end_of_job = $rstop;
    }
}

sub check_print {
    if($pstate == 0) {
        if(substr($pline, 0, 1) eq "\f") {
            $pline = "";
        }
        ++$pstate;
    } elsif($pstate == 1 && $pcount == 80){
        if(substr($pline, 10, 14) eq "ASP JOB NO. = ") {
            $jobno = rtrim(substr($pline, 24, 4));
            $print_date = rtrim(substr($pline, 72, 6));
            ++$pstate;
        }
    } elsif($pstate == 2 && substr($pline, 0, 2) eq "//") {
            $jobname = substr($pline, 2, index($pline, " ") - 2);
            ++$pstate;
    } elsif($pstate == 3 && substr($pline, 52, 10) eq "START TIME") {
            $start_time = rtrim(substr($pline, 65, 8));
            $file_name = $prtid . "_" . $jobno . "_" . 
                         $jobname . "_" .
                         $print_date . "_" .
                         $start_time;
            $title = $logid . " " . $jobno . " " . 
                     $jobname . " " .
                     $print_date . " " .
                     $start_time;
            ++$pstate;
    } elsif($pstate == 4) {
        if($printpt == $end_of_job) {
            if(substr($pline, 0, 1) eq "\f") {
                $pline = "";
            }
        }
    }
}

1;
