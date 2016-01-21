use strict;
use warnings;
use Data::Dumper;


my @worlds = (
	[8, 1, 6, 3, 5, 7, 4, 9, 2],
	[16, 9, 14, 11, 13, 15, 12, 17, 10],
	[24, 17, 22, 19, 21, 23, 20, 25, 18]
);

sub isSpecial {
	my ($f) = @_;
	return $f =~ m/^\-?(13)?$/;
}

sub disjonct {
	my ($flame) = @_;
	
	if (isSpecial($flame)) { return ''; }
	return -$flame;
}

sub incompatible {
	my ($flame) = @_;
	
	if (isSpecial($flame)) { return ''; }
	
	if ($flame >= 1) { return 26 - $flame; }
	if (($flame >= -25) && ($flame <= -14)) { return $flame + 13; }
	return $flame - 13;
};

sub responsive {
	my ($flame) = @_;

	if (isSpecial($flame)) { return ''; }
	my %assoc = (
		  '1' =>  '12',
		 '12' =>   '1',
		 '14' =>  '25',
		 '25' =>  '14',
		  '2' =>  '11',
		 '11' =>   '2',
		 '15' =>  '24',
		 '24' =>  '15',
		  '3' =>  '10',
		 '10' =>   '3',
		 '16' =>  '23',
		 '23' =>  '16',
		  '4' =>   '9',
		  '9' =>   '4',
		 '17' =>  '22',
		 '22' =>  '17',
		  '5' =>   '8',
		  '8' =>   '5',
		 '18' =>  '21',
		 '21' =>  '18',
		  '6' =>   '7',
		  '7' =>   '6',
		 '19' =>  '20',
		 '20' =>  '19',
		 '-7' =>  '-6',
		 '-6' =>  '-7',
		'-20' => '-19',
		'-19' => '-20',
		 '-8' =>  '-5',
		 '-5' =>  '-8',
		'-21' => '-18',
		'-18' => '-21',
		 '-9' =>  '-4',
		 '-4' =>  '-9',
		'-22' => '-17',
		'-17' => '-22',
		'-10' =>  '-3',
		 '-3' => '-10',
		'-23' => '-16',
		'-16' => '-23',
		'-11' =>  '-2',
		 '-2' => '-11',
		'-24' => '-15',
		'-15' => '-24',
		'-12' =>  '-1',
		 '-1' => '-12',
		'-25' => '-14',
		'-14' => '-25'
	);

	return $assoc{$flame};
};




sub toAsciiDoc
{
	my ($inWorlds, $inOptTransform) = @_;
	my @outWorlds = ();
		
	if (! defined($inOptTransform)) {
		$inOptTransform = sub { my ($f) = @_; return $f; }
	}
	
	for (my $level=0; $level<3; $level++) {
		my $world = $inWorlds->[$level];
		my $dimension = 0;
		
		push(@outWorlds, "|==================");
		for (my $line=0; $line<3; $line++) {
			my @textLine = ();
			
			for (my $column=0; $column<3; $column++) {
				my $flame = $inOptTransform->($world->[$dimension]);
				my $cell = sprintf("%4s", $flame);
				push(@textLine, $cell);
				$dimension++;
			}
			
			push(@outWorlds, '|' . join(' |', @textLine) . ' |');
		}
		push(@outWorlds, "|==================");
		push(@outWorlds, "\n");
	}
	return @outWorlds;
}


print join("\n", toAsciiDoc(\@worlds));
print "\n\nDisjonct";
print "\n========\n\n";
print join("\n", toAsciiDoc(\@worlds, \&disjonct));
print "\n\nIncompatible";
print "\n========\n\n";
print join("\n", toAsciiDoc(\@worlds, \&incompatible));
print "\n\nResponsive";
print "\n========\n\n";
print join("\n", toAsciiDoc(\@worlds, \&responsive));

print "\n\nComposition: (disjonct o incompatible)(f)";
print "\n========\n\n";
print join("\n", toAsciiDoc(\@worlds, sub { my ($f) = @_; return disjonct(incompatible($f)); }) );
print "\n\nComposition: (incompatible o disjonct)(f)";
print "\n========\n\n";
print join("\n", toAsciiDoc(\@worlds, sub { my ($f) = @_; return incompatible(disjonct($f)); }) );

print "\n\nComposition: (disjonct o responsive)(f) and (responsive o disjonct)(f)";
print "\n========\n\n";
print join("\n", toAsciiDoc(\@worlds, sub { my ($f) = @_; return disjonct(responsive($f)); }) );

print "\n\nComposition: (responsive o incompatible)(f) and (incompatible o responsive)(f)";
print "\n========\n\n";
print join("\n", toAsciiDoc(\@worlds, sub { my ($f) = @_; return responsive(incompatible($f)); }) );





