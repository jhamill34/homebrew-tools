require "formula"
require_relative "lib/private_strategy"

class Tpcli < Formula
  desc ""
  homepage "https://github.com/jhamill34/solutions_engineering"
  url "https://github.com/jhamill34/solutions_engineering/releases/download/v0.1.0/tpcli-v0.1.0-aarch64-apple-darwin.tar.gz", :using => GitHubPrivateRepositoryReleaseDownloadStrategy
  sha256 "96066eed5be293b0fb9adcc73c9b15b093e78ab865c238964ab1f41da5898429"
  head "https://github.com/jhamill34/solutions_engineering.git"

  depends_on "fzf"
  depends_on "jq"

  def install
    bin.install "transpositd"
    bin.install "tpcli"
    bin.install Dir["scripts/*"]

    home = ENV["HOME"]
    system "mkdir", "-p", "#{home}/.tplite"
    system "cp", "-R", "templates", "#{home}/.tplite/"
  end

  # Homebrew requires tests.
  test do
    system "true"
  end
end
