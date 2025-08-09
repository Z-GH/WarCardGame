# frozen_string_literal: true

RSpec.describe WarCard::Deck do
    describe "create_deck" do
        subject { described_class.new }

        context "returns correct data" do
            it "returns correct array of cards" do
                cards = subject.create_deck
                expect(cards.size).to eq(52)
            end
        end
    end

    describe "get_cards" do
        subject { described_class.new }

        let(:number_of_cards) { 3 }

        context "returns cards" do
            it "returns first n cards in the deck" do
                subject.create_deck
                sub_cards = subject.cards[0..number_of_cards - 1]
                cards = subject.get_cards(number_of_cards)

                expect(cards).to eq(sub_cards)
            end
        end

        context "returns nil if cards have not been created" do
            it "returns nil if no deck created" do
                cards = subject.get_cards(number_of_cards)

                expect(cards).to be_nil
            end
        end
    end

    describe "get_card" do
        subject { described_class.new }

        context "returns card" do
            it "returns first card in the deck" do
                subject.create_deck
                first_card = subject.cards[0]
                card = subject.get_card

                expect(card).to eq(first_card)
            end
        end

        context "returns nil if cards have not been created" do
            it "returns nil if no deck created" do
                card = subject.get_card

                expect(card).to be_nil
            end
        end
    end
end
