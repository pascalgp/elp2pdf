#!/usr/bin/perl

# ===========
# TOPS-20 4.1
# ===========

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
        if(substr($rline, 0, 7) eq "**END**") {
            ++$rstate;
        }
    } elsif($rstate == 1) {
        if(substr($rline, 0, 7) eq "1234567") {
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
    } elsif($pstate == 1 && $pcount == 5) {
        @jobw = split ' ', $pline;
        $jobid = sprintf("%04d", substr($jobw[4], 1));
        $jobname = $jobw[2];
        $userid = $jobw[6];
        @job_time = split ':', $jobw[9];
        $print_time_f = sprintf("%02d", $job_time[0]) . "." .
                        sprintf("%02d", $job_time[1]) . "." .
                        sprintf("%02d", $job_time[2]);
        @job_date = split '-', $jobw[8];
        $print_date_f = $job_date[2] . "-" .
                        $month{$job_date[1]} . "-" .
                        sprintf("%02d", $job_date[0]);
        ++$pstate;
    } elsif($pstate == 2 && $pcount == 1) {
        if(substr($pline, 0, 7) eq "**END**") {
            ++$pstate;
        }
    } elsif($pstate == 3) {
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
        }
    }
}

1;
