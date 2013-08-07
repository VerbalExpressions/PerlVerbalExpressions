use strict;
use warnings;
use Test::More;
use Regexp::VerbalExpression;

# https://github.com/jehna/VerbalExpressions/wiki

my $re = verex;

for my $meth (qw/
    anything
    anything_but
    end_of_line
    find
    maybe
    start_of_line
    then

    any
    any_of
    br
    line_break
    range
    tab
    word

    with_any_case
    stop_at_first
    search_one_line

    replace

    add
    multiple
    or
/) {
    ok $re->can($meth), "implement $meth";
}

done_testing;
