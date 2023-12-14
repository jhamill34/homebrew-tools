require "formula"

VERSION = "0.1.2"

class RoverCli < Formula
  homepage "https://github.com/jhamill34/rover"
  on_macos do
    on_arm do
      url "https://github.com/jhamill34/rover/releases/download/v#{VERSION}/rover-v#{VERSION}-aarch64-apple-darwin.tar.gz"
    end

    on_intel do
      url "https://github.com/jhamill34/rover/releases/download/v#{VERSION}/rover-v#{VERSION}-x86_64-apple-darwin.tar.gz"
    end
  end

  head "https://github.com/jhamill34/rover.git"
  version VERSION

  def install
    bin.install "rover"
  end

  # Homebrew requires tests.
  test do
    system "true"
  end
end
