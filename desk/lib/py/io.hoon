/-  *pyro, spider
/+  libstrand=strand, *strandio, util=py-util
=,  strand=strand:libstrand
|%
++  send-events
  |=  events=(list aqua-event)
  =/  m  (strand ,~)
  ^-  form:m
  (poke-our %pyro %aqua-events !>(events))
::
++  take-unix-effect
  =/  m  (strand ,[ship unix-effect])
  ^-  form:m
  ;<  [=path =cage]  bind:m  (take-fact-prefix /effect)
  ?>  ?=(%aqua-effect p.cage)
  (pure:m !<([aqua-effect] q.cage))
::
++  start-simple
  (start-test %aqua-ames %aqua-behn %aqua-dill %aqua-eyre ~)
::
++  end
  (end-test %aqua-ames %aqua-behn %aqua-dill %aqua-eyre ~)
::
++  start-test
  |=  vane-threads=(list term)
  =/  m  (strand ,~)
  ^-  form:m
  ~&  >  "starting"
  ;<  tids=(map term tid:spider)  bind:m  (start-threads vane-threads)
  ;<  ~  bind:m  (watch-our /effect %pyro /effect)
  ::  Get our very own event with no mistakes in it... yet.
  ::
  ::  We want to wait for the vane threads to actually start and get
  ::  their subscriptions started.  Other ways to do this are delaying
  ::  the ack from spider until the build is finished (does that
  ::  guarantee the subscriptions have started?) or subscribe to the
  ::  threads themselves for a notification when they're done.  This is
  ::  probably the best option because the thread can delay until it
  ::  gets a positive ack on the subscription.
  ::
  ::  Threads might not get built until a %writ is dripped back to
  ::  spider.  Drips are at +(now), so we sleep until two clicks in the
  ::  future.
  ::
  ;<  ~  bind:m  (sleep `@dr`2)
  (pure:m ~)
::
++  end-test
  |=  vane-threads=(list term)
  =/  m  (strand ,~)
  ^-  form:m
  ~&  >  "done"
  ;<  ~  bind:m  (stop-threads vane-threads)
  ;<  ~  bind:m  (leave-our /effect %pyro)
  (pure:m ~)
