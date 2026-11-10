class Utf8proc < Formula
  desc "Clean C library for processing UTF-8 Unicode data"
  homepage "https://juliastrings.github.io/utf8proc/"
  url "https://github.com/JuliaStrings/utf8proc/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "f564011d38b2888d583d510b08e69ffa15aa117155db1b9b49ef1dfe1fa25111"
  license all_of: ["MIT", "Unicode-DFS-2015"]
  compatibility_version 1
  head "https://github.com/JuliaStrings/utf8proc.git", branch: "master"

  bottle do
    root_url "https://github.com/NeneNyann/intelbrew-core/releases/download/utf8proc-2.12.0-be05f6f5c376c566d236b3bcb"
    sha256 cellar: :any, sequoia: "9e6c1e519f027d47112a4fc32c8d2398cd907824653d3697f45a189d55b53f3c"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <string.h>
      #include <utf8proc.h>

      int main() {
        const char *version = utf8proc_version();
        return strnlen(version, sizeof("1.3.1-dev")) > 0 ? 0 : -1;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lutf8proc", "-o", "test"
    system "./test"
  end
end
