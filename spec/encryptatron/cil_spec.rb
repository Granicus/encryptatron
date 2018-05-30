require 'spec_helper'

describe Encryptatron::CLI do
  it 'may not have 1 parameter' do
    expect { described_class.invoke(['encrypt']) }.to raise_error(SystemExit)
  end

  it 'must have a valid action' do
    expect { described_class.invoke(['encode', 'file1.yml']) }.to raise_error(SystemExit)
  end

  it 'may not have 3 parameters' do
    expect { described_class.invoke(['encrypt', 'file1.yml', 'file2.yml']) }.to raise_error(SystemExit)
  end

  context 'calls into the FileHandler' do
    let(:test_handler) { double(Encryptatron::FileHandler, file: 'tmp/file_test.yml', data: { 'foo' => 'bar' }) }
    before :each do
      expect(Encryptatron::FileHandler).to receive(:new).and_return(test_handler)
    end

    it 'calls encrypt on the file object when given action' do
      expect(test_handler).to receive(:encrypt!)
      expect { described_class.invoke(['encrypt', 'tmp/file_test.yml']) }.not_to raise_error
    end

    it 'calls decrypt on the file provided' do
      expect(test_handler).to receive(:load_encrypted)
      expect { described_class.invoke(['decrypt', 'tmp/file_test.yml']) }.not_to raise_error
    end
  end
end
