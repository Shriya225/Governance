module shri_addr::VotingSystem {
    use std::string::{Self, String};
    use std::vector;
    use std::signer;
    use std::option::{Self, Option};
    use std::error;
    use aptos_std::table::{Self, Table};

    const E_ALREADY_INITIALIZED: u64 = 1;
    const E_ALREADY_VOTED: u64 = 2;
    const E_INVALID_PROPOSAL: u64 = 3;
    const E_NOT_INITIALIZED: u64 = 4;

    // Resource to store voting data
    struct VotingData has key {
        votes: Table<address, u8>,  // who voted for what index
        counts: vector<u64>,        // votes per proposal
        total_voters: u64,          // number of participants
        proposals: vector<String>,  // store proposals in the resource
    }

    // Initialize the voting resource
    public entry fun init(account: &signer) acquires VotingData {
        let addr = signer::address_of(account);
        assert!(!exists<VotingData>(addr), error::already_exists(E_ALREADY_INITIALIZED));

        // Create hardcoded proposals
        let proposals = vector::empty<String>();
        vector::push_back(&mut proposals, string::utf8(b"Proposal 1: Increase funding"));
        vector::push_back(&mut proposals, string::utf8(b"Proposal 2: Launch new feature"));
        vector::push_back(&mut proposals, string::utf8(b"Proposal 3: Reduce fees"));

        let proposal_count = vector::length(&proposals);
        let vote_table = table::new<address, u8>();

        move_to(account, VotingData {
            votes: vote_table,
            counts: vector::empty<u64>(),
            total_voters: 0,
            proposals,
        });

        // Initialize counts vector with zeros
        let data = borrow_global_mut<VotingData>(addr);
        let i = 0;
        while (i < proposal_count) {
            vector::push_back(&mut data.counts, 0);
            i = i + 1;
        };
    }

    /// Cast a vote (only once per account)
    public entry fun vote(voter: &signer, voting_contract_addr: address, proposal_idx: u8) acquires VotingData {
        assert!(exists<VotingData>(voting_contract_addr), error::not_found(E_NOT_INITIALIZED));
        
        let voter_addr = signer::address_of(voter);
        let data = borrow_global_mut<VotingData>(voting_contract_addr);

        // Check if already voted
        assert!(!table::contains(&data.votes, voter_addr), error::invalid_state(E_ALREADY_VOTED));

        // Check if proposal index is valid
        let num_proposals = vector::length(&data.proposals);
        assert!((proposal_idx as u64) < num_proposals, error::invalid_argument(E_INVALID_PROPOSAL));

        // Record vote
        table::add(&mut data.votes, voter_addr, proposal_idx);
        let count_ref = vector::borrow_mut(&mut data.counts, (proposal_idx as u64));
        *count_ref = *count_ref + 1;

        data.total_voters = data.total_voters + 1;
    }

    #[view]
    public fun get_vote_counts(voting_contract_addr: address): vector<u64> acquires VotingData {
        assert!(exists<VotingData>(voting_contract_addr), error::not_found(E_NOT_INITIALIZED));
        let data = borrow_global<VotingData>(voting_contract_addr);
        data.counts
    }

    #[view]
    public fun get_vote_by_user(voting_contract_addr: address, voter: address): Option<u8> acquires VotingData {
        assert!(exists<VotingData>(voting_contract_addr), error::not_found(E_NOT_INITIALIZED));
        let data = borrow_global<VotingData>(voting_contract_addr);
        if (table::contains(&data.votes, voter)) {
            option::some(*table::borrow(&data.votes, voter))
        } else {
            option::none<u8>()
        }
    }

    #[view]
    public fun get_total_participants(voting_contract_addr: address): u64 acquires VotingData {
        assert!(exists<VotingData>(voting_contract_addr), error::not_found(E_NOT_INITIALIZED));
        let data = borrow_global<VotingData>(voting_contract_addr);
        data.total_voters
    }

    #[view]
    public fun get_proposals(voting_contract_addr: address): vector<String> acquires VotingData {
        assert!(exists<VotingData>(voting_contract_addr), error::not_found(E_NOT_INITIALIZED));
        let data = borrow_global<VotingData>(voting_contract_addr);
        data.proposals
    }

    #[view]
    public fun get_results(voting_contract_addr: address): (vector<String>, vector<u64>, u64) acquires VotingData {
        assert!(exists<VotingData>(voting_contract_addr), error::not_found(E_NOT_INITIALIZED));
        let data = borrow_global<VotingData>(voting_contract_addr);
        (data.proposals, data.counts, data.total_voters)
    }

    #[view]
    public fun is_initialized(voting_contract_addr: address): bool {
        exists<VotingData>(voting_contract_addr)
    }

    #[view]
    public fun get_winner(voting_contract_addr: address): (String, u64) acquires VotingData {
        assert!(exists<VotingData>(voting_contract_addr), error::not_found(E_NOT_INITIALIZED));
        let data = borrow_global<VotingData>(voting_contract_addr);
        
        let max_votes = 0u64;
        let winner_idx = 0u64;
        let i = 0u64;
        let count_len = vector::length(&data.counts);
        
        while (i < count_len) {
            let current_votes = *vector::borrow(&data.counts, i);
            if (current_votes > max_votes) {
                max_votes = current_votes;
                winner_idx = i;
            };
            i = i + 1;
        };
        
        let winner_proposal = *vector::borrow(&data.proposals, winner_idx);
        (winner_proposal, max_votes)
    }
}