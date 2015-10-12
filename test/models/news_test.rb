require 'test_helper'

describe Page do
  it { expect(build(:news)).to be_valid }
  it { should validate_length_of(:name).is_at_least(2) }
  it { should validate_length_of(:description).is_at_least(2) }
  it { should validate_length_of(:branch).is_at_least(2) }
  it { should validate_length_of(:popular).is_at_least(2) }
  it { should validate_length_of(:date).is_at_least(2) }
  it { should validate_length_of(:created_at).is_at_least(2) }
  it { should validate_presence_of(:updated_at) }
end
