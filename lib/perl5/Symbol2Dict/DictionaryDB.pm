package Symbol2Dict::DictionaryDB;

use Modern::Perl;
use Symbol2Dict::DBI;

my %Attributes = ( dictionaries => 1 );

sub new {
  my $class = shift;
  my %args  = @_;
  my $self  = bless {
    dictionaries => undef,
    dbcon        => undef
  }, $class;
  while ( my ( $arg, $val ) = each %args ) {
    die "Invalid initialisation for $class object" unless $Attributes{$arg};
    die "$arg is undef in the initialisation for $class object"
      unless defined $val;
    $self->$arg($val);
  }
  foreach my $attrib ( keys %Attributes ) {
    die "$attrib attribute has not been passed to $class"
      unless defined $self->$attrib;
  }

  my $dict_db = Symbol2Dict::DBI->new();
  $dict_db->connect;
  $self->dbcon($dict_db);
  $self->sql( $self->_build_dict_query );
  return $self;
}

sub dictionaries {
  my $self = shift;
  if (@_) {
    my $dicts = shift;
    $self->{dictionaries} = _check_dicts($dicts);
  }
  return $self->{dictionaries};
}

sub dbcon {
  my $self = shift;
  $self->{dbcon} = shift if @_;
  return $self->{dbcon};
}

sub sql {
  my $self = shift;
  $self->{sql} = shift if @_;
  return $self->{sql};
}

sub look_for {
  my $self = shift;
  my $word = shift;
  my $sth  = $self->dbcon->dbh->prepare( $self->sql );
  $sth->execute( ($word) x scalar( @{ $self->dictionaries } ) );
  foreach my $dictWord ( @{ $sth->fetchall_arrayref( {} ) } ) {
    say $word;
    last;
  }
}

sub _build_dict_query {
  my $self  = shift;
  my $dicts = $self->dictionaries;
  my @sql;
  my %queries = (
    'gb' => 'select word from gb where Lower(gb.word) = Lower(?)',
    'gbize' =>
      'select word from "gb-ize" where Lower("gb-ize".word) = Lower(?)',
    'au' => 'select word from au where Lower(au.word) = Lower(?)',
    'ca' => 'select word from ca where Lower(ca.word) = Lower(?)',
    'us' => 'select word from us where Lower(us.word) = Lower(?)'
  );
  my @using;
  foreach my $dict (@$dicts) {
    if ( $queries{$dict} ) {
      push @using, $dict;
      push @sql,   $queries{$dict};
    }
  }

  say sprintf 'Using the following dictionaries: %s', join ', ', @using;
  return join ' UNION ', @sql;
}

sub _check_dicts {
  my $dictionaries = shift;
  die 'No dictionaries were provided' unless scalar @$dictionaries;
  my %allowed = (
    'gb'    => 1,
    'gbize' => 1,
    'au'    => 1,
    'ca'    => 1,
    'us'    => 1
  );
  my @clean;
  my @unclean;
  foreach my $dict (@$dictionaries) {
    if ( $allowed{$dict} ) {
      push @clean, $dict;
    }
    else {
      push @unclean, $dict;
    }
  }
  die sprintf 'Dictionaries do not exist: %s', join ', ', @unclean if @unclean;
  return \@clean;
}

1;
