package Unicode::EastAsianWidth::Detect;
use 5.008005;
use strict;
use warnings;
use POSIX qw(setlocale LC_CTYPE);
use base 'Exporter';
our @EXPORT = qw/is_cjk_lang /;

our $VERSION = "0.02";

# based on https://sourceware.org/cgi-bin/cvsweb.cgi/src/newlib/libc/locale/locale.c?rev=1.51&content-type=text/x-cvsweb-markup&cvsroot=src
sub is_cjk_lang {
  my $locale = shift || setlocale(LC_CTYPE);
  # ignore C locale
  return 0 if $locale eq 'POSIX';
  return 0 if $locale eq 'C' || $locale =~ /^C[-.]/;
  return 0 if $locale !~ /^[a-z][a-z][a-z]?(?:_[A-Z][A-Z])?.(.+)/;
  my $charset = $1;
  my $cjk_narrow = $charset =~ /\@cjknarrow$/;
  $charset =~ s/@.*//;
  my $mbc_max =
    $charset =~ /^utf-?8$/i ? 6 :
      $charset =~ /^jis$/i ? 8 :
        $charset =~ /^eucjp$/i ? 3 :
          $charset =~ /^euc(?:kr|cn)$/i ? 2 :
            $charset =~ /^(?:sjis|cp932)$/i ? 2 :
              $charset =~ /^big5$/i ? 2 :
                $charset =~ /^(?:gbk|gb2312)$/i ? 2 : 1;
  return !$cjk_narrow
    && $mbc_max > 1
      && ($charset !~ /^U/
        || $locale =~ /^ja/
        || $locale =~ /^ko/
        || $locale =~ /^zh/) ? 1 : 0;
}

1;
__END__

=encoding utf-8

=head1 NAME

Unicode::EastAsianWidth::Detect - Detect CJK Language

=head1 SYNOPSIS

    use Unicode::EastAsianWidth::Detect;
    warn is_cjk_lang;

=head1 DESCRIPTION

Unicode::EastAsianWidth::Detect is module that can detect the locale is CJK or
not.  For example, most of users who uses CJK languages are thinking that Easy
Asian Width Ambiguous Widths should be double cells.

=head1 HOW TO USE

    use Unicode::EastAsianWidth;
    use Unicode::EastAsianWidth::Detect qw(is_cjk_lang);
    $Unicode::EastAsianWidth::EastAsian = is_cjk_lang;

=head1 LICENSE

Copyright (C) mattn.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

mattn E<lt>mattn.jp@gmail.comE<gt>

=cut

