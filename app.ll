; ModuleID = '/home/karina/Prog/LLVM_course/LifeGame/app.cpp'
source_filename = "/home/karina/Prog/LLVM_course/LifeGame/app.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@grid = dso_local global [700 x [700 x i8]] zeroinitializer, align 16
@nextGrid = dso_local global [700 x [700 x i8]] zeroinitializer, align 16

; Function Attrs: mustprogress noinline optnone uwtable
define dso_local void @_Z14initializeGridv() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  store i32 225, i32* %1, align 4
  br label %3

3:                                                ; preds = %25, %0
  %4 = load i32, i32* %1, align 4
  %5 = icmp slt i32 %4, 450
  br i1 %5, label %6, label %28

6:                                                ; preds = %3
  store i32 225, i32* %2, align 4
  br label %7

7:                                                ; preds = %21, %6
  %8 = load i32, i32* %2, align 4
  %9 = icmp slt i32 %8, 450
  br i1 %9, label %10, label %24

10:                                               ; preds = %7
  %11 = call noundef i32 @_Z7simRandv()
  %12 = srem i32 %11, 2
  %13 = icmp eq i32 %12, 1
  %14 = load i32, i32* %1, align 4
  %15 = sext i32 %14 to i64
  %16 = getelementptr inbounds [700 x [700 x i8]], [700 x [700 x i8]]* @grid, i64 0, i64 %15
  %17 = load i32, i32* %2, align 4
  %18 = sext i32 %17 to i64
  %19 = getelementptr inbounds [700 x i8], [700 x i8]* %16, i64 0, i64 %18
  %20 = zext i1 %13 to i8
  store i8 %20, i8* %19, align 1
  br label %21

21:                                               ; preds = %10
  %22 = load i32, i32* %2, align 4
  %23 = add nsw i32 %22, 1
  store i32 %23, i32* %2, align 4
  br label %7, !llvm.loop !6

24:                                               ; preds = %7
  br label %25

25:                                               ; preds = %24
  %26 = load i32, i32* %1, align 4
  %27 = add nsw i32 %26, 1
  store i32 %27, i32* %1, align 4
  br label %3, !llvm.loop !8

28:                                               ; preds = %3
  ret void
}

declare noundef i32 @_Z7simRandv() #1

; Function Attrs: mustprogress noinline optnone uwtable
define dso_local void @_Z8drawGridv() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  br label %3

3:                                                ; preds = %27, %0
  %4 = load i32, i32* %1, align 4
  %5 = icmp slt i32 %4, 700
  br i1 %5, label %6, label %30

6:                                                ; preds = %3
  store i32 0, i32* %2, align 4
  br label %7

7:                                                ; preds = %23, %6
  %8 = load i32, i32* %2, align 4
  %9 = icmp slt i32 %8, 700
  br i1 %9, label %10, label %26

10:                                               ; preds = %7
  %11 = load i32, i32* %1, align 4
  %12 = sext i32 %11 to i64
  %13 = getelementptr inbounds [700 x [700 x i8]], [700 x [700 x i8]]* @grid, i64 0, i64 %12
  %14 = load i32, i32* %2, align 4
  %15 = sext i32 %14 to i64
  %16 = getelementptr inbounds [700 x i8], [700 x i8]* %13, i64 0, i64 %15
  %17 = load i8, i8* %16, align 1
  %18 = trunc i8 %17 to i1
  br i1 %18, label %19, label %22

19:                                               ; preds = %10
  %20 = load i32, i32* %1, align 4
  %21 = load i32, i32* %2, align 4
  call void @_Z11simPutPixeliii(i32 noundef %20, i32 noundef %21, i32 noundef -65536)
  br label %22

22:                                               ; preds = %19, %10
  br label %23

23:                                               ; preds = %22
  %24 = load i32, i32* %2, align 4
  %25 = add nsw i32 %24, 1
  store i32 %25, i32* %2, align 4
  br label %7, !llvm.loop !9

26:                                               ; preds = %7
  br label %27

27:                                               ; preds = %26
  %28 = load i32, i32* %1, align 4
  %29 = add nsw i32 %28, 1
  store i32 %29, i32* %1, align 4
  br label %3, !llvm.loop !10

30:                                               ; preds = %3
  call void @_Z8simFlushv()
  ret void
}

declare void @_Z11simPutPixeliii(i32 noundef, i32 noundef, i32 noundef) #1

declare void @_Z8simFlushv() #1

; Function Attrs: mustprogress noinline optnone uwtable
define dso_local void @_Z3appv() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  call void @_Z14initializeGridv()
  store i32 0, i32* %1, align 4
  br label %11

11:                                               ; preds = %149, %0
  %12 = load i32, i32* %1, align 4
  %13 = icmp slt i32 %12, 1000
  br i1 %13, label %14, label %152

