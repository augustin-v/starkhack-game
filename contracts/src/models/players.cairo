use dojo::database::introspect::{Introspect, Layout, FieldLayout, Ty, Enum, Member};
use core::poseidon::PoseidonTrait;


use starknet::ContractAddress;
#[derive(Drop, Debug, Serde)]
enum PlayerType {
    Human,
    Computer,
}

#[derive(Serde, Copy, Drop, Introspect, PartialEq, Print)]
enum Outcome {
    // player 1 won
    Player1,
    // player 2 won
    Player2,
    // Game not over
    Pending,
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
    outcome: Outcome,
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
                   layout: Introspect::<PlayerType>::layout() 
                },
                FieldLayout {
                    selector: selector!("Computer"),
                    layout: Introspect::<PlayerType>::layout()
                },
            ]
                .span()
        )
    }
    #[inline(always)]
    fn ty() -> Ty {
        Ty::Enum(
            Enum {
                name: 'PlayerType',  // Convert to felt252 if required
                attrs: array![].span(),
                children: array![
                    Member {
                        name: 'Human'.into(),  // Convert to felt252 if required
                        attrs: array![].span(),
                        ty: Introspect::<PlayerType>::ty()
                    },
                    Member {
                        name: 'Computer'.into(),  // Convert to felt252 if required
                        attrs: array![].span(),
                        ty: Introspect::<PlayerType>::ty()
                    }
                ].span()
            }
        )
    }
}