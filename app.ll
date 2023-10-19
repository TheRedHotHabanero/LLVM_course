; ModuleID = '/home/karina/Prog/LLVM_course/LifeGame/app.cpp'
source_filename = "/home/karina/Prog/LLVM_course/LifeGame/app.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@grid = dso_local local_unnamed_addr global [700 x [700 x i8]] zeroinitializer, align 16
@nextGrid = dso_local local_unnamed_addr global [700 x [700 x i8]] zeroinitializer, align 16

; Function Attrs: mustprogress uwtable
define dso_local void @_Z14initializeGridv() local_unnamed_addr #0 {
  br label %1

1:                                                ; preds = %0, %4
  %2 = phi i64 [ 225, %0 ], [ %5, %4 ]
  br label %7

3:                                                ; preds = %4
  ret void

4:                                                ; preds = %7
  %5 = add nuw nsw i64 %2, 1
  %6 = icmp eq i64 %5, 450
  br i1 %6, label %3, label %1, !llvm.loop !5

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

declare noundef i32 @_Z7simRandv() local_unnamed_addr #1

; Function Attrs: mustprogress uwtable
define dso_local void @_Z8drawGridv() local_unnamed_addr #0 {
  br label %1

1:                                                ; preds = %0, %5
  %2 = phi i64 [ 0, %0 ], [ %6, %5 ]
  %3 = trunc i64 %2 to i32
  br label %8

4:                                                ; preds = %5
  tail call void @_Z8simFlushv()
  ret void

5:                                                ; preds = %15
  %6 = add nuw nsw i64 %2, 1
  %7 = icmp eq i64 %6, 700
  br i1 %7, label %4, label %1, !llvm.loop !12

8:                                                ; preds = %1, %15
  %9 = phi i64 [ 0, %1 ], [ %16, %15 ]
  %10 = getelementptr inbounds [700 x [700 x i8]], [700 x [700 x i8]]* @grid, i64 0, i64 %2, i64 %9
  %11 = load i8, i8* %10, align 1, !tbaa !7, !range !13
  %12 = icmp eq i8 %11, 0
  br i1 %12, label %15, label %13

13:                                               ; preds = %8
  %14 = trunc i64 %9 to i32
  tail call void @_Z11simPutPixeliii(i32 noundef %3, i32 noundef %14, i32 noundef -65536)
  br label %15

15:                                               ; preds = %8, %13
  %16 = add nuw nsw i64 %9, 1
  %17 = icmp eq i64 %16, 700
  br i1 %17, label %5, label %8, !llvm.loop !14
}

declare void @_Z11simPutPixeliii(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

declare void @_Z8simFlushv() local_unnamed_addr #1

; Function Attrs: mustprogress uwtable
define dso_local void @_Z3appv() local_unnamed_addr #0 {
  br label %1

1:                                                ; preds = %3, %0
  %2 = phi i64 [ 225, %0 ], [ %4, %3 ]
  br label %6

3:                                                ; preds = %6
  %4 = add nuw nsw i64 %2, 1
  %5 = icmp eq i64 %4, 450
  br i1 %5, label %15, label %1, !llvm.loop !5

6:                                                ; preds = %6, %1
  %7 = phi i64 [ 225, %1 ], [ %13, %6 ]
  %8 = tail call noundef i32 @_Z7simRandv()
  %9 = srem i32 %8, 2
  %10 = icmp eq i32 %9, 1
  %11 = getelementptr inbounds [700 x [700 x i8]], [700 x [700 x i8]]* @grid, i64 0, i64 %2, i64 %7
  %12 = zext i1 %10 to i8
  store i8 %12, i8* %11, align 1, !tbaa !7
  %13 = add nuw nsw i64 %7, 1
  %14 = icmp eq i64 %13, 450
  br i1 %14, label %3, label %6, !llvm.loop !11

15:                                               ; preds = %3, %151
  %16 = phi i32 [ %152, %151 ], [ 0, %3 ]
  br label %18

17:                                               ; preds = %151
  ret void

18:                                               ; preds = %15, %59
  %19 = phi i64 [ 0, %15 ], [ %24, %59 ]
  %20 = trunc i64 %19 to i32
  %21 = add i32 %20, -1
  %22 = icmp ult i32 %21, 700
  %23 = zext i32 %21 to i64
  %24 = add nuw nsw i64 %19, 1
  %25 = icmp ult i64 %19, 699
  br i1 %22, label %26, label %32

26:                                               ; preds = %18
  %27 = getelementptr inbounds [700 x [700 x i8]], [700 x [700 x i8]]* @grid, i64 0, i64 %23, i64 0
  %28 = load i8, i8* %27, align 4, !tbaa !7, !range !13
  %29 = getelementptr inbounds [700 x [700 x i8]], [700 x [700 x i8]]* @grid, i64 0, i64 %23, i64 1
  %30 = load i8, i8* %29, align 1, !tbaa !7, !range !13
  %31 = add nuw nsw i8 %28, %30
  br label %32

32:                                               ; preds = %26, %18
  %33 = phi i8 [ %31, %26 ], [ 0, %18 ]
  %34 = zext i8 %33 to i32
  %35 = getelementptr inbounds [700 x [700 x i8]], [700 x [700 x i8]]* @grid, i64 0, i64 %19, i64 1
  %36 = load i8, i8* %35, align 1, !tbaa !7, !range !13
  %37 = zext i8 %36 to i32
  %38 = add nuw nsw i32 %34, %37
  br i1 %25, label %39, label %48

39:                                               ; preds = %32
  %40 = getelementptr inbounds [700 x [700 x i8]], [700 x [700 x i8]]* @grid, i64 0, i64 %24, i64 0
  %41 = load i8, i8* %40, align 4, !tbaa !7, !range !13
  %42 = zext i8 %41 to i32
  %43 = add nuw nsw i32 %38, %42
  %44 = getelementptr inbounds [700 x [700 x i8]], [700 x [700 x i8]]* @grid, i64 0, i64 %24, i64 1
  %45 = load i8, i8* %44, align 1, !tbaa !7, !range !13
  %46 = zext i8 %45 to i32
  %47 = add nuw nsw i32 %43, %46
  br label %48

48:                                               ; preds = %39, %32
  %49 = phi i32 [ %47, %39 ], [ %38, %32 ]
  %50 = getelementptr inbounds [700 x [700 x i8]], [700 x [700 x i8]]* @grid, i64 0, i64 %19, i64 0
  %51 = load i8, i8* %50, align 4, !tbaa !7, !range !13
  %52 = icmp eq i8 %51, 0
  %53 = icmp eq i32 %49, 3
  %54 = and i32 %49, -2
  %55 = icmp eq i32 %54, 2
  %56 = select i1 %52, i1 %53, i1 %55
  %57 = zext i1 %56 to i8
  %58 = getelementptr inbounds [700 x [700 x i8]], [700 x [700 x i8]]* @nextGrid, i64 0, i64 %19, i64 0
  store i8 %57, i8* %58, align 4
  br label %62

59:                                               ; preds = %122
  %60 = icmp eq i64 %24, 700
  br i1 %60, label %61, label %18, !llvm.loop !15

61:                                               ; preds = %59
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(490000) getelementptr inbounds ([700 x [700 x i8]], [700 x [700 x i8]]* @grid, i64 0, i64 0, i64 0), i8* noundef nonnull align 16 dereferenceable(490000) getelementptr inbounds ([700 x [700 x i8]], [700 x [700 x i8]]* @nextGrid, i64 0, i64 0, i64 0), i64 490000, i1 false), !tbaa !7
  br label %135

