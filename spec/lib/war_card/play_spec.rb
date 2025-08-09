# frozen_string_literal: true

RSpec.describe WarCard::Play do
  # TODO: this spec does just a high level of testin with only 2 players.
  #       It should be extended to cover more cases, like:
  #       - 4 players
  #       - more edge cases with the war resolution
  #       - more complex scenarios with the players having different number of cards
  let(:play) { described_class.new(2) }

  let(:deck) { instance_double(WarCard::Deck) }
  let(:card1) { instance_double(WarCard::Card, rank: 13, display_name: "K-hearts") }
  let(:card2) { instance_double(WarCard::Card, rank: 10, display_name: "10-spades") }
  let(:player1) { instance_double(WarCard::Player, name: "Player 1", has_cards?: true, cards_left: 26, player_cards: [ card1 ]) }
  let(:player2) { instance_double(WarCard::Player, name: "Player 2", has_cards?: true, cards_left: 26, player_cards: [ card2 ]) }

  before do
    allow(WarCard::Deck).to receive(:new).and_return(deck)
    allow(WarCard::Player).to receive(:new).and_return(player1, player2)
    allow(WarCard::GeneralService).to receive(:log_data)
    allow(deck).to receive(:create_deck)
    allow(deck).to receive_messages(get_size: 52, get_cards: [])
    allow(player1).to receive(:add_cards)
    allow(player2).to receive(:add_cards)
  end

  describe "#initialize" do
    it "sets up initial state and calls setup" do
      # play = described_class.new(2)

      expect(play.number_of_players).to eq(2)
      expect(play.deck).to eq(deck)
      expect(deck).to have_received(:create_deck)
      expect(WarCard::Player).to have_received(:new).with("Player 1")
      expect(WarCard::Player).to have_received(:new).with("Player 2")
      expect(deck).to have_received(:get_cards).with(26).twice
    end
  end

  describe "#play_the_game" do
    before do
      allow(play).to receive(:play_round)
    end

    context "when only one player has cards" do
      before do
        allow(player1).to receive(:has_cards?).and_return(true)
        allow(player2).to receive(:has_cards?).and_return(false)
        play.players = [ player1, player2 ]
      end

      it "ends game and declares winner" do
        play.play_the_game

        expect(WarCard::GeneralService).to have_received(:log_data).with("*** Game Over! ***")
        expect(WarCard::GeneralService).to have_received(:log_data).with("*** Winner is Player 1 with 26 cards! ***")
      end
    end
  end

    describe "#eliminate_players" do
      before do
        play.players = [ player1, player2 ]
        allow(player1).to receive(:has_cards?).and_return(true)
        allow(player2).to receive(:has_cards?).and_return(false)
      end

      it "removes players without cards" do
        play.send(:eliminate_players)

        expect(play.players).to eq([ player1 ])
      end
    end

    describe "#play_round" do
      before do
        allow(player1).to receive(:face_up_card).and_return(card1)
        allow(player2).to receive(:face_up_card).and_return(card2)
        allow(play).to receive(:resolve_war)
      end

      it "collects cards and resolves war" do
        play.send(:play_round, [ player1, player2 ])

        expect(WarCard::GeneralService).to have_received(:log_data).with("*** Player 1 *** ==> plays K-hearts ***")
        expect(WarCard::GeneralService).to have_received(:log_data).with("*** Player 2 *** ==> plays 10-spades ***")
        expect(play).to have_received(:resolve_war)
      end
    end

    describe "#resolve_war" do
      context "single winner" do
        let(:played_cards) { { player1 => [ card1 ], player2 => [ card2 ] } }

        before do
          allow(player1).to receive(:add_cards)
        end

        it "awards cards to winner" do
          play.send(:resolve_war, played_cards)

          expect(player1).to have_received(:add_cards).at_least(:once)
          expect(WarCard::GeneralService).to have_received(:log_data).with(/Player 1 wins this round/)
        end
      end

      context "multi players with the same highest card" do
        let(:war_card1) { instance_double(WarCard::Card, rank: 13, display_name: "K-clubs") }
        let(:war_card2) { instance_double(WarCard::Card, rank: 13, display_name: "K-spades") }
        let(:played_cards) { { player1 => [ war_card1 ], player2 => [ war_card2 ] } }

        before do
          allow(player1).to receive_messages(face_up_card: card1, cards_left: 10)
          allow(player2).to receive_messages(face_up_card: card2, cards_left: 10)
        end

        it "resolve war" do
          play.send(:resolve_war, played_cards)

          expect(WarCard::GeneralService).to have_received(:log_data).with("*** War between players: Player 1, Player 2 ***")
          expect(WarCard::GeneralService).to have_received(:log_data).with("*** Player 1 plays K-hearts face up for war ***")
          expect(WarCard::GeneralService).to have_received(:log_data).with("*** Player 2 plays 10-spades face up for war ***")
          expect(WarCard::GeneralService).to have_received(:log_data).with("*** Player 1 wins this round and takes 10 cards ***")
        end
      end
    end
end
