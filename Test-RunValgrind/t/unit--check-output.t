#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 1;

use Test::RunValgrind ();

{
    my $obj = Test::RunValgrind->new;

    # TEST
    ok( scalar( $obj->_calc_verdict( \<<'EOF') ), 'normal is fine by default' );
==26077== Memcheck, a memory error detector
==26077== Copyright (C) 2002-2017, and GNU GPL'd, by Julian Seward et al.
==26077== Using Valgrind-3.13.0 and LibVEX; rerun with -h for copyright info
==26077== Command: /bin/true
==26077==
==26077==
==26077== HEAP SUMMARY:
==26077==     in use at exit: 0 bytes in 0 blocks
==26077==   total heap usage: 0 allocs, 0 frees, 0 bytes allocated
==26077==
==26077== All heap blocks were freed -- no leaks are possible
==26077==
==26077== For counts of detected and suppressed errors, rerun with: -v
==26077== ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 0 from 0)
EOF
}

