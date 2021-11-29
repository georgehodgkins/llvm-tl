; ModuleID = 'test.cpp'
source_filename = "test.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%"struct.std::__atomic_base" = type { i32 }
%"struct.std::atomic" = type { %"struct.std::__atomic_base" }

$_ZSt23__cmpexch_failure_orderSt12memory_order = comdat any

$_ZStanSt12memory_orderSt23__memory_order_modifier = comdat any

$__clang_call_terminate = comdat any

$_ZStorSt12memory_orderSt23__memory_order_modifier = comdat any

$_ZSt24__cmpexch_failure_order2St12memory_order = comdat any

@g = dso_local global i32 0, align 4

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define dso_local i32 @_Z7notmainRi(i32* nonnull align 4 dereferenceable(4) %y) #0 {
entry:
  %y.addr = alloca i32*, align 8
  store i32* %y, i32** %y.addr, align 8
  %0 = load i32*, i32** %y.addr, align 8
  %1 = load i32, i32* %0, align 4
  %inc = add nsw i32 %1, 1
  store i32 %inc, i32* %0, align 4
  %2 = load i32*, i32** %y.addr, align 8
  %3 = load i32, i32* %2, align 4
  store i32 %3, i32* @g, align 4
  %4 = load i32, i32* @g, align 4
  ret i32 %4
}

; Function Attrs: mustprogress noinline norecurse nounwind optnone uwtable
define dso_local i32 @main() #1 personality i32 (...)* @__gxx_personality_v0 {
entry:
  %this.addr.i6 = alloca %"struct.std::__atomic_base"*, align 8
  %__i1.addr.i7 = alloca i32*, align 8
  %__i2.addr.i8 = alloca i32, align 4
  %__m1.addr.i = alloca i32, align 4
  %__m2.addr.i = alloca i32, align 4
  %__b2.i = alloca i32, align 4
  %__b1.i = alloca i32, align 4
  %.atomictmp.i9 = alloca i32, align 4
  %cmpxchg.bool.i = alloca i8, align 1
  %this.addr.i3 = alloca %"struct.std::__atomic_base"*, align 8
  %__i1.addr.i = alloca i32*, align 8
  %__i2.addr.i = alloca i32, align 4
  %__m.addr.i4 = alloca i32, align 4
  %this.addr.i = alloca %"struct.std::__atomic_base"*, align 8
  %__i.addr.i = alloca i32, align 4
  %__m.addr.i = alloca i32, align 4
  %.atomictmp.i = alloca i32, align 4
  %atomic-temp.i = alloca i32, align 4
  %x = alloca %"struct.std::atomic", align 4
  %y = alloca i32, align 4
  %0 = bitcast %"struct.std::atomic"* %x to i8*
  call void @llvm.memset.p0i8.i64(i8* align 4 %0, i8 0, i64 4, i1 false)
  %1 = bitcast %"struct.std::atomic"* %x to %"struct.std::__atomic_base"*
  store %"struct.std::__atomic_base"* %1, %"struct.std::__atomic_base"** %this.addr.i, align 8
  store i32 1, i32* %__i.addr.i, align 4
  store i32 5, i32* %__m.addr.i, align 4
  %this1.i = load %"struct.std::__atomic_base"*, %"struct.std::__atomic_base"** %this.addr.i, align 8
  %_M_i.i = getelementptr inbounds %"struct.std::__atomic_base", %"struct.std::__atomic_base"* %this1.i, i32 0, i32 0
  %2 = load i32, i32* %__m.addr.i, align 4
  %3 = load i32, i32* %__i.addr.i, align 4
  store i32 %3, i32* %.atomictmp.i, align 4
  switch i32 %2, label %monotonic.i [
    i32 1, label %acquire.i
    i32 2, label %acquire.i
    i32 3, label %release.i
    i32 4, label %acqrel.i
    i32 5, label %seqcst.i
  ]

