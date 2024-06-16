use super::players::{Game, PlayerType, Outcome};
use super::moves::{Moves, MovesTrait};
use starknet::ContractAddress;

#[derive(Drop, Debug, Introspect)]
struct PlayerMove {
    player: ContractAddress,
    move: Moves,
}

trait GameTrait {
    fn new(game_id: felt252, player1: ContractAddress, player2: ContractAddress, player1_type: PlayerType, player2_type: PlayerType) -> Game;
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
        }
    }
}