use dojo_starter::models::games::{Game, PlayerType, Outcome, PlayerMove};
use dojo_starter::models::moves::{Moves};
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
use starknet::ContractAddress;
#[starknet::interface]
trait IGameActions<TContractState> {
    fn new_game(self: @TContractState,  world: IWorldDispatcher, player1: ContractAddress, player2: ContractAddress, player1_type: PlayerType, player2_type: PlayerType);
    fn play_turn(self: @TContractState,  world: IWorldDispatcher, player_move: PlayerMove );
}

#[starknet::contract]
mod game_actions {
    use super::IGameActions;
    use dojo_starter::models::games::{Game, PlayerType, Outcome, PlayerMove, GameTrait};
    use dojo_starter::models::moves::{Moves};
    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
    use starknet::ContractAddress;
    use dojo::world;

    #[storage]
    struct Storage {
        game_data: Game,
        player_data: PlayerMove,
    }

    #[abi(embed_v0)]
    impl GameActionsImpl of IGameActions<ContractState> {
        fn new_game(self: @ContractState, world: IWorldDispatcher, player1: ContractAddress, player2: ContractAddress, player1_type: PlayerType, player2_type: PlayerType) {
            let game_id = 1; // generate_game_id();
            let new_game = GameTrait::new(game_id, player1, player2, player1_type, player2_type);

            set!(world,  (new_game));
        }

        fn play_turn(self: @ContractState, world: IWorldDispatcher, player_move: PlayerMove) {
            let game_id = 2; // get_game_id_from_player(player_move.player);
            let mut game: Game = get!(world, game_id, (Game));

            let outcome = GameTrait::play_turn(ref game, player_move);
            set!(world, (outcome));
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