::
++  start-threads
  |=  threads=(list term)
  =/  m  (strand ,(map term tid:spider))
  ^-  form:m
  ;<  =bowl:spider  bind:m  get-bowl
  =|  tids=(map term tid:spider)
  |-  ^-  form:m
  =*  loop  $
  ?~  threads
    (pure:m tids)
  =/  tid
    %+  scot  %ta
    (cat 3 (cat 3 'strand_' i.threads) (scot %uv (sham i.threads eny.bowl)))
  =/  poke-vase  !>([`tid.bowl ~ byk.bowl i.threads *vase])
  ;<  ~  bind:m  (poke-our %spider %spider-start poke-vase)
  loop(threads t.threads, tids (~(put by tids) i.threads tid))
::
++  stop-threads
  |=  threads=(list term)
  =/  m  (strand ,~)
  ^-  form:m
  (pure:m ~)
::
++  init-ship
  |=  =ship
  =/  m  (strand ,~)
  ^-  form:m
  ~&  >  "starting {<ship>}"
  ;<  ~  bind:m  (send-events (init:util ship))
  (check-ship-booted ship)
::
++  check-ship-booted
  |=  =ship
  =/  m  (strand ,~)
  ^-  form:m
  =*  loop  $
  ;<  [her=^ship =unix-effect]  bind:m  take-unix-effect
  =/  f  |=(=tape (is-dojo-output:util ship her unix-effect tape))
  ::  This is a pretty bad heuristic, but in general galaxies will
  ::  hit the first of these cases, and other ships will hit the
  ::  second.
  ::
  ?:  ?|  (f ":dojo>")
          (f "is your neighbor")
      ==
    (pure:m ~)
  loop
::
++  dojo
  |=  [=ship =tape]
  =/  m  (strand ,~)
  ^-  form:m
  ~&  >  "dojo: {tape}"
  (send-events (dojo:util ship tape))
::
++  wait-for-output
  |=  [=ship =tape]
  =/  m  (strand ,~)
  ^-  form:m
  ~&  >  "waiting for output: {tape}"
  |-  ^-  form:m
  =*  loop  $
  ;<  [her=^ship =unix-effect]  bind:m  take-unix-effect
  ?:  (is-dojo-output:util ship her unix-effect tape)
    (pure:m ~)
  loop
::
::  Send "|hi" from one ship to another
::
++  send-hi
  |=  [from=@p to=@p]
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  (dojo from "|hi {(scow %p to)}")
  (wait-for-output from "hi {(scow %p to)} successful")
::
::  Send "|hi" and wait for "not responding" message
::
++  send-hi-not-responding
  |=  [from=@p to=@p]
  ~&  >  'sending hi not responding'
  =/  m  (strand ,~)
  ;<  ~  bind:m  (dojo from "|hi {(scow %p to)}")
  (wait-for-output from "{(scow %p to)} not responding still trying")
::
::  Mount a desk.
::
++  mount
  |=  [=ship =desk]
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~                         bind:m  (dojo ship "|mount /={(trip desk)}=")
  |-  ^-  form:m
  =*  loop  $
  ;<  [her=^ship =unix-effect]  bind:m  take-unix-effect
  ?:  (is-ergo:util ship her unix-effect)
    (pure:m ~)
  loop
::
::  Modify /sur/aquarium/hoon on the given ship
::
++  touch-file
  |=  [her=ship =desk extra=@t]
  =/  m  (strand ,@t)
  ^-  form:m
  (touch her desk /sur/aquarium/hoon extra)
::
::  Modify path on the given ship
::
++  touch
  |=  [her=ship =desk pax=path extra=@t]
  =/  m  (strand ,@t)
  ^-  form:m
  ~&  >  "touching file on {<her>}/{<desk>}"
  ;<  ~        bind:m  (mount her desk)
  ;<  our=@p   bind:m  get-our
  ;<  now=@da  bind:m  get-time
  =/  aqua-pax
    ;:  weld
        /i/(scot %p her)/cx/(scot %p her)/[desk]/(scot %da now)
        pax
        /noun
    ==
  =/  warped
    %^  cat  3  '=>  .  '
    %^  cat  3  extra
    (need (scry-aqua:util (unit @) our now aqua-pax))
  ;<  ~  bind:m  (send-events (insert-files:util her desk [pax warped] ~))
  (pure:m warped)
::
::  Check /sur/aquarium/hoon on the given has the given contents.
::
++  check-file-touched
  |=  [=ship =desk warped=@t]
  =/  m  (strand ,~)
  (check-touched ship desk /sur/aquarium/hoon warped)
::
::  Check path on the given desk has the given contents.
::
++  check-touched
  |=  [=ship =desk pax=path warped=@t]
  =/  m  (strand ,~)
  ~&  >  "checking file touched on {<ship>}/{<desk>}"
  ;<  ~                         bind:m  (mount ship desk)
  ^-  form:m
  |-  ^-  form:m
  =*  loop  $
  ;<  [her=^ship =unix-effect]  bind:m  take-unix-effect
  ;<  our=@p                    bind:m  get-our
  ;<  now=@da                   bind:m  get-time
  ::  %ergo is no longer sufficient because .^ is pinned to beginning of
  ::  the event.  So we hope somebody sets a timer for something.
  ::
  ?.  &(=(ship her) ?=(?(%init %ergo %doze) -.q.unix-effect))
    loop
  =/  aqua-pax
    ;:  weld
        /i/(scot %p ship)/cx/(scot %p ship)/[desk]/(scot %da now)
        pax
        /noun
    ==
  ?:  =(warped (need (scry-aqua:util (unit @) our now aqua-pax)))
    (pure:m ~)
  loop
::
::  Turns poke into a dojo command
::
++  poke-app
  |=  [=ship app=term =mark data=*]
  =/  m  (strand ,~)
  ^-  form:m
  =/  command=tape  ":{(trip app)} &{(trip mark)} {<data>}"
  (send-events (dojo:util ship command))
::
++  dojo-thread
  |=  [=ship ted=term =mark data=*]
  =/  m  (strand ,~)
  ^-  form:m
  =/  command=tape  "-{(trip ted)} &{(trip mark)} {<data>}"
  (send-events (dojo:util ship command))
--
