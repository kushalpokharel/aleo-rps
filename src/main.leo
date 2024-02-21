// The 'rps' program.
program rps.aleo {
    record Move{
        owner:address, 
        challenger_move:group,
        acceptor_move:u8,
        turn:u8
        player1:address,
        player2:address,
        is_winner:bool
    }

    function hash_choice(choice:u8, key:u8)->group{
        let key_hash:scalar = BHP256::hash_to_scalar(key);
        return BHP256::commit_to_group(choice, key_hash);
    }

    transition challenge(opponent:address, choice: u8, key:u8) -> Move {
        let move: group = hash_choice(choice, key);
        return Move{
            owner:opponent,
            challenger_move:move,
            acceptor_move:0u8,
            turn:1u8,
            player1:self.signer,
            player2:opponent,
            is_winner:false
        };

    }
    transition accept(move_rec:Move, choice:u8) -> Move{
        return Move{
            owner:move_rec.player1,
            challenger_move:move_rec.challenger_move,
            acceptor_move:choice,
            turn:2u8,
            player1:move_rec.player1,
            player2:move_rec.player2,
            is_winner:false
        };
    }

    transition reveal(move_rec:Move, choice:u8, key:u8)-> (u8,address){
        assert(move_rec.challenger_move == hash_choice(choice, key));
        assert(move_rec.turn == 2u8);
        if choice == 1u8{
            if move_rec.acceptor_move==1u8{
                return (0u8, move_rec.player1);
            }
            else if move_rec.acceptor_move==2u8{
                return (1u8, move_rec.player2);
            }
            else{
                return (1u8, move_rec.player1);
            }  
        }
        else if choice == 2u8{
            if move_rec.acceptor_move==1u8{
                return (1u8, move_rec.player1);
            }
            else if move_rec.acceptor_move==2u8{
                return (0u8, move_rec.player2);
            }
            else{
                return (1u8, move_rec.player2);
            }  
        }
        else if choice == 3u8{
            if move_rec.acceptor_move==1u8{
                return (1u8, move_rec.player2);
            }
            else if move_rec.acceptor_move==2u8{
                return (1u8, move_rec.player1);
            }
            else{
                return (0u8, move_rec.player2);
            }  
        }
        return (0u8, move_rec.player2);
    }
}
