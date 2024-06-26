use dojo::database::introspect::{Introspect, Layout, FieldLayout, Ty, Enum, Member};
use super::moves::Moves;
use dojo::world;
use starknet::ContractAddress;
#[derive(Drop, Debug, Serde, Copy, Clone)]
enum PlayerType {
    Human,
    Computer,
}

#[derive(Model,Serde, Drop, Introspect, Copy, Clone, Debug, PartialEq)]
enum OutcomeResult {
    // player 1 won
    Player1,
    // player 2 won
    Player2,
    // Game not over
    Pending,
}
#[derive(Model, Serde, Drop, Introspect, Copy,  Debug, PartialEq)]
#[dojo::model]
struct Outcome {
    #[key]
    result: OutcomeResult,
    details: felt252,
}

#[derive(Drop, Serde, Introspect)]
#[dojo::model]
struct Game {
    #[key]
    game_id: felt252,
    player1: ContractAddress,
    player2: ContractAddress,
    player1_type: PlayerType,
    player2_type: PlayerType,
    player1_score: u8,
    player2_score: u8,
    turn: u8,
    outcome: OutcomeResult,
    player1_move: Option<Moves>,
    player2_move: Option<Moves>,
}


impl PlayerTypeIntrospection of Introspect<PlayerType> {
    #[inline(always)]
    fn size() -> Option<usize> {
        Option::Some(2)
    }
    fn layout() -> Layout {
        Layout::Enum(
            array![
                FieldLayout {
                   selector: selector!("Human"),
                   layout: Self::layout() 
                },
                FieldLayout {
                    selector: selector!("Computer"),
                    layout: Self::layout()
                },
            ]
                .span()
        )
    }
    //#[inline(always)]
    fn ty() -> Ty {
        Ty::Enum(
            Enum {
                name: 'PlayerType',  
                attrs: array![].span(),
                children: array![
                    (
                        'Human'.into(),
                        Self::ty()
                    ),
                    (
                        'Computer'.into(),
                        Self::ty()
                    )
                ].span()
            }
        )
    }
}