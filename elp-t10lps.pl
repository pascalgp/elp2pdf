#!/usr/bin/perl

# ==============
# TOPS-10 LPTSPL
# ==============

sub init {
    %month = (
    "January"   => '01',
    "February"  => '02',
    "March"     => '03',
    "April"     => '04',
    "May"       => '05',
    "June"      => '06',
    "July"      => '07',
    "August"    => '08',
    "September" => '09',
    "October"   => '10',
    "November"  => '11',
    "December"  => '12' );
}

sub check_read {
    if($rstate == 0 && ($rcount == 2 || $rcount == 3)) {
        if(substr($rline, 1, 9) eq "***END***") {
            ++$rstate;
        }
    } elsif($rstate == 1 && substr($rline, -1) eq "\f") {
        $end_of_job = $readpt;
    }
}

sub check_print {
        if(substr($pline, 0 , 14) eq "LPTSPL Version") {
            ++$pstate;
        }
    if($pstate == 0) {
        if(substr($pline, 0, 1) eq "\f") {
            $pline = "";
        }
        ++$pstate;
    } elsif($pstate == 1 && $pcount == 1) {
        if(substr($pline, 0 , 14) eq "LPTSPL Version") {
            ++$pstate;
        }
    } elsif($pstate == 2 && $pcount == 2) {
        @jobw = split ' ', $pline;
        if($jobw[10] eq "Address:") {
            $jdaten = 8;
            $jtimen = 9;
            $jobid = $jobw[7];
        } else {
            $jdaten = 9;
            $jtimen = 10;
            $jobid = $jobw[7].$jobw[8];
        }
        $userid = $jobw[2];
        $print_time = $jobw[$jtimen];
        $print_time_f = substr($print_time, 0, 2) . "." .
                        substr($print_time, 3, 2) . "." .
                        substr($print_time, 6, 2);
        @job_date = split '-', $jobw[$jdaten];
        $print_date_f = substr($job_date[2],2,2) . "-" .
                        $month{$job_date[1]} . "-" .
                        $job_date[0];
        $file_name = $prtid . "_" .
                     $jobid . "_" .
                     $userid . "_" . 
                     $print_date_f . "_" .
                     $print_time_f;
        $title = $jobid . " " .
                 $userid . " " .
                 $print_date_f . " " .
                 $print_time;
        ++$pstate;
    } elsif ($printpt == $end_of_job) {
        if(substr($pline, 0, 1) eq "\f") {
            $pline = "";
        }
    }
}

1;
