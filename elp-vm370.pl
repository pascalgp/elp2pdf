#!/usr/bin/perl

# ======
# VM/370
# ======

sub init {
    return;
}

sub check_read {
    if($rstate == 0) {
        if(substr($rline, 1, 20) eq "********************" && $rcount == 58) {
            ++$rstate;
        }
    } elsif($rstate == 1) {
        if(substr($rline, 11, 6) eq "USERID" && $rcount == 72) {
            $end_of_job = $readpt - 74;
        }
    }
}

sub check_print {
    if($pstate == 0) {
        if(ord(substr($pline, 0, 1)) == 0x9f && substr($pline, 1, 1) eq "\r") {
            $pline = "";
        } elsif(substr($pline, 0, 1) eq "\f") {
            $pline = "";
            ++$pstate;
        } else {
            ++$pstate;
        }
    } elsif($pstate == 1) {
        if(substr($pline, 1, 20) eq "********************" && $pcount == 58) {
            ++$pstate;
        }
    } elsif($pstate == 2) {
        if(substr($pline, 11, 6) eq "USERID" && $pcount == 72) {
            $userid = rtrim(substr($pline, 33, 12));
        } elsif(substr($pline, 11, 8) eq "CREATION" && $pcount == 78) {
            $print_date = substr($pline, 39, 2) . "-" .
                substr($pline, 36, 2) . "-" .
                substr($pline, 33, 2);
            $print_time = substr($pline, 42, 2) . "." .
                substr($pline, 45, 2) . "." .
                substr($pline, 48, 2);
        } elsif(substr($pline, 11, 13) eq "SPOOL FILE ID" && $pcount == 80) {
            $spool_id = rtrim(substr($pline, 33, 4));
            $file_name = $prtid . "_" . $spool_id . "_" . 
                $userid . "_" .
                $print_date . "_" .
                $print_time;
            $title = $logid . " " . $spool_id . " " .
                $userid . " " .
                $print_date . " " .
                $print_time;
            ++$pstate;
        }
    } elsif($printpt == $end_of_job) {
        if(substr($pline, 0, 1) eq "\f") {
            $pline = "";
        }
    }
}

1;
