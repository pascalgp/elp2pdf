#!/usr/bin/perl

# ========
# MVT HASP
# ========

sub init {
    %month = (
    "JAN" => '01',
    "FEB" => '02',
    "MAR" => '03',
    "APR" => '04',
    "MAY" => '05',
    "JUN" => '06',
    "JUL" => '07',
    "AUG" => '08',
    "SEP" => '09',
    "OCT" => '10',
    "NOV" => '11',
    "DEC" => '12' );
}

sub check_read {
    if($rstate == 0 && $rcount == 61 && substr($rline, 24, 7) eq "END JOB") {
        ++$rstate;
    } elsif($rstate == 1) {
        $end_of_job = $readpt;
    }
}

sub check_print {
    if($pstate == 0) {
        if(substr($pline, 0, 1) eq "\f") {
            $pline = "";
        }
        ++$pstate;
    } elsif($pstate == 1 && $pcount == 30){
        if(substr($pline, 22, 9) eq "START JOB") {
            $jobid = substr($pline, 32, 4);
            $jobid =~ s/ /0/g;
            $jobname = rtrim(substr($pline, 78, 8));
            $print_time_hh = rtrim(substr($pline, 40, 2));
            $print_time_hh =~ s/\./0/g;
            if(substr($pline, 49, 2) eq "PM") {
                if($print_time_hh ne "12") {
                    $print_time_hh = $print_time_hh + 12;
                }
            } else {
                if($print_time_hh eq "12") {
                    $print_time_hh = "00";
                }
            }
            $print_time = $print_time_hh . "." . rtrim(substr($pline, 43, 5));
            $print_date = rtrim(substr($pline, 52, 9));
            $print_date_f = substr($print_date, 7, 2) . "-" .
                            $month{substr($print_date, 3, 3)} . "-" .
                            sprintf("%02d", substr($print_date, 0, 2));
            $file_name = $prtid . "_" . $jobid . "_" . 
                         $jobname . "_" .
                         $print_date_f . "_" .
                         $print_time;
            $title = $logid . " " . $jobid . " " .
                     $jobname . " " .
                     $print_date . " " .
                     $print_time;
            ++$pstate;
        }
    } elsif($pstate == 2) {
        if($printpt == $end_of_job) {
            if(substr($pline, 0, 1) eq "\f") {
                $pline = "";
            }
        }
    }
}

1;
