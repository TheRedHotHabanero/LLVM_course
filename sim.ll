; ModuleID = '/home/karina/Prog/LLVM_course/LifeGame/sim.cpp'
source_filename = "/home/karina/Prog/LLVM_course/LifeGame/sim.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.SDL_Window = type opaque
%struct.SDL_Renderer = type opaque
%union.SDL_Event = type { %struct.SDL_TouchFingerEvent, [8 x i8] }
%struct.SDL_TouchFingerEvent = type { i32, i32, i64, i64, float, float, float, float, float, i32 }

@_ZL6Window = internal global %struct.SDL_Window* null, align 8
@_ZL8Renderer = internal global %struct.SDL_Renderer* null, align 8
@.str = private unnamed_addr constant [20 x i8] c"User-requested quit\00", align 1
@.str.1 = private unnamed_addr constant [60 x i8] c"SDL_TRUE != SDL_HasEvent(SDL_QUIT) && \22User-requested quit\22\00", align 1
@.str.2 = private unnamed_addr constant [47 x i8] c"/home/karina/Prog/LLVM_course/LifeGame/sim.cpp\00", align 1
@__PRETTY_FUNCTION__._Z8simFlushv = private unnamed_addr constant [16 x i8] c"void simFlush()\00", align 1
@_ZL5Ticks = internal global i32 0, align 4
@.str.3 = private unnamed_addr constant [13 x i8] c"Out of range\00", align 1
@.str.4 = private unnamed_addr constant [43 x i8] c"0 <= x && x < SIM_X_SIZE && \22Out of range\22\00", align 1
@__PRETTY_FUNCTION__._Z11simPutPixeliii = private unnamed_addr constant [32 x i8] c"void simPutPixel(int, int, int)\00", align 1
@.str.5 = private unnamed_addr constant [43 x i8] c"0 <= y && y < SIM_Y_SIZE && \22Out of range\22\00", align 1

; Function Attrs: mustprogress noinline optnone uwtable
define dso_local void @_Z7simInitv() #0 {
  %1 = call i32 @SDL_Init(i32 noundef 32)
  %2 = call i32 @SDL_CreateWindowAndRenderer(i32 noundef 700, i32 noundef 700, i32 noundef 0, %struct.SDL_Window** noundef @_ZL6Window, %struct.SDL_Renderer** noundef @_ZL8Renderer)
  %3 = load %struct.SDL_Renderer*, %struct.SDL_Renderer** @_ZL8Renderer, align 8
  %4 = call i32 @SDL_SetRenderDrawColor(%struct.SDL_Renderer* noundef %3, i8 noundef zeroext 0, i8 noundef zeroext 0, i8 noundef zeroext 0, i8 noundef zeroext 0)
  %5 = load %struct.SDL_Renderer*, %struct.SDL_Renderer** @_ZL8Renderer, align 8
  %6 = call i32 @SDL_RenderClear(%struct.SDL_Renderer* noundef %5)
  %7 = call i64 @time(i64* noundef null) #6
  %8 = trunc i64 %7 to i32
  call void @srand(i32 noundef %8) #6
  ret void
}

declare i32 @SDL_Init(i32 noundef) #1

declare i32 @SDL_CreateWindowAndRenderer(i32 noundef, i32 noundef, i32 noundef, %struct.SDL_Window** noundef, %struct.SDL_Renderer** noundef) #1

declare i32 @SDL_SetRenderDrawColor(%struct.SDL_Renderer* noundef, i8 noundef zeroext, i8 noundef zeroext, i8 noundef zeroext, i8 noundef zeroext) #1

declare i32 @SDL_RenderClear(%struct.SDL_Renderer* noundef) #1

; Function Attrs: nounwind
declare void @srand(i32 noundef) #2

; Function Attrs: nounwind
declare i64 @time(i64* noundef) #2

; Function Attrs: mustprogress noinline optnone uwtable
define dso_local void @_Z7simExitv() #0 {
  %1 = alloca %union.SDL_Event, align 8
  br label %2

2:                                                ; preds = %0, %10
  %3 = call i32 @SDL_PollEvent(%union.SDL_Event* noundef %1)
  %4 = icmp ne i32 %3, 0
  br i1 %4, label %5, label %10

5:                                                ; preds = %2
  %6 = bitcast %union.SDL_Event* %1 to i32*
  %7 = load i32, i32* %6, align 8
  %8 = icmp eq i32 %7, 256
  br i1 %8, label %9, label %10