monotonic.i:                                      ; preds = %entry
  %4 = load i32, i32* %.atomictmp.i, align 4
  %5 = atomicrmw add i32* %_M_i.i, i32 %4 monotonic, align 4
  store i32 %5, i32* %atomic-temp.i, align 4
  br label %_ZNSt13__atomic_baseIiE9fetch_addEiSt12memory_order.exit

acquire.i:                                        ; preds = %entry, %entry
  %6 = load i32, i32* %.atomictmp.i, align 4
  %7 = atomicrmw add i32* %_M_i.i, i32 %6 acquire, align 4
  store i32 %7, i32* %atomic-temp.i, align 4
  br label %_ZNSt13__atomic_baseIiE9fetch_addEiSt12memory_order.exit

release.i:                                        ; preds = %entry
  %8 = load i32, i32* %.atomictmp.i, align 4
  %9 = atomicrmw add i32* %_M_i.i, i32 %8 release, align 4
  store i32 %9, i32* %atomic-temp.i, align 4
  br label %_ZNSt13__atomic_baseIiE9fetch_addEiSt12memory_order.exit

acqrel.i:                                         ; preds = %entry
  %10 = load i32, i32* %.atomictmp.i, align 4
  %11 = atomicrmw add i32* %_M_i.i, i32 %10 acq_rel, align 4
  store i32 %11, i32* %atomic-temp.i, align 4
  br label %_ZNSt13__atomic_baseIiE9fetch_addEiSt12memory_order.exit

seqcst.i:                                         ; preds = %entry
  %12 = load i32, i32* %.atomictmp.i, align 4
  %13 = atomicrmw add i32* %_M_i.i, i32 %12 seq_cst, align 4
  store i32 %13, i32* %atomic-temp.i, align 4
  br label %_ZNSt13__atomic_baseIiE9fetch_addEiSt12memory_order.exit

_ZNSt13__atomic_baseIiE9fetch_addEiSt12memory_order.exit: ; preds = %monotonic.i, %acquire.i, %release.i, %acqrel.i, %seqcst.i
  %14 = load i32, i32* %atomic-temp.i, align 4
  store i32 %14, i32* %y, align 4
  %call1 = call i32 @_Z7notmainRi(i32* nonnull align 4 dereferenceable(4) %y)
  store i32 %call1, i32* %y, align 4
  %15 = bitcast %"struct.std::atomic"* %x to %"struct.std::__atomic_base"*
  store %"struct.std::__atomic_base"* %15, %"struct.std::__atomic_base"** %this.addr.i3, align 8
  store i32* %y, i32** %__i1.addr.i, align 8
  store i32 2, i32* %__i2.addr.i, align 4
  store i32 5, i32* %__m.addr.i4, align 4
  %this1.i5 = load %"struct.std::__atomic_base"*, %"struct.std::__atomic_base"** %this.addr.i3, align 8
  %16 = load i32*, i32** %__i1.addr.i, align 8
  %17 = load i32, i32* %__i2.addr.i, align 4
  %18 = load i32, i32* %__m.addr.i4, align 4
  %19 = load i32, i32* %__m.addr.i4, align 4
  %call.i = call i32 @_ZSt23__cmpexch_failure_orderSt12memory_order(i32 %19) #4
  store %"struct.std::__atomic_base"* %this1.i5, %"struct.std::__atomic_base"** %this.addr.i6, align 8
  store i32* %16, i32** %__i1.addr.i7, align 8
  store i32 %17, i32* %__i2.addr.i8, align 4
  store i32 %18, i32* %__m1.addr.i, align 4
  store i32 %call.i, i32* %__m2.addr.i, align 4
  %this1.i10 = load %"struct.std::__atomic_base"*, %"struct.std::__atomic_base"** %this.addr.i6, align 8
  %20 = load i32, i32* %__m2.addr.i, align 4
  %call.i11 = invoke i32 @_ZStanSt12memory_orderSt23__memory_order_modifier(i32 %20, i32 65535)
          to label %invoke.cont.i unwind label %terminate.lpad.i

