use strict;
use warnings;
use Test::More;
use Regexp::VerbalExpression;

is verex->add('^$'), '^$';

{
    my $re = verex->start_of_line->range('a' => 'c')->regex;
    for my $c ('a'..'c') {
        like $c, $re;
    }
    unlike 'd', $re;
}

{
    my $re = verex->start_of_line->range('a' => 'b', 'X' => 'Z')->regex;
    for my $c ('a'..'b') {
        like $c, $re;
    }
    for my $c ('X'..'Z') {
        like $c, $re;
    }
    unlike 'c', $re;
    unlike 'W', $re;
}

like 'text  ', verex->start_of_line->regex;
like '', verex->start_of_line->end_of_line->regex;
like '!@#$%¨&*()__+{}', verex->start_of_line->anything->end_of_line->regex;

{
    my $re = verex->start_of_line->anything_but('X')->end_of_line->regex;
    like 'Y Files', $re;
    unlike 'VerEX', $re;
}

{
    my $re = verex->start_of_line->find('Wally')->end_of_line->regex;
    like 'Wally', $re;
    unlike 'Wall-e', $re;
}

{
    my $re = verex->start_of_line->find('Python2.')->maybe('7')->end_of_line->regex;
    like 'Python2.7', $re;
    like 'Python2.', $re;
}

{
    my $re = verex->start_of_line->any('Q')->anything->end_of_line->regex;
    like 'Query', $re;
    unlike 'W', $re;
}

{
    my $re = verex->start_of_line->anything->line_break->anything->end_of_line->regex;
    like "Marco \n Polo", $re;
    like "Marco \r\n Polo", $re;
    unlike 'Marco Polo', $re;
}

{
    my $re = verex->start_of_line->anything->tab->end_of_line->regex;
    like "One tab only\t", $re;
    unlike 'No tab there', $re;
}

like 'Oneword', verex->start_of_line->anything->word->end_of_line->regex;

{
    my $re = verex->start_of_line->anything->find('G')->or->find('h')->end_of_line->regex;
    like 'Github', $re;
    unlike 'Bitbucket', $re;
}

like 'thor', verex->start_of_line->find('THOR')->end_of_line->with_any_case(1)->regex;
like "Ping \n Pong \n Ping", verex->start_of_line->anything->find('Pong')->anything->end_of_line->search_one_line(1)->regex;
like 'mail@mail.com', verex->start_of_line->word->then('@')->word->then('.')->word->end_of_line->regex;
like 'https://www.google.com/', verex->start_of_line->then('http')->maybe('s')->then('://')->maybe('www.')->word->then('.')->word->maybe('/')->end_of_line->regex;

is verex->start_of_line->tab->replace("\tabc\t", ''), "abc\t";
is verex->tab->stop_at_first(1)->replace("\tabc\t", ''), "abc";
is verex->find('A')->with_any_case(1)->stop_at_first(1)->replace("abcabc", ''), "bcbc";

done_testing;
