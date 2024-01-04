require "formula"

VERSION = "0.1.2"

class Apicli < Formula
  homepage "https://github.com/jhamill34/api-tools"
  
  on_macos do
    on_arm do 
      url "https://github.com/jhamill34/api-tools/releases/download/v#{VERSION}/apicli-v#{VERSION}-aarch64-apple-darwin.tar.gz"
    end

    on_intel do
      url "https://github.com/jhamill34/api-tools/releases/download/v#{VERSION}/apicli-v#{VERSION}-x86_64-apple-darwin.tar.gz"
    end
  end

  head "https://github.com/jhamill34/api-tools.git"
  version VERSION

  depends_on "fzf"
  depends_on "jq"

  def install
    bin.install "apid"
    bin.install "apicli"
    bin.install Dir["scripts/*"]
    prefix.install "templates"

    inreplace "etc/apicli-config.toml" do |s| 
      s.gsub! "/usr/local/apicli", "#{prefix}"
    end

    inreplace "etc/apid-config.toml" do |s|
      s.gsub! "/usr/local/var" , "#{var}"
    end

    prefix.install Dir["etc/*"]
  end

  def caveats
    caveats = ""
    caveats += <<~EOS
      Before starting apid you will need to update the connector.path in the config file located at:
        #{prefix}/apid-config.toml

      Also, apicli by default points to $HOME/.apilite/config.toml for configuration. 
      You will need to either:
      Create this file by hand  

        touch $HOME/.apilite/config.toml

      Copy the default config located at #{prefix}/apicli-config.toml to $HOME/.apilite/config.toml 
        
        cp #{prefix}/apicli-config.toml $HOME/.apilite/config.toml
  
      Or set the environment variable APICLI_CONFIG_PATH to point to #{prefix}/apicli-config.toml

        export APICLI_CONFIG_PATH=#{prefix}/apicli-config.toml
    EOS

    caveats
  end

  service do 
    run [opt_bin/"apid"]
    log_path var/"log/apid.log"
    error_log_path var/"log/apid.log"

    (var/"log/apid").mkpath 

    environment_variables :APID_CONFIG_PATH => opt_prefix/"apid-config.toml"
  end

  # Homebrew requires tests.
  test do
    system "true"
  end
end
