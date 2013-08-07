# NAME

Regexp::VerbalExpression - Perl Regular expressions made easy

# SYNOPSIS

    use Regexp::VerbalExpression;

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

Regexp::VerbalExpression is a Perl module that helps to construct difficult regular expressions.

# LICENSE

Copyright (C) Takumi Akiyama.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Takumi Akiyama <t.akiym@gmail.com>
