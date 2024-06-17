use starknet::ContractAddress;
pub mod 

#[dojo::interface]
trait IGameActions {
    fn new_game(ref world: IWorldDispatcher, player1: ContractAddress, player2: ContractAddress, player1_type: PlayerType, player2_type: PlayerType);
    fn play_turn(ref world: IWorldDispatcher, player_move: PlayerMove );
}

#[dojo::contract]
mod game_actions {
    use super::IGameActions;
    use crate::models::games::{Game, PlayerType, Outcome, PlayerMove};
    use crate::models::moves::{Moves};

    #[abi(embed_v0)]
    impl GameActionsImpl of IGameActions<ContractState> {
        fn new_game(ref world: IWorldDispatcher, player1: ContractAddress, player2: ContractAddress, player1_type: PlayerType, player2_type: PlayerType) {
            let game_id = generate_game_id();
            let new_game = Game::new(game_id, player1, player2, player1_type, player2_type);

            set(world, game_id, new_game);
        }

        fn play_turn(ref world: IWorldDispatcher, player_move: PlayerMove) {
            let game_id = get_game_id_from_player(player_move.player);
            let mut game: Game = get!(world, game_id);

            let outcome = game.play_turn(player_move);
            set!(world, game_id, game);
        }
    }

}

fn generate_game_id() -> felt252 {
    // TODO implement logic
    1
}

fn get_game_id_from_player(player: ContractAddress) -> felt252 {
    //TODO implement
    2
}