14:                                               ; preds = %11
  store i32 0, i32* %2, align 4
  br label %15

15:                                               ; preds = %114, %14
  %16 = load i32, i32* %2, align 4
  %17 = icmp slt i32 %16, 700
  br i1 %17, label %18, label %117

18:                                               ; preds = %15
  store i32 0, i32* %3, align 4
  br label %19

19:                                               ; preds = %110, %18
  %20 = load i32, i32* %3, align 4
  %21 = icmp slt i32 %20, 700
  br i1 %21, label %22, label %113

22:                                               ; preds = %19
  store i32 0, i32* %4, align 4
  store i32 -1, i32* %5, align 4
  br label %23

23:                                               ; preds = %72, %22
  %24 = load i32, i32* %5, align 4
  %25 = icmp sle i32 %24, 1
  br i1 %25, label %26, label %75

26:                                               ; preds = %23
  store i32 -1, i32* %6, align 4
  br label %27

27:                                               ; preds = %68, %26
  %28 = load i32, i32* %6, align 4
  %29 = icmp sle i32 %28, 1
  br i1 %29, label %30, label %71

30:                                               ; preds = %27
  %31 = load i32, i32* %5, align 4
  %32 = icmp eq i32 %31, 0
  br i1 %32, label %33, label %37

33:                                               ; preds = %30
  %34 = load i32, i32* %6, align 4
  %35 = icmp eq i32 %34, 0
  br i1 %35, label %36, label %37

36:                                               ; preds = %33
  br label %68

37:                                               ; preds = %33, %30
  %38 = load i32, i32* %2, align 4
  %39 = load i32, i32* %5, align 4
  %40 = add nsw i32 %38, %39
  store i32 %40, i32* %7, align 4
  %41 = load i32, i32* %3, align 4
  %42 = load i32, i32* %6, align 4
  %43 = add nsw i32 %41, %42
  store i32 %43, i32* %8, align 4
  %44 = load i32, i32* %7, align 4
  %45 = icmp sge i32 %44, 0
  br i1 %45, label %46, label %67

46:                                               ; preds = %37
  %47 = load i32, i32* %7, align 4
  %48 = icmp slt i32 %47, 700
  br i1 %48, label %49, label %67

49:                                               ; preds = %46
  %50 = load i32, i32* %8, align 4
  %51 = icmp sge i32 %50, 0
  br i1 %51, label %52, label %67

52:                                               ; preds = %49
  %53 = load i32, i32* %8, align 4
  %54 = icmp slt i32 %53, 700
  br i1 %54, label %55, label %67

55:                                               ; preds = %52
  %56 = load i32, i32* %7, align 4
  %57 = sext i32 %56 to i64
  %58 = getelementptr inbounds [700 x [700 x i8]], [700 x [700 x i8]]* @grid, i64 0, i64 %57
  %59 = load i32, i32* %8, align 4
  %60 = sext i32 %59 to i64
  %61 = getelementptr inbounds [700 x i8], [700 x i8]* %58, i64 0, i64 %60
  %62 = load i8, i8* %61, align 1
  %63 = trunc i8 %62 to i1
  br i1 %63, label %64, label %67

64:                                               ; preds = %55
  %65 = load i32, i32* %4, align 4
  %66 = add nsw i32 %65, 1
  store i32 %66, i32* %4, align 4
  br label %67

67:                                               ; preds = %64, %55, %52, %49, %46, %37
  br label %68

68:                                               ; preds = %67, %36
  %69 = load i32, i32* %6, align 4
  %70 = add nsw i32 %69, 1
  store i32 %70, i32* %6, align 4
  br label %27, !llvm.loop !11

71:                                               ; preds = %27
  br label %72

72:                                               ; preds = %71
  %73 = load i32, i32* %5, align 4
  %74 = add nsw i32 %73, 1
  store i32 %74, i32* %5, align 4
  br label %23, !llvm.loop !12

75:                                               ; preds = %23
  %76 = load i32, i32* %2, align 4
  %77 = sext i32 %76 to i64
  %78 = getelementptr inbounds [700 x [700 x i8]], [700 x [700 x i8]]* @grid, i64 0, i64 %77
  %79 = load i32, i32* %3, align 4
  %80 = sext i32 %79 to i64
  %81 = getelementptr inbounds [700 x i8], [700 x i8]* %78, i64 0, i64 %80
  %82 = load i8, i8* %81, align 1
  %83 = trunc i8 %82 to i1
  br i1 %83, label %84, label %99

84:                                               ; preds = %75
  %85 = load i32, i32* %4, align 4
  %86 = icmp eq i32 %85, 2
  br i1 %86, label %90, label %87

87:                                               ; preds = %84
  %88 = load i32, i32* %4, align 4
  %89 = icmp eq i32 %88, 3
  br label %90

