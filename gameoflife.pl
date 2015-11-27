use v6;

class Map {
    has $!height = 20;
    has $!width = 50;
    has @!cases;

    method generate() {
        @!cases = [Bool.pick xx $!width] xx $!height;
    }

    method draw() {
        my $str = "\e[2J┌" ~ ( "──" x $!width ) ~ "┐\n";
        for @!cases -> @line {
            $str ~= '│';
            for @line -> $cell {
                $str ~= $cell??'米'!!'  ';
            }
            $str ~= "│\n";
        }
        $str ~= "└" ~ ( "──" x $!width ) ~ "┘";
        $str.say();
    }

    method evolve() {
        my @new;
        my @coordinates = ^$!height X ^$!width;
        for @coordinates -> ( $y , $x ) {
            my $neighbour-alive = 0;
            my @neigbours = ();
            for [ -1 , -1 ] , [ -1 , +0 ] , [ -1 , +1 ],
                [ +0 , -1 ] ,               [ +0 , +1 ],
                [ +1 , -1 ] , [ +1 , +0 ] , [ +1 , +1 ] {
                my $ny = ($y + .[0]) % $!height;
                my $nx = ($x + .[1]) % $!width;
                push @neigbours, [$ny,$nx];
                if @!cases[$ny][$nx] {
                    $neighbour-alive++;
                }
            }
            my $alive = False;
            if @!cases[$y][$x] {
                $alive = True if 2 <= $neighbour-alive <= 3;
            } else {
                $alive = True if $neighbour-alive == 3;
            }
            @new[$y][$x] = $alive;
        }
        @!cases = @new;
    }

}

my $m = Map.new();
$m.generate();
loop {
    $m.draw();
    $m.evolve();
}
