
use Data::Dumper;
use Storable qw(dclone);
%cubicle = (
0 => [0, 1, 2, 10, 11, 12, 20, 21, 22],
1 => [3, 4, 5, 13, 14, 15, 23, 24, 25],
2  => [6, 7, 8, 16 , 17, 18, 26, 27, 28],
3 => [30, 31, 32, 40, 41, 42, 50, 51, 52],
4 => [33, 34, 35, 43, 44, 45, 53, 54, 55],
5 => [36, 37, 38, 46, 47, 48, 56, 57, 58],
6 => [60, 61, 62, 70, 71, 72, 80, 81, 82],
7 => [63, 64, 65, 73, 74, 75, 83, 84, 85],
8 => [66, 67, 68, 76, 77, 78, 86, 87, 88]
	);

sub probableboard{
	my @arr;
	my $arr;
	$arr = dclone($_[0]);
	@arr = @{$arr};
	my $i;
	my $j;
	for($i = 0; $i < 9; $i++){
		my %h = ();
		for($j = 0; $j < 9; $j++){
			$h{$arr[$i][$j]} += 1;
		}
		foreach my $temp (keys %h){
			if ($h{$temp} > 1 && ($temp != 0)) {
				return 0;
			}
		}
	}

	for($i = 0; $i < 9; $i++){
		my %h = ();
		for($j = 0; $j < 9; $j++){
			$h{$arr[$j][$i]} += 1;
		}
		foreach my $temp (keys %h){
			if ($h{$temp} > 1 && ($temp != 0)  ){
				
				return 0;
			}
		}
	}
	for($i = 0; $i < 9; $i++){
		@checkpoints = @{$cubicle{$i}};
		@values = ();
		foreach(@checkpoints){
			$row = int($_ / 10);
			$column = $_ % 10;
			if($arr[$row][$column] != 0){
				push @values, $arr[$row][$column]; 
			}
		}
		my %h = ();
		foreach(@values){
			$h{$_} += 1;
		}
		foreach my $temp (keys %h){
			if ($h{$temp} > 1){
				return 0;
			}
		}
		
	}
	return 1;
}


#lenOfArray(\@a1)
sub lenOfArray{
	my $x = @_[0];
	my $i = 0;
	while($x->[$i]){
		$i++;
	}
	$i;
}

#isIn($x, @arr)
sub isIn{
	my $x = shift;
	my $ans = 0;
	foreach(@_){
		if ($x == $_){
			$ans = 1;
			return $ans;
		}
	}
	return $ans;
}

#isEq(\@a1, \@a2)
sub isEq{
	my @a1 = @{dclone($_[0])};
	my @a2 = @{dclone($_[1])};
	if (!(scalar @a1 == scalar @a2)){
		return 0;
	}
	else{
		$i = 0;
		foreach(@a2){
			if($_ != $a1[$i++] ){
				return 0;
			}
		}
		return 1;
	}
}

sub checkBoard{
	my @a1 = (1..9);
	my @arr = @{dclone($_[0])};
	for($i = 0; $i < 9; $i++){
		@row = sort @{$arr[$i]};
		if( !isEq(\@row, \@a1) ){
			print "here1";
			return 0;
		}
	}
	for($i = 0; $i < 9; $i++){
		@column = ();
		for($j = 0; $j < 9; $j++){
			push @column, $arr[$j][$i];
		}
		@column = sort @column;
		if( !isEq(\@row, \@a1) ){
			print "here2";
			return 0;
		}
	}
	for($i = 0; $i < 9; $i++){
		@values = ();
		@checkpoints = @{$cubicle{$i}};
		foreach(@checkpoints){
			$row = int($_ / 10);
			$column = $_ % 10;
			push @values, $arr[$row][$column];
		}
		@values = sort @values;
		if( !isEq(\@values, \@a1) ){
			print "here3 $i";
			return 0;
		}
	}
	return 1;
}

open(DATA, "<sRead.txt") or die "Couldn't open file file.txt, $!";
while(<DATA>){
	chomp($_);
  @row = split //, $_;
  for($j = 0; $j < @row; $j++){
  	$arr[$i][$j] = $row[$j];
  }
  $i++;
}
for (my $i = 0; $i < 9; $i++) {
	for (my $j = 0; $j < 9; $j++) {
		print "$arr[$i][$j]";
	}
	print "\n";
}
#reads the data in fine
my @poss = (); #3d array storing all the posibilities
#row by row
my @values = (1,2,3,4,5,6,7,8,9);
for($i = 0; $i <9; $i++){
	my @rowContains = ();
	for($j = 0; $j < 9; $j++){
		if($arr[$i][$j] != 0){
			push (@rowContains, $arr[$i][$j]) ;
		}
	}
	my @values2 = ();
	foreach(@values){
		if (!isIn($_, @rowContains)){
			push @values2, $_;
		}
	}
	print "values2 is @values2\n";
	for(my $j = 0; $j < 9; $j++){
		if($arr[$i][$j] == 0){
			print "$i $j is 0\n";
			$k = 0;
			foreach(@values2){
				$poss[$i][$j][$k++] = $_;
			}
		}
	}
}

