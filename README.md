# Check4KnownWords.pl:

Checks a list of words against one or many english
dictionaries to see if the words exists in the dictionaries.

## SYNOPSIS

```
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
```

## DESCRIPTION

A perl script which will loop through lists of words provided in files against one or
more english dictionaries. If there is a match, the word is printed onto the screen.

## OPTIONS

### --help

Print a brief help message and exits.

### --man

Prints the manual page and exits.

### --dictionary

Dictionary type which can be one of the following:
au for Australian dictionary
ca for Canadian dictionary
gb for British dictionary
gbize for British with -ize rather than -ise word endings
us for US dictionary

### --file

The path of the txt file that contains a list of words

## REQUIREMENTS

In order to install and run this script you will need the following:
  - A mac or a linux machine.
  - Git installed (Mac users see the Mac users section below).
  - Git-lfs (https://git-lfs.github.com) installed.
  - Must have perl ≥ 5.20.0.

### Mac users

If you haven't install git or xcode and you initiate a `git clone`, your mac
may ask you to install xcode. Please install this app and try to `git clone`
once again.

## INSTALL

To install this command line tool, clone this project into your directory of choice:

```bash
git clone https://github.com/HGNC/Check4KnownWords.git
```

Once cloned you then need to run the install script:

```bash
./install.sh
```

The install script will download all the required modules needed for the script and
will test the script. Once successfully install you may use the script as described
above.