90:                                               ; preds = %87, %84
  %91 = phi i1 [ true, %84 ], [ %89, %87 ]
  %92 = load i32, i32* %2, align 4
  %93 = sext i32 %92 to i64
  %94 = getelementptr inbounds [700 x [700 x i8]], [700 x [700 x i8]]* @nextGrid, i64 0, i64 %93
  %95 = load i32, i32* %3, align 4
  %96 = sext i32 %95 to i64
  %97 = getelementptr inbounds [700 x i8], [700 x i8]* %94, i64 0, i64 %96
  %98 = zext i1 %91 to i8
  store i8 %98, i8* %97, align 1
  br label %109

99:                                               ; preds = %75
  %100 = load i32, i32* %4, align 4
  %101 = icmp eq i32 %100, 3
  %102 = load i32, i32* %2, align 4
  %103 = sext i32 %102 to i64
  %104 = getelementptr inbounds [700 x [700 x i8]], [700 x [700 x i8]]* @nextGrid, i64 0, i64 %103
  %105 = load i32, i32* %3, align 4
  %106 = sext i32 %105 to i64
  %107 = getelementptr inbounds [700 x i8], [700 x i8]* %104, i64 0, i64 %106
  %108 = zext i1 %101 to i8
  store i8 %108, i8* %107, align 1
  br label %109

109:                                              ; preds = %99, %90
  br label %110

110:                                              ; preds = %109
  %111 = load i32, i32* %3, align 4
  %112 = add nsw i32 %111, 1
  store i32 %112, i32* %3, align 4
  br label %19, !llvm.loop !13

113:                                              ; preds = %19
  br label %114

114:                                              ; preds = %113
  %115 = load i32, i32* %2, align 4
  %116 = add nsw i32 %115, 1
  store i32 %116, i32* %2, align 4
  br label %15, !llvm.loop !14

117:                                              ; preds = %15
  store i32 0, i32* %9, align 4
  br label %118

118:                                              ; preds = %145, %117
  %119 = load i32, i32* %9, align 4
  %120 = icmp slt i32 %119, 700
  br i1 %120, label %121, label %148

121:                                              ; preds = %118
  store i32 0, i32* %10, align 4
  br label %122

122:                                              ; preds = %141, %121
  %123 = load i32, i32* %10, align 4
  %124 = icmp slt i32 %123, 700
  br i1 %124, label %125, label %144

125:                                              ; preds = %122
  %126 = load i32, i32* %9, align 4
  %127 = sext i32 %126 to i64
  %128 = getelementptr inbounds [700 x [700 x i8]], [700 x [700 x i8]]* @nextGrid, i64 0, i64 %127
  %129 = load i32, i32* %10, align 4
  %130 = sext i32 %129 to i64
  %131 = getelementptr inbounds [700 x i8], [700 x i8]* %128, i64 0, i64 %130
  %132 = load i8, i8* %131, align 1
  %133 = trunc i8 %132 to i1
  %134 = load i32, i32* %9, align 4
  %135 = sext i32 %134 to i64
  %136 = getelementptr inbounds [700 x [700 x i8]], [700 x [700 x i8]]* @grid, i64 0, i64 %135
  %137 = load i32, i32* %10, align 4
  %138 = sext i32 %137 to i64
  %139 = getelementptr inbounds [700 x i8], [700 x i8]* %136, i64 0, i64 %138
  %140 = zext i1 %133 to i8
  store i8 %140, i8* %139, align 1
  br label %141

141:                                              ; preds = %125
  %142 = load i32, i32* %10, align 4
  %143 = add nsw i32 %142, 1
  store i32 %143, i32* %10, align 4
  br label %122, !llvm.loop !15

144:                                              ; preds = %122
  br label %145

145:                                              ; preds = %144
  %146 = load i32, i32* %9, align 4
  %147 = add nsw i32 %146, 1
  store i32 %147, i32* %9, align 4
  br label %118, !llvm.loop !16

148:                                              ; preds = %118
  call void @_Z8drawGridv()
  br label %149

149:                                              ; preds = %148
  %150 = load i32, i32* %1, align 4
  %151 = add nsw i32 %150, 1
  store i32 %151, i32* %1, align 4
  br label %11, !llvm.loop !17

152:                                              ; preds = %11
  ret void
}

attributes #0 = { mustprogress noinline optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

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
!8 = distinct !{!8, !7}
!9 = distinct !{!9, !7}
!10 = distinct !{!10, !7}
!11 = distinct !{!11, !7}
!12 = distinct !{!12, !7}
!13 = distinct !{!13, !7}
!14 = distinct !{!14, !7}
!15 = distinct !{!15, !7}
!16 = distinct !{!16, !7}
!17 = distinct !{!17, !7}
