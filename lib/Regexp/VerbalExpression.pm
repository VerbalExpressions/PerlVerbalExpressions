package Regexp::VerbalExpression;
use 5.008005;
use strict;
use warnings;
use parent qw/Exporter/;
use overload fallback => 1, q{""} => \&source, 'qr' => \&regex;

our $VERSION = "0.01";

our @EXPORT = qw/verex/;

sub new {
    my $class = shift;
    return bless {
        s         => '',
        modifiers => {
            i => '',
            g => '',
            m => '',
        },
    }, $class;
}

sub verex { __PACKAGE__->new() }

sub add {
    my ($self, $value) = @_;
    $self->{s} .= $value;
    return $self;
}

sub regex {
    my $self = shift;
    my $modifiers = join '', values %{$self->{modifiers}};
    return qr/(?^$modifiers:$self->{s})/;
}
*compile = \&regex;

sub source {
    my $self = shift;
    return $self->{s};
}
*raw = *value = \&source;

sub find {
    my ($self, $value) = @_;
    return $self->add('(?:' . quotemeta($value) . ')');
}
*then = \&find;

sub start_of_line {
    my $self = shift;
    return $self->add('^');
}

sub end_of_line {
    my $self = shift;
    return $self->add('$');
}

sub maybe {
    my ($self, $value) = @_;
    return $self->add('(?:' . quotemeta($value) . ')?');
}

sub anything {
    my $self = shift;
    return $self->add('(?:.*)');
}

sub anything_but {
    my ($self, $value) = @_;
    return $self->add('(?:[^' . quotemeta($value) . ']*)');
}

sub line_break {
    my $self = shift;
    return $self->add('(?:\n|(?:\r\n))');
}
*br = \&line_break;

sub tab {
    my $self = shift;
    return $self->add('\t');
}

sub word {
    my $self = shift;
    return $self->add('\w+');
}

sub any {
    my ($self, $value) = @_;
    return $self->add('[' . quotemeta($value) . ']');
}
*any_of = \&any;

sub range {
    my ($self, @args) = @_;
    my $value = '[';
    for (my $i = 0; $i < @args; $i += 2) {
        $value .= quotemeta($args[$i]) . '-' . quotemeta($args[$i + 1]);
    }
    $value .= ']';
    return $self->add($value);
}

sub multiple {
    my ($self, $value) = @_;
    $self->add(quotemeta($value) . '+');
}

sub or {
    my ($self, $value) = @_;
    $self->add('|');
    return defined $value ? $self->find($value) : $self;
}
*alternatively = \&or;

sub replace {
    my ($self, $source, $value) = @_;
    if ($self->{modifiers}{g}) {
        local $self->{modifiers}{g} = ''; # not include /g in pattern
        my $re = $self->regex;
        $source =~ s/$re/$value/g;
    } else {
        my $re = $self->regex;
        $source =~ s/$re/$value/;
    }
    return $source;
}

sub with_any_case {
    my ($self, $value) = @_;
    $self->{modifiers}{i} = $value ? 'i' : '';
    return $self;
}

sub stop_at_first {
    my ($self, $value) = @_;
    $self->{modifiers}{g} = $value ? 'g' : '';
    return $self;
}

sub search_one_line {
    my ($self, $value) = @_;
    $self->{modifiers}{m} = $value ? 'm' : '';
    return $self;
}

1;
__END__

=encoding utf-8

=head1 NAME

Regexp::VerbalExpression - Perl Regular expressions made easy

=head1 SYNOPSIS

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

=head1 DESCRIPTION

Regexp::VerbalExpression is a Perl module that helps to construct difficult regular expressions.

=head1 LICENSE

Copyright (C) Takumi Akiyama.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Takumi Akiyama E<lt>t.akiym@gmail.comE<gt>

=cut

