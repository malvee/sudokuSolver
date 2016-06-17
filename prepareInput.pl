open(DATA, "<sudoku.txt") or die "Couldn't open file file.txt, $!";
while(<DATA>){
	chomp($_);
  @row = split //, $_;
  for($j = 0; $j < @row; $j++){
  	if($row[$j] eq "."){
  		print "0";
  	}
  	else{
  		print $row[$j];
  	}
  	if(($j+1) % 9 == 0){
  		print "\n";
  	}
  }
  $i++;
}