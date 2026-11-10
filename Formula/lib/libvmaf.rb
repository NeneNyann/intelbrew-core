class Libvmaf < Formula
  desc "Perceptual video quality assessment based on multi-method fusion"
  homepage "https://github.com/Netflix/vmaf"
  url "https://github.com/Netflix/vmaf/archive/refs/tags/v3.2.1.tar.gz"
  sha256 "5df7386911bc15fd1ca783132528748d219768ae4fc5f8e0b61184f041648092"
  license "BSD-2-Clause-Patent"
  compatibility_version 1

  bottle do
    root_url "https://github.com/NeneNyann/intelbrew-core/releases/download/libvmaf-3.2.1-b86133ae8d60e28e8a750cda7"
    sha256 cellar: :any, sequoia: "ee687e1f0942dfe7991442f0e86d55a550bd86422047dc39c9b5ad964611e04a"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  uses_from_macos "vim" => :build # needed for xxd

  on_intel do
    depends_on "nasm" => :build
  end

  def install
    system "meson", "setup", "build", "libvmaf", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    pkgshare.install "model"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libvmaf/libvmaf.h>
      int main() {
        return 0;
      }
    C

    flags = [
      "-I#{HOMEBREW_PREFIX}/include/libvmaf",
      "-L#{lib}",
    ]

    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
