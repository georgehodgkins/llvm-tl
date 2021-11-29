; ModuleID = 'lock.cpp'
source_filename = "lock.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { %struct.__pthread_internal_list*, %struct.__pthread_internal_list* }
%union.pthread_mutexattr_t = type { i32 }

@lock = dso_local global %union.pthread_mutex_t zeroinitializer, align 8
@x = dso_local global i32 0, align 4

; Function Attrs: mustprogress noinline norecurse nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  store i32 0, i32* %retval, align 4
  store i32 %argc, i32* %argc.addr, align 4
  store i8** %argv, i8*** %argv.addr, align 8
  %call = call i32 @pthread_mutex_init(%union.pthread_mutex_t* @lock, %union.pthread_mutexattr_t* null) #2
  %call1 = call i32 @pthread_mutex_lock(%union.pthread_mutex_t* @lock) #2
  %0 = load i32, i32* %argc.addr, align 4
  %cmp = icmp eq i32 %0, 0
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  store i32 2, i32* @x, align 4
  %call2 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* @lock) #2
  store i32 0, i32* %retval, align 4
  br label %if.end10

if.end:                                           ; preds = %entry
  %1 = load i32, i32* %argc.addr, align 4
  %cmp3 = icmp slt i32 %1, 0
  br i1 %cmp3, label %if.then4, label %if.end6

if.then4:                                         ; preds = %if.end
  store i32 -5, i32* @x, align 4
  %call5 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* @lock) #2
  store i32 0, i32* %retval, align 4
  br label %if.end10

if.end6:                                          ; preds = %if.end
  %2 = load i32, i32* %argc.addr, align 4
  %cmp7 = icmp sgt i32 %2, 0
  br i1 %cmp7, label %if.then8, label %if.end10

if.then8:                                         ; preds = %if.end6
  store i32 27, i32* @x, align 4
  %call9 = call i32 @pthread_mutex_unlock(%union.pthread_mutex_t* @lock) #2
  store i32 0, i32* %retval, align 4
  br label %if.end10

if.end10:                                         ; preds = %if.then, %if.then4, %if.then8, %if.end6
  %3 = load i32, i32* %retval, align 4
  ret i32 %3
}

; Function Attrs: nounwind
declare dso_local i32 @pthread_mutex_init(%union.pthread_mutex_t*, %union.pthread_mutexattr_t*) #1

; Function Attrs: nounwind
declare dso_local i32 @pthread_mutex_lock(%union.pthread_mutex_t*) #1

; Function Attrs: nounwind
declare dso_local i32 @pthread_mutex_unlock(%union.pthread_mutex_t*) #1

attributes #0 = { mustprogress noinline norecurse nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"uwtable", i32 1}
!2 = !{i32 7, !"frame-pointer", i32 2}
!3 = !{!"clang version 14.0.0 (https://github.com/llvm/llvm-project 4732dd301086ce056d869eded4e1543fcb45506d)"}
