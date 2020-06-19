#!/usr/bin/perl

# =======
# MVS 3.8
# =======

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
    if($rstate == 0) {
        if ($rcount == 30) {
            if(substr($rline, 0, 4) eq "****" &&
                substr($rline, 5, 9) eq "   END   ") {
                    ++$rstate;
            }
        }
    } elsif($rstate == 1) {
        if($rcount == 34) {
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
        if ($pcount == 30) {
            if(substr($pline, 0, 4) eq "****" &&
                substr($pline, 5, 9) eq "   END   ") {
                    ++$pstate;
            }
        }
    } elsif($pstate == 2) {
        if($pcount == 33) {
            $jobid = rtrim(substr($pline, 14, 8));
            $jobid =~ s/ /0/g;
            $jobname = rtrim(substr($pline, 24, 8));
            $print_time_hh = rtrim(substr($pline, 67, 2));
            $print_time_hh =~ s/ /0/g;
            if(substr($pline, 76, 2) eq "PM") {
                if($print_time_hh ne "12") {
                    $print_time_hh = $print_time_hh + 12;
                }
            } else {
                if($print_time_hh eq "12") {
                    $print_time_hh = "00";
                }
            }
            $print_time = $print_time_hh . "." . rtrim(substr($pline, 70, 5));
            $print_date = rtrim(substr($pline, 79, 9));
            $print_date_f = substr($print_date, 7, 2) . "-" .
                            $month{substr($print_date, 3, 3)} . "-" .
                            substr($print_date, 0, 2);
            $file_name = $jobid . "_" . 
                         $jobname . "_" .
                         $print_date_f . "_" .
                         $print_time;
            $title = $jobid . " " .
                     $jobname . " " .
                     $print_date . " " .
                     $print_time;
            ++$pstate;
        }
    } elsif($pstate == 3) {
        if($pcount == 34) {
            $pline = "";
        }
    }
}

1;
