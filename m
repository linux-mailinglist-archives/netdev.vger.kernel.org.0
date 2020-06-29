Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07FFF20D238
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 20:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729358AbgF2Srq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 14:47:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729328AbgF2Srm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 14:47:42 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6FDC030781
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 08:11:10 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id dg28so13136375edb.3
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 08:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gpSVf/UflP9ilocWouTsTwWKOXGTd5AdEBIHo39VdEU=;
        b=RPeEM+t2iCQcMV7YcfTh3XI4EUxVmIvbOWCLhZeDtReEP81sQ/FisrGp9gFHaxkjzX
         3yUdKHZfWJQa5juuH2k9SBcfDCc8vrFJSO1AxCq7qkr1dAM238Dut05qHnhOMwzLO8AI
         lXRpXpl6ElVf/BRwv3YrTp18tBm8xD7vaVFOvD0UUt3TvPXWogmj8eSq60ybWEyvveRs
         v/6VO+1IZ7JRxbIWdO/SUyvRHUaB+yPtNu4dnrcEPObxI91JDTUKUhQDs0CMwWfAz5WL
         x74vJVPQw78pSvoZQeCbCS1BMxkCiXpAkhBJ8pD+5BTK41dxtYfufG5/iveHWqk67zPx
         C3zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gpSVf/UflP9ilocWouTsTwWKOXGTd5AdEBIHo39VdEU=;
        b=sm5cZlr3Islz0MiZsub00NNegjUwFOzu+E5bIzAgVcDEckczUgYBVmfGNrbhLQKwU4
         z7tHU+1J/L06Pi87duBP3bZlI8forI0lOc2jLbM3avVYdzCMGV4oJXFmpPiG/txriHqJ
         lSBNUMmAp9H70mi8s7X09yv/pCumKPS8BSszJ0eZvH7CA+8jIXcQt8dvBuJbJ0spxecN
         tyBjV/tq93jRDUTROdq325DfzoOhpyYzVS/F6CpSK0lgwHfEAk9L8ZJHv9U9bEkicsiq
         wYlyTw00T5KTIcHw+wxq7QEjvs4iTyGdjpyTXGVntJIJGpCQtGxvE6cAuQCjuSJWl2UN
         DM3Q==
X-Gm-Message-State: AOAM530yrCwYzDpNJ46NIPpO5OBTSsXa/s5oUlc1CfZHSQ9pWbG9aFGv
        +n+DDwfKqTVNu0ZNCNrtn3dnxfj5ZMQeD0M1VbEYR8kM
X-Google-Smtp-Source: ABdhPJzeu+mYwfrClZ5DNMGo8BIhBI2llxU3Vb/ci1KEetXqQcukLw9aD5Iu5gcVcVdcYLo8cyfKZpSgTwfMz83PjcA=
X-Received: by 2002:a05:6402:1c96:: with SMTP id cy22mr17683760edb.79.1593443468687;
 Mon, 29 Jun 2020 08:11:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200624171749.11927-1-tom@herbertland.com> <20200624171749.11927-12-tom@herbertland.com>
 <5ff4eb9d43b563952f255a2af64e14bb7feadb20.camel@mellanox.com>
In-Reply-To: <5ff4eb9d43b563952f255a2af64e14bb7feadb20.camel@mellanox.com>
From:   Tom Herbert <tom@herbertland.com>
Date:   Mon, 29 Jun 2020 08:10:57 -0700
Message-ID: <CALx6S34-1zUAXCzUbe=Wb7ZXgfgVTTe5i=0GnTDUCdcnTshrvA@mail.gmail.com>
Subject: Re: [RFC PATCH 11/11] doc: Documentation for Per Thread Queues
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 28, 2020 at 11:28 PM Saeed Mahameed <saeedm@mellanox.com> wrote:
>
> On Wed, 2020-06-24 at 10:17 -0700, Tom Herbert wrote:
> > Add a section on Per Thread Queues to scaling.rst.
> > ---
> >  Documentation/networking/scaling.rst | 195
> > ++++++++++++++++++++++++++-
> >  1 file changed, 194 insertions(+), 1 deletion(-)
> >
> > diff --git a/Documentation/networking/scaling.rst
> > b/Documentation/networking/scaling.rst
> > index 8f0347b9fb3d..42f1dc639ab7 100644
> > --- a/Documentation/networking/scaling.rst
> > +++ b/Documentation/networking/scaling.rst
> > @@ -250,7 +250,7 @@ RFS: Receive Flow Steering
> >  While RPS steers packets solely based on hash, and thus generally
> >  provides good load distribution, it does not take into account
> >  application locality. This is accomplished by Receive Flow Steering
> > -(RFS). The goal of RFS is to increase datacache hitrate by steering
> > +(RFS). The goal of RFS is to increase datacache hit rate by steering
> >  kernel processing of packets to the CPU where the application thread
> >  consuming the packet is running. RFS relies on the same RPS
> > mechanisms
> >  to enqueue packets onto the backlog of another CPU and to wake up
> > that
> > @@ -508,6 +508,199 @@ a max-rate attribute is supported, by setting a
> > Mbps value to::
> >  A value of zero means disabled, and this is the default.
> >
> >
> > +PTQ: Per Thread Queues
> > +======================
> > +
> > +Per Thread Queues allows application threads to be assigned
>
> I think i am a bit confused about the definition of Thread in this
> context. Is it a netwroking kernel thread ? or an actual application
> user thread ?
>
Actual appication user threads.

