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
@.str.1 = private unnamed_addr constant [60 x i8] c"SDL_TRUE != SDL_HasEvent(SDL_QUIT) && \22User-requested quit\22\00", align 1
@.str.2 = private unnamed_addr constant [47 x i8] c"/home/karina/Prog/LLVM_course/LifeGame/sim.cpp\00", align 1
@__PRETTY_FUNCTION__._Z8simFlushv = private unnamed_addr constant [16 x i8] c"void simFlush()\00", align 1
@_ZL5Ticks = internal unnamed_addr global i32 0, align 4
@.str.4 = private unnamed_addr constant [43 x i8] c"0 <= x && x < SIM_X_SIZE && \22Out of range\22\00", align 1
@__PRETTY_FUNCTION__._Z11simPutPixeliii = private unnamed_addr constant [32 x i8] c"void simPutPixel(int, int, int)\00", align 1
@.str.5 = private unnamed_addr constant [43 x i8] c"0 <= y && y < SIM_Y_SIZE && \22Out of range\22\00", align 1

; Function Attrs: mustprogress uwtable
define dso_local void @_Z7simInitv() local_unnamed_addr #0 {
  %1 = tail call i32 @SDL_Init(i32 noundef 32)
  %2 = tail call i32 @SDL_CreateWindowAndRenderer(i32 noundef 700, i32 noundef 700, i32 noundef 0, %struct.SDL_Window** noundef nonnull @_ZL6Window, %struct.SDL_Renderer** noundef nonnull @_ZL8Renderer)
  %3 = load %struct.SDL_Renderer*, %struct.SDL_Renderer** @_ZL8Renderer, align 8, !tbaa !5
  %4 = tail call i32 @SDL_SetRenderDrawColor(%struct.SDL_Renderer* noundef %3, i8 noundef zeroext 0, i8 noundef zeroext 0, i8 noundef zeroext 0, i8 noundef zeroext 0)
  %5 = load %struct.SDL_Renderer*, %struct.SDL_Renderer** @_ZL8Renderer, align 8, !tbaa !5
  %6 = tail call i32 @SDL_RenderClear(%struct.SDL_Renderer* noundef %5)
  %7 = tail call i64 @time(i64* noundef null) #7
  %8 = trunc i64 %7 to i32
  tail call void @srand(i32 noundef %8) #7
  ret void
}

declare i32 @SDL_Init(i32 noundef) local_unnamed_addr #1

declare i32 @SDL_CreateWindowAndRenderer(i32 noundef, i32 noundef, i32 noundef, %struct.SDL_Window** noundef, %struct.SDL_Renderer** noundef) local_unnamed_addr #1

declare i32 @SDL_SetRenderDrawColor(%struct.SDL_Renderer* noundef, i8 noundef zeroext, i8 noundef zeroext, i8 noundef zeroext, i8 noundef zeroext) local_unnamed_addr #1

declare i32 @SDL_RenderClear(%struct.SDL_Renderer* noundef) local_unnamed_addr #1

; Function Attrs: nounwind
declare void @srand(i32 noundef) local_unnamed_addr #2

; Function Attrs: nounwind
declare i64 @time(i64* noundef) local_unnamed_addr #2

; Function Attrs: mustprogress uwtable
define dso_local void @_Z7simExitv() local_unnamed_addr #0 {
  %1 = alloca %union.SDL_Event, align 8
  %2 = bitcast %union.SDL_Event* %1 to i8*
  call void @llvm.lifetime.start.p0i8(i64 56, i8* nonnull %2) #7
  %3 = getelementptr inbounds %union.SDL_Event, %union.SDL_Event* %1, i64 0, i32 0, i32 0
  br label %4

4:                                                ; preds = %4, %0
  %5 = call i32 @SDL_PollEvent(%union.SDL_Event* noundef nonnull %1)
  %6 = icmp ne i32 %5, 0
  %7 = load i32, i32* %3, align 8
  %8 = icmp eq i32 %7, 256
  %9 = select i1 %6, i1 %8, i1 false
  br i1 %9, label %10, label %4, !llvm.loop !9

10:                                               ; preds = %4
  %11 = load %struct.SDL_Renderer*, %struct.SDL_Renderer** @_ZL8Renderer, align 8, !tbaa !5
  call void @SDL_DestroyRenderer(%struct.SDL_Renderer* noundef %11)
  %12 = load %struct.SDL_Window*, %struct.SDL_Window** @_ZL6Window, align 8, !tbaa !5
  call void @SDL_DestroyWindow(%struct.SDL_Window* noundef %12)
  call void @SDL_Quit()
  call void @llvm.lifetime.end.p0i8(i64 56, i8* nonnull %2) #7
  ret void
}

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #3

