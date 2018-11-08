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
#include "llvm/ADT/ArrayRef.h"
#include "llvm/IR/IntrinsicInst.h"
using namespace llvm;

int main() {
    LLVMContext context;
    // ; ModuleID = 'app'
    // source_filename = "app"
    Module *module = new Module("app", context);
    IRBuilder<> builder(context);
// --------------------------------------------------------------------------------
    
    // @grid = dso_local local_unnamed_addr global [700 x [700 x i8]] zeroinitializer, align 16
    // @nextGrid = dso_local local_unnamed_addr global [700 x [700 x i8]] zeroinitializer, align 16
    Type* elementType = builder.getInt1Ty();
    Type* arrayType = llvm::ArrayType::get(llvm::ArrayType::get(elementType, 700), 700);

    GlobalVariable *grid = new GlobalVariable(
        *module,
        arrayType,
        false,
        GlobalValue::CommonLinkage,
        Constant::getNullValue(arrayType),
        "grid"
    );

    GlobalVariable *nextGrid = new GlobalVariable(
        *module,
        arrayType,
        false,
        GlobalValue::CommonLinkage,
        Constant::getNullValue(arrayType),
        "nextGrid"
    );
    grid->setAlignment(Align(16));
    nextGrid->setAlignment(Align(16));

    /*
      Declare external functions from sum.h
    */
    // declare void @_Z8simFlushv() local_unnamed_addr #1
    FunctionType *simFlushFuncType = FunctionType::get(builder.getVoidTy(), false);
    FunctionCallee simFlushFunc = module->getOrInsertFunction("_Z8simFlushv", simFlushFuncType);

    // declare void @_Z11simPutPixeliii(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1
    FunctionType *simPutPixelFuncType = FunctionType::get(builder.getVoidTy(), {builder.getInt32Ty(), builder.getInt32Ty(), builder.getInt32Ty()}, false);
    FunctionCallee simPutPixelFunc = module->getOrInsertFunction("_Z11simPutPixeliii", simPutPixelFuncType);

    // declare noundef i32 @_Z7simRandv() local_unnamed_addr #1
    FunctionType *simRandFuncType = FunctionType::get(builder.getInt32Ty(), false);
    FunctionCallee simRandFunc = module->getOrInsertFunction("_Z7simRandv", simRandFuncType);

    /*
    Define my func initializeGrid from app.cpp
    define dso_local void @_Z14initializeGridv() local_unnamed_addr #0 {
    */
    FunctionType *initializeGridFuncType = FunctionType::get(builder.getVoidTy(), false);
    Function *initializeGridFunc = Function::Create(initializeGridFuncType, Function::ExternalLinkage, "_Z14initializeGridv", module);
    initializeGridFunc->setDSOLocal(true);
    initializeGridFunc->setUnnamedAddr(GlobalValue::UnnamedAddr::Local);

    /*
    Define my func drawGrid from app.cpp
    define dso_local void @_Z8drawGridv() local_unnamed_addr #0 {
    */
    FunctionType *drawGridFuncType = FunctionType::get(builder.getVoidTy(), false);
    Function *drawGridFunc = Function::Create(drawGridFuncType, Function::ExternalLinkage, "_Z8drawGridv", module);
    drawGridFunc->setDSOLocal(true);
    drawGridFunc->setUnnamedAddr(GlobalValue::UnnamedAddr::Local);

    /*
    Define my func app from app.cpp
    define dso_local void @_Z3appv() local_unnamed_addr #0 {
    */
    FunctionType *appFuncType = FunctionType::get(builder.getVoidTy(), false);
    Function *appFunc = Function::Create(appFuncType, Function::ExternalLinkage, "_Z3appv", module);
    appFunc->setDSOLocal(true);
    appFunc->setUnnamedAddr(GlobalValue::UnnamedAddr::Local);

    
    // Actual IR for initializeGrid() function
    {
        // Declare all basic blocks in advance
        BasicBlock *BB0 = BasicBlock::Create(context, "", initializeGridFunc);
        BasicBlock *BB1 = BasicBlock::Create(context, "", initializeGridFunc);
        BasicBlock *BB3 = BasicBlock::Create(context, "", initializeGridFunc);
        BasicBlock *BB4 = BasicBlock::Create(context, "", initializeGridFunc);
        BasicBlock *BB7 = BasicBlock::Create(context, "", initializeGridFunc);

        // 0:
        builder.SetInsertPoint(BB0);
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
        // value9->setTailCall(true);
        auto *value10 = builder.CreateSRem(value9, builder.getInt32(2));
        auto *value11 = builder.CreateICmpEQ(value10, builder.getInt32(1));
        auto *value12 = builder.CreateInBoundsGEP(arrayType, grid, {builder.getInt64(0), value2, value8}); // value 2 should be first
        auto *value13 = builder.CreateZExt(value11, builder.getInt8Ty());
        auto *storeActive = builder.CreateStore(value13, value12);
        storeActive->setAlignment(Align(1));
        auto *value14 = builder.CreateAdd(value8, builder.getInt64(1), "", true, true);
        auto *value15 = builder.CreateICmpEQ(value14, builder.getInt64(450));
        builder.CreateCondBr(value15, BB4, BB7);

        // resolving phi
        value2->addIncoming(builder.getInt64(225), BB0);
        value2->addIncoming(value5, BB4);
        value8->addIncoming(builder.getInt64(225), BB1);
        value8->addIncoming(value14, BB7);

    }

    // Actual IR for drawGrid() function
    {
        // Declare all basic blocks in advance
        BasicBlock *BB0 = BasicBlock::Create(context, "", drawGridFunc);
        BasicBlock *BB1 = BasicBlock::Create(context, "", drawGridFunc);
        BasicBlock *BB4 = BasicBlock::Create(context, "", drawGridFunc);
        BasicBlock *BB5 = BasicBlock::Create(context, "", drawGridFunc);
        BasicBlock *BB8 = BasicBlock::Create(context, "", drawGridFunc);
        BasicBlock *BB13 = BasicBlock::Create(context, "", drawGridFunc);
        BasicBlock *BB15 = BasicBlock::Create(context, "", drawGridFunc);

        builder.SetInsertPoint(BB0);
        builder.CreateBr(BB1); // br label %1

        builder.SetInsertPoint(BB1); // 1:
        PHINode *value2 = builder.CreatePHI(builder.getInt64Ty(), 2);
        auto *value3 = builder.CreateTrunc(value2, builder.getInt32Ty());
        builder.CreateBr(BB8); // br label %8

        builder.SetInsertPoint(BB4); // 4:
        CallInst *call1 = builder.CreateCall(simFlushFunc); // tail call void @_Z8simFlushv()
        // call1->setTailCall(true);
        builder.CreateRetVoid(); // ret void

        builder.SetInsertPoint(BB5); // 5:
        auto *value6 = builder.CreateAdd(value2, builder.getInt64(1), "", true, true);
        auto *value7 = builder.CreateICmpEQ(value6, builder.getInt64(700));
        builder.CreateCondBr(value7, BB4, BB1); // br i1 %7, label %4, label %1, !llvm.loop !12

        builder.SetInsertPoint(BB8); // 8:
        PHINode *value9 = builder.CreatePHI(builder.getInt64Ty(), 2);
        auto *value10 = builder.CreateInBoundsGEP(arrayType, grid, {builder.getInt64(0), value2, value9});
        auto *value11 = builder.CreateLoad(builder.getInt8Ty(), value10);        
        value11->setAlignment(Align(1));
        auto *value12 = builder.CreateICmpEQ(value11, builder.getInt8(0));
        builder.CreateCondBr(value12, BB15, BB13); // br i1 %12, label %15, label %13

        builder.SetInsertPoint(BB13); // 13:
        auto *value14 = builder.CreateTrunc(value9, builder.getInt32Ty());
        // maybe trouble
        CallInst *call2 = builder.CreateCall(simPutPixelFunc, {builder.CreateTrunc(value3, builder.getInt32Ty()), builder.CreateTrunc(value14, builder.getInt32Ty()), builder.getInt32(-65536)});
        // call2->setTailCall(true);
        builder.CreateBr(BB15);

        builder.SetInsertPoint(BB15); // 15:
        auto *value16 = builder.CreateAdd(value9, builder.getInt64(1), "", true, true);
        auto *value17 = builder.CreateICmpEQ(value16, builder.getInt64(700));
        builder.CreateCondBr(value17, BB5, BB8); // br i1 %17, label %5, label %8, !llvm.loop !14

        
        // resolving phi
        value2->addIncoming(builder.getInt64(0), BB0);
        value2->addIncoming(value6, BB5);
        value9->addIncoming(builder.getInt64(0), BB1);
        value9->addIncoming(value16, BB15);
    }

    // Actual IR for app() function
    {
        // Declare all basic blocks in advance
        BasicBlock *BB0 = BasicBlock::Create(context, "", appFunc);
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

        // 0:
        builder.SetInsertPoint(BB0); // 0:
        builder.CreateBr(BB1); // br label %1

        builder.SetInsertPoint(BB1); // 1:
        // maybe trouble
        PHINode *value2 = builder.CreatePHI(builder.getInt64Ty(), 2);
        builder.CreateBr(BB6); // br label %6

        builder.SetInsertPoint(BB3); // 3:
        auto *value4 = builder.CreateAdd(value2, builder.getInt64(1), "", true, true);
        auto *value5 = builder.CreateICmpEQ(value4, builder.getInt64(450));
        builder.CreateCondBr(value5, BB15, BB1); // br i1 %8, label %15, label %1, !llvm.loop !5

        builder.SetInsertPoint(BB6); // 6:
        PHINode *value7 = builder.CreatePHI(builder.getInt64Ty(), 2);
        auto *value8 = builder.CreateCall(simRandFunc);
        // value8->setTailCall(true);
        auto *value9 = builder.CreateSRem(value8, builder.getInt32(2));
        auto *value10 = builder.CreateICmpEQ(value9, builder.getInt32(1));
        auto *value11 = builder.CreateInBoundsGEP(arrayType, grid, {builder.getInt64(0), value2, value7});
        auto *value12 = builder.CreateZExt(value10, builder.getInt8Ty());
        auto *storeActive = builder.CreateStore(value12, value11);
        storeActive->setAlignment(Align(1));
        auto *value13 = builder.CreateAdd(value7, builder.getInt64(1), "", true, true);
        auto *value14 = builder.CreateICmpEQ(value13, builder.getInt64(450));
        builder.CreateCondBr(value14, BB3, BB6);

        builder.SetInsertPoint(BB15); // 15:
        PHINode *value16 = builder.CreatePHI(builder.getInt32Ty(), 2);
        builder.CreateBr(BB18);
        
        builder.SetInsertPoint(BB17); // 17: //No predecessors! // maybe trouble
        builder.CreateRetVoid();  // ret void

        builder.SetInsertPoint(BB18); // 18:
        PHINode *value19 = builder.CreatePHI(builder.getInt64Ty(), 2);
        auto *value20 = builder.CreateTrunc(value19, builder.getInt32Ty());
        auto *value21 = builder.CreateAdd(value20, builder.getInt32(-1));
        auto *value22 = builder.CreateICmpULT(value21, builder.getInt32(700));
        auto *value23 = builder.CreateZExt(value21, builder.getInt64Ty());
        auto *value24 = builder.CreateAdd(value19, builder.getInt64(1), "", true, true);
        auto *value25 = builder.CreateICmpULT(value19, builder.getInt64(699));
        builder.CreateCondBr(value22, BB26, BB32);

        builder.SetInsertPoint(BB26); // 26:
        auto *value27 = builder.CreateInBoundsGEP(arrayType, grid, {builder.getInt64(0), value23, builder.getInt64(0)});
        auto *value28 = builder.CreateLoad(builder.getInt8Ty(), value27);
        value28->setAlignment(Align(4));
        auto *value29 = builder.CreateInBoundsGEP(arrayType, grid, {builder.getInt64(0), value23, builder.getInt64(1)});
        auto *value30 = builder.CreateLoad(builder.getInt8Ty(), value29);
        value30->setAlignment(Align(1));
        auto *value31 = builder.CreateAdd(value28, value30, "", true, true); // warnings
        builder.CreateBr(BB32);

        builder.SetInsertPoint(BB32); // 32:
        PHINode *value33 = builder.CreatePHI(builder.getInt8Ty(), 2);
        auto *value34 = builder.CreateZExt(value33, builder.getInt32Ty());
        auto *value35 = builder.CreateInBoundsGEP(arrayType, grid, {builder.getInt64(0), value19, builder.getInt64(1)});
        auto *value36 = builder.CreateLoad(builder.getInt8Ty(), value35);
        value36->setAlignment(Align(1));
        auto *value37 = builder.CreateZExt(value36, builder.getInt32Ty());
        auto *value38 = builder.CreateAdd(value34, value37, "", true, true);
        builder.CreateCondBr(value25, BB39, BB48);

        builder.SetInsertPoint(BB39); // 39:
        auto *value40 = builder.CreateInBoundsGEP(arrayType, grid, {builder.getInt64(0), value24, builder.getInt64(0)});
        auto *value41 = builder.CreateLoad(builder.getInt8Ty(), value40);
        value41->setAlignment(Align(4));
        auto *value42 = builder.CreateZExt(value41, builder.getInt32Ty());
        auto *value43 = builder.CreateAdd(value38, value42, "", true, true);
        auto *value44 = builder.CreateInBoundsGEP(arrayType, grid, {builder.getInt64(0), value24, builder.getInt64(1)});
        auto *value45 = builder.CreateLoad(builder.getInt8Ty(), value44);
        value45->setAlignment(Align(1));
        auto *value46 = builder.CreateZExt(value45, builder.getInt32Ty());
        auto *value47 = builder.CreateAdd(value43, value46, "", true, true);
        builder.CreateBr(BB48);

        builder.SetInsertPoint(BB48); // 48:
        PHINode *value49 = builder.CreatePHI(builder.getInt32Ty(), 2);
        auto *value50 = builder.CreateInBoundsGEP(arrayType, grid, {builder.getInt64(0), value19, builder.getInt64(0)});
        auto *value51 = builder.CreateLoad(builder.getInt8Ty(), value50);
        value51->setAlignment(Align(4));
        auto *value52 = builder.CreateICmpEQ(value51, builder.getInt8(0));
        auto *value53 = builder.CreateICmpEQ(value49, builder.getInt32(3));
        auto *value54 = builder.CreateAnd(value49, builder.getInt32(-2));
        auto *value55 = builder.CreateICmpEQ(value54, builder.getInt32(2));
        auto *value56 = builder.CreateSelect(value52, value53, value55);
        auto *value57 = builder.CreateZExt(value56, builder.getInt8Ty());
        auto *value58 = builder.CreateInBoundsGEP(arrayType, nextGrid, {builder.getInt64(0), value19, builder.getInt64(0)});
        auto *store1 = builder.CreateStore(value57, value58);
        store1->setAlignment(Align(4));
        builder.CreateBr(BB62); // but dumps as BB61. how???

        builder.SetInsertPoint(BB59); // 59:
        auto *value60 = builder.CreateICmpEQ(value24, builder.getInt64(700));
        builder.CreateCondBr(value60, BB61, BB18);

        builder.SetInsertPoint(BB61); // 61:
        // Call to memcpy
        auto *gridPtr = builder.CreateBitCast(grid, builder.getInt8PtrTy());
        auto *nextGridPtr = builder.CreateBitCast(nextGrid, builder.getInt8PtrTy());
        auto *gridSize = builder.getInt64(490000);
        auto *isVolatile = builder.getInt1(false);
        Value *memcpyCallArgs[] = {
            gridPtr,
            nextGridPtr,
            gridSize,
            isVolatile
        };
        Function *memcpyFunc = module->getFunction("llvm.memcpy.p0i8.p0i8.i64");
        if (!memcpyFunc) {
            // Функция не найдена в module, создайте ее.
            FunctionType *memcpyFuncType = Intrinsic::getType(module->getContext(), Intrinsic::memcpy, {builder.getInt8PtrTy(), builder.getInt8PtrTy(), builder.getInt64Ty()});
            memcpyFunc = Function::Create(memcpyFuncType, Function::ExternalLinkage, "llvm.memcpy.p0i8.p0i8.i64", module);
        }
        auto *call7 = builder.CreateCall(memcpyFunc, memcpyCallArgs);
        builder.CreateBr(BB135);
        
        builder.SetInsertPoint(BB62); // 62:
        PHINode *value63 = builder.CreatePHI(builder.getInt64Ty(), 2);
        builder.CreateCondBr(value22, BB64, BB70);

        builder.SetInsertPoint(BB64); // 64:
        auto *value65 = builder.CreateAdd(value63, builder.getInt64(4294967295), "", true, true);
        auto *value66 = builder.CreateAnd(value65, builder.getInt64(4294967295));
        auto *value67 = builder.CreateInBoundsGEP(arrayType, grid, {builder.getInt64(0), value23, value66});
        auto *value68 = builder.CreateLoad(builder.getInt8Ty(), value67);
        value68->setAlignment(Align(1));
        auto *value69 = builder.CreateZExt(value68, builder.getInt32Ty());
        builder.CreateBr(BB70);

        builder.SetInsertPoint(BB70); // 70:
        PHINode *value71 = builder.CreatePHI(builder.getInt32Ty(), 2);
        builder.CreateCondBr(value22, BB72, BB84); // write bb79

        builder.SetInsertPoint(BB72); // 72:
        auto *value73 = builder.CreateInBoundsGEP(arrayType, grid, {builder.getInt64(0), value23, value63});
        auto *value74 = builder.CreateLoad(builder.getInt8Ty(), value73);
        value74->setAlignment(Align(1));
        auto *value75 = builder.CreateZExt(value74, builder.getInt32Ty());
        auto *value76 = builder.CreateAdd(value71, value75, "", true, true);
        auto *value77 = builder.CreateICmpULT(value63, builder.getInt64(699));
        builder.CreateCondBr(value77, BB78, BB84);
    
        builder.SetInsertPoint(BB78); // 78:
        auto *value79 = builder.CreateAdd(value63, builder.getInt64(1));
        auto *value80 = builder.CreateInBoundsGEP(arrayType, grid, {builder.getInt64(0), value23, value79});
        auto *value81 = builder.CreateLoad(builder.getInt8Ty(), value80);
        value81->setAlignment(Align(1));
        auto *value82 = builder.CreateZExt(value81, builder.getInt32Ty());
        auto *value83 = builder.CreateAdd(value76, value82);
        builder.CreateBr(BB84);

        builder.SetInsertPoint(BB84); // 84:
        PHINode *value85 = builder.CreatePHI(builder.getInt32Ty(), 3);
        auto *value86 = builder.CreateAdd(value63, builder.getInt64(4294967295), "", true, true);
        auto *value87 = builder.CreateAnd(value86, builder.getInt64(4294967295));
        auto *value88 = builder.CreateInBoundsGEP(arrayType, grid, {builder.getInt64(0), value19, value87});
        auto *value89 = builder.CreateLoad(builder.getInt8Ty(), value88);
        value89->setAlignment(Align(1));
        auto *value90 = builder.CreateZExt(value89, builder.getInt32Ty());
        auto *value91 = builder.CreateAdd(value85, value90, "", true, true);
        auto *value92 = builder.CreateICmpULT(value63, builder.getInt64(699));
        builder.CreateCondBr(value92, BB93, BB99);


        builder.SetInsertPoint(BB93); // 93:
        auto *value94 = builder.CreateAdd(value63, builder.getInt64(1), "", true, true);
        auto *value95 = builder.CreateInBoundsGEP(arrayType, grid, {builder.getInt64(0), value19, value94});
        auto *value96 = builder.CreateLoad(builder.getInt8Ty(), value95);
        value96->setAlignment(Align(1));
        auto *value97 = builder.CreateZExt(value96, builder.getInt32Ty());
        auto *value98 = builder.CreateAdd(value91, value97);
        builder.CreateBr(BB99);

        builder.SetInsertPoint(BB99); // 99:
        PHINode *value100 = builder.CreatePHI(builder.getInt32Ty(), 2);
        builder.CreateCondBr(value25, BB101, BB108);
        
        builder.SetInsertPoint(BB101); // 101:
        auto *value102 = builder.CreateAdd(value63, builder.getInt64(4294967295), "", true, true);
        auto *value103 = builder.CreateAnd(value102, builder.getInt64(4294967295));
        auto *value104 = builder.CreateInBoundsGEP(arrayType, grid, {builder.getInt64(0), value24, value103});
        auto *value105 = builder.CreateLoad(builder.getInt8Ty(), value104);
        value105->setAlignment(Align(1));
        auto *value106 = builder.CreateZExt(value105, builder.getInt32Ty());
        auto *value107 = builder.CreateAdd(value100, value106, "", true, true);
        builder.CreateBr(BB108);

        builder.SetInsertPoint(BB108); // 108:
        PHINode *value109 = builder.CreatePHI(builder.getInt32Ty(), 2);
        builder.CreateCondBr(value25, BB110, BB122);

        builder.SetInsertPoint(BB110); // 110:
        auto *value111 = builder.CreateInBoundsGEP(arrayType, grid, {builder.getInt64(0), value24, value63});
        auto *value112 = builder.CreateLoad(builder.getInt8Ty(), value111);
        value112->setAlignment(Align(1));
        auto *value113 = builder.CreateZExt(value112, builder.getInt32Ty());
        auto *value114 = builder.CreateAdd(value109, value113);
        auto *value115 = builder.CreateICmpULT(value63, builder.getInt64(699));
        builder.CreateCondBr(value115, BB116, BB122);

        builder.SetInsertPoint(BB116); // 116:
        auto *value117 = builder.CreateAdd(value63, builder.getInt64(1), "", true, true);
        auto *value118 = builder.CreateInBoundsGEP(arrayType, grid, {builder.getInt64(0), value24, value117});
        auto *value119 = builder.CreateLoad(builder.getInt8Ty(), value118);
        value119->setAlignment(Align(1));
        auto *value120 = builder.CreateZExt(value119, builder.getInt32Ty());
        auto *value121 = builder.CreateAdd(value114, value120, "", true, true);
        builder.CreateBr(BB122);
        
        builder.SetInsertPoint(BB122); // 122:
        PHINode *value123 = builder.CreatePHI(builder.getInt32Ty(), 3);
        auto *value124 = builder.CreateInBoundsGEP(arrayType, grid, {builder.getInt64(0), value19, value63});
        auto *value125 = builder.CreateLoad(builder.getInt8Ty(), value124);
        value125->setAlignment(Align(1));
        auto *value126 = builder.CreateICmpEQ(value125, builder.getInt8(0));
        auto *value127 = builder.CreateICmpEQ(value123, builder.getInt32(3));
        auto *value128 = builder.CreateAnd(value123, builder.getInt32(-2));
        auto *value129 = builder.CreateICmpEQ(value128, builder.getInt32(2));
        auto *value130 = builder.CreateSelect(value126, value127, value129);
        auto *value131 = builder.CreateZExt(value130, builder.getInt8Ty());
        auto *value132 = builder.CreateInBoundsGEP(arrayType, nextGrid, {builder.getInt64(0), value19, value63});
        auto *store4 = builder.CreateStore(value131, value132);
        store4->setAlignment(Align(1));
        auto *value133 = builder.CreateAdd(value63, builder.getInt64(1), "", true, true);
        auto *value134 = builder.CreateICmpEQ(value133, builder.getInt64(700));
        builder.CreateCondBr(value134, BB59, BB62);

        builder.SetInsertPoint(BB135); // 135:
        PHINode *value136 = builder.CreatePHI(builder.getInt64Ty(), 2);
        auto *value137 = builder.CreateTrunc(value136, builder.getInt32Ty());
        builder.CreateBr(BB141);

        builder.SetInsertPoint(BB138); // 138:
        auto *value139 = builder.CreateAdd(value136, builder.getInt64(1), "", true, true);
        auto *value140 = builder.CreateICmpEQ(value139, builder.getInt64(700));
        builder.CreateCondBr(value140, BB151, BB135);
        
        builder.SetInsertPoint(BB141); // 141:
        PHINode *value142 = builder.CreatePHI(builder.getInt64Ty(), 2);
        auto *value143 = builder.CreateInBoundsGEP(arrayType, grid, {builder.getInt64(0), value136, value142});
        auto *value144 = builder.CreateLoad(builder.getInt8Ty(), value143);
        value144->setAlignment(Align(1));
        auto *value145 = builder.CreateICmpEQ(value144, builder.getInt8(0));
        builder.CreateCondBr(value145, BB148, BB146);

        builder.SetInsertPoint(BB146); // 146:
        auto *value147 = builder.CreateTrunc(value142, builder.getInt32Ty());
        Value *args148[] = {value137, value147, builder.getInt32(-65536)};
        CallInst *call4 = builder.CreateCall(simPutPixelFunc, args148);
        // call4->setTailCall(true); // warnings
        builder.CreateBr(BB148);

        builder.SetInsertPoint(BB148); // 148:
        auto *value149 = builder.CreateAdd(value142, builder.getInt64(1), "", true, true);
        auto *value150 = builder.CreateICmpEQ(value149, builder.getInt64(700));
        builder.CreateCondBr(value150, BB138, BB141);

        builder.SetInsertPoint(BB151); // 151:
        CallInst *call5 = builder.CreateCall(simFlushFunc);
        // call5->setTailCall(true);
        auto *value152 = builder.CreateAdd(value16, builder.getInt32(1), "", true, true);
        auto *value153 = builder.CreateICmpEQ(value152, builder.getInt32(1000));
        builder.CreateCondBr(value153, BB17, BB15);
        
        // resolving phi
        value2->addIncoming(builder.getInt64(225), BB0);
        value2->addIncoming(value4, BB3);
        value7->addIncoming(builder.getInt64(225), BB1);
        value7->addIncoming(value13, BB6);
        value16->addIncoming(value152, BB151);
        value16->addIncoming(builder.getInt32(0), BB3);
        value19->addIncoming(builder.getInt64(0), BB15);
        value19->addIncoming(value24, BB59);
        value33->addIncoming(value31, BB26);
        value33->addIncoming(builder.getInt8(0), BB18);
        value49->addIncoming(value47, BB39);
        value49->addIncoming(value38, BB32);
        value63->addIncoming(builder.getInt64(1), BB48);
        value63->addIncoming(value133, BB122);
        value71->addIncoming(builder.getInt32(0), BB62);
        value71->addIncoming(value69, BB64);
        value85->addIncoming(value76, BB72);
        value85->addIncoming(value83, BB78);
        value85->addIncoming(value71, BB70);
        value100->addIncoming(value91, BB84);
        value100->addIncoming(value98, BB93);
        value109->addIncoming(value100, BB99);
        value109->addIncoming(value107, BB101);
        value123->addIncoming(value114, BB110);
        value123->addIncoming(value121, BB116);
        value123->addIncoming(value109, BB108);
        value136->addIncoming(value139, BB138);
        value136->addIncoming(builder.getInt64(0), BB61);
        value142->addIncoming(builder.getInt64(0), BB135);
        value142->addIncoming(value149, BB148);
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
    			if (fnName == "_Z11simPutPixeliii") {
    				return reinterpret_cast<void *>(simPutPixel);
    			}
    			if (fnName == "_Z8simFlushv") {
    				return reinterpret_cast<void *>(simFlush);
    			}
    			if (fnName == "_Z7simRandv") {
    				return reinterpret_cast<void *>(simRand);
    			}
    			return nullptr;
    		});
    ee->finalizeObject();

    simInit();

    ArrayRef<GenericValue> noargs;
    GenericValue v = ee->runFunction(appFunc, noargs);
    outs() << "Code was run.\n";
    
    simExit();
    return 0;
}