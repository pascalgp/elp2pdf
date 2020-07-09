#!/usr/bin/perl

# =====
# MPE V
# =====

sub init {
    return;
}

sub check_read {
    if($rstate == 0) {
        if ((($rcount - 1) % 66 == 57) && ($rline =~ /^#S\d*; #O\d*  \*  \S*; \S*  \*  \S* \S*\s*\S*, \S*,\s*\d*:\d* \S*/)) {
            ++$rstate;
        }  elsif ((($rcount - 1) % 66 == 57) && ($rline =~ /^#J\d*; #O\d*  \*  \S*, \S*; \S*  \*  \S* \S*\s*\S*, \S*,\s*\d*:\d* \S*/)) {
            ++$rstate;
        }
    } elsif($rstate == 1) {
        if(($rcount - 1) % 66 == 65 && substr($rline, -1) eq "\n") {
            $end_of_job = $readpt;
        }
    }
}

sub check_print {
    if($pstate == 0) {
        if((($pcount - 1) % 66 == 0) && ($pline =~ /^#(S\d*); #(O\d*)  \*  (\S*); (\S*)  \*  \S* (\S*)\s*(\S*), (\S*),\s*(\d*):(\d*) (\S*)/)) {
            $file_name = $1 . "_" . $2 . "_" . $3 . "_" . $4 . "_" . $5 . "_" .
                         sprintf("%02d", $6) . "_" . $7 . "_" . sprintf("%02d", $8) . "_" . sprintf("%02d", $9) . "_" . $10;
            $file_name =~ tr/$/@/;
            $title     = $1 . " " . $2 . " " . $3 . " " . $4 . " " . $5 . " " .
                         sprintf("%02d", $6) . " " . $7 . " " . sprintf("%02d", $8) . ":" . sprintf("%02d", $9) . " " . $10;
            $title =~ tr/$/@/;
            ++$pstate;
       } elsif((($pcount - 1) % 66 == 0) && ($pline =~ /^#(J\d*); #(O\d*)  \*  (\S*), (\S*); (\S*)  \*  \S* (\S*)\s*(\S*), (\S*),\s*(\d*):(\d*) (\S*)/)) {
            $file_name = $1 . "_" . $2 . "_" . $3 . "_" . $4 . "_" . $5 . "_" . $6 . "_" .
                         sprintf("%02d", $7) . "_" . $8 . "_" . sprintf("%02d", $9) . "_" . sprintf("%02d", $10) . "_" . $11;
            $file_name =~ tr/$/@/;
            $title     = $1 . " " . $2 . " " . $3 . " " . $4 . " " . $5 . " " . $6 . " " .
                         sprintf("%02d", $7) . " " . $8 . " " . sprintf("%02d", $9) . ":" . sprintf("%02d", $10) . " " . $11;
            $title =~ tr/$/@/;
            ++$pstate;
       } else {
            $pline = "";
       }    
    } elsif(($pstate == 1) && (($pcount - 1) % 66 == 65)) {
        $pstate = 2;
    } elsif($pstate == 2) {
        if ((($pcount - 1) % 66 == 57) && ($pline =~ /^#S\d*; #O\d*  \*  \S*; \S*  \*  \S* \S*\s*\S*, \S*,\s*\d*:\d* \S*/)) {
            ++$pstate;
        }  elsif ((($pcount - 1) % 66 == 57) && ($pline =~ /^#J\d*; #O\d*  \*  \S*, \S*; \S*  \*  \S* \S*\s*\S*, \S*,\s*\d*:\d* \S*/)) {
            ++$pstate;
        }
    } elsif($pstate == 3) {
        if(($pcount - 1) % 66 > 59) {
            $pline = "";
        }
    }
}

1;
