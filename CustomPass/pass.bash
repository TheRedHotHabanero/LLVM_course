mkdir -p build
cd build
clang++ ../pass.cpp -c -fPIC -I`llvm-config --includedir` -o Pass.o
clang++ Pass.o -fPIC -shared -o libPass.so
clang++ ../../LifeGame/app.cpp -c -o app.o -Xclang -load -Xclang ./libPass.so -O2 -flegacy-pass-manager
clang++ ../../LifeGame/sim.cpp ../log_passes.cpp app.o -o IR_traces -lSDL2