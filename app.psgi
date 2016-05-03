use Mojolicious::Lite;


get '/' => sub {
  my $c = shift;
  $c->render(template => 'index');
};

get '/api/time' => sub {
  my $c = shift;
  my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime();
  my $t = sprintf("%04d-%02d-%02dT%02d:%02d:%02dZ", $year+1900, $mon+1, $mday, $hour, $min, $sec);
  $c->render(text => $t);
};

get '/:foo' => sub {
  my $c   = shift;
  my $foo = $c->param('foo');
  $c->render(text => "Hello from $foo.");
};

get '/api/myenv' => sub {
  my $c = shift;
  $c->res->headers->header('Access-Control-Allow-Origin' => '*');
  my ($myenv, $key);
  for $key (keys %ENV){
    $myenv .= $key . " : " . $ENV{$key} . "    " ;
  }
  $c->render(text => $myenv);
};

get '/api/clientip' => sub {
  my $c = shift;
  my $ip = $c->tx->remote_address;
  $c->res->headers->header('Access-Control-Allow-Origin' => '*');
  $c->respond_to(
    json => {json => {clientip => $ip}},
    xml  => {text => "<clientip>$ip</clientip>"},
    any  => {data => '', status => 204}
  );
};


app->start('daemon', '-l', 'http://*:8080');;