62:                                               ; preds = %122, %48
  %63 = phi i64 [ 1, %48 ], [ %133, %122 ]
  br i1 %22, label %64, label %70

64:                                               ; preds = %62
  %65 = add nuw nsw i64 %63, 4294967295
  %66 = and i64 %65, 4294967295
  %67 = getelementptr inbounds [700 x [700 x i8]], [700 x [700 x i8]]* @grid, i64 0, i64 %23, i64 %66
  %68 = load i8, i8* %67, align 1, !tbaa !7, !range !13
  %69 = zext i8 %68 to i32
  br label %70

70:                                               ; preds = %62, %64
  %71 = phi i32 [ 0, %62 ], [ %69, %64 ]
  br i1 %22, label %72, label %84

72:                                               ; preds = %70
  %73 = getelementptr inbounds [700 x [700 x i8]], [700 x [700 x i8]]* @grid, i64 0, i64 %23, i64 %63
  %74 = load i8, i8* %73, align 1, !tbaa !7, !range !13
  %75 = zext i8 %74 to i32
  %76 = add nuw nsw i32 %71, %75
  %77 = icmp ult i64 %63, 699
  br i1 %77, label %78, label %84

78:                                               ; preds = %72
  %79 = add nuw nsw i64 %63, 1
  %80 = getelementptr inbounds [700 x [700 x i8]], [700 x [700 x i8]]* @grid, i64 0, i64 %23, i64 %79
  %81 = load i8, i8* %80, align 1, !tbaa !7, !range !13
  %82 = zext i8 %81 to i32
  %83 = add nuw nsw i32 %76, %82
  br label %84

84:                                               ; preds = %78, %72, %70
  %85 = phi i32 [ %76, %72 ], [ %83, %78 ], [ %71, %70 ]
  %86 = add nuw nsw i64 %63, 4294967295
  %87 = and i64 %86, 4294967295
  %88 = getelementptr inbounds [700 x [700 x i8]], [700 x [700 x i8]]* @grid, i64 0, i64 %19, i64 %87
  %89 = load i8, i8* %88, align 1, !tbaa !7, !range !13
  %90 = zext i8 %89 to i32
  %91 = add nuw nsw i32 %85, %90
  %92 = icmp ult i64 %63, 699
  br i1 %92, label %93, label %99

93:                                               ; preds = %84
  %94 = add nuw nsw i64 %63, 1
  %95 = getelementptr inbounds [700 x [700 x i8]], [700 x [700 x i8]]* @grid, i64 0, i64 %19, i64 %94
  %96 = load i8, i8* %95, align 1, !tbaa !7, !range !13
  %97 = zext i8 %96 to i32
  %98 = add nuw nsw i32 %91, %97
  br label %99