invoke.cont.i:                                    ; preds = %_ZNSt13__atomic_baseIiE9fetch_addEiSt12memory_order.exit
  store i32 %call.i11, i32* %__b2.i, align 4
  %21 = load i32, i32* %__m1.addr.i, align 4
  %call3.i = invoke i32 @_ZStanSt12memory_orderSt23__memory_order_modifier(i32 %21, i32 65535)
          to label %invoke.cont2.i unwind label %terminate.lpad.i

invoke.cont2.i:                                   ; preds = %invoke.cont.i
  store i32 %call3.i, i32* %__b1.i, align 4
  %_M_i.i12 = getelementptr inbounds %"struct.std::__atomic_base", %"struct.std::__atomic_base"* %this1.i10, i32 0, i32 0
  %22 = load i32, i32* %__m1.addr.i, align 4
  %23 = load i32*, i32** %__i1.addr.i7, align 8
  %24 = load i32, i32* %__i2.addr.i8, align 4
  store i32 %24, i32* %.atomictmp.i9, align 4
  %25 = load i32, i32* %__m2.addr.i, align 4
  switch i32 %22, label %monotonic.i13 [
    i32 1, label %acquire.i14
    i32 2, label %acquire.i14
    i32 3, label %release.i15
    i32 4, label %acqrel.i16
    i32 5, label %seqcst.i17
  ]

monotonic.i13:                                    ; preds = %invoke.cont2.i
  switch i32 %25, label %monotonic_fail.i [
    i32 1, label %acquire_fail.i
    i32 2, label %acquire_fail.i
    i32 5, label %seqcst_fail.i
  ]

acquire.i14:                                      ; preds = %invoke.cont2.i, %invoke.cont2.i
  switch i32 %25, label %monotonic_fail11.i [
    i32 1, label %acquire_fail12.i
    i32 2, label %acquire_fail12.i
    i32 5, label %seqcst_fail13.i
  ]

release.i15:                                      ; preds = %invoke.cont2.i
  switch i32 %25, label %monotonic_fail24.i [
    i32 1, label %acquire_fail25.i
    i32 2, label %acquire_fail25.i
    i32 5, label %seqcst_fail26.i
  ]

acqrel.i16:                                       ; preds = %invoke.cont2.i
  switch i32 %25, label %monotonic_fail37.i [
    i32 1, label %acquire_fail38.i
    i32 2, label %acquire_fail38.i
    i32 5, label %seqcst_fail39.i
  ]

seqcst.i17:                                       ; preds = %invoke.cont2.i
  switch i32 %25, label %monotonic_fail50.i [
    i32 1, label %acquire_fail51.i
    i32 2, label %acquire_fail51.i
    i32 5, label %seqcst_fail52.i
  ]

monotonic_fail.i:                                 ; preds = %monotonic.i13
  %26 = load i32, i32* %23, align 4
  %27 = load i32, i32* %.atomictmp.i9, align 4
  %28 = cmpxchg i32* %_M_i.i12, i32 %26, i32 %27 monotonic monotonic, align 4
  %29 = extractvalue { i32, i1 } %28, 0
  %30 = extractvalue { i32, i1 } %28, 1
  br i1 %30, label %cmpxchg.continue.i, label %cmpxchg.store_expected.i

acquire_fail.i:                                   ; preds = %monotonic.i13, %monotonic.i13
  %31 = load i32, i32* %23, align 4
  %32 = load i32, i32* %.atomictmp.i9, align 4
  %33 = cmpxchg i32* %_M_i.i12, i32 %31, i32 %32 monotonic acquire, align 4
  %34 = extractvalue { i32, i1 } %33, 0
  %35 = extractvalue { i32, i1 } %33, 1
  br i1 %35, label %cmpxchg.continue6.i, label %cmpxchg.store_expected5.i

seqcst_fail.i:                                    ; preds = %monotonic.i13
  %36 = load i32, i32* %23, align 4
  %37 = load i32, i32* %.atomictmp.i9, align 4
  %38 = cmpxchg i32* %_M_i.i12, i32 %36, i32 %37 monotonic seq_cst, align 4
  %39 = extractvalue { i32, i1 } %38, 0
  %40 = extractvalue { i32, i1 } %38, 1
  br i1 %40, label %cmpxchg.continue9.i, label %cmpxchg.store_expected8.i

