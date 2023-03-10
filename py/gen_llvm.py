# TODO: passes: globaldce, inline, mem2reg, sroa, lcssa?, licm, loop-unswitch, loop-unroll, lowerswitch, (strip), (module-debuginfo)

# TODO: alloca at entry -> mem2reg, sroa
# %x = alloca i64, align 8

# TODO:
# %a1 = phi i32 [ 0, %0 ], [ %nextvar, %loop ]
# br i1 %condition, label %true, label %false
# br label %loop

# if x
#   ...
# else
#   ...

#   %1 = icmp ne i32 %x, i32 0
#   br i1 %1, label %1.then, label %2.else
# 1.then:
#   ...
# 2.else:
#   ...
# 3:
#   %phi

# for i in 1..10
#  ...

#  br label %1.for
# 1.for:
#  %i = phi i32 [ 0, %0 ], [ %i.1, %1.for ]
#  %i.1 = add i32 %i.0, i32 1
#  br i1 %condition, label %1.for, label %2
# 2:
