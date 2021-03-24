#!/usr/bin/perl

# ==========
# TOPS-10 V7
# ==========

sub init {
    %month = (
    "Jan" => '01',
    "Feb" => '02',
    "Mar" => '03',
    "Apr" => '04',
    "May" => '05',
    "Jun" => '06',
    "Jul" => '07',
    "Aug" => '08',
    "Sep" => '09',
    "Oct" => '10',
    "Nov" => '11',
    "Dec" => '12' );
}

sub check_read {
    if($rstate == 0 && $rcount == 1) {
        if(substr($rline, 1, 7) eq "**END**") {
            ++$rstate;
        }
    } elsif($rstate == 1) {
        if(substr($rline, 0, 7) eq "1234567") {
            ++$rstate;
        }
    } elsif($rstate == 2) {
        if(substr($rline, 0, 7) eq "1234567") {
            $end_of_job = $readpt + 1;
        }
    }
}

sub check_print {
    if($pstate == 0) {
        if(substr($pline, 0, 1) eq "\f") {
            $pline = "";
        }
        ++$pstate;
    } elsif($pstate == 1 && $pcount == 5) {
        @jobw = split ' ', $pline;
        $jobid = sprintf("%04d", $jobw[7]);
        $jobname = $jobw[5];
        $userid = $jobw[2];
        @job_time = split ':', $jobw[10];
        $print_time_f = sprintf("%02d", $job_time[0]) . "." .
                        sprintf("%02d", $job_time[1]) . "." .
                        sprintf("%02d", $job_time[2]);
        @job_date = split '-', $jobw[9];
        $print_date_f = $job_date[2] . "-" .
                        $month{$job_date[1]} . "-" .
                        sprintf("%02d", $job_date[0]);
        ++$pstate;
    } elsif($pstate == 2 && $pcount == 1) {
        if(substr($pline, 1, 7) eq "**END**") {
            ++$pstate;
        }
    } elsif($pstate == 3) {
        if(substr($pline, 0, 7) eq "1234567") {
            ++$pstate;
        }
    } elsif($pstate == 4) {
        if(substr($pline, 0, 7) eq "1234567") {
            $file_name = $prtid . "_" . $jobid . "_" . 
                         $userid . "_" . 
                         $jobname . "_" .
                         $print_date_f . "_" .
                         $print_time_f;
            $title = $logid . " " . $jobid . " " .
                     $userid . " " .
                     $jobname . " " .
                     $print_date_f . " " .
                     $print_time_f;
            ++$pstate;
        }
    } else {
        if ($printpt == $end_of_job) {
            $pline = "";
        }
    }
}

1;