atomic.continue4.i:                               ; preds = %cmpxchg.continue9.i, %cmpxchg.continue6.i, %cmpxchg.continue.i
  br label %_ZNSt13__atomic_baseIiE23compare_exchange_strongERiiSt12memory_orderS2_.exit

cmpxchg.store_expected.i:                         ; preds = %monotonic_fail.i
  store i32 %29, i32* %23, align 4
  br label %cmpxchg.continue.i

cmpxchg.continue.i:                               ; preds = %cmpxchg.store_expected.i, %monotonic_fail.i
  %frombool.i = zext i1 %30 to i8
  store i8 %frombool.i, i8* %cmpxchg.bool.i, align 1
  br label %atomic.continue4.i

cmpxchg.store_expected5.i:                        ; preds = %acquire_fail.i
  store i32 %34, i32* %23, align 4
  br label %cmpxchg.continue6.i

cmpxchg.continue6.i:                              ; preds = %cmpxchg.store_expected5.i, %acquire_fail.i
  %frombool7.i = zext i1 %35 to i8
  store i8 %frombool7.i, i8* %cmpxchg.bool.i, align 1
  br label %atomic.continue4.i

cmpxchg.store_expected8.i:                        ; preds = %seqcst_fail.i
  store i32 %39, i32* %23, align 4
  br label %cmpxchg.continue9.i

cmpxchg.continue9.i:                              ; preds = %cmpxchg.store_expected8.i, %seqcst_fail.i
  %frombool10.i = zext i1 %40 to i8
  store i8 %frombool10.i, i8* %cmpxchg.bool.i, align 1
  br label %atomic.continue4.i

monotonic_fail11.i:                               ; preds = %acquire.i14
  %41 = load i32, i32* %23, align 4
  %42 = load i32, i32* %.atomictmp.i9, align 4
  %43 = cmpxchg i32* %_M_i.i12, i32 %41, i32 %42 acquire monotonic, align 4
  %44 = extractvalue { i32, i1 } %43, 0
  %45 = extractvalue { i32, i1 } %43, 1
  br i1 %45, label %cmpxchg.continue16.i, label %cmpxchg.store_expected15.i

acquire_fail12.i:                                 ; preds = %acquire.i14, %acquire.i14
  %46 = load i32, i32* %23, align 4
  %47 = load i32, i32* %.atomictmp.i9, align 4
  %48 = cmpxchg i32* %_M_i.i12, i32 %46, i32 %47 acquire acquire, align 4
  %49 = extractvalue { i32, i1 } %48, 0
  %50 = extractvalue { i32, i1 } %48, 1
  br i1 %50, label %cmpxchg.continue19.i, label %cmpxchg.store_expected18.i

seqcst_fail13.i:                                  ; preds = %acquire.i14
  %51 = load i32, i32* %23, align 4
  %52 = load i32, i32* %.atomictmp.i9, align 4
  %53 = cmpxchg i32* %_M_i.i12, i32 %51, i32 %52 acquire seq_cst, align 4
  %54 = extractvalue { i32, i1 } %53, 0
  %55 = extractvalue { i32, i1 } %53, 1
  br i1 %55, label %cmpxchg.continue22.i, label %cmpxchg.store_expected21.i

atomic.continue14.i:                              ; preds = %cmpxchg.continue22.i, %cmpxchg.continue19.i, %cmpxchg.continue16.i
  br label %_ZNSt13__atomic_baseIiE23compare_exchange_strongERiiSt12memory_orderS2_.exit

cmpxchg.store_expected15.i:                       ; preds = %monotonic_fail11.i
  store i32 %44, i32* %23, align 4
  br label %cmpxchg.continue16.i

cmpxchg.continue16.i:                             ; preds = %cmpxchg.store_expected15.i, %monotonic_fail11.i
  %frombool17.i = zext i1 %45 to i8
  store i8 %frombool17.i, i8* %cmpxchg.bool.i, align 1
  br label %atomic.continue14.i