> > dedicated
> > +hardware network queues for both transmit and receive. This facility
>
> "dedicated hardware network queues" seems a bit out of context here, as
> from the looks of it, the series only deals with lightweight mapping
> between threads and hardware queues, as opposed to CPUs (XPS) and aRFS
> (HW flow steering) mappings.

Global queues are mapped to hardware queues via some function that
takes both the global queue and device as input. If the mapping is 1-1
per device that it is equivalent to providing a dedicated HW queues to
threads.

>
> But for someone like me, from device drivers and XDP-XSK/RDMA world,
> "dedicated hardware queues", means a dedicated and isolated hw queue
> per thread/app which can't be shared with others, and I don't see any
> mention of creation of new dedicated hw queues per thread in this
> patchset, just re-mapping of pre-existing HW queues.
>
Hardware queues are generic entities that have no particular semantics
until they're instantiated with some sort of packet steering
configuration (e.g. RSS, aRFS, tc filters on receive; XPS, hash
mapping on slection). For a dedicated hardware receive tc receve
filtering and aRFS (sterring to queue instead of CPU) provide
necessary isolation for receive, and grabbing the assign transmit
queue from the running thread and using that in lieu of XPS provides
for transmit isolation. Note that dedicated queues won't be in RSS or
aRFS maps, and neither in XPS maps. So if queue #800 is assigned to a
thread for TX and RX then we expect all packets for that sockets
processed by that thread to be received and sent on the queue. The TX
side should be completely accurate in this regard since we select
queue with full state for the socket, it's thread, and running CPU.
Receive is accurate up the ability to program the device for all
possible received packets that might be received on the sockets.

> So no matter how you look at it, there will only be #CPUs hardware
> queues (at most) that must be shared somehow if you want to run more
> than #CPUs threads.

Yes, there is no requirement that _all_ threads have to use dedicated
queues. We will always need some number of general non-dedicated
queues to handle "other traffic". In fact, I think the dedicated
queues would more be used in cases where isolation or performance of
crucial.

>
> So either i am missing something, or this is actually the point of the
> series, in which case, this limitation of the #threads or sharing
> should be clarified ..
>
I'm not sure what the limitation here is-- I beleive this patch set is
overcoming limitations. Some hardware devices support thousands of
queues, and we have been unable to leverage those since packet
steering to date have more queues than CPUs didn't make much sense.
Using queues for isolation of threads' traffic makes sense, we just
need the right infrastructure. This also solves one of the nagging
problems in aRFS: when a thread is scheduled on a different CPU all of
the thread's sockets thrash to using a different queue (i.e. a whole
bunch of ndo_rx_flow_steer calls). In PTQ, the receive queue for the
thread sockets follow the thread so when it's rescheduled to a new CPU
there's no work to do. This does mean that we probably need
alternative mechanisms than canonical interrupt per queue ready, for
that busy polling or we can leverage device completion queues (latter
is follow on work).

