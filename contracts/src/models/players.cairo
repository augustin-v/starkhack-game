use core::dict::Felt252DictTrait;
#[derive(Drop, Debug)]
enum PlayerType {
    Human,
    Computer,
}
#[derive(Drop)]
struct UserDatabase<T> {
    users_updates: u64,
    balances: Felt252Dict<u64>,
    player_types: PlayerType,
}

trait UserDatabaseTrait {
   fn new() -> UserDatabase;
   fn update_user(ref self: UserDatabase, name: felt252, balance: T, player_type: PlayerType)
   fn get_balance(ref self: UserDatabase, name: felt252) -> T;
   fn get_player_type(ref self: UserDatabase, name: felt252) -> PlayerType;
}

impl UserDatabaseImpl of UserDatabaseTrait {
    // Creates a database
    fn new() -> UserDatabase {
        UserDatabase { users_updates: 0, balances: Felt252Dict::new(), player_types: Default::default() }
    }
    fn get_balance(ref self: UserDatabase, name: felt252) -> T {
        self.balances.get(name)
    }
    fn update_user(ref self: UserDatabase, name: felt252, balance: T, player_type: PlayerType) {
        self.balances.insert(name, balance);
        self.player_types.insert(name, player_type);
        self.users_updates += 1;
    }
    fn get_player_type(ref self: UserDatabase, name: felt252) -> PlayerType {
        self.player_types.get(name)
    }
}