cmpxchg.store_expected18.i:                       ; preds = %acquire_fail12.i
  store i32 %49, i32* %23, align 4
  br label %cmpxchg.continue19.i

cmpxchg.continue19.i:                             ; preds = %cmpxchg.store_expected18.i, %acquire_fail12.i
  %frombool20.i = zext i1 %50 to i8
  store i8 %frombool20.i, i8* %cmpxchg.bool.i, align 1
  br label %atomic.continue14.i

cmpxchg.store_expected21.i:                       ; preds = %seqcst_fail13.i
  store i32 %54, i32* %23, align 4
  br label %cmpxchg.continue22.i

cmpxchg.continue22.i:                             ; preds = %cmpxchg.store_expected21.i, %seqcst_fail13.i
  %frombool23.i = zext i1 %55 to i8
  store i8 %frombool23.i, i8* %cmpxchg.bool.i, align 1
  br label %atomic.continue14.i

monotonic_fail24.i:                               ; preds = %release.i15
  %56 = load i32, i32* %23, align 4
  %57 = load i32, i32* %.atomictmp.i9, align 4
  %58 = cmpxchg i32* %_M_i.i12, i32 %56, i32 %57 release monotonic, align 4
  %59 = extractvalue { i32, i1 } %58, 0
  %60 = extractvalue { i32, i1 } %58, 1
  br i1 %60, label %cmpxchg.continue29.i, label %cmpxchg.store_expected28.i

acquire_fail25.i:                                 ; preds = %release.i15, %release.i15
  %61 = load i32, i32* %23, align 4
  %62 = load i32, i32* %.atomictmp.i9, align 4
  %63 = cmpxchg i32* %_M_i.i12, i32 %61, i32 %62 release acquire, align 4
  %64 = extractvalue { i32, i1 } %63, 0
  %65 = extractvalue { i32, i1 } %63, 1
  br i1 %65, label %cmpxchg.continue32.i, label %cmpxchg.store_expected31.i

seqcst_fail26.i:                                  ; preds = %release.i15
  %66 = load i32, i32* %23, align 4
  %67 = load i32, i32* %.atomictmp.i9, align 4
  %68 = cmpxchg i32* %_M_i.i12, i32 %66, i32 %67 release seq_cst, align 4
  %69 = extractvalue { i32, i1 } %68, 0
  %70 = extractvalue { i32, i1 } %68, 1
  br i1 %70, label %cmpxchg.continue35.i, label %cmpxchg.store_expected34.i

atomic.continue27.i:                              ; preds = %cmpxchg.continue35.i, %cmpxchg.continue32.i, %cmpxchg.continue29.i
  br label %_ZNSt13__atomic_baseIiE23compare_exchange_strongERiiSt12memory_orderS2_.exit

cmpxchg.store_expected28.i:                       ; preds = %monotonic_fail24.i
  store i32 %59, i32* %23, align 4
  br label %cmpxchg.continue29.i

cmpxchg.continue29.i:                             ; preds = %cmpxchg.store_expected28.i, %monotonic_fail24.i
  %frombool30.i = zext i1 %60 to i8
  store i8 %frombool30.i, i8* %cmpxchg.bool.i, align 1
  br label %atomic.continue27.i

cmpxchg.store_expected31.i:                       ; preds = %acquire_fail25.i
  store i32 %64, i32* %23, align 4
  br label %cmpxchg.continue32.i

cmpxchg.continue32.i:                             ; preds = %cmpxchg.store_expected31.i, %acquire_fail25.i
  %frombool33.i = zext i1 %65 to i8
  store i8 %frombool33.i, i8* %cmpxchg.bool.i, align 1
  br label %atomic.continue27.i

cmpxchg.store_expected34.i:                       ; preds = %seqcst_fail26.i
  store i32 %69, i32* %23, align 4
  br label %cmpxchg.continue35.i

cmpxchg.continue35.i:                             ; preds = %cmpxchg.store_expected34.i, %seqcst_fail26.i
  %frombool36.i = zext i1 %70 to i8
  store i8 %frombool36.i, i8* %cmpxchg.bool.i, align 1
  br label %atomic.continue27.i

