#include <iostream>

#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/InstrTypes.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/IR/Module.h"
#include "llvm/Pass.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Transforms/IPO/PassManagerBuilder.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"
#include "llvm/Transforms/IPO/PassManagerBuilder.h"

using namespace llvm;

namespace custom_pass {

extern "C" {
    void traceInstr(char *instr_name);
}

struct CustomPass : public FunctionPass {
    static char ID;

    CustomPass() : FunctionPass(ID) {}

    bool runOnFunction(Function &func) override {
        if (func.getName() == "traceInstr") {
            return false; // diabling for current func
        }

        LLVMContext &context = func.getContext();
        IRBuilder<> builder(context);
        Type *tracer_ret_type = Type::getVoidTy(context);

        ArrayRef<Type *> tracer_instr_param_types = {
            builder.getInt8Ty()->getPointerTo(),
        };

        FunctionType *tracer_instr_func_type =
            FunctionType::get(tracer_ret_type, tracer_instr_param_types, false);
        FunctionCallee tracer_instr_func = func.getParent()->getOrInsertFunction(
            "traceInstr", tracer_instr_func_type);
        // Dump functions
        outs() << "trace: " << func.getName() << "\n";

        for (auto &basic_block : func) {
            for (auto &instruction : basic_block) {
                if (auto *call = dyn_cast<CallInst>(&instruction)) {
                    Function *callee = call->getCalledFunction();
                    if (!callee || callee->getName() == "traceInstr") {
                        continue; // diabling for current func
                    }
                }

                // ret, br, switch, 
                if (instruction.mayHaveSideEffects() && !instruction.isTerminator()) {
                    continue;
                }

                // Skip PHI Nodes
                if (auto *phi = dyn_cast<PHINode>(&instruction)) {
                  continue;
                }
                // Dump functions
                outs() << "  Adding calls for: " << instruction.getOpcodeName() << "\n";

                builder.SetInsertPoint(&instruction);
                Value *instruction_name =
                    builder.CreateGlobalStringPtr(instruction.getOpcodeName());
                Value *args[] = {instruction_name};
                builder.CreateCall(tracer_instr_func, args);
            }
        }

        return true;
    }
};

char CustomPass::ID = 0;

// code below is from http://adriansampson.net/blog/clangpass.html
static void registerMyPass(const PassManagerBuilder &Builder,
                           llvm::legacy::PassManagerBase &PM) {
    // Double check of opt level
    if (Builder.OptLevel == 2) {
        PM.add(new CustomPass());
        outs () << "GOTCHA" << "\n";
    } else {
        outs () << "not hehe" << "\n";
    }
}
static RegisterStandardPasses
    RegisterMyPass(PassManagerBuilder::EP_OptimizerLast,
                   registerMyPass);
} // namespace my_pass