99:                                               ; preds = %84, %93
  %100 = phi i32 [ %91, %84 ], [ %98, %93 ]
  br i1 %25, label %101, label %108

101:                                              ; preds = %99
  %102 = add nuw nsw i64 %63, 4294967295
  %103 = and i64 %102, 4294967295
  %104 = getelementptr inbounds [700 x [700 x i8]], [700 x [700 x i8]]* @grid, i64 0, i64 %24, i64 %103
  %105 = load i8, i8* %104, align 1, !tbaa !7, !range !13
  %106 = zext i8 %105 to i32
  %107 = add nuw nsw i32 %100, %106
  br label %108

108:                                              ; preds = %99, %101
  %109 = phi i32 [ %100, %99 ], [ %107, %101 ]
  br i1 %25, label %110, label %122

110:                                              ; preds = %108
  %111 = getelementptr inbounds [700 x [700 x i8]], [700 x [700 x i8]]* @grid, i64 0, i64 %24, i64 %63
  %112 = load i8, i8* %111, align 1, !tbaa !7, !range !13
  %113 = zext i8 %112 to i32
  %114 = add nuw nsw i32 %109, %113
  %115 = icmp ult i64 %63, 699
  br i1 %115, label %116, label %122

116:                                              ; preds = %110
  %117 = add nuw nsw i64 %63, 1
  %118 = getelementptr inbounds [700 x [700 x i8]], [700 x [700 x i8]]* @grid, i64 0, i64 %24, i64 %117
  %119 = load i8, i8* %118, align 1, !tbaa !7, !range !13
  %120 = zext i8 %119 to i32
  %121 = add nuw nsw i32 %114, %120
  br label %122

122:                                              ; preds = %108, %116, %110
  %123 = phi i32 [ %114, %110 ], [ %121, %116 ], [ %109, %108 ]
  %124 = getelementptr inbounds [700 x [700 x i8]], [700 x [700 x i8]]* @grid, i64 0, i64 %19, i64 %63
  %125 = load i8, i8* %124, align 1, !tbaa !7, !range !13
  %126 = icmp eq i8 %125, 0
  %127 = icmp eq i32 %123, 3
  %128 = and i32 %123, -2
  %129 = icmp eq i32 %128, 2
  %130 = select i1 %126, i1 %127, i1 %129
  %131 = zext i1 %130 to i8
  %132 = getelementptr inbounds [700 x [700 x i8]], [700 x [700 x i8]]* @nextGrid, i64 0, i64 %19, i64 %63
  store i8 %131, i8* %132, align 1
  %133 = add nuw nsw i64 %63, 1
  %134 = icmp eq i64 %133, 700
  br i1 %134, label %59, label %62, !llvm.loop !16

135:                                              ; preds = %61, %138
  %136 = phi i64 [ %139, %138 ], [ 0, %61 ]
  %137 = trunc i64 %136 to i32
  br label %141

138:                                              ; preds = %148
  %139 = add nuw nsw i64 %136, 1
  %140 = icmp eq i64 %139, 700
  br i1 %140, label %151, label %135, !llvm.loop !12

141:                                              ; preds = %148, %135
  %142 = phi i64 [ 0, %135 ], [ %149, %148 ]
  %143 = getelementptr inbounds [700 x [700 x i8]], [700 x [700 x i8]]* @grid, i64 0, i64 %136, i64 %142
  %144 = load i8, i8* %143, align 1, !tbaa !7, !range !13
  %145 = icmp eq i8 %144, 0
  br i1 %145, label %148, label %146

146:                                              ; preds = %141
  %147 = trunc i64 %142 to i32
  tail call void @_Z11simPutPixeliii(i32 noundef %137, i32 noundef %147, i32 noundef -65536)
  br label %148

148:                                              ; preds = %146, %141
  %149 = add nuw nsw i64 %142, 1
  %150 = icmp eq i64 %149, 700
  br i1 %150, label %138, label %141, !llvm.loop !14

151:                                              ; preds = %138
  tail call void @_Z8simFlushv()
  %152 = add nuw nsw i32 %16, 1
  %153 = icmp eq i32 %152, 1000
  br i1 %153, label %17, label %15, !llvm.loop !18
}

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #2

attributes #0 = { mustprogress uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { argmemonly nofree nounwind willreturn }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{!"Ubuntu clang version 14.0.6"}
!5 = distinct !{!5, !6}
!6 = !{!"llvm.loop.mustprogress"}
!7 = !{!8, !8, i64 0}
!8 = !{!"bool", !9, i64 0}
!9 = !{!"omnipotent char", !10, i64 0}
!10 = !{!"Simple C++ TBAA"}
!11 = distinct !{!11, !6}
!12 = distinct !{!12, !6}
!13 = !{i8 0, i8 2}
!14 = distinct !{!14, !6}
!15 = distinct !{!15, !6}
!16 = distinct !{!16, !6, !17}
!17 = !{!"llvm.loop.peeled.count", i32 1}
!18 = distinct !{!18, !6}