monotonic_fail37.i:                               ; preds = %acqrel.i16
  %71 = load i32, i32* %23, align 4
  %72 = load i32, i32* %.atomictmp.i9, align 4
  %73 = cmpxchg i32* %_M_i.i12, i32 %71, i32 %72 acq_rel monotonic, align 4
  %74 = extractvalue { i32, i1 } %73, 0
  %75 = extractvalue { i32, i1 } %73, 1
  br i1 %75, label %cmpxchg.continue42.i, label %cmpxchg.store_expected41.i

acquire_fail38.i:                                 ; preds = %acqrel.i16, %acqrel.i16
  %76 = load i32, i32* %23, align 4
  %77 = load i32, i32* %.atomictmp.i9, align 4
  %78 = cmpxchg i32* %_M_i.i12, i32 %76, i32 %77 acq_rel acquire, align 4
  %79 = extractvalue { i32, i1 } %78, 0
  %80 = extractvalue { i32, i1 } %78, 1
  br i1 %80, label %cmpxchg.continue45.i, label %cmpxchg.store_expected44.i

seqcst_fail39.i:                                  ; preds = %acqrel.i16
  %81 = load i32, i32* %23, align 4
  %82 = load i32, i32* %.atomictmp.i9, align 4
  %83 = cmpxchg i32* %_M_i.i12, i32 %81, i32 %82 acq_rel seq_cst, align 4
  %84 = extractvalue { i32, i1 } %83, 0
  %85 = extractvalue { i32, i1 } %83, 1
  br i1 %85, label %cmpxchg.continue48.i, label %cmpxchg.store_expected47.i

atomic.continue40.i:                              ; preds = %cmpxchg.continue48.i, %cmpxchg.continue45.i, %cmpxchg.continue42.i
  br label %_ZNSt13__atomic_baseIiE23compare_exchange_strongERiiSt12memory_orderS2_.exit

cmpxchg.store_expected41.i:                       ; preds = %monotonic_fail37.i
  store i32 %74, i32* %23, align 4
  br label %cmpxchg.continue42.i

cmpxchg.continue42.i:                             ; preds = %cmpxchg.store_expected41.i, %monotonic_fail37.i
  %frombool43.i = zext i1 %75 to i8
  store i8 %frombool43.i, i8* %cmpxchg.bool.i, align 1
  br label %atomic.continue40.i

cmpxchg.store_expected44.i:                       ; preds = %acquire_fail38.i
  store i32 %79, i32* %23, align 4
  br label %cmpxchg.continue45.i

cmpxchg.continue45.i:                             ; preds = %cmpxchg.store_expected44.i, %acquire_fail38.i
  %frombool46.i = zext i1 %80 to i8
  store i8 %frombool46.i, i8* %cmpxchg.bool.i, align 1
  br label %atomic.continue40.i

cmpxchg.store_expected47.i:                       ; preds = %seqcst_fail39.i
  store i32 %84, i32* %23, align 4
  br label %cmpxchg.continue48.i

cmpxchg.continue48.i:                             ; preds = %cmpxchg.store_expected47.i, %seqcst_fail39.i
  %frombool49.i = zext i1 %85 to i8
  store i8 %frombool49.i, i8* %cmpxchg.bool.i, align 1
  br label %atomic.continue40.i

monotonic_fail50.i:                               ; preds = %seqcst.i17
  %86 = load i32, i32* %23, align 4
  %87 = load i32, i32* %.atomictmp.i9, align 4
  %88 = cmpxchg i32* %_M_i.i12, i32 %86, i32 %87 seq_cst monotonic, align 4
  %89 = extractvalue { i32, i1 } %88, 0
  %90 = extractvalue { i32, i1 } %88, 1
  br i1 %90, label %cmpxchg.continue55.i, label %cmpxchg.store_expected54.i

