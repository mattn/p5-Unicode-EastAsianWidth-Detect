use strict;
use warnings;
use Test::More tests => 2, skip_all => $^O ne 'MSWin32';
use Unicode::EastAsianWidth::Detect qw(is_cjk_lang);

is(is_cjk_lang('japanese_japan.932'), 1);
is(is_cjk_lang('Japanese_Japan.932'), 1);
