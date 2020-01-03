require 'spec_helper'

RSpec.describe Procedure::Organizer do
  let(:context) do
    {
      first_name: 'John'
    }
  end

  class FakePassedStepOne
    include Procedure::Step

    def passed?
      true
    end
  end

  class FakePassedStepTwo
    include Procedure::Step

    def passed?
      true
    end
  end

  class FakeFailedStepOne
    include Procedure::Step

    def passed?
      false
    end

    def failure_message
      "User #{context.first_name} is not valid"
    end

    def failure_code
      :user_not_valid
    end
  end

  class FakePassedOrganizer
    include Procedure::Organizer

    steps FakePassedStepOne, FakePassedStepTwo
  end

  class FakeFailedOrganizer
    include Procedure::Organizer

    steps FakePassedStepOne, FakeFailedStepOne, FakePassedStepTwo
  end

  it 'returns false outcome when procedure did not passed' do
    outcome = FakeFailedOrganizer.call(context)

    expect(outcome).not_to be_success
    expect(outcome.failure_message).to eq('User John is not valid')
    expect(outcome.failure_code).to eq(:user_not_valid)
  end

  it 'returns true outcome when procedure passed' do
    outcome = FakePassedOrganizer.call(context)

    expect(outcome).to be_success
  end
end
