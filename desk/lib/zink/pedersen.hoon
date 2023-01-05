~%  %ped  ..part  ~
|%
++  pedersen
  ~%  %pedersen  +  ~
  |%
  ++  t
    ^-  domain:secp:crypto
    :*  :(add (bex 251) (mul 17 (bex 192)) 1)
        1
        3.141.592.653.589.793.238.462.643.383.279.
          502.884.197.169.399.375.105.820.974.944.
          592.307.816.406.665
        :-  874.739.451.078.007.766.457.464.989.
              774.322.083.649.278.607.533.249.481.
              151.382.481.072.868.806.602
            152.666.792.071.518.830.868.575.557.
              812.948.353.041.420.400.780.739.481.
              342.941.381.225.525.861.407
        3.618.502.788.666.131.213.697.322.783.095.
          070.105.526.743.751.716.087.489.154.079.
          457.884.512.865.583
    ==
  ::
  ++  curve             ~(. secp:secp:crypto 32 t)
  ++  add-points        add-points:curve
  ++  mul-point-scalar  mul-point-scalar:curve
  ++  p0
    :-  2.089.986.280.348.253.421.170.679.821.480.
          865.132.823.066.470.938.446.095.505.822.
          317.253.594.081.284
        1.713.931.329.540.660.377.023.406.109.199.
          410.414.810.705.867.260.802.078.187.082.
          345.529.207.694.986
  ++  p1
    :-  996.781.205.833.008.774.514.500.082.376.
          783.249.102.396.023.663.454.813.447.423.
          147.977.397.232.763
        1.668.503.676.786.377.725.805.489.344.771.
          023.921.079.126.552.019.160.156.920.634.
          619.255.970.485.781
  ++  p2
    :-  2.251.563.274.489.750.535.117.886.426.533.
          222.435.294.046.428.347.329.203.627.021.
          249.169.616.184.184
        1.798.716.007.562.728.905.295.480.679.789.
          526.322.175.868.328.062.420.237.419.143.
          593.021.674.992.973
  ++  p3
    :-  2.138.414.695.194.151.160.943.305.727.036.
          575.959.195.309.218.611.738.193.261.179.
          310.511.854.807.447
        113.410.276.730.064.486.255.102.093.846.
          540.133.784.865.286.929.052.426.931.474.
          106.396.135.072.156
  ++  p4
    :-  2.379.962.749.567.351.885.752.724.891.227.
          938.183.011.949.129.833.673.362.440.656.
          643.086.021.394.946
        776.496.453.633.298.175.483.985.398.648.
          758.586.525.933.812.536.653.089.401.905.
          292.063.708.816.422
  ++  hash
    ~/  %phash
    |=  [a=@ b=@]
    ^-  @
    |^
    ~&  >>>  "WARNING: hashing in zink/hoon"
    =/  x  (has a)
    =/  y  (has b)
    +:(do-hash y x)
    ::
    ++  has
      |=  n=@
      ^-  @
      ?:  (lte (met 2 n) 63)  n
      =/  rips
        %^  spin  (tear [3 32] n)  0
        |=  [x=@ ext=@]
        ?:  (lth (met 3 x) 32)
           [x ext]
        :-  (zero-nib x)
        (cat 3 ext (first-nib x))
      =/  r
        ?:  =(q:rips 0)  p.rips
        (into p.rips (lent p.rips) q.rips)
      ?~  r  n
      =/  hed  (snag 0 `(list @)`r)
      =/  tal  (slag 1 `(list @)`r)
      q:(spin tal hed do-hash)
    ::
    ++  first-nib
      |=  n=@
      (end 2 (rev 2 (met 2 n) n))
    ::
    ++  zero-nib
      |=  n=@
      (rev 2 (dec (met 2 n)) (rsh [2 1] (rev 2 (met 2 n) n)))
    ::
    ++  tear
      |=  [s=[@ @] n=@]
      ^-  (list @)
      ?:  =(n 0)  ~[0]
      (rip s n)
    ::
    ++  do-hash
      |=  [b=@ a=@]
      ^-  [@ @]
      =+  alow=(mod a (bex 248))
      =+  ahig=(rsh [0 248] a)
      =+  blow=(mod b (bex 248))
      =+  bhig=(rsh [0 248] b)
      :-  0
      =-  x
      ;:  add-points
        p0
        (mul-point-scalar p1 alow)
        (mul-point-scalar p2 ahig)
        (mul-point-scalar p3 blow)
        (mul-point-scalar p4 bhig)
      ==
    --
  --
--