declare i32 @SDL_PollEvent(%union.SDL_Event* noundef) local_unnamed_addr #1

declare void @SDL_DestroyRenderer(%struct.SDL_Renderer* noundef) local_unnamed_addr #1

declare void @SDL_DestroyWindow(%struct.SDL_Window* noundef) local_unnamed_addr #1

declare void @SDL_Quit() local_unnamed_addr #1

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #3

; Function Attrs: mustprogress norecurse uwtable
define dso_local noundef i32 @main() local_unnamed_addr #4 {
  %1 = alloca %union.SDL_Event, align 8
  %2 = tail call i32 @SDL_Init(i32 noundef 32)
  %3 = tail call i32 @SDL_CreateWindowAndRenderer(i32 noundef 700, i32 noundef 700, i32 noundef 0, %struct.SDL_Window** noundef nonnull @_ZL6Window, %struct.SDL_Renderer** noundef nonnull @_ZL8Renderer)
  %4 = load %struct.SDL_Renderer*, %struct.SDL_Renderer** @_ZL8Renderer, align 8, !tbaa !5
  %5 = tail call i32 @SDL_SetRenderDrawColor(%struct.SDL_Renderer* noundef %4, i8 noundef zeroext 0, i8 noundef zeroext 0, i8 noundef zeroext 0, i8 noundef zeroext 0)
  %6 = load %struct.SDL_Renderer*, %struct.SDL_Renderer** @_ZL8Renderer, align 8, !tbaa !5
  %7 = tail call i32 @SDL_RenderClear(%struct.SDL_Renderer* noundef %6)
  %8 = tail call i64 @time(i64* noundef null) #7
  %9 = trunc i64 %8 to i32
  tail call void @srand(i32 noundef %9) #7
  tail call void @_Z3appv()
  %10 = bitcast %union.SDL_Event* %1 to i8*
  call void @llvm.lifetime.start.p0i8(i64 56, i8* nonnull %10) #7
  %11 = getelementptr inbounds %union.SDL_Event, %union.SDL_Event* %1, i64 0, i32 0, i32 0
  br label %12

12:                                               ; preds = %12, %0
  %13 = call i32 @SDL_PollEvent(%union.SDL_Event* noundef nonnull %1)
  %14 = icmp ne i32 %13, 0
  %15 = load i32, i32* %11, align 8
  %16 = icmp eq i32 %15, 256
  %17 = select i1 %14, i1 %16, i1 false
  br i1 %17, label %18, label %12, !llvm.loop !9

18:                                               ; preds = %12
  %19 = load %struct.SDL_Renderer*, %struct.SDL_Renderer** @_ZL8Renderer, align 8, !tbaa !5
  call void @SDL_DestroyRenderer(%struct.SDL_Renderer* noundef %19)
  %20 = load %struct.SDL_Window*, %struct.SDL_Window** @_ZL6Window, align 8, !tbaa !5
  call void @SDL_DestroyWindow(%struct.SDL_Window* noundef %20)
  call void @SDL_Quit()
  call void @llvm.lifetime.end.p0i8(i64 56, i8* nonnull %10) #7
  ret i32 0
}

declare void @_Z3appv() local_unnamed_addr #1

; Function Attrs: mustprogress uwtable
define dso_local void @_Z8simFlushv() local_unnamed_addr #0 {
  tail call void @SDL_PumpEvents()
  %1 = tail call i32 @SDL_HasEvent(i32 noundef 256)
  %2 = icmp eq i32 %1, 1
  br i1 %2, label %3, label %4

3:                                                ; preds = %0
  tail call void @__assert_fail(i8* noundef getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i8* noundef getelementptr inbounds ([47 x i8], [47 x i8]* @.str.2, i64 0, i64 0), i32 noundef 44, i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @__PRETTY_FUNCTION__._Z8simFlushv, i64 0, i64 0)) #8
  unreachable

4:                                                ; preds = %0
  %5 = tail call i32 @SDL_GetTicks()
  %6 = load i32, i32* @_ZL5Ticks, align 4, !tbaa !11
  %7 = sub i32 %5, %6
  %8 = icmp ult i32 %7, 200
  br i1 %8, label %9, label %11

9:                                                ; preds = %4
  %10 = sub nuw nsw i32 200, %7
  tail call void @SDL_Delay(i32 noundef %10)
  br label %11

