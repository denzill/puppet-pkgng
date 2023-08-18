# frozen_string_literal: true

require 'spec_helper'

describe 'pkg_updates fact' do
  subject { Facter.fact(:pkg_updates).value }

  after { Facter.clear }

  before do
    allow(File).to receive(:executable?).and_return(false)
    allow(File).to receive(:executable?).with('/usr/sbin/pkg').and_return(true)
    allow(Facter.fact(:osfamily)).to receive(:value).and_return('FreeBSD')
    allow(Facter::Util::Resolution).to receive(:exec).with('/usr/sbin/pkg version -RUql"<"').and_return(pkg_version_output)
  end

  context 'when there is no update' do
    let(:pkg_version_output) { '' }

    it { is_expected.to be_nil }
  end

  context 'when there are updates' do
    let(:pkg_version_output) { "apr-1.6.2.1.6.0\napache24-2.4.27\n" }

    it { is_expected.to eq(2) }
  end
end