for($i = 0; $i <9; $i++){
	my @columnContains = ();
	for($j = 0; $j < 9; $j++){
		if($arr[$j][$i] != 0){
			push (@columnContains, $arr[$j][$i]) ;
		}
	}
	for($j = 0; $j < 9; $j++){
		if($arr[$j][$i] == 0){
			#filter the fucking poss array
			$len = scalar @{$poss[$j][$i]};
			@values = ();
			for($k = 0; $k < $len; $k++){
				push(@values, $poss[$j][$i][$k]);
			}
			@values2 = ();
			foreach(@values){
				if(!isIn( $_, @columnContains )){
					push @values2, $_;
				}
			}
			if(scalar @values2 == 0){
				print "UNSOLVABLE\n";
				exit();
			}
			@{$poss[$j][$i]} = @values2;
		}
	}
}

for($i = 0; $i < 9; $i++){
	for($j = 0; $j < 9; $j++){
		print "$i<->$j ";
		for($k = 0; $k < lenOfArray $poss[$i][$j]; $k++){
			print $poss[$i][$j][$k];
		}
		print " ";
	}
	print "\n";
}
print "finish column check\n";

#cubicle check left, @poss now has all the right stuff 
for($i = 0; $i < 9; $i++){
	@checkpoints = @{$cubicle{$i}};
	@values = ();
	foreach(@checkpoints){
		$row = int($_ / 10);
		$column = $_ % 10;
		if($arr[$row][$column] != 0){
			push @values, $arr[$row][$column]; 
		}
	}
	foreach(@checkpoints){
		$row = int($_ / 10);
		$column = $_ % 10;
		if($arr[$row][$column] == 0){
			@temp = ();
			foreach(@{$poss[$row][$column]}){
				if(!isIn($_, @values)){
					push @temp, $_;
				}
			}
			@{$poss[$row][$column]} = @temp;
			if(scalar @temp == 0){
				print "UNSOLVABLE\n";
				exit();
			}
		}
	}
}

for($i = 0; $i < 9; $i++){
	for($j = 0; $j < 9; $j++){
		print "$i<->$j ";
		for($k = 0; $k < lenOfArray $poss[$i][$j]; $k++){
			print $poss[$i][$j][$k];
		}
		print " ";
	}
	print "\n";
}

#optimization idea, if a sqaure has only 1 possible value then assign it that value
for($i = 0; $i < 9; $i++){
	for($j = 0; $j < 9; $j++){
		if($arr[$i][$j] == 0){
			if (scalar @{$poss[$i][$j]} == 1){
				$arr[$i][$j] = shift @{$poss[$i][$j]};
			}
		}
	}
}

print "test\n";
for($i = 0; $i < 9; $i++){
	for($j = 0; $j < 9; $j++){
		print $arr[$i][$j];
	}
	print "\n";
}

@possList = ();
for($i = 0; $i < 9; $i++){
	for($j = 0; $j < 9; $j++){
		if($arr[$i][$j] == 0){
			push @possList, [ $i.$j , $poss[$i][$j]];
		}
	}
}

my @res = ();
$a = lenOfArray $possList[0][1];
$b = lenOfArray $possList[1][1];
for($i = 0; $i < $a; $i++){
	for($j = 0; $j < $b; $j++){
		#probableboard function needed
		my @newArr = @{dclone(\@arr)};
		#print "value is " . $possList[0][1][$i] . "\n";
		$newArr[int($possList[0][0]/10)][$possList[0][0]%10] = $possList[0][1][$i];
		$newArr[int($possList[1][0]/10)][$possList[1][0]%10] = $possList[1][1][$j];
		#print "probable is " . probableboard(@newArr) . "\n";
		if(probableboard \@newArr){
			push @res, [ [ $possList[0][0], $possList[0][1][$i]], [$possList[1][0], $possList[1][1][$j]] ];
		}
		
	}
}

#upto this correct

if(@possList > 2){
	for($i = 2; $i < @possList; $i++){
		print "go $i\n";
		@res2 = ();
		for($j = 0; $j < lenOfArray $possList[$i][1]; $j++){
			for($k = 0; $k < @res; $k++){
				my @newArr = @{dclone(\@arr)};
				$newArr[int($possList[$i][0]/10)][$possList[$i][0]%10] = $possList[$i][1][$j];
				for($l = 0; $l < lenOfArray $res[$k]; $l++){
					$newArr[int($res[$k][$l][0] / 10)][$res[$k][$l][0] % 10] = $res[$k][$l][1];
				}
				if(probableboard \@newArr){
					@temp = @{$res[$k]};
					
					$temp[scalar @temp] = [$possList[$i][0], $possList[$i][1][$j]];
					#$res[$k][lenOfArray $res[$k]] = [$possList[$i][0], $possList[$i][1][$j]];
					push @res2 , [@temp];
				}
			}

		}
		@res = @{dclone(\@res2)};
	}
}
@newArr = @{dclone(\@arr)};
$i = 0;
print "size of res " . scalar @res;
print "\n";
foreach(@res){
	print "working - $i\n";
	$a = scalar @possList;
	if ($a == lenOfArray $_){
		print "i is $i\n";
		foreach(@{$res[$i]}){
			$newArr[int($_->[0]/10)][$_->[0]%10] = $_->[1];
		}
		if(checkBoard \@newArr){
			print "SOLVEDDDDDDDDDD\n";
			for($i = 0; $i < 9 ; $i++){
				for($j = 0; $j < 9; $j++){
					print $newArr[$i][$j];
				}
			}
			last;
		}
		else{
			@newArr = @{dclone(\@arr)};
		}
		
	}
	$i++;
}
