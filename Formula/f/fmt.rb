class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https://fmt.dev/"
  url "https://github.com/fmtlib/fmt/releases/download/12.2.1/fmt-12.2.1.zip"
  sha256 "870a49acec5bcdab236aeea834ebd7f0b8548a7d8cea33c996b6873a37f2d50c"
  license "MIT"
  compatibility_version 2
  head "https://github.com/fmtlib/fmt.git", branch: "main"

  bottle do
    root_url "https://github.com/NeneNyann/intelbrew-core/releases/download/fmt-12.2.1-b70d701ecbbf56749a4bdf448"
    sha256 cellar: :any, sequoia: "25e2eae960ff5b3bd606ae98fed5ccf40f19acc7b8a3d2762805c7c7f1d65cb3"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=TRUE", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system "cmake", "-S", ".", "-B", "build-static", "-DBUILD_SHARED_LIBS=FALSE", *std_cmake_args
    system "cmake", "--build", "build-static"
    lib.install "build-static/libfmt.a"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <string>
      #include <fmt/format.h>
      int main()
      {
        std::string str = fmt::format("The answer is {}", 42);
        std::cout << str;
        return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test",
                  "-I#{include}",
                  "-L#{lib}",
                  "-lfmt"
    assert_equal "The answer is 42", shell_output("./test")
  end
end
