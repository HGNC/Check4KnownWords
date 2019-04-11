#!/usr/bin/env perl

use lib qw{./lib/perl5};
use local::lib qw{./lib/perl5};
use Getopt::Long qw(GetOptions);
use Pod::Usage qw(pod2usage);
use Symbol2Dict::DictionaryDB;

use strict;
use warnings;

my ( $help, $man ) = ( 0, 0 );
my ( @dicts, @files );

GetOptions(
  'help|?'       => \$help,
  'man'          => \$man,
  'file=s'       => \@files,
  'dictionary=s' => \@dicts    # array of strings, required
) or pod2usage(1);
pod2usage( { -verbose => 0, -exitval => 0 } ) if $help;
pod2usage( { -verbose => 2, -exitval => 0 } ) if $man;

my $dictionary = Symbol2Dict::DictionaryDB->new( dictionaries => \@dicts );

foreach my $file (@files) {
  open my $fh, '<', $file or die "Cannot open file $file";
  while ( my $word = <$fh> ) {
    chomp $word;
    $dictionary->look_for($word);
  }
  close $fh;
}

1;

__END__

=head1 NAME

Check4KnownWords.pl: check a list of words against one or many english
dictionaries to see if the words exists in the dictionaries.

=head1 SYNOPSIS

./Check4KnownWords.pl --dictionary=us --dictionary=gb --file=words1.txt --file=words2.txt
  
  Options:
    --help           Brief help message.
    --man            Full documentation.
    --file           File name containing the list of words (one word per line).
                     Option be used multiple times
    --dictionary     Choose which dictionaries to query:
                       au    = Australian
                       ca    = Canadian
                       gb    = British
                       gbize = British dictionary with -ize endings instead of
                               -ise such as characterized rather than
                               characterised.
                     Option be used multiple times

=head1 DESCRIPTION

A perl script which will loop through lists of words provided in files against one or
more english dictionaries. If there is a match, the word is printed onto the screen.

=head1 OPTIONS

=over 4

=item B<--help>

Print a brief help message and exits.

=item B<--man>

Prints the manual page and exits.

=item B<--dictionary>

Dictionary type which can be one of the following:

    au               for Australian dictionary
    ca               for Canadian dictionary
    gb               for British dictionary
    gbize            for British with -ize rather than -ise word endings
    us               for US dictionary

=item B<-file>

The path of the txt file that contains a list of words

=back

=cut
