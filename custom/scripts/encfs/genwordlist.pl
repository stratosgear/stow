#!/usr/bin/perl
#
# Wordlist Generator
# ----------------------------------------------------------------------
# This script gerates a wordlist from the possibilities you define in
# @wordlayout and prints it to STDOUT.
#
# Useage:
# Define your layout in @wordlayout: As an array of lists.
# Each list in the array represents a part of the word or phrase that
# will be generated and contains the possible alterations for the part
# of the word/phrase as listitems.
# Somewhat hard to explain, take a look at the examples...
#
# Example:
#
# @wordlayout =
# (
# 	[1],
# 	[2, 3],
# 	[4, 5, '']
# );
#
# Will produce the following wordlist:
# 124
# 125
# 12
# 134
# 135
# 13
#
# EXTERNALS
# ---------
#
# This script uses YAML for wordlist generation.
#
# You can install YAML::XS from the shell like this:
# perl -MCPAN -e 'install YAML::XS'
# or get it here:
# http://search.cpan.org/dist/YAML-LibYAML/lib/YAML/XS.pm
#
# If you don't need YAML syntax, just comment the lines 58
# to 63 and define your layout directly in `@wordlayout`.


$PROGRAMMNAME = "Wordlist Generator";
$VERSION = "0.3";
$AUTHOR = "Brutus [DMC] <brutus.dmc(at)googlemail.com>";

@wordlayout_original =
(
  [1],
  [2, 3],
  [4, 5, '']
);

@wordlayout =
(
  ['a', 'A'],
  ['nother'],
  ['1', 'one', 'One'],
  ['b', 'B'],
  ['1tes', 'ites'],  
  ['the', 'The'],
  ['dust', 'Dust'],
  ['.', '']
);

$yaml_file = shift(@ARGV);
#if (-e $yaml_file)
#{
#  use YAML::XS qw(LoadFile);
#  @wordlayout = LoadFile($yaml_file);
#}

for my $idx ( 0 .. $#wordlayout )
{
  # A loop for each level.
  $code .= 'for my $char ( @{$wordlayout['.$idx.']} ) {'."\n";
  # concat chars
  $code .= '$str .= $char;'."\n";
}
# At the innermost level, extract a word.
$code .= 'push @list, $str;'."\n";
for my $idx ( 0 .. $#wordlayout )
{
  # Remove this levels char(s) on our way out.
  $code .= 'my $len = length $char;'."\n";
  $code .= 'substr($str, \'-\'.$len, $len,"");'."\n";
  $code .= "}\n";
}
# print $code;  # curious?
eval $code; # Now do it.
print join("\n", @list),"\n";   # The result is in @list.
