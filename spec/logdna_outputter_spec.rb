require "spec_helper"

RSpec.describe Log4r::LogdnaOutputter do
  it "has a version number" do
    expect(Log4r::Logdna::VERSION).not_to be nil
  end
end
