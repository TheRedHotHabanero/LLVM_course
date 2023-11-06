mkdir -p build
cd build
clang++ `llvm-config --cppflags --ldflags --libs` ../app_ir.cpp -lSDL2
./a.out > app_gen.ll
diff -I -W --width=200 --minimal --color -y app_gen.ll ../../app.ll > output.txt