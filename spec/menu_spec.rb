require_relative '../lib/menu.rb'

describe 'Menus' do
  before do
    allow(STDOUT).to receive(:write) # .and_call_original
  end

  before(:all) do
    @single_page_menu = {
      'north' => 'go north',
      'south' => 'go south',
      'east' => 'go east',
      'west' => 'go west'
    }

    @multi_page_menu = {
      AL: 'Alabama',
      AK: 'Alaska',
      AZ: 'Arizona',
      AR: 'Arkansas',
      CA: 'California',
      CO: 'Colorado',
      CT: 'Connecticut',
      DE: 'Delaware',
      FL: 'Florida',
      GA: 'Georgia',

      HI: 'Hawaii',
      ID: 'Idaho',
      IL: 'Illinois',
      IN: 'Indiana',
      IA: 'Iowa',
      KS: 'Kansas',
      KY: 'Kentucky',
      LA: 'Louisiana',
      ME: 'Maine',
      MD: 'Maryland',

      MA: 'Massachusetts',
      MI: 'Michigan',
      MN: 'Minnesota',
      MS: 'Mississippi',
      MO: 'Missouri',
      MT: 'Montana',
      NE: 'Nebraska',
      NV: 'Nevada',
      NH: 'New Hampshire',
      NJ: 'New Jersey',

      NM: 'New Mexico',
      NY: 'New York',
      NC: 'North Carolina',
      ND: 'North Dakota',
      OH: 'Ohio',
      OK: 'Oklahoma',
      OR: 'Oregon',
      PA: 'Pennsylvania',
      RI: 'Rhode Island',
      SC: 'South Carolina',

      SD: 'South Dakota',
      TN: 'Tennessee',
      TX: 'Texas',
      UT: 'Utah',
      VT: 'Vermont',
      VA: 'Virginia',
      WA: 'Washington',
      WV: 'West Virginia',
      WI: 'Wisconsin',
      WY: 'Wyoming'
    }
  end

  context 'when all the options fit on one page' do
    context 'and the player enters previous' do
      it 'does not change the page' do
        allow(STDIN).to receive(:gets).and_return('prev', 'nor')
        expect(STDOUT).to receive(:write).with("north) go north").twice
        do_menu('Test Menu', @single_page_menu)
      end
    end

    context 'and the player enters next' do
      it 'does not change the page' do
        allow(STDIN).to receive(:gets).and_return('next', 'nor')
        expect(STDOUT).to receive(:write).with("north) go north").twice
        do_menu('Test Menu', @single_page_menu)
      end
    end

    context 'and the player enters an exact option' do
      it 'returns the matching option' do
        allow(STDIN).to receive(:gets).and_return('north')
        expect(do_menu('Test Menu', @single_page_menu)).to eq('north')
      end
    end

    context 'and the player enters a partial option' do
      context 'and the input matches no options' do
        it 'prompts until a match is chosen' do
          allow(STDIN).to receive(:gets).and_return('nope', 'try again', 'north')
          expect(STDOUT).to receive(:write).with("Choice? ").exactly(3).times
          expect(do_menu('Test Menu', @single_page_menu)).to eq('north')
        end
      end

      context 'and the input matches one option' do
        it 'returns the matching option' do
          allow(STDIN).to receive(:gets).and_return('nor')
          expect(do_menu('Test Menu', @single_page_menu)).to eq('north')
        end
      end

      context 'and the input matches more than one option' do
        it 'prompts until a specific match is chosen' do
          allow(STDIN).to receive(:gets).and_return('t', 'st', 'est')
          expect(STDOUT).to receive(:write).with("Choice? ").exactly(3).times
          expect(do_menu('Test Menu', @single_page_menu)).to eq('west')
        end
      end
    end
  end

  context "when the options don't fit on one page" do
    context 'and the first page is displayed' do
      context 'and the player chooses previous' do
        it 'does not change the page' do
          allow(STDIN).to receive(:gets).and_return('prev', 'OR')
          expect(STDOUT).to receive(:write).with(/ page 1 of 5 /).twice
          do_menu('Test Menu', @multi_page_menu)
        end
      end

      context 'and the player chooses next' do
        it 'advances to the next page' do
          allow(STDIN).to receive(:gets).and_return('next', 'OR')
          expect(STDOUT).to receive(:write).with(/ page 1 of 5 /)
          expect(STDOUT).to receive(:write).with(/ page 2 of 5 /)
          do_menu('Test Menu', @multi_page_menu)
        end
      end
    end

    context 'and a middle page is displayed' do
      context 'and the player chooses previous' do
        it 'goes back to the previous page' do
          allow(STDIN).to receive(:gets).and_return('next', 'prev', 'OR')
          expect(STDOUT).to receive(:write).with(/ page 1 of 5 /).twice
          expect(STDOUT).to receive(:write).with(/ page 2 of 5 /)
          do_menu('Test Menu', @multi_page_menu)
        end
      end

      context 'and the player chooses next' do
        it 'advances to the next page' do
          allow(STDIN).to receive(:gets).and_return('next', 'next', 'OR')
          expect(STDOUT).to receive(:write).with(/ page 1 of 5 /)
          expect(STDOUT).to receive(:write).with(/ page 2 of 5 /)
          expect(STDOUT).to receive(:write).with(/ page 3 of 5 /)
          do_menu('Test Menu', @multi_page_menu)
        end
      end
    end

    context 'and the last page is displayed' do
      context 'and the player chooses previous' do
        it 'goes back to the previous page' do
          allow(STDIN).to receive(:gets).and_return('next', 'next', 'next', 'next', 'prev', 'OR')
          expect(STDOUT).to receive(:write).with(/ page 4 of 5 /).twice
          expect(STDOUT).to receive(:write).with(/ page 5 of 5 /)
          do_menu('Test Menu', @multi_page_menu)
        end
      end

      context 'and the player chooses next' do
        it 'goes back to the previous page' do
          allow(STDIN).to receive(:gets).and_return('next', 'next', 'next', 'next', 'next', 'OR')
          expect(STDOUT).to receive(:write).with(/ page 5 of 5 /).twice
          do_menu('Test Menu', @multi_page_menu)
        end
      end
    end

    context 'and the player enters a partial option' do
      context 'and the input matches an option on the current page' do
        it 'returns the chosen option' do
          allow(STDIN).to receive(:gets).and_return('K')
          expect(do_menu('Test Menu', @multi_page_menu)).to eq(:AK)
        end
      end

      context 'and the input matches an option on some other page' do
        it 'returns the chosen option' do
          allow(STDIN).to receive(:gets).and_return('X')
          expect(do_menu('Test Menu', @multi_page_menu)).to eq(:TX)
        end
      end

      context 'and the input matches more than one option on the current page' do
        it 'prompts again' do
          allow(STDIN).to receive(:gets).and_return('next', 'next', 'next', 'next', 'W', 'OR')
          expect(STDOUT).to receive(:write).with('UT) Utah').twice
          do_menu('Test Menu', @multi_page_menu)
        end
      end

      context 'and the input matches more than one option on all pages' do
        it 'prompts again' do
          allow(STDIN).to receive(:gets).and_return('Y', 'OR')
          expect(STDOUT).to receive(:write).with('Choice? ').twice
          do_menu('Test Menu', @multi_page_menu)
        end
      end

      context 'and the input matches no options on any pages' do
        it 'prompts again' do
          allow(STDIN).to receive(:gets).and_return('ZZZ', 'OR')
          expect(STDOUT).to receive(:write).with('Choice? ').twice
          do_menu('Test Menu', @multi_page_menu)
        end
      end
    end
  end
end
