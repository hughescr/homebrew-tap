class Ggmorse < Formula
    desc "Morse code decoding library"
    homepage "https://github.com/ggerganov/ggmorse"
    url "https://github.com/ggerganov/ggmorse/archive/8fb433d.tar.gz"
    version "0.1.0"
    sha256 "9cbb49c7b25bde8bcec2a6d18ab25772e78ac8ad8233a138d4ba389563f011c3"
    license "MIT"

    depends_on "cmake" => :build

    def install
        cmake_args = %W[
            -DCMAKE_POLICY_VERSION_MINIMUM=3.5
            -DGGMORSE_BUILD_EXAMPLES=OFF
            -DGGMORSE_SUPPORT_SDL2=OFF
        ]
        system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *cmake_args
        system "cmake", "--build", "build"
        system "cmake", "--install", "build"
    end

    test do
        (testpath/"test.cpp").write <<~EOS
#include "ggmorse/ggmorse.h"

int main() {
    GGMorse ggm(GGMorse::getDefaultParameters());
    return 0;
}
        EOS
        system ENV.cxx, "test.cpp", "-std=c++17", "-I#{include}", "-L#{lib}", "-lggmorse", "-o", "test"
        system "./test"
    end
end