9:                                                ; preds = %5
  br label %11

10:                                               ; preds = %5, %2
  br label %2, !llvm.loop !6

11:                                               ; preds = %9
  %12 = load %struct.SDL_Renderer*, %struct.SDL_Renderer** @_ZL8Renderer, align 8
  call void @SDL_DestroyRenderer(%struct.SDL_Renderer* noundef %12)
  %13 = load %struct.SDL_Window*, %struct.SDL_Window** @_ZL6Window, align 8
  call void @SDL_DestroyWindow(%struct.SDL_Window* noundef %13)
  call void @SDL_Quit()
  ret void
}

declare i32 @SDL_PollEvent(%union.SDL_Event* noundef) #1

declare void @SDL_DestroyRenderer(%struct.SDL_Renderer* noundef) #1

declare void @SDL_DestroyWindow(%struct.SDL_Window* noundef) #1

declare void @SDL_Quit() #1

; Function Attrs: mustprogress noinline norecurse optnone uwtable
define dso_local noundef i32 @main() #3 {
  %1 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @_Z7simInitv()
  call void @_Z3appv()
  call void @_Z7simExitv()
  ret i32 0
}

declare void @_Z3appv() #1

; Function Attrs: mustprogress noinline optnone uwtable
define dso_local void @_Z8simFlushv() #0 {
  %1 = alloca i32, align 4
  call void @SDL_PumpEvents()
  %2 = call i32 @SDL_HasEvent(i32 noundef 256)
  %3 = icmp ne i32 1, %2
  br i1 %3, label %4, label %5

4:                                                ; preds = %0
  br label %5

5:                                                ; preds = %4, %0
  %6 = phi i1 [ false, %0 ], [ true, %4 ]
  br i1 %6, label %7, label %8

7:                                                ; preds = %5
  br label %10

8:                                                ; preds = %5
  call void @__assert_fail(i8* noundef getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i8* noundef getelementptr inbounds ([47 x i8], [47 x i8]* @.str.2, i64 0, i64 0), i32 noundef 44, i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @__PRETTY_FUNCTION__._Z8simFlushv, i64 0, i64 0)) #7
  unreachable

9:                                                ; No predecessors!
  br label %10

10:                                               ; preds = %9, %7
  %11 = call i32 @SDL_GetTicks()
  %12 = load i32, i32* @_ZL5Ticks, align 4
  %13 = sub i32 %11, %12
  store i32 %13, i32* %1, align 4
  %14 = load i32, i32* %1, align 4
  %15 = icmp ult i32 %14, 200
  br i1 %15, label %16, label %19

16:                                               ; preds = %10
  %17 = load i32, i32* %1, align 4
  %18 = sub i32 200, %17
  call void @SDL_Delay(i32 noundef %18)
  br label %19

19:                                               ; preds = %16, %10
  %20 = load %struct.SDL_Renderer*, %struct.SDL_Renderer** @_ZL8Renderer, align 8
  call void @SDL_RenderPresent(%struct.SDL_Renderer* noundef %20)
  ret void
}

declare void @SDL_PumpEvents() #1

declare i32 @SDL_HasEvent(i32 noundef) #1

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) #4

declare i32 @SDL_GetTicks() #1

declare void @SDL_Delay(i32 noundef) #1

declare void @SDL_RenderPresent(%struct.SDL_Renderer* noundef) #1

; Function Attrs: mustprogress noinline optnone uwtable
define dso_local void @_Z11simPutPixeliii(i32 noundef %0, i32 noundef %1, i32 noundef %2) #0 {
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i8, align 1
  %8 = alloca i8, align 1
  %9 = alloca i8, align 1
  %10 = alloca i8, align 1
  store i32 %0, i32* %4, align 4
  store i32 %1, i32* %5, align 4
  store i32 %2, i32* %6, align 4
  %11 = load i32, i32* %4, align 4
  %12 = icmp sle i32 0, %11
  br i1 %12, label %13, label %17

13:                                               ; preds = %3
  %14 = load i32, i32* %4, align 4
  %15 = icmp slt i32 %14, 700
  br i1 %15, label %16, label %17

16:                                               ; preds = %13
  br label %17

17:                                               ; preds = %16, %13, %3
  %18 = phi i1 [ false, %13 ], [ false, %3 ], [ true, %16 ]
  br i1 %18, label %19, label %20

