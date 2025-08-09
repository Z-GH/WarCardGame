# frozen_string_literal: true

RSpec.describe WarCard::Game do
  describe "start" do
    let(:play_instance) { instance_double(WarCard::Play) }

    before do
      allow(WarCard::GeneralService).to receive(:log_data)
      allow(WarCard::GeneralService).to receive(:user_input)
      allow(WarCard::GeneralService).to receive(:check_number_of_players)
      allow(WarCard::Play).to receive(:new).and_return(play_instance)
      allow(play_instance).to receive(:play_the_game)
    end

    context "when valid number of players" do
      before do
        allow(WarCard::GeneralService).to receive_messages(user_input: "2", check_number_of_players: true)
      end

      it "starts the game" do
        described_class.start

        expect(WarCard::GeneralService).to have_received(:log_data).with("*** War Card Game has to have 2 or 4 players. Please, Enter number of the players: ***")
        expect(WarCard::GeneralService).to have_received(:log_data).with("*** Welcome to War Card Game ***")
        expect(WarCard::Play).to have_received(:new).with(2)
        expect(play_instance).to have_received(:play_the_game)
      end
    end

    context "when invalid number of players" do
      before do
        allow(WarCard::GeneralService).to receive_messages(user_input: "3", check_number_of_players: false)
      end

      it "returns early without starting game" do
        described_class.start

        expect(WarCard::GeneralService).to have_received(:log_data).with("*** War Card Game has to have 2 or 4 players. Please, Enter number of the players: ***")
        expect(WarCard::GeneralService).not_to have_received(:log_data).with("*** Welcome to War Card Game ***")
        expect(WarCard::Play).not_to have_received(:new)
        expect(play_instance).not_to have_received(:play_the_game)
      end
    end
  end
end
