Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9CC29CBFA
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 23:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506379AbgJ0WcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 18:32:09 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:45147 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2506023AbgJ0WcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 18:32:08 -0400
Received: by mail-ed1-f65.google.com with SMTP id dg9so3096812edb.12
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 15:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=H2+tc+YfU+UH8ZxbTBaHNnfM3lc/GGaRiH2sH+hCYBE=;
        b=q//K56fluCZaSNJPJZYjCneUzASYEGKZ5T5AEAlbewNSm6KVmJKiMbEmiP2ciaU/xS
         YtG0Zo88PwzKLv0yqpNG5GxDEFrUd0KTKO+F9ayTf8sD4PhRg56nt20PfGRv9tc0P4Wn
         RbWXFgGzw41UJF+BTLaeapYTW+eyjalSRWatpJvtK6k3tSCcbLpymSpoPlaVOVDIo0pu
         UTm4NWijZTDXKdDs0Th1untncy73jChywOvqpWG6/x4edm9smuButzE2E+cP2xt5ATuf
         JRscao59xJHnnQi9WJqiWak/8TehWFAnzLWMFpStOVdGDOreEAa2p8Q2RwDsuic1HBnK
         p2qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=H2+tc+YfU+UH8ZxbTBaHNnfM3lc/GGaRiH2sH+hCYBE=;
        b=qQeRwZZdKD0e0AOnnJrs0py7ep9R+gcpQuUlBXxvVoGd/Td10EplaIoUIpTXf7SleR
         GKV+StZVGnSEeDbMAqVEFr8Jn7WzE4IzYAHqCUoSyZqkJ6jgeYqWZOmn9uhMt8sECpX7
         3LRel42xFpXtX0UwLDYaTWLcYF4uLhwXB85uUbDjGVj4iNkwSFD5PgLZui4ndHFLFepC
         pmhGSPfEpPEap+SESaxFzPItTyPsD2mlyas/9Kh7GprDQHOICD0X+nTvM2T3sZyTVSy1
         McPER1UXOexuL6tqh366pgTinuNtJA9CTN+VwOgQ/cdD2CTX0KDubOWnaWHf9r3WFryn
         of6Q==
X-Gm-Message-State: AOAM531Xv1A1KAZmnNaZarvdLLb4nfD+RO7DgUz9JH5hl1spbzuGJewU
        DXoO7+XnctoXa8j/SgzhtSc=
X-Google-Smtp-Source: ABdhPJwbH56yzN1NBGAFdt8gre6hA+B2EdeVozG0hNcES3Yz2kJId1Ox3lWGyyffS/vTU5t5Xd9PDw==
X-Received: by 2002:a50:f749:: with SMTP id j9mr4518680edn.376.1603837926556;
        Tue, 27 Oct 2020 15:32:06 -0700 (PDT)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id v10sm565126ejk.101.2020.10.27.15.32.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 15:32:06 -0700 (PDT)
Date:   Wed, 28 Oct 2020 00:32:05 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Marek Behun <marek.behun@nic.cz>,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] net: dsa: link aggregation support
Message-ID: <20201027223205.bhwb7sl33cnr5glq@skbuf>
References: <20201027105117.23052-1-tobias@waldekranz.com>
 <20201027160530.11fc42db@nic.cz>
 <20201027152330.GF878328@lunn.ch>
 <87k0vbv84z.fsf@waldekranz.com>
 <20201027190034.utk3kkywc54zuxfn@skbuf>
 <87blgnv4rt.fsf@waldekranz.com>
 <20201027200220.3ai2lcyrxkvmd2f4@skbuf>
 <878sbrv19i.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878sbrv19i.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 09:53:45PM +0100, Tobias Waldekranz wrote:
> So all FROM_CPU packets to a given device/port will always travel
> through the same set of ports.

Ah, this is the part that didn't click for me.
For the simple case where you have a multi-CPU port system:

                     Switch 0
                   +--------------------------------+
DSA master #1      |CPU port #1                     |
   +------+        +------+                 +-------+
   | eth0 | ---->  |      | -----\    ----- | sw0p0 | ------>
   +------+        +------+       \  /      +-------+
                   |               \/               |
 DSA master #2     |CPU port #2    /\               |
   +------+        +------+       /  \      +-------|
   | eth1 | ---->  |      | -----/    \-----| sw0p1 | ------>
   +------+        +------+                 +-------+
                   |                                |
                   +--------------------------------+

you can have Linux do load balancing of CPU ports on TX for many streams
being delivered to the same egress port (sw0p0).