19:                                               ; preds = %17
  br label %22

20:                                               ; preds = %17
  call void @__assert_fail(i8* noundef getelementptr inbounds ([43 x i8], [43 x i8]* @.str.4, i64 0, i64 0), i8* noundef getelementptr inbounds ([47 x i8], [47 x i8]* @.str.2, i64 0, i64 0), i32 noundef 54, i8* noundef getelementptr inbounds ([32 x i8], [32 x i8]* @__PRETTY_FUNCTION__._Z11simPutPixeliii, i64 0, i64 0)) #7
  unreachable

21:                                               ; No predecessors!
  br label %22

22:                                               ; preds = %21, %19
  %23 = load i32, i32* %5, align 4
  %24 = icmp sle i32 0, %23
  br i1 %24, label %25, label %29

25:                                               ; preds = %22
  %26 = load i32, i32* %5, align 4
  %27 = icmp slt i32 %26, 700
  br i1 %27, label %28, label %29

28:                                               ; preds = %25
  br label %29

29:                                               ; preds = %28, %25, %22
  %30 = phi i1 [ false, %25 ], [ false, %22 ], [ true, %28 ]
  br i1 %30, label %31, label %32

31:                                               ; preds = %29
  br label %34

32:                                               ; preds = %29
  call void @__assert_fail(i8* noundef getelementptr inbounds ([43 x i8], [43 x i8]* @.str.5, i64 0, i64 0), i8* noundef getelementptr inbounds ([47 x i8], [47 x i8]* @.str.2, i64 0, i64 0), i32 noundef 55, i8* noundef getelementptr inbounds ([32 x i8], [32 x i8]* @__PRETTY_FUNCTION__._Z11simPutPixeliii, i64 0, i64 0)) #7
  unreachable

33:                                               ; No predecessors!
  br label %34

34:                                               ; preds = %33, %31
  %35 = load i32, i32* %6, align 4
  %36 = ashr i32 %35, 24
  %37 = trunc i32 %36 to i8
  store i8 %37, i8* %7, align 1
  %38 = load i32, i32* %6, align 4
  %39 = ashr i32 %38, 16
  %40 = and i32 %39, 255
  %41 = trunc i32 %40 to i8
  store i8 %41, i8* %8, align 1
  %42 = load i32, i32* %6, align 4
  %43 = ashr i32 %42, 8
  %44 = and i32 %43, 255
  %45 = trunc i32 %44 to i8
  store i8 %45, i8* %9, align 1
  %46 = load i32, i32* %6, align 4
  %47 = and i32 %46, 255
  %48 = trunc i32 %47 to i8
  store i8 %48, i8* %10, align 1
  %49 = load %struct.SDL_Renderer*, %struct.SDL_Renderer** @_ZL8Renderer, align 8
  %50 = load i8, i8* %8, align 1
  %51 = load i8, i8* %9, align 1
  %52 = load i8, i8* %10, align 1
  %53 = load i8, i8* %7, align 1
  %54 = call i32 @SDL_SetRenderDrawColor(%struct.SDL_Renderer* noundef %49, i8 noundef zeroext %50, i8 noundef zeroext %51, i8 noundef zeroext %52, i8 noundef zeroext %53)
  %55 = load %struct.SDL_Renderer*, %struct.SDL_Renderer** @_ZL8Renderer, align 8
  %56 = load i32, i32* %4, align 4
  %57 = load i32, i32* %5, align 4
  %58 = call i32 @SDL_RenderDrawPoint(%struct.SDL_Renderer* noundef %55, i32 noundef %56, i32 noundef %57)
  %59 = call i32 @SDL_GetTicks()
  store i32 %59, i32* @_ZL5Ticks, align 4
  ret void
}

declare i32 @SDL_RenderDrawPoint(%struct.SDL_Renderer* noundef, i32 noundef, i32 noundef) #1

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define dso_local noundef i32 @_Z7simRandv() #5 {
  %1 = call i32 @rand() #6
  ret i32 %1
}

; Function Attrs: nounwind
declare i32 @rand() #2

attributes #0 = { mustprogress noinline optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { mustprogress noinline norecurse optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { noreturn nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { mustprogress noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { nounwind }
attributes #7 = { noreturn nounwind }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"Ubuntu clang version 14.0.6"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