>
> > +provides a high degree of traffic isolation between applications and
> > +can also help facilitate high performance due to fine grained packet
> > +steering.
> > +
> > +PTQ has three major design components:
> > +     - A method to assign transmit and receive queues to threads
> > +     - A means to associate packets with threads and then to steer
> > +       those packets to the queues assigned to the threads
> > +     - Mechanisms to process the per thread hardware queues
> > +
> > +Global network queues
> > +~~~~~~~~~~~~~~~~~~~~~
> > +
> > +Global network queues are an abstraction of hardware networking
> > +queues that can be used in generic non-device specific
> > configuration.
> > +Global queues may mapped to real device queues. The mapping is
> > +performed on a per device queue basis. A device sysfs parameter
> > +"global_queue_mapping" in queues/{tx,rx}-<num> indicates the mapping
> > +of a device queue to a global queue. Each device maintains a table
> > +that maps global queues to device queues for the device. Note that
> > +for a single device, the global to device queue mapping is 1 to 1,
> > +however each device may map a global queue to a different device
> > +queue.
> > +
> > +net_queues cgroup controller
> > +~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > +
> > +For assigning queues to the threads, a cgroup controller named
> > +"net_queues" is used. A cgroup can be configured with pools of
> > transmit
> > +and receive global queues from which individual threads are assigned
> > +queues. The contents of the net_queues controller are described
> > below in
> > +the configuration section.
> > +
> > +Handling PTQ in the transmit path
> > +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > +
> > +When a socket operation is performed that may result in sending
> > packets
> > +(i.e. listen, accept, sendmsg, sendpage), the task structure for the
> > +current thread is consulted to see if there is an assigned transmit
> > +queue for the thread. If there is a queue assignment, the queue
> > index is
> > +set in a field of the sock structure for the corresponding socket.
> > +Subsequently, when transmit queue selection is performed, the sock
> > +structure associated with packet being sent is consulted. If a
> > transmit
> > +global queue is set in the sock then that index is mapped to a
> > device
> > +queue for the output networking device. If a valid device queue is
> > +discovered then that queue is used, else if a device queue is not
> > found
> > +then queue selection proceeds to XPS.
> > +
> > +Handling PTQ in the receive path
> > +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > +
> > +The receive path uses the infrastructure of RFS which is extended
> > +to steer based on the assigned received global queue for a thread in
> > +addition to steering based on the CPU. The rps_sock_flow_table is
> > +modified to contain either the desired CPU for flows or the desired
> > +receive global queue. A queue is updated at the same time that the
> > +desired CPU would updated during calls to recvmsg and sendmsg (see
> > RFS
> > +description above). The process is to consult the running task
> > structure
> > +to see if a receive queue is assigned to the task. If a queue is
> > assigned
> > +to the task then the corresponding queue index is set in the
> > +rps_sock_flow_table; if no queue is assigned then the current CPU is
> > +set as the desired per canonical RFS.
> > +
> > +When packets are received, the rps_sock_flow table is consulted to
> > check
> > +if they were received on the proper queue. If the
> > rps_sock_flow_table
> > +entry for a corresponding flow of a received packet contains a
> > global
> > +queue index, then the index is mapped to a device queue on the
> > received
> > +device. If the mapped device queue is equal to the receive queue
> > then
> > +packets are being steered properly. If there is a mismatch then the
> > +local flow to queue mapping in the device is changed and
> > +ndo_rx_flow_steer is invoked to set the receive queue for the flow
> > in
> > +the device as described in the aRFS section.
> > +
> > +Processing queues in Per Queue Threads
> > +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > +
> > +When Per Queue Threads is used, the queue "follows" the thread. So
> > when
> > +a thread is rescheduled from one queue to another we expect that the
> > +processing of the device queues that map to the thread are processed
> > on
> > +the CPU where the thread is currently running. This is a bit tricky
> > +especially with respect to the canonical device interrupt driven
> > model.
> > +There are at least three possible approaches:
> > +     - Arrange for interrupts to follow threads as they are
> > +       rescheduled, or alternatively pin threads to CPUs and
> > +       statically configure the interrupt mappings for the queues
> > for
> > +       each thread
> > +     - Use busy polling
> > +     - Use "sleeping busy-poll" with completion queues. The basic
> > +       idea is to have one CPU busy poll a device completion queue
> > +       that reports device queues with received or completed
> > transmit
> > +       packets. When a queue is ready, the thread associated with
> > the
> > +       queue (derived by reverse mapping the queue back to its
> > +       assigned thread) is scheduled. When the thread runs it polls
> > +       its queues to process any packets.
> > +
> > +Future work may further elaborate on solutions in this area.
> > +
> > +Reducing flow state in devices
> > +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > +
> > +PTQ (and aRFS as well) potentially create per flow state in a
> > device.
> > +This is costly in at least two ways: 1) State requires device memory
> > +which is almost always much less than host memory can and thus the
> > +number of flows that can be instantiated in a device are less than
> > that
> > +in the host. 2) State requires instantiation and synchronization
> > +messages, i.e. ndo_rx_flow_steer causes a message over PCIe bus; if
> > +there is a highly turnover rate of connections this messaging
> > becomes
> > +a bottleneck.
> > +
> > +Mitigations to reduce the amount of flow state in the device should
> > be
> > +considered.
> > +
> > +In PTQ (and aRFS) the device flow state is a considered cache. A
> > flow
> > +entry is only set in the device on a cache miss which occurs when
> > the
> > +receive queue for a packet doesn't match the desired receive queue.
> > So
> > +conceptually, if a packets for a flow are always received on the
> > desired
> > +queue from the beginning of the flow then a flow state might never
> > need
> > +to be instantiated in the device. This motivates a strategy to try
> > to
> > +use stateless steering mechanisms before resorting to stateful ones.
> > +
> > +As an example of applying this strategy, consider an application
> > that
> > +creates four threads where each threads creates a TCP listener
> > socket
> > +for some port that is shared amongst the threads via SO_REUSEPORT.
> > +Four global queues can be assigned to the application (via a cgroup
> > +for the application), and a filter rule can be set up in each device
> > +that matches the listener port and any bound destination address.
> > The
> > +filter maps to a set of four device queues that map to the four
> > global
> > +queues for the application. When a packet is received that matches
> > the
> > +filter, one of the four queues is chosen via a hash over the
> > packet's
> > +four tuple. So in this manner, packets for the application are
> > +distributed amongst the four threads. As long as processing for
> > sockets
> > +doesn't move between threads and the number of listener threads is
> > +constant then packets are always received on the desired queue and
> > no
> > +flow state needs to be instantiated. In practice, we want to allow
> > +elasticity in applications to create and destroy threads on demand,
> > so
> > +additional techniques, such as consistent hashing, are probably
> > needed.
> > +
> > +Per Thread Queues Configuration
> > +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > +
> > +Per Thread Queues is only available if the kernel is compiled with
> > +CONFIG_PER_THREAD_QUEUES. For PTQ in the receive path, aRFS needs to
> > be
> > +supported and configured (see aRFS section above).
> > +
> > +The net_queues cgroup controller is in:
> > +     /sys/fs/cgroup/<cgrp>/net_queues
> > +
> > +The net_queues controller contains the following attributes:
> > +     - tx-queues, rx-queues
> > +             Specifies the transmit queue pool and receive queue
> > pool
> > +             respectively as a range of global queue indices. The
> > +             format of these entries is "<base>:<extent>" where
> > +             <base> is the first queue index in the pool, and
> > +             <extent> is the number of queues in the range of pool.
> > +             If <extent> is zero the queue pool is empty.
> > +     - tx-assign,rx-assign
> > +             Boolean attributes ("0" or "1") that indicate unique
> > +             queue assignment from the respective transmit or
> > receive
> > +             queue pool. When the "assign" attribute is enabled, a
> > +             thread is assigned a queue that is not already assigned
> > +             to another thread.
> > +     - symmetric
> > +             A boolean attribute ("0" or "1") that indicates the
> > +             receive and transmit queue assignment for a thread
> > +             should be the same. That is the assigned transmit queue
> > +             index is equal to the assigned receive queue index.
> > +     - task-queues
> > +             A read-only attribute that lists the threads of the
> > +             cgroup and their assigned queues.
> > +
> > +The mapping of global queues to device queues is in:
> > +
> > +  /sys/class/net/<dev>/queues/tx-<n>/global_queue_mapping
> > +     -and -
> > +  /sys/class/net/<dev>/queues/rx-<n>/global_queue_mapping
> > +
> > +A value of "none" indicates no mapping, an integer value (up to
> > +a maximum of 32,766) indicates a global queue.
> > +
> > +Suggested Configuration
> > +~~~~~~~~~~~~~~~~~~~~~~
> > +
> > +Unlike aRFS, PTQ requires per application application configuration.
> > To
> > +most effectively use PTQ some understanding of the threading model
> > of
> > +the application is warranted. The section above describes one
> > possible
> > +configuration strategy for a canonical application using
> > SO_REUSEPORT.
> > +
> > +
> >  Further Information
> >  ===================
> >  RPS and RFS were introduced in kernel 2.6.35. XPS was incorporated
> > into
