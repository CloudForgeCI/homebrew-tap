class CloudforgeCli < Formula
  desc "Non-interactive synth+deploy CLI for CloudForge apps against MiniStack/LocalStack"
  homepage "https://github.com/CloudForgeCI/cloudforge-cli"
  url "https://github.com/CloudForgeCI/cloudforge-cli/releases/download/v0.1.0/cloudforge-cli-0.1.0-darwin.tar.gz"
  sha256 "d8126920260d27c2ec5f70f2de87bde695ac673012ba0231d300aa26baa01804"
  version "0.1.0"
  license "Apache-2.0"

  # jsii/aws-cdk-lib synthesis spawns a real node process itself (no pure-Java CDK synthesis
  # path exists); openjdk provides the JVM this release's classpath launch needs.
  depends_on "node"
  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/cloudforge-cli"
  end

  test do
    # No deployment context on a fresh install, so just confirm the binary launches far enough
    # to print its own usage message and exit non-zero rather than crashing outright.
    assert_match "Usage: DeployCli", shell_output("#{bin}/cloudforge-cli 2>&1", 1)
  end
end
