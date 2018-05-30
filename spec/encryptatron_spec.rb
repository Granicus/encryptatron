require 'spec_helper'

describe Encryptatron do
  it "has a version number" do
    expect(Encryptatron::VERSION).not_to be nil
  end

  it 'calls into file on #load' do
    file_double = double(Encryptatron::FileHandler)
    ENV['ENCRYPTATRON_KEY'] = 'here is a long encryption key'
    expect(Encryptatron::FileHandler).to receive(:new).with('file.yml').and_return(file_double)
    expect(file_double).to receive(:load).with('here is a long encryption key').and_return(key_name: 'value')
    expect(file_double).to receive(:data).and_return(key_name: 'value')
    expect(Encryptatron.load('file.yml')).to eq(key_name: 'value')
  end

  it 'calls into #load on #use' do
    expect(Encryptatron).to receive(:load).with('file.yml').and_return(keh: 'value')
    Encryptatron.use('file.yml')
  end
end
