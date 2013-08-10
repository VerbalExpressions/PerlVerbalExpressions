package Regexp::VerbalExpressions;
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
            i => 0,
            m => 0,
            s => 0,
            x => 0,
        },
        global_matching => 0,
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
    my $enabled = my $disabled = '';
    for my $modifier (sort keys %{$self->{modifiers}}) {
        if ($self->{modifiers}{$modifier}) {
            $enabled .= $modifier;
        } else {
            $disabled .= $modifier;
        }
    }
    return qr/(?$enabled-$disabled:$self->{s})/;
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

sub something {
    my $self = shift;
    return $self->add('(?:.+)');
}

sub something_but {
    my ($self, $value) = @_;
    return $self->add('(?:[^' . quotemeta($value) . ']+)');
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
    my $re = $self->regex;
    if ($self->{global_matching}) {
        $source =~ s/$re/$value/g;
    } else {
        $source =~ s/$re/$value/;
    }
    return $source;
}

sub _build_modifier {
    my ($self, $modifier, $value) = @_;
    if (!defined $value) {
        # XXX verex->with_any_case;
        $self->{modifiers}{$modifier} = 1;
    } else {
        $self->{modifiers}{$modifier} = $value ? 1 : 0;
    }
}

sub with_any_case {
    my ($self, $value) = @_;
    $self->_build_modifier(i => $value);
    return $self;
}

sub stop_at_first {
    my ($self, $value) = @_;
    if (!defined $value) {
        $self->{global_matching} = 1;
    } else {
        $self->{global_matching} = $value ? 1 : 0;
    }
    return $self;
}

sub search_one_line {
    my ($self, $value) = @_;
    $self->_build_modifier(m => $value);
    return $self;
}

1;
__END__

=encoding utf-8

=head1 NAME

Regexp::VerbalExpressions - Perl Regular expressions made easy

=head1 SYNOPSIS

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

=head1 DESCRIPTION

Regexp::VerbalExpressions is a Perl module that helps to construct difficult regular expressions.

=head1 API

=head2 Modifiers

=over 4

=item C<< anything() >>

=item C<< anything_but($value) >>

=item C<< end_of_line() >>

=item C<< find($value) >>

=item C<< maybe($value) >>

=item C<< start_of_line() >>

=item C<< then($value) >>

=back

=head2 Special characters and groups

=over 4

=item C<< any($value) >>

=item C<< any_of($value) >>

=item C<< br() >>

=item C<< line_break() >>

=item C<< range($from, $to) >>

=item C<< tab() >>

=item C<< word() >>

=back

=head2 Modifiers

=over 4

=item C<< with_any_case() >>

=item C<< stop_at_first() >>

=item C<< search_one_line() >>

=back

=head2 Functions

=over 4

=item C<< replace($source, $value) >>

=back

=head2 Other

=over 4

=item C<< add($expression) >>

=item C<< multiple($value) >>

=item C<< or() >>

=back

=head1 SEE ALSO

L<https://github.com/VerbalExpressions/JSVerbalExpressions>

=head1 LICENSE

Copyright (C) Takumi Akiyama.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Takumi Akiyama E<lt>t.akiym@gmail.comE<gt>

=cut

