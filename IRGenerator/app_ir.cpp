// begin of sim.cpp
#include <cstdlib>
#include <cassert>
#include <SDL2/SDL.h>
#include <time.h>
#include "../LifeGame/sim.h"

#define FRAME_TICKS 200

static SDL_Renderer *Renderer = nullptr;
static SDL_Window *Window = nullptr;
static uint32_t Ticks = 0;

void simInit() {
    SDL_Init(SDL_INIT_VIDEO);
    SDL_CreateWindowAndRenderer(SIM_X_SIZE, SIM_Y_SIZE, 0, &Window, &Renderer);
    SDL_SetRenderDrawColor(Renderer, 0, 0, 0, 0);
    SDL_RenderClear(Renderer);
    srand(time(NULL)); // comment it?
}

void simExit() {
    SDL_Event event;
    while (1)
    {
        if (SDL_PollEvent(&event) && event.type == SDL_QUIT)
            break;
    }
    SDL_DestroyRenderer(Renderer);
    SDL_DestroyWindow(Window);
    SDL_Quit();
}

void simFlush() {
    SDL_PumpEvents();
    assert(SDL_TRUE != SDL_HasEvent(SDL_QUIT) && "User-requested quit");
    uint32_t cur_ticks = SDL_GetTicks() - Ticks;
    if (cur_ticks < FRAME_TICKS)
    {
        SDL_Delay(FRAME_TICKS - cur_ticks);
    }
    SDL_RenderPresent(Renderer);
}

void simPutPixel(int x, int y, int argb) {
    assert(0 <= x && x < SIM_X_SIZE && "Out of range");
    assert(0 <= y && y < SIM_Y_SIZE && "Out of range");
    uint8_t a = argb >> 24;
    uint8_t r = (argb >> 16) & 0xFF;
    uint8_t g = (argb >> 8) & 0xFF;
    uint8_t b = argb & 0xFF;
    SDL_SetRenderDrawColor(Renderer, r, g, b, a);
    SDL_RenderDrawPoint(Renderer, x, y);
    Ticks = SDL_GetTicks();
}

int simRand() { // comment it?
    return rand();
}

// end of sim.cpp

#include "llvm/ExecutionEngine/ExecutionEngine.h"
#include "llvm/IR/GlobalVariable.h"
#include "llvm/ExecutionEngine/GenericValue.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/DerivedTypes.h"
using namespace llvm;

