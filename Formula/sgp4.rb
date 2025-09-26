class Sgp4 < Formula
  desc "Simplified perturbations models"
  homepage "https://github.com/dnwrnr/sgp4"
  url "https://github.com/dnwrnr/sgp4/archive/147b1ae.tar.gz"
  version "1.0.0"
  sha256 "ac4a30ce7b52937f02b7ee7038e81466ebf7b54450d5c311e9a098449e617a8f"
  license "Apache-2.0"

  depends_on "cmake" => :build

  def install
        system "cmake", "-S", ".", "-B", "build", *std_cmake_args
        system "cmake", "--build", "build"
        system "cmake", "--install", "build"

        # Generate a pkg-config file since upstream does not ship one.
        (buildpath/"sgp4.pc").write <<~EOS
prefix=#{opt_prefix}
exec_prefix=${prefix}
libdir=${prefix}/lib
includedir=${prefix}/include

Name: sgp4
Description: Simplified perturbations models
Version: #{version}
Libs: -L${libdir} -lsgp4s
Cflags: -I${includedir}
        EOS
        (lib/"pkgconfig").install "sgp4.pc"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test sgp4`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system bin/"program", "do", "something"`.
    system "false"
  end
end
