require 'spec_helper'

describe Encryptatron::FileHandler do
  subject { Encryptatron::FileHandler.new(file_fixture('test.yml')) }
  let(:key) { 'PEqb/ShhfI6e5P/G3QwMw63qk2y2TeXGiteAShlz5JU=' }

  it 'sets up the appropriate file names on #initialize' do
    subject = Encryptatron::FileHandler.new('foo.yml')
    expect(subject.file).to eq('foo.yml')
    expect(subject.enc_file).to eq('foo.yml.enc')
    expect(subject.iv_file).to eq('foo.yml.iv')
  end

  it 'calls load_unencrypted if the files do not exist' do
    subject = Encryptatron::FileHandler.new('foo.yml')
    expect(File).to receive(:exist?).with('foo.yml').and_return(true)
    expect(File).to receive(:exist?).with('foo.yml.enc').and_return(false)
    expect(subject).to receive(:load_unencrypted)
    subject.load('whatever')
  end

  context 'files exist' do
    it 'calls load_encrypted if the files do exist' do
      expect(File).to receive(:exist?).with(file_fixture('test.yml')).and_return(false)
      expect(File).to receive(:exist?).with(file_fixture('test.yml.enc')).and_return(true)
      expect(File).to receive(:exist?).with(file_fixture('test.yml.iv')).and_return(true)
      expect(subject).to receive(:load_encrypted).with('whatever')
      subject.load('whatever')
    end
  end

  context '#load_unencrypted' do
    it 'loads a file from yaml' do
      expect(subject.load_unencrypted).to eq('test' => %w[yml yaml json])
    end
  end

  context '#load_encrypted' do
    it 'loads an encrypted file' do
      expect(subject.load_encrypted(key)).to eq("test" => %w[yml yaml json], "data" => { "more_data" => "another thing" })
    end

    it 'raises an exception if the encryption key is not set' do
      expect { subject.load_encrypted(nil) }.to raise_error(RuntimeError)
    end
  end

  context '#encrypt!' do
    let(:dir) { 'tmp/testdata' }

    before :each do
      FileUtils.mkdir_p dir
    end

    after :each do
      FileUtils.rm_rf dir
    end

    it 'writes out an encrypted file' do
      expected_data = { "foo" => 'bar', "beep" => 'boop' }
      subject.file = "#{dir}/test_encryption.yml"
      subject.data = expected_data
      subject.encrypt!(key)

      expect(File).to exist("#{dir}/test_encryption.yml.enc")
      expect(File).to exist("#{dir}/test_encryption.yml.iv")

      expect(subject.load_encrypted(key)).to eq(expected_data)
    end
  end
end
