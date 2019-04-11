package Symbol2Dict::DBI;

use DBI;
use strict;
use warnings;

my %Attributes = ();

sub new {
  my $class = shift;
  my %args  = @_;
  my $self  = bless {}, $class;
  return $self;
}

sub _has_dbh {
  my $self = shift;
  return $self->{dbh} ? 1 : 0;
}

#========================
# Methods
#========================

sub dbh {
  my $self = shift;
  if ( $self->_has_dbh ) {
    $self->_set_dbh() if !$self->{dbh}->ping;
  }
  else {
    die 'Attempting to retrieve database handle without connecting first';
  }
  return $self->{dbh};
}

sub ping {
  my ($self) = @_;
  if ( $self->_has_dbh ) {
    return 1 if $self->{dbh}->ping;
    eval { $self->_set_dbh() };
    return 0 if $@;
    return 1 if $self->{dbh}->ping;
    return 0;
  }
  eval { $self->_set_dbh() };
  return 0 if $@;
  return 1 if $self->{dbh}->ping;
  return 0;
}

sub connect {
  my ($self) = @_;
  if ( $self->_has_dbh ) {
    if ( !$self->{dbh}->ping ) {
      $self->_set_dbh();
      return $self->{dbh};
    }
    else {
      $self->{dbh}->disconnect or die 'Cannot disconnect';
      $self->_set_dbh();
      return $self->{dbh};
    }
  }
  $self->_set_dbh();
  return $self->{dbh};
}

sub _set_dbh {
  my ($self) = @_;
  my $dsn = 'dbi:SQLite:dbname=./data/dictionaries.db';
  my $dbh = DBI->connect( $dsn, '', '' )
    or die "Database connection not made: $DBI::errstr";
  $self->{dbh} = $dbh;
}

sub DEMOLISH {
  my $self = shift;
  if ( $self->_has_dbh ) {
    $self->{dbh}->disconnect or die "Cannot disconnect";
  }
}

1;