int main() {
    LLVMContext context;
    // ; ModuleID = 'app'
    // source_filename = "app"
    Module *module = new Module("app", context);
    IRBuilder<> builder(context);
// --------------------------------------------------------------------------------
    
    
    
    /*
    @grid = dso_local local_unnamed_addr global [700 x [700 x i8]] zeroinitializer, align 16
    @nextGrid = dso_local local_unnamed_addr global [700 x [700 x i8]] zeroinitializer, align 16
    */
    // Create the type for a single element (i8)
    Type* elementType = builder.getInt8Ty();
    // Create the type for the array [700 x [700 x i8]]
    Type* arrayType = llvm::ArrayType::get(llvm::ArrayType::get(elementType, 700), 700);

    GlobalVariable* grid = new GlobalVariable(/*Module=*/*module, 
        /*Type=*/arrayType,
        /*isConstant=*/false,
        /*Linkage=*/GlobalValue::CommonLinkage,
        /*Initializer=*/0, // has initializer, specified below
        /*Name=*/"grid");

    GlobalVariable* nextGrid = new GlobalVariable(/*Module=*/*module, 
        /*Type=*/arrayType,
        /*isConstant=*/false,
        /*Linkage=*/GlobalValue::CommonLinkage,
        /*Initializer=*/0, // has initializer, specified below
        /*Name=*/"nextGrid");
    grid->setAlignment(Align(16));
    nextGrid->setAlignment(Align(16));




    /*
      Declare external functions from sum.h
    */

    // declare void @_Z8simFlushv() local_unnamed_addr #1
    FunctionType *simFlushFuncType = FunctionType::get(builder.getVoidTy(), false);
    FunctionCallee simFlushFunc = module->getOrInsertFunction("simFlush", simFlushFuncType);

    // declare void @_Z11simPutPixeliii(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1
    FunctionType *simPutPixelFuncType = FunctionType::get(builder.getVoidTy(), {builder.getInt32Ty(), builder.getInt32Ty(), builder.getInt32Ty()}, false);
    FunctionCallee simPutPixelFunc = module->getOrInsertFunction("simPutPixel", simPutPixelFuncType);

    // declare noundef i32 @_Z7simRandv() local_unnamed_addr #1
    FunctionType *simRandFuncType = FunctionType::get(builder.getInt32Ty(), false);
    FunctionCallee simRandFunc = module->getOrInsertFunction("simRand", simRandFuncType);






    /*
    Define my func drawGrid from app.cpp
    define dso_local void @_Z8drawGridv() local_unnamed_addr #0 {
    */
    FunctionType *drawGridFuncType = FunctionType::get(builder.getVoidTy(), false);
    Function *drawGridFunc = Function::Create(drawGridFuncType, Function::ExternalLinkage, "drawGrid", module);
    drawGridFunc->setDSOLocal(true);
    drawGridFunc->setUnnamedAddr(GlobalValue::UnnamedAddr::Local);

    /*
    Define my func initializeGrid from app.cpp
    define dso_local void @_Z14initializeGridv() local_unnamed_addr #0 {
    */
    FunctionType *initializeGridFuncType = FunctionType::get(builder.getVoidTy(), false);
    Function *initializeGridFunc = Function::Create(initializeGridFuncType, Function::ExternalLinkage, "initializeGrid", module);
    initializeGridFunc->setDSOLocal(true);
    initializeGridFunc->setUnnamedAddr(GlobalValue::UnnamedAddr::Local);

    /*
    Define my func app from app.cpp
    define dso_local void @_Z3appv() local_unnamed_addr #0 {
    */
    FunctionType *appFuncType = FunctionType::get(builder.getVoidTy(), false);
    Function *appFunc = Function::Create(appFuncType, Function::ExternalLinkage, "app", module);
    appFunc->setDSOLocal(true);
    appFunc->setUnnamedAddr(GlobalValue::UnnamedAddr::Local);






    /*
    Actual IR for initializeGrid() function
    */
    {
        // Declare all basic blocks in advance
        BasicBlock *BB1 = BasicBlock::Create(context, "", initializeGridFunc);
        BasicBlock *BB3 = BasicBlock::Create(context, "", initializeGridFunc);
        BasicBlock *BB4 = BasicBlock::Create(context, "", initializeGridFunc);
        BasicBlock *BB7 = BasicBlock::Create(context, "", initializeGridFunc);


        // 0:
        builder.CreateBr(BB1);

        /*
        1:                                                ; preds = %0, %4
        %2 = phi i64 [ 225, %0 ], [ %5, %4 ]
        br label %7
        */
        builder.SetInsertPoint(BB1); // 1:
        PHINode *value2 = builder.CreatePHI(builder.getInt64Ty(), 2);
        builder.CreateBr(BB7); // br label %7

        /*
        3:                                                ; preds = %4
        ret void
        */
        builder.SetInsertPoint(BB3); // 3:
        builder.CreateRetVoid();

        /*
        4:                                                ; preds = %7
        %5 = add nuw nsw i64 %2, 1
        %6 = icmp eq i64 %5, 450
        br i1 %6, label %3, label %1, !llvm.loop !5 ///// HELP
        */
        builder.SetInsertPoint(BB4); // 4:
        auto *value5 = builder.CreateAdd(value2, builder.getInt64(1), "", true, true);
        auto *value6 = builder.CreateICmpEQ(value5, builder.getInt64(450));
        builder.CreateCondBr(value6, BB3, BB1);

        /*
        7:                                                ; preds = %1, %7
          %8 = phi i64 [ 225, %1 ], [ %14, %7 ]
          %9 = tail call noundef i32 @_Z7simRandv()
          %10 = srem i32 %9, 2
          %11 = icmp eq i32 %10, 1
          %12 = getelementptr inbounds [700 x [700 x i8]], [700 x [700 x i8]]* @grid, i64 0, i64 %2, i64 %8
          %13 = zext i1 %11 to i8
          store i8 %13, i8* %12, align 1, !tbaa !7
          %14 = add nuw nsw i64 %8, 1
          %15 = icmp eq i64 %14, 450
          br i1 %15, label %4, label %7, !llvm.loop !11
        }
        */
        builder.SetInsertPoint(BB7); // 7:
        PHINode *value8 = builder.CreatePHI(builder.getInt64Ty(), 2);
        auto *value9 = builder.CreateCall(simRandFunc);
        value9->setTailCall();
        auto *value10 = builder.CreateSRem(value9, builder.getInt32(2));
        auto *value11 = builder.CreateICmpEQ(value10, builder.getInt32(1));
        auto *value12 = builder.CreateInBoundsGEP(arrayType, grid, {builder.getInt64(0), value2, builder.getInt64(8)}); // value 2 should be first
        auto *value13 = builder.CreateZExt(value11, builder.getInt8Ty());
        auto *storeActive = builder.CreateStore(value13, value12);
        storeActive->setAlignment(Align(1));
        auto *value14 = builder.CreateAdd(value8, builder.getInt64(1), "", true, true);
        auto *value15 = builder.CreateICmpEQ(value14, builder.getInt64(450));
        builder.CreateCondBr(value15, BB4, BB7);
    }

    /*
    Actual IR for drawGrid() function
    */
    {
        // Declare all basic blocks in advance
        BasicBlock *BB1 = BasicBlock::Create(context, "", drawGridFunc);
        BasicBlock *BB4 = BasicBlock::Create(context, "", drawGridFunc);
        BasicBlock *BB5 = BasicBlock::Create(context, "", drawGridFunc);
        BasicBlock *BB8 = BasicBlock::Create(context, "", drawGridFunc);
        BasicBlock *BB13 = BasicBlock::Create(context, "", drawGridFunc);
        BasicBlock *BB15 = BasicBlock::Create(context, "", drawGridFunc);


        builder.SetInsertPoint(BB1);
        builder.CreateBr(BB1); // br label %1

        PHINode *value2 = builder.CreatePHI(builder.getInt64Ty(), 2);
        // %3 = trunc i64 %2 to i32
        // br label %8
        auto *value3 = builder.CreateTrunc(value2, builder.getInt32Ty());
        builder.CreateBr(BB8); // br label %1

        builder.SetInsertPoint(BB4);
        builder.CreateCall(simFlushFunc); // tail call void @_Z8simFlushv()
        builder.CreateRetVoid(); // ret void

        builder.SetInsertPoint(BB5);
        PHINode *value6 = builder.CreatePHI(builder.getInt64Ty(), 2);
        auto *value7 = builder.CreateAdd(value6, builder.getInt64(1), "", true, true);
        auto *value8 = builder.CreateICmpEQ(value7, builder.getInt64(700));
        builder.CreateCondBr(value8, BB4, BB1); // br i1 %7, label %4, label %1, !llvm.loop !12

        builder.SetInsertPoint(BB8);
        PHINode *value9 = builder.CreatePHI(builder.getInt64Ty(), 2);
        auto *value10 = builder.CreateInBoundsGEP(arrayType, grid, {builder.getInt64(0), value2, value9});

        // %11 = load i8, i8* %10, align 1, !tbaa !7, !range !13
        auto *value11 = builder.CreateLoad(builder.getInt8Ty(), value10);
        value11->setAlignment(Align(1));
        auto *value12 = builder.CreateICmpEQ(value11, builder.getInt8(0));
        builder.CreateCondBr(value12, BB15, BB13); // br i1 %12, label %15, label %13

        builder.SetInsertPoint(BB13);
        PHINode *value14 = builder.CreatePHI(builder.getInt64Ty(), 2);
        auto *value15 = builder.CreateAdd(value14, builder.getInt64(1), "", true, true);
        auto *value16 = builder.CreateICmpEQ(value15, builder.getInt64(700));
        builder.CreateCondBr(value16, BB5, BB8); // br i1 %17, label %5, label %8, !llvm.loop !14

        builder.SetInsertPoint(BB15);
        builder.CreateCall(simPutPixelFunc, {builder.CreateTrunc(value2, builder.getInt32Ty()), builder.CreateTrunc(value14, builder.getInt32Ty()), builder.getInt32(-65536)});
        builder.CreateBr(BB15);
    }

    /*
    Actual IR for app() function
    */
    {
        // Declare all basic blocks in advance
        BasicBlock *BB1 = BasicBlock::Create(context, "", appFunc);
        BasicBlock *BB3 = BasicBlock::Create(context, "", appFunc);
        BasicBlock *BB6 = BasicBlock::Create(context, "", appFunc);
        BasicBlock *BB15 = BasicBlock::Create(context, "", appFunc);
        BasicBlock *BB17 = BasicBlock::Create(context, "", appFunc);
        BasicBlock *BB18 = BasicBlock::Create(context, "", appFunc);
        BasicBlock *BB26 = BasicBlock::Create(context, "", appFunc);
        BasicBlock *BB32 = BasicBlock::Create(context, "", appFunc);
        BasicBlock *BB39 = BasicBlock::Create(context, "", appFunc);
        BasicBlock *BB48 = BasicBlock::Create(context, "", appFunc);
        BasicBlock *BB59 = BasicBlock::Create(context, "", appFunc);
        BasicBlock *BB61 = BasicBlock::Create(context, "", appFunc);
        BasicBlock *BB62 = BasicBlock::Create(context, "", appFunc);
        BasicBlock *BB64 = BasicBlock::Create(context, "", appFunc);
        BasicBlock *BB70 = BasicBlock::Create(context, "", appFunc);
        BasicBlock *BB72 = BasicBlock::Create(context, "", appFunc);
        BasicBlock *BB78 = BasicBlock::Create(context, "", appFunc);
        BasicBlock *BB84 = BasicBlock::Create(context, "", appFunc);
        BasicBlock *BB93 = BasicBlock::Create(context, "", appFunc);
        BasicBlock *BB99 = BasicBlock::Create(context, "", appFunc);
        BasicBlock *BB101 = BasicBlock::Create(context, "", appFunc);
        BasicBlock *BB108 = BasicBlock::Create(context, "", appFunc);
        BasicBlock *BB110 = BasicBlock::Create(context, "", appFunc);
        BasicBlock *BB116 = BasicBlock::Create(context, "", appFunc);
        BasicBlock *BB122 = BasicBlock::Create(context, "", appFunc);
        BasicBlock *BB135 = BasicBlock::Create(context, "", appFunc);
        BasicBlock *BB138 = BasicBlock::Create(context, "", appFunc);
        BasicBlock *BB141 = BasicBlock::Create(context, "", appFunc);
        BasicBlock *BB146 = BasicBlock::Create(context, "", appFunc);
        BasicBlock *BB148 = BasicBlock::Create(context, "", appFunc);
        BasicBlock *BB151 = BasicBlock::Create(context, "", appFunc);

    }









// --------------------------------------------------------------------------------
    // Dump LLVM IR
    module->print(outs(), nullptr);

  
    // Interpreter of LLVM IR
    outs() << "Running code...\n";
    InitializeNativeTarget();
    InitializeNativeTargetAsmPrinter();

    ExecutionEngine *ee = EngineBuilder(std::unique_ptr<Module>(module)).create();
    ee->InstallLazyFunctionCreator([&](const std::string &fnName) -> void * {
    			if (fnName == "simPutPixel") {
    				return reinterpret_cast<void *>(simPutPixel);
    			}
    			if (fnName == "simFlush") {
    				return reinterpret_cast<void *>(simFlush);
    			}
    			if (fnName == "simRand") {
    				return reinterpret_cast<void *>(simRand);
    			}
    			return nullptr;
    		});
    ee->finalizeObject();

    simInit();

    ArrayRef<GenericValue> noargs;
    GenericValue v = ee->runFunction(appFunc, noargs);
    outs() << "Done.\n";
    
    simExit();
    return 0;
}