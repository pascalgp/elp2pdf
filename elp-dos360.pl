#!/usr/bin/perl

# =======
# DOS/360
# =======

sub init {
    return;
}

sub check_read {
    if($rstate == 0) {
        if(substr($rline, 0, 6) eq "// JOB") {
            $rstate = 1;
        }
    } elsif($rstate == 1) {
        if(substr($rline, 0, 4) eq "EOJ " &&
            substr($rline, 74, 1) eq "." &&
            substr($rline, 77, 1) eq ".") {
                $end_of_job = $readpt;
            }
    }
}

sub check_print {
    if($pstate == 0) {
        if(substr($pline, 0, 1) eq "\n" || substr($pline, 0, 1) eq "\f") {
            $pline = "";
        }
        ++$pstate;
    } elsif($pstate == 1) {
        if(substr($pline, 0, 1) eq "\f") {
            $pline = "";
        }
        ++$pstate;
    } elsif($pstate == 2) {
        if(substr($pline, 0, 6) eq "// JOB") {
            $pstate = 3;
        } else {
            $pstate = 4;
        }
    } elsif($pstate == 3) {
        if(substr($pline, 0, 4) eq "EOJ " &&
            substr($pline, 74, 1) eq "." &&
            substr($pline, 77, 1) eq ".") {
            $jobname = rtrim(substr($pline,4,8));
            $now_string = strftime "%Y-%m-%d-%H.%M.%S", localtime;
            $file_name = $prtid . "_" . $now_string . "_" . $jobname;
            $now_string = strftime "%Y-%m-%d %H:%M:%S", localtime;
            $title = $logid . " " . $now_string . " " . $jobname;
            $pstate = 5;
        }
    } elsif($pstate == 4 && $pcount == 46) {
        if(substr($pline, 0, 33) eq "*********************************") {
            $jobname = rtrim(substr($pline, 38, 8));
            $date = substr($pline, 62, 2) . "-" . substr($pline, 56,2) . "-" . substr($pline, 59, 2);
            $time = substr($pline, 74, 2) . "." . substr($pline, 77,2) . "." . substr($pline, 80, 2);
            $file_name = $prtid . "_" . $date . "_" . $time . "_" . $jobname;
            $time =~ tr/./:/;
            $title = $logid . " " . $date . " " . $time . " " . $jobname;
            $pstate = 5;
        }
    }
}

1;
