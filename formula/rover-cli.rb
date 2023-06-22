require "formula"

class RoverCli < Formula
  homepage "https://github.com/jhamill34/rover"
  url "https://github.com/jhamill34/rover/releases/download/v0.1.0/rover-v0.1.0-aarch64-apple-darwin.tar.gz"
  sha256 "4a999dc6a2bc91949bd3bf066cd35e7fb953064f719f9fb149dcae52a44771b7"
  head "https://github.com/jhamill34/rover.git"
  version "0.1.0"

  def install
    bin.install "rover"
  end

  # Homebrew requires tests.
  test do
    system "true"
  end
end
