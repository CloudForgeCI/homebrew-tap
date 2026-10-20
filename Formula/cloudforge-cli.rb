class CloudforgeCli < Formula
  desc "Non-interactive synth+deploy CLI for CloudForge apps against MiniStack/LocalStack"
  homepage "https://github.com/CloudForgeCI/cloudforge-cli"
  url "https://github.com/CloudForgeCI/homebrew-tap/releases/download/v0.2.14/cloudforge-cli-0.2.14-darwin.tar.gz"
  sha256 "1de9c2693e196386237f930c035bb46da650bc5a98c746a16e00a8f8d86e3168"
  version "0.2.14"
  license "Apache-2.0"

  # jsii/aws-cdk-lib synthesis spawns a real node process itself (no pure-Java CDK synthesis
  # path exists); openjdk provides the JVM this release's classpath launch needs.
  depends_on "node"
  depends_on "openjdk"

  def install
    # The release tarball wraps everything in its own "libexec/" directory (matching
    # assemble-release.sh's layout), and Homebrew cds into the tarball's single top-level
    # directory before running this block -- so Dir["*"] here is just ["libexec"], and
    # libexec.install Dir["*"] copies that folder INTO this keg's own libexec, producing
    # libexec/libexec/bin/cloudforge-cli. bin.install_symlink then points at the shallower,
    # nonexistent libexec/bin/cloudforge-cli -- ln -s never validates its target, so this
    # failed silently: `brew install` reported success while leaving a dangling symlink.
    libexec.install Dir["libexec/*"]
    bin.install_symlink libexec/"bin/cloudforge-cli"
  end

  test do
    # No deployment context on a fresh install, so just confirm the binary launches far enough
    # to print its own usage message and exit non-zero rather than crashing outright.
    assert_match "Usage: DeployCli", shell_output("#{bin}/cloudforge-cli 2>&1", 1)
  end
end
