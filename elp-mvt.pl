#!/usr/bin/perl

# ===
# MVT
# ===

sub init {
    return;
}

sub check_read {
    if($rstate == 0) {
        if(substr($rline, 54, 24) eq "<==JOB END STATISTICS==>") {
            $rstop = $readpt + 5;
            ++$rstate;
        }
    } elsif($rstate == 1 && $readpt == $rstop) {
        $end_of_job = $rstop;
    }
}

sub check_print {
    if($pstate == 0) {
        if(substr($pline, 0, 1) ne "\r") {
            if(substr($pline, 0, 1) eq "\f") {
                $pline = "";
            }
            ++$pstate;
        }
    } elsif($pstate == 1) {
        if(substr($pline, 54, 24) eq "<==JOB END STATISTICS==>") {
            ++$pstate;
        }
    } elsif($pstate == 2) {
        if(substr($pline, 4, 8) eq "JOB NAME") {
            $jobname = rtrim(substr($pline, 14, 8));
            ++$pstate;
        }
    } elsif($pstate == 3) {
        if(substr($pline, 25, 7) eq "JOB END") {
            $end_time = substr($pline, 39,8);
            $end_time =~ s/:/./g;
            $end_date = substr($pline, 76, 4) . "-" .
                        substr($pline, 81, 2) . "-" .
                        substr($pline, 84, 2);
            $file_name = $prtid . "_" . $end_date . "_" .
                         $end_time . "_" . $jobname;
            $title = $logid . " " . $end_date . " " .
                     $end_time . " " . $jobname;
            ++$pstate;
        }
    }
}

1;
