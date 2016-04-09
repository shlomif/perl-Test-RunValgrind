package Test::RunValgrind;

use strict;
use warnings;

our $VERSION = '0.0.1';

use Test::More;
use Path::Tiny qw/path/;

use Carp;

sub new
{
    my $class = shift;

    my $self = bless {}, $class;

    $self->_init(@_);

    return $self;
}

sub _init
{
    my ($self, $args) = @_;

    return;
}

sub run
{
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    my ($self, $args) = @_;

    my $blurb = $args->{blurb}
        or Carp::confess("blurb not specified.");

    my $log_fn = $args->{log_fn}
        or Carp::confess("log_fn not specified.");

    my $prog = $args->{prog}
        or Carp::confess("prog not specified.");

    my $argv = $args->{argv}
        or Carp::confess("argv not specified.");

    system(
        "valgrind",
        "--track-origins=yes",
        "--leak-check=yes",
        "--log-file=$log_fn",
        $prog,
        @$argv,
    );

    my $out_text = path( $log_fn )->slurp_utf8;
    my $ret = Test::More::ok (
        (index($out_text, q{ERROR SUMMARY: 0 errors from 0 contexts}) >= 0)
        &&
        (index($out_text, q{in use at exit: 0 bytes}) >= 0)
        , $blurb
    );
    if ($ret)
    {
        unlink($log_fn);
    }
    return $ret;
}

1;

__END__

=head1 NAME

Test::RunValgrind - tests that an external program is valgrind-clean.

=head1 SYNOPSIS

    use Test::More tests => 1;

    # TEST
    Test::RunValgrind->new({})->run(
        {
            log_fn => './expr--valgrind-log.txt',
            prog => '/usr/bin/expr',
            argv => [qw/5 + 6/],
            blurb => 'valgrind likes /usr/bin/expr',
        }
    );

=head1 DESCRIPTION

This module runs valgrind (L<http://en.wikipedia.org/wiki/Valgrind>) on
an executable and makes sure that valgrind did not find any faults in it.

It originated from some code used to test the Freecell Solver executables
using valgrind, and was extracted into its own CPAN module to allow for
reuse by other projects, including fortune-mod
(L<https://github.com/shlomif/fortune-mod>).

=head1 METHODS

=head2 my $obj = Test::RunValgrind->new({})

The constructor - currently accepts a single hash reference and does not use
any of its keys.

=head2 $obj->run({ ... })

Runs valgrind.

Accepts a hash ref with the following keys:

=over 4

=item * blurb

The L<Test::More> test assertion blurb.

=item * log_fn

The path to write the log file to (and read from it). Make sure it is secured.

=item * prog

The path to the executable to run.

=item * argv

An array reference contains strings with command line arguments to the executable.

=back

=cut

See the synopsis for an example.

=cut
