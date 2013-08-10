use strict;
use warnings;
use Test::More;
use Regexp::VerbalExpressions;

# taken from JSVerbalExpressions/test/tests.js

subtest 'something' => sub {
    my $re = verex->something->regex;
    unlike '', $re;
    like 'a', $re;
};

subtest 'anything' => sub {
    my $re = verex->start_of_line->anything->regex;
    like 'what', $re;
};

subtest 'anything_but' => sub {
    my $re = verex->start_of_line->anything_but('w')->regex;
    like 'what', $re;
};

subtest 'something_but' => sub {
    my $re = verex->something_but('a')->regex;
    unlike '', $re;
    like 'b', $re;
    unlike 'a', $re;
};

subtest 'start_of_line' => sub {
    my $re = verex->start_of_line->then('a')->regex;
    like 'a', $re;
    unlike 'ba', $re;
};

subtest 'end_of_line' => sub {
    my $re = verex->find('a')->end_of_line->regex;
    like 'a', $re;
    unlike 'ab', $re;
};

subtest 'maybe' => sub {
    my $re = verex->start_of_line->then('a')->maybe('b')->regex;
    like 'acb', $re;
    like 'abc', $re;
};

subtest 'any_of' => sub {
    my $re = verex->start_of_line->then('a')->any_of('xyz')->regex;
    like 'ay', $re;
    unlike 'abc', $re;
};

subtest 'or' => sub {
    my $re = verex->start_of_line->then('abc')->or('def')->regex;
    like 'defzzz', $re;
    unlike 'xyzabc', $re;
};

subtest 'line_break' => sub {
    my $re = verex->start_of_line->then('abc')->line_break->then('def')->regex;
    like "abc\r\ndef", $re;
    like "abc\ndef", $re;
    unlike "abc\r\n def", $re;
};

subtest 'br' => sub {
    my $re = verex->start_of_line->then('abc')->line_break->then('def')->regex;
    like "abc\r\ndef", $re;
    like "abc\ndef", $re;
    unlike "abc\r\n def", $re;
};

subtest 'tab' => sub {
    my $re = verex->start_of_line->tab->then('abc')->regex;
    like "\tabc", $re;
    unlike 'abc', $re;
};

subtest 'with_any_case' => sub {
    unlike 'A', verex->start_of_line->then('a')->regex;

    my $re = verex->start_of_line->then('a')->with_any_case->regex;
    like 'A', $re;
    like 'a', $re;
};

subtest 'search_one_line' => sub {
    like "a\nb", verex->start_of_line->then('a')->br->then('b')->end_of_line->regex;
    like "a\nb", verex->start_of_line->then('a')->br->then('b')->end_of_line->search_one_line->regex;
};

done_testing;
