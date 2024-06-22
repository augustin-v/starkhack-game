use super::players::{Game, PlayerType, Outcome};
use super::moves::{Moves, MovesTrait};
use starknet::ContractAddress;

#[derive(Drop, Debug, Introspect, Serde)]
struct PlayerMove {
    player: ContractAddress,
    move: Moves,
}

trait GameTrait {
    fn new(game_id: felt252, player1: ContractAddress, player2: ContractAddress, player1_type: PlayerType, player2_type: PlayerType) -> Game;
    fn play_turn(ref self: Game, player_move: PlayerMove) -> Outcome;
}

impl GameImpl of GameTrait {
    fn new(game_id: felt252, player1: ContractAddress, player2: ContractAddress, player1_type: PlayerType, player2_type: PlayerType) -> Game {
        Game {
            game_id,
            player1,
            player2,
            player1_type,
            player2_type,
            player1_score: 0,
            player2_score: 0,
            turn: 1,
            outcome: Outcome::Pending,
            player1_move: Option::None,
            player2_move: Option::None,
        }
    }
    fn play_turn(ref self: Game, player_move: PlayerMove) -> Outcome {
        // Ensure the game is still going
        if let Outcome::Pending = @self.outcome {
            if self.turn % 2 == 1 {
                // Player 1's turn
                if player_move.player != self.player1 {
                    panic!("It's not Player 2's turn!");
                }
                self.player1_move = Option::Some(player_move.move);
            } else {
                //Player 2's turn
                if player_move.player != self.player2 {
                    panic!("It's not Player 1's turn!");
                }
                self.player2_move = Option::Some(player_move.move);
               // Determine the outcome of the current turn
                if let (Option::Some(player1_move), Option::Some(player2_move)) = (self.player1_move, self.player2_move) {
                    if player1_move.beats(player2_move) {
                        self.player1_score += 1;
                    } else if player2_move.beats(player1_move) {
                        self.player2_score += 1;
                    }
                }
                self.player1_move = Option::None;
                self.player2_move = Option::None;
            }

            // Determine the overall winner if the game is over
            if self.player1_score >= 3 {
                self.outcome = Outcome::Player1;
            } else if self.player2_score >= 3 {
                self.outcome = Outcome::Player2;
            }

            self.turn += 1;
        }

        self.outcome
    }
}

#[cfg(test)]
mod test {
    use core::traits::TryInto;
use core::option::OptionTrait;
use starknet::ContractAddress;
    use super::{Game, PlayerType, Outcome, GameTrait};
    use super::Moves;
    #[test]
    fn test_new_game() {
        let player1: ContractAddress = 0x61.try_into().unwrap();
        let player2: ContractAddress = 0x62.try_into().unwrap();
        let game = GameTrait::new(1, player1, player2, PlayerType::Human, PlayerType::Computer);

        assert_eq!(game.player1, player1);
        assert_eq!(game.player2, player2);
        assert_eq!(game.player1_score, 0);
        assert_eq!(game.player2_score, 0);
        assert_eq!(game.turn, 1);
        assert_eq!(game.outcome, Outcome::Pending);
    }
}