11:                                               ; preds = %9, %4
  %12 = load %struct.SDL_Renderer*, %struct.SDL_Renderer** @_ZL8Renderer, align 8, !tbaa !5
  tail call void @SDL_RenderPresent(%struct.SDL_Renderer* noundef %12)
  ret void
}

declare void @SDL_PumpEvents() local_unnamed_addr #1

declare i32 @SDL_HasEvent(i32 noundef) local_unnamed_addr #1

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) local_unnamed_addr #5

declare i32 @SDL_GetTicks() local_unnamed_addr #1

declare void @SDL_Delay(i32 noundef) local_unnamed_addr #1

declare void @SDL_RenderPresent(%struct.SDL_Renderer* noundef) local_unnamed_addr #1

; Function Attrs: mustprogress uwtable
define dso_local void @_Z11simPutPixeliii(i32 noundef %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #0 {
  %4 = icmp ult i32 %0, 700
  br i1 %4, label %5, label %7

5:                                                ; preds = %3
  %6 = icmp ult i32 %1, 700
  br i1 %6, label %8, label %21

7:                                                ; preds = %3
  tail call void @__assert_fail(i8* noundef getelementptr inbounds ([43 x i8], [43 x i8]* @.str.4, i64 0, i64 0), i8* noundef getelementptr inbounds ([47 x i8], [47 x i8]* @.str.2, i64 0, i64 0), i32 noundef 54, i8* noundef getelementptr inbounds ([32 x i8], [32 x i8]* @__PRETTY_FUNCTION__._Z11simPutPixeliii, i64 0, i64 0)) #8
  unreachable

8:                                                ; preds = %5
  %9 = lshr i32 %2, 24
  %10 = trunc i32 %9 to i8
  %11 = lshr i32 %2, 16
  %12 = trunc i32 %11 to i8
  %13 = lshr i32 %2, 8
  %14 = trunc i32 %13 to i8
  %15 = trunc i32 %2 to i8
  %16 = load %struct.SDL_Renderer*, %struct.SDL_Renderer** @_ZL8Renderer, align 8, !tbaa !5
  %17 = tail call i32 @SDL_SetRenderDrawColor(%struct.SDL_Renderer* noundef %16, i8 noundef zeroext %12, i8 noundef zeroext %14, i8 noundef zeroext %15, i8 noundef zeroext %10)
  %18 = load %struct.SDL_Renderer*, %struct.SDL_Renderer** @_ZL8Renderer, align 8, !tbaa !5
  %19 = tail call i32 @SDL_RenderDrawPoint(%struct.SDL_Renderer* noundef %18, i32 noundef %0, i32 noundef %1)
  %20 = tail call i32 @SDL_GetTicks()
  store i32 %20, i32* @_ZL5Ticks, align 4, !tbaa !11
  ret void

21:                                               ; preds = %5
  tail call void @__assert_fail(i8* noundef getelementptr inbounds ([43 x i8], [43 x i8]* @.str.5, i64 0, i64 0), i8* noundef getelementptr inbounds ([47 x i8], [47 x i8]* @.str.2, i64 0, i64 0), i32 noundef 55, i8* noundef getelementptr inbounds ([32 x i8], [32 x i8]* @__PRETTY_FUNCTION__._Z11simPutPixeliii, i64 0, i64 0)) #8
  unreachable
}

declare i32 @SDL_RenderDrawPoint(%struct.SDL_Renderer* noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: mustprogress nounwind uwtable
define dso_local noundef i32 @_Z7simRandv() local_unnamed_addr #6 {
  %1 = tail call i32 @rand() #7
  ret i32 %1
}

; Function Attrs: nounwind
declare i32 @rand() local_unnamed_addr #2

attributes #0 = { mustprogress uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { argmemonly mustprogress nofree nosync nounwind willreturn }
attributes #4 = { mustprogress norecurse uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { noreturn nounwind "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { mustprogress nounwind uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #7 = { nounwind }
attributes #8 = { noreturn nounwind }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{!"Ubuntu clang version 14.0.6"}
!5 = !{!6, !6, i64 0}
!6 = !{!"any pointer", !7, i64 0}
!7 = !{!"omnipotent char", !8, i64 0}
!8 = !{!"Simple C++ TBAA"}
!9 = distinct !{!9, !10}
!10 = !{!"llvm.loop.mustprogress"}
!11 = !{!12, !12, i64 0}
!12 = !{!"int", !7, i64 0}
