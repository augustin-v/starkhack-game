use super::players::{Game};



#[derive(Drop, Debug, Introspect)]
enum Moves {
    Rock,
    Paper,
    Scissors,
}

trait MovesTrait {
    fn beats(self: Moves, other: Moves) -> bool;
}

impl MoveImpl of MovesTrait {
    
    fn beats(self: Moves, other: Moves) -> bool {
        match (self, other) {
            (Moves::Rock, Moves::Scissors) => true,
            (Moves::Scissors, Moves::Paper) => true,
            (Moves::Paper, Moves::Rock) => true,
            _ => false,
        }
    }
}

#[cfg(test)]
mod test{

    use super::{Moves, MovesTrait};
    #[test]
    fn basic() {
        let rock = Moves::Rock;
        let paper = Moves::Paper;
        assert!(paper.beats(rock));
        assert!(!rock.beats(paper));
    }
}