acquire_fail51.i:                                 ; preds = %seqcst.i17, %seqcst.i17
  %91 = load i32, i32* %23, align 4
  %92 = load i32, i32* %.atomictmp.i9, align 4
  %93 = cmpxchg i32* %_M_i.i12, i32 %91, i32 %92 seq_cst acquire, align 4
  %94 = extractvalue { i32, i1 } %93, 0
  %95 = extractvalue { i32, i1 } %93, 1
  br i1 %95, label %cmpxchg.continue58.i, label %cmpxchg.store_expected57.i

seqcst_fail52.i:                                  ; preds = %seqcst.i17
  %96 = load i32, i32* %23, align 4
  %97 = load i32, i32* %.atomictmp.i9, align 4
  %98 = cmpxchg i32* %_M_i.i12, i32 %96, i32 %97 seq_cst seq_cst, align 4
  %99 = extractvalue { i32, i1 } %98, 0
  %100 = extractvalue { i32, i1 } %98, 1
  br i1 %100, label %cmpxchg.continue61.i, label %cmpxchg.store_expected60.i

atomic.continue53.i:                              ; preds = %cmpxchg.continue61.i, %cmpxchg.continue58.i, %cmpxchg.continue55.i
  br label %_ZNSt13__atomic_baseIiE23compare_exchange_strongERiiSt12memory_orderS2_.exit

cmpxchg.store_expected54.i:                       ; preds = %monotonic_fail50.i
  store i32 %89, i32* %23, align 4
  br label %cmpxchg.continue55.i

cmpxchg.continue55.i:                             ; preds = %cmpxchg.store_expected54.i, %monotonic_fail50.i
  %frombool56.i = zext i1 %90 to i8
  store i8 %frombool56.i, i8* %cmpxchg.bool.i, align 1
  br label %atomic.continue53.i

cmpxchg.store_expected57.i:                       ; preds = %acquire_fail51.i
  store i32 %94, i32* %23, align 4
  br label %cmpxchg.continue58.i

cmpxchg.continue58.i:                             ; preds = %cmpxchg.store_expected57.i, %acquire_fail51.i
  %frombool59.i = zext i1 %95 to i8
  store i8 %frombool59.i, i8* %cmpxchg.bool.i, align 1
  br label %atomic.continue53.i

cmpxchg.store_expected60.i:                       ; preds = %seqcst_fail52.i
  store i32 %99, i32* %23, align 4
  br label %cmpxchg.continue61.i

cmpxchg.continue61.i:                             ; preds = %cmpxchg.store_expected60.i, %seqcst_fail52.i
  %frombool62.i = zext i1 %100 to i8
  store i8 %frombool62.i, i8* %cmpxchg.bool.i, align 1
  br label %atomic.continue53.i

terminate.lpad.i:                                 ; preds = %invoke.cont.i, %_ZNSt13__atomic_baseIiE9fetch_addEiSt12memory_order.exit
  %101 = landingpad { i8*, i32 }
          catch i8* null
  %102 = extractvalue { i8*, i32 } %101, 0
  call void @__clang_call_terminate(i8* %102) #5
  unreachable

_ZNSt13__atomic_baseIiE23compare_exchange_strongERiiSt12memory_orderS2_.exit: ; preds = %atomic.continue4.i, %atomic.continue14.i, %atomic.continue27.i, %atomic.continue40.i, %atomic.continue53.i
  %103 = load i8, i8* %cmpxchg.bool.i, align 1
  %tobool.i = trunc i8 %103 to i1
  ret i32 0
}

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #2

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define linkonce_odr dso_local i32 @_ZSt23__cmpexch_failure_orderSt12memory_order(i32 %__m) #0 comdat personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) {
entry:
  %__m.addr = alloca i32, align 4
  store i32 %__m, i32* %__m.addr, align 4
  %0 = load i32, i32* %__m.addr, align 4
  %call = call i32 @_ZStanSt12memory_orderSt23__memory_order_modifier(i32 %0, i32 65535)
  %call1 = call i32 @_ZSt24__cmpexch_failure_order2St12memory_order(i32 %call) #4
  %1 = load i32, i32* %__m.addr, align 4
  %call2 = call i32 @_ZStanSt12memory_orderSt23__memory_order_modifier(i32 %1, i32 -65536)
  %call3 = invoke i32 @_ZStorSt12memory_orderSt23__memory_order_modifier(i32 %call1, i32 %call2)
          to label %invoke.cont unwind label %terminate.lpad

invoke.cont:                                      ; preds = %entry
  ret i32 %call3

terminate.lpad:                                   ; preds = %entry
  %2 = landingpad { i8*, i32 }
          catch i8* null
  %3 = extractvalue { i8*, i32 } %2, 0
  call void @__clang_call_terminate(i8* %3) #5
  unreachable
}

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define linkonce_odr dso_local i32 @_ZStanSt12memory_orderSt23__memory_order_modifier(i32 %__m, i32 %__mod) #0 comdat {
entry:
  %__m.addr = alloca i32, align 4
  %__mod.addr = alloca i32, align 4
  store i32 %__m, i32* %__m.addr, align 4
  store i32 %__mod, i32* %__mod.addr, align 4
  %0 = load i32, i32* %__m.addr, align 4
  %1 = load i32, i32* %__mod.addr, align 4
  %and = and i32 %0, %1
  ret i32 %and
}

declare dso_local i32 @__gxx_personality_v0(...)

; Function Attrs: noinline noreturn nounwind
define linkonce_odr hidden void @__clang_call_terminate(i8* %0) #3 comdat {
  %2 = call i8* @__cxa_begin_catch(i8* %0) #4
  call void @_ZSt9terminatev() #5
  unreachable
}

declare dso_local i8* @__cxa_begin_catch(i8*)

declare dso_local void @_ZSt9terminatev()

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define linkonce_odr dso_local i32 @_ZStorSt12memory_orderSt23__memory_order_modifier(i32 %__m, i32 %__mod) #0 comdat {
entry:
  %__m.addr = alloca i32, align 4
  %__mod.addr = alloca i32, align 4
  store i32 %__m, i32* %__m.addr, align 4
  store i32 %__mod, i32* %__mod.addr, align 4
  %0 = load i32, i32* %__m.addr, align 4
  %1 = load i32, i32* %__mod.addr, align 4
  %or = or i32 %0, %1
  ret i32 %or
}

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define linkonce_odr dso_local i32 @_ZSt24__cmpexch_failure_order2St12memory_order(i32 %__m) #0 comdat {
entry:
  %__m.addr = alloca i32, align 4
  store i32 %__m, i32* %__m.addr, align 4
  %0 = load i32, i32* %__m.addr, align 4
  %cmp = icmp eq i32 %0, 4
  br i1 %cmp, label %cond.true, label %cond.false

cond.true:                                        ; preds = %entry
  br label %cond.end4

cond.false:                                       ; preds = %entry
  %1 = load i32, i32* %__m.addr, align 4
  %cmp1 = icmp eq i32 %1, 3
  br i1 %cmp1, label %cond.true2, label %cond.false3

cond.true2:                                       ; preds = %cond.false
  br label %cond.end

cond.false3:                                      ; preds = %cond.false
  %2 = load i32, i32* %__m.addr, align 4
  br label %cond.end

cond.end:                                         ; preds = %cond.false3, %cond.true2
  %cond = phi i32 [ 0, %cond.true2 ], [ %2, %cond.false3 ]
  br label %cond.end4

cond.end4:                                        ; preds = %cond.end, %cond.true
  %cond5 = phi i32 [ 2, %cond.true ], [ %cond, %cond.end ]
  ret i32 %cond5
}

attributes #0 = { mustprogress noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { mustprogress noinline norecurse nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { argmemonly nofree nounwind willreturn writeonly }
attributes #3 = { noinline noreturn nounwind }
attributes #4 = { nounwind }
attributes #5 = { noreturn nounwind }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"uwtable", i32 1}
!2 = !{i32 7, !"frame-pointer", i32 2}
!3 = !{!"clang version 14.0.0 (https://github.com/llvm/llvm-project 4732dd301086ce056d869eded4e1543fcb45506d)"}
