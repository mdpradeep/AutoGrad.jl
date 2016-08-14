# broadcast2arg:
# These functions use broadcasting to handle arrays of different sizes.
# Unless otherwise specified they support:
# (N,N) (N,A) (A,N) (A,A) (A,B)
# where N:Number, A,B arrays of broadcast compatible sizes.

broadcast2arg = Dict{Symbol,Any}(
:.+ => (1,1),                    # extra (A,)
:.* => (:x2,:x1),                # extra (A,)
:.- => (1,-1),
#:.% => (1,:(-trunc(x1./x2))),  # BUG: WARNING: (:check_grads,(:sum,:.%),:args,([-1.6685861285973334,2.349598738753782],[0.5880954718832765,-0.0010728600840855926]),:exact,([1.0,1.0],[2.0,2190.0]),:numeric,([1.0000000000021103,-9.728600840858691],[1.9999999999997797,-4.863172375468294])), WARNING: (:check_grads,(:sum,:.%),:args,([0.20579984208295538,-0.5521335915808314],[0.14504947039368943,-5.795215813098871e-5]),:exact,([1.0,1.0],[-1.0,-9527.0]),:numeric,([0.9999999999998899,-0.15904316261985962],[-0.9999999999998899,0.5895451080050601]))
:./ => (:(1./x2),:(-x1./abs2(x2))),
:.\ => (:(-x2./abs2(x1)),:(1./x1)),
:.^ => (:(x2.*x1.^(x2-1)),:(y.*log(x1))), # domain: x1 >= 0 (unless we use complex args)
# :.<  => 0, # BUG: MethodError(isless,(0.3836010032871748,N31(0.28940741417311505,(:A3,:R61))))
# :.<= => 0, # BUG: MethodError(isless,(N64(0.2943038720867562,(:A93,:R0)),1.6879170322331594))
:.== => 0, # BUG: StackOverflowError()
# :.>  => 0, # BUG: StackOverflowError()
# :.>= => 0, # BUG: StackOverflowError()
#:.<< => :todo,                   # domain: Integers, left bit shift; operators,arraymath,broadcast
#:.>> => :todo,                   # domain: Integers, right bit shift
)

defgrads(broadcast2arg, Number, Number)
defgrads(broadcast2arg, AbstractArray, Number)
defgrads(broadcast2arg, Number, AbstractArray)
defgrads(broadcast2arg, AbstractArray, AbstractArray)

testargs(::Type{Val{:.^}},x...)=map(abs,testargs(nothing,x...))