But if you have a cascade:

                     Switch 0                                 Switch 1
                   +--------------------------------+       +--------------------------------+
DSA master #1      |CPU port #1         DSA link #1 |       |DSA link #1                     |
   +------+        +------+                 +-------+       +------+                 +-------+
   | eth0 | ---->  |      | -----\    ----- |       | ----> |      | -----\    ----- | sw1p0 | ---->
   +------+        +------+       \  /      +-------+       +------+       \  /      +-------+
                   |               \/               |       |               \/               |
 DSA master #2     |CPU port #2    /\   DSA link #2 |       |DSA link #2    /\               |
   +------+        +------+       /  \      +-------|       +------+       /  \      +-------|
   | eth1 | ---->  |      | -----/    \-----|       | ----> |      | -----/    \-----| sw1p1 | ---->
   +------+        +------+                 +-------+       +------+                 +-------+
                   |                                |       |                                |
                   +--------------------------------+       +--------------------------------+

then you have no good way to spread the same load (many streams all
delivered to the same egress port, sw1p0) between DSA link #1 and DSA
link #2. DSA link #1 will get congested, while DSA link #2 will remain
unused.

And this all happens because for FROM_CPU packets, the hardware is
configured in mv88e6xxx_devmap_setup to deliver all packets with a
non-local switch ID towards the same "routing" port, right?

Whereas for FORWARD frames, the destination port for non-local switch ID
will not be established based on mv88e6xxx_devmap_setup, but based on
FDB lookup of {DMAC, VID}. In the second case above, this is the only
way for your hardware that the FDB could select the LAG as the
destination based on the FDB. Then, the hash code would be determined
from the packet, and the appropriate egress port within the LAG would be
selected.

So, to answer my own question:
Q: What does using FORWARD frames to offload TX flooding from the bridge
   have to do with a LAG between 2 switches?
A: Nothing, they would just both need FORWARD frames to be used.

> > Why don't you attempt to solve this more generically somehow? Your
> > switch is not the only one that can't perform source address learning
> > for injected traffic, there are tons more, some are not even DSA. We
> > can't have everybody roll their own solution.
> 
> Who said anything about rolling my solution? I'm going for a generic
> solution where a netdev can announce to the bridge it is being added to
> that it can offload forwarding of packets for all ports belonging to the
> same switchdev device. Most probably modeled after how the macvlan
> offloading stuff is done.

The fact that I have no idea how the macvlan offloading is done does not
really help me, but here, the fact that I understood nothing doesn't
appear to stem from that.

"a netdev can announce to the bridge it is being added to that it can
offload forwarding of packets for all ports belonging to the same
switchdev device"

What do you mean? skb->offload_fwd_mark? Or are you still talking about
its TX-side equivalent here, which is what we've been talking about in
these past few mails? If so, I'm confused by you calling it "offload
forwarding of packets", I was expecting a description more in the lines
of "offload flooding of packets coming from host" or something like
that.

> In the case of mv88e6xxx that would kill two birds with one stone -
> great! In other cases you might have to have the DSA subsystem listen to
> new neighbors appearing on the bridge and sync those to hardware or
> something. Hopefully someone working with that kind of hardware can
> solve that problem.

If by "neighbors" you mean that you bridge a DSA swp0 with an e1000
eth0, then that is not going to be enough. The CPU port of swp0 will
need to learn not eth0's MAC address, but in fact the MAC address of all
stations that might be connected to eth0. There might even be a network
switch connected to eth0, not just a directly connected link partner.
So there are potentially many MAC addresses to be learnt, and all are
unknown off-hand.
I admit I haven't actually looked at implementing this, but I would
expect that what needs to be done is that the local (master) FDB of the
bridge (which would get populated on the RX side of the "foreign
interface" through software learning) would need to get offloaded in its
entirety towards all switchdev ports, via a new switchdev "host FDB"
object or something of that kind (where a "host FDB" entry offloaded on
a port would mean "see this {DMAC, VID} pair? send it to the CPU").

With your FORWARD frames life-hack you can eschew all of that, good for
you. I was just speculatively hoping you might be interested in tackling
the hard way.

Anyway, this discussion has started mixing up basic stuff (like
resolving your source address learning issue on the CPU port, when
bridged with a foreign interface) with advanced / optimization stuff
(LAG, offload flooding from host), the only commonality appearing to be
a need for FORWARD frames. Can you even believe we are still commenting
on a series about something as mundane as link aggregation on DSA user
ports? At least I can't. I'll go off and start reviewing your patches,
before we manage to lose everybody along the way.
