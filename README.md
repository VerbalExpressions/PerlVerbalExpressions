# NAME

Regexp::VerbalExpressions - Perl Regular expressions made easy

# SYNOPSIS

    use Regexp::VerbalExpressions;

    # Create an example of how to test for correctly formed URLs
    my $re = verex
           ->start_of_line
           ->then('http')
           ->maybe('s')
           ->then('://')
           ->maybe('www.')
           ->anything_but(' ')
           ->end_of_line;

    if ('https://www.google.com/' =~ $re) {
        print 'We have a correct URL'; # This output will fire
    } else {
        print 'The URL is incorrect';
    }

    print $re; # Outputs the actual expression used: ^(?:http)(?:s)?(?:\:\/\/)(?:www\.)?(?:[^\ ]*)$

# DESCRIPTION

Regexp::VerbalExpressions is a Perl module that helps to construct difficult regular expressions.

# API

## Modifiers

- `anything()`
- `anything_but($value)`
- `end_of_line()`
- `find($value)`
- `maybe($value)`
- `start_of_line()`
- `then($value)`

## Special characters and groups

- `any($value)`
- `any_of($value)`
- `br()`
- `line_break()`
- `range($from, $to)`
- `tab()`
- `word()`

## Modifiers

- `with_any_case()`
- `stop_at_first()`
- `search_one_line()`

## Functions

- `replace($source, $value)`

## Other

- `add($expression)`
- `multiple($value)`
- `or()`

# SEE ALSO

[https://github.com/VerbalExpressions/JSVerbalExpressions](https://github.com/VerbalExpressions/JSVerbalExpressions)

# LICENSE

Copyright (C) Takumi Akiyama.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Takumi Akiyama <t.akiym@gmail.com>
