class Tarsplit < Formula
  desc "Utility to split tarballs into smaller pieces while keeping files intact"
  homepage "https://github.com/dmuth/tarsplit"
  url "https://github.com/dmuth/tarsplit/archive/tarsplit-1.0.tar.gz"
  sha256 "e5522dd4f6120e7c0a88207be75cb2fcfa87601faa52dbf8cbca89cd432900a9"
  license "Apache-2.0"

  def install
    bin.install "tarsplit"
  end

  test do
    # Testing is done with tests.sh during development.
    system "true"
  end
end
