Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B356923F87D
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 20:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbgHHSlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 14:41:01 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:41231 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726232AbgHHSlA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Aug 2020 14:41:00 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 6F02F15CF;
        Sat,  8 Aug 2020 14:40:59 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 08 Aug 2020 14:40:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=+6w2JwjCivTuz6fKrVJb/sI5CRJTJHFV60T1jOZTF
        sw=; b=WQhrrmFG/dnzhYxIe92BS6fP7FOcTrc9tgEQeXyU23F9A9umIFXiY9TAe
        V5Y6dWJK61FRgzTRP2eIt7q8S01vTFwNlipXck+xcIFrojH0PP6aPamMlKD6CbT6
        VVvfwLAMFS7zgfNpKa6DwlgmCK3OqMPhKK/0GR9XKBIjKWwfzXf5yJhSuY3yWDTP
        cqVUYCUj2TdFkelXB5oAnv9EkrSbDvQaz+ZdZv5wWxsvMoocOM0y8Npj3r/hPbPm
        pHjg3re6BypAzh1fNG+LrUELKtMdSNY0+P0slcUUs20W2b22ph0g3zmcs+JWZb1R
        2JtEy24fkaiTT2HIfNwjx4ORoJqwA==
X-ME-Sender: <xms:uvEuX-OThXbnEe9WGOrLYaEsEFdO36lCAldEaHK-OacK-PbVG6hjDg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrkeeggddutdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtjeenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepffegheeufffgfeetuddvgfetkeevffejhfeggfffgedtveejueekiedvtdev
    geetnecuffhomhgrihhnpegtuhhmuhhluhhsnhgvthifohhrkhhsrdgtohhmnecukfhppe
    ejledrudekvddrieefrdegvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhep
    mhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:uvEuX88F-PBGVX1zAeUogNDVP7txTS53b_YcdcVL31EIzPpMKkgY0g>
    <xmx:uvEuX1TLBkPzBTWqW1rxgGlm4jO8YSzfSfn_g5SvoCuIS8J61uBEfw>
    <xmx:uvEuX-t25TK8LMKVI0ML-Ub5Se3TZNf1WeahHmAXdU150hjkuu4S_A>
    <xmx:u_EuX4qDQ_PuJQpvjTFJX27acEun-Ja6W-hlHrDAlvEh-91irdkUmg>
Received: from localhost (bzq-79-182-63-42.red.bezeqint.net [79.182.63.42])
        by mail.messagingengine.com (Postfix) with ESMTPA id 238B0306005F;
        Sat,  8 Aug 2020 14:40:58 -0400 (EDT)
Date:   Sat, 8 Aug 2020 21:40:50 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Yi Yang =?utf-8?B?KOadqOeHmikt5LqR5pyN5Yqh6ZuG5Zui?= 
        <yangyi01@inspur.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>
Subject: Re: =?utf-8?B?562U5aSNOiBbUEFUQ0hdIGNhbiBj?= =?utf-8?Q?urren?=
 =?utf-8?Q?t?= ECMP implementation support consistent hashing for next hop?
Message-ID: <20200808184050.GA2801845@shredder>
References: <4037f805c6f842dcc429224ce28425eb@sslemail.net>
 <8ff0c684-7d33-c785-94d7-c0e6f8b79d64@gmail.com>
 <8867a00d26534ed5b84628db1a43017c@inspur.com>
 <8da839b3-5b5d-b663-7d9c-0bc8351980dd@gmail.com>
 <20200802144959.GA2483264@shredder>
 <3c965294-fe7d-3893-e9d9-3354ff508731@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3c965294-fe7d-3893-e9d9-3354ff508731@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 06, 2020 at 10:45:52AM -0600, David Ahern wrote:
> On 8/2/20 8:49 AM, Ido Schimmel wrote:
> > On Thu, Jun 11, 2020 at 10:36:59PM -0600, David Ahern wrote:
> >> On 6/11/20 6:32 PM, Yi Yang (杨燚)-云服务集团 wrote:
> >>> David, thank you so much for confirming it can't, I did read your cumulus document before, resilient hashing is ok for next hop remove, but it still has the same issue there if add new next hop. I know most of kernel code in Cumulus Linux has been in upstream kernel, I'm wondering why you didn't push resilient hashing to upstream kernel.
> >>>
> >>> I think consistent hashing is must-have for a commercial load balancing solution, otherwise it is basically nonsense , do you Cumulus Linux have consistent hashing solution?
> >>>
> >>> Is "- replacing nexthop entries as LB's come and go" ithe stuff https://docs.cumulusnetworks.com/cumulus-linux/Layer-3/Equal-Cost-Multipath-Load-Sharing-Hardware-ECMP/#resilient-hashing is showing? It can't ensure the flow is distributed to the right backend server if a new next hop is added.
> >>
> >> I do not believe it is a problem to be solved in the kernel.
> >>
> >> If you follow the *intent* of the Cumulus document: what is the maximum
> >> number of load balancers you expect to have? 16? 32? 64? Define an ECMP
> >> route with that number of nexthops and fill in the weighting that meets
> >> your needs. When an LB is added or removed, you decide what the new set
> >> of paths is that maintains N-total paths with the distribution that
> >> meets your needs.
> > 
> > I recently started looking into consistent hashing and I wonder if it
> > can be done with the new nexthop API while keeping all the logic in user
> > space (e.g., FRR).
> > 
> > The only extension that might be required from the kernel is a new
> > nexthop attribute that indicates when a nexthop was last recently used.
> 
> The only potential problem that comes to mind is that a nexthop can be
> used by multiple prefixes.

Yes. The key point is that for resilient hashing a nexthop ID no longer
represents a logical nexthop (dev + gw), but rather a hash bucket. User
space determines how many buckets there are in a group (e.g., 256) and
how logical nexthops are assigned to them.

> 
> But, I'm not sure I follow what the last recently used indicator gives
> you for maintaining flows as a group is updated.

When adding a nexthop to a group the goal is to do it in a way that
minimizes the impact on existing flows. Therefore, you want to avoid
assigning the nexthop to buckets that are active. After a certain time
of bucket inactivity user space can "safely" perform the replacement.
See description of this knob in Cumulus documentation:

```
resilient_hash_active_timer: A timer that protects TCP sessions from being
disrupted while attempting to populate new next hops. You specify the number of
seconds when at least one hash bucket consistently sees no traffic before
Cumulus Linux rebalances the flows; the default is 120 seconds. If any one
bucket is idle; that is, it sees no traffic for the defined period, the next
new flow utilizes that bucket and flows to the new link. Thus, if the network
is experiencing a large number of flows or very consistent or persistent flows,
there may not be any buckets remaining idle for a consistent 120 second period,
and the imbalance remains until that timer has been met. If a new link is
brought up and added back to a group during this time, traffic does not get
allocated to utilize it until a bucket qualifies as empty, meaning it has been
idle for 120 seconds. This is when a rebalance can occur.
```

Currently, user space does not have this activity information.

I'm saying "safely" because by the time user space decides to perform
the replacement it is possible that the bucket became active again. In
this case it is possible for the kernel / hardware to reject the
replacement. How such an atomic replacement is communicated to the
kernel will determine how the activity information should be exposed.

Option 1:

A new nexthop flag (RTNH_F_ACTIVE ?). For example:

id 1 via 2.2.2.2 dev dummy_b scope link active

User space can periodically query the kernel and clear the activity. For
example:

ip nexthop list_clear

To communicate an atomic replacement:

ip nexthop replace atomic id 3 via 2.2.2.2 dev dummy_b

Option 2:

Add a new 'used' attribute that encodes time since the bucket was last
used. For example:

ip -s nexthop show id 1
id 1 via 2.2.2.2 dev dummy_b scope link used 5

User space will cache it and use it to perform an atomic replacement:

ip nexthop replace used 5 id 3 via 2.2.2.2 dev dummy_b

The kernel will compare its current used time with the value specified
by user space. If current value is smaller, reject the replacement.

> 
> > User space can then use it to understand which nexthops to replace when
> > a new nexthop is added and when to perform the replacement. In case the
> > nexthops are offloaded, it is possible for the driver to periodically
> > update the nexthop code about their activity.
> > 
> > Below is a script that demonstrates the concept with the example in the
> > Cumulus documentation. I chose to replace the individual nexthops
> > instead of creating new ones and then replacing the group.
> 
> That is one of the features ... a group points to individual nexthops
> and those can be atomically updated without affecting the group.
> 
> > 
> > It is obviously possible to create larger groups to reduce the impact on
> > existing flows when a new nexthop is added.
> > 
> > WDYT?
> 
> This is inline with my earlier responses, and your script shows an
> example of how to manage it. Combine it with the active-backup patch set
> and you handle device events too (avoid disrupting size of the group on
> device events).

Yes, correct. I rebased your active-backup patches on top of net-next,
salvaged the iproute2 patches from your github and updated the example
script:

```
#!/bin/bash

### Setup ####

IP="ip -n testns"

ip netns add testns

$IP link add name dummy_a up type dummy
$IP link add name dummy_b up type dummy
$IP link add name dummy_c up type dummy
$IP link add name dummy_d up type dummy
$IP link add name dummy_e up type dummy

$IP route add 1.1.1.0/24 dev dummy_a
$IP route add 2.2.2.0/24 dev dummy_b
$IP route add 3.3.3.0/24 dev dummy_c
$IP route add 4.4.4.0/24 dev dummy_d
$IP route add 5.5.5.0/24 dev dummy_e

### Initial nexthop configuration ####
# According to:
# https://docs.cumulusnetworks.com/cumulus-linux-42/Layer-3/Equal-Cost-Multipath-Load-Sharing-Hardware-ECMP/#resilient-hash-buckets

# First sub-group

$IP nexthop replace id 1 via 1.1.1.1 dev dummy_a
$IP nexthop replace id 2 via 2.2.2.2 dev dummy_b
$IP nexthop replace id 101 group 1/2 active-backup

$IP nexthop replace id 3 via 2.2.2.2 dev dummy_b
$IP nexthop replace id 4 via 1.1.1.1 dev dummy_a
$IP nexthop replace id 102 group 3/4 active-backup

$IP nexthop replace id 5 via 3.3.3.3 dev dummy_c
$IP nexthop replace id 6 via 1.1.1.1 dev dummy_a
$IP nexthop replace id 103 group 5/6 active-backup

$IP nexthop replace id 7 via 4.4.4.4 dev dummy_d
$IP nexthop replace id 8 via 1.1.1.1 dev dummy_a
$IP nexthop replace id 104 group 7/8 active-backup

# Second sub-group

$IP nexthop replace id 9 via 1.1.1.1 dev dummy_a
$IP nexthop replace id 10 via 3.3.3.3 dev dummy_c
$IP nexthop replace id 105 group 9/10 active-backup

$IP nexthop replace id 11 via 2.2.2.2 dev dummy_b
$IP nexthop replace id 12 via 3.3.3.3 dev dummy_c
$IP nexthop replace id 106 group 11/12 active-backup

$IP nexthop replace id 13 via 3.3.3.3 dev dummy_c
$IP nexthop replace id 14 via 2.2.2.2 dev dummy_b
$IP nexthop replace id 107 group 13/14 active-backup

$IP nexthop replace id 15 via 4.4.4.4 dev dummy_d
$IP nexthop replace id 16 via 2.2.2.2 dev dummy_b
$IP nexthop replace id 108 group 15/16 active-backup

# Third sub-group

$IP nexthop replace id 17 via 1.1.1.1 dev dummy_a
$IP nexthop replace id 18 via 4.4.4.4 dev dummy_d
$IP nexthop replace id 109 group 17/18 active-backup

$IP nexthop replace id 19 via 2.2.2.2 dev dummy_b
$IP nexthop replace id 20 via 4.4.4.4 dev dummy_d
$IP nexthop replace id 110 group 19/20 active-backup

$IP nexthop replace id 21 via 3.3.3.3 dev dummy_c
$IP nexthop replace id 22 via 4.4.4.4 dev dummy_d
$IP nexthop replace id 111 group 21/22 active-backup

$IP nexthop replace id 23 via 4.4.4.4 dev dummy_d
$IP nexthop replace id 24 via 3.3.3.3 dev dummy_c
$IP nexthop replace id 112 group 23/24 active-backup

$IP nexthop replace id 10001 \
	group 101/102/103/104/105/106/107/108/109/110/111/112

echo
echo "Initial state:"
echo
$IP nexthop show

### Nexthop B is removed ###
# According to:
# https://docs.cumulusnetworks.com/cumulus-linux-42/Layer-3/Equal-Cost-Multipath-Load-Sharing-Hardware-ECMP/#remove-next-hops

$IP link set dev dummy_b carrier off

echo
echo "After nexthop B was removed:"
echo
$IP nexthop show

### Initial state restored ####

$IP link set dev dummy_b carrier on

$IP nexthop replace id 2 via 2.2.2.2 dev dummy_b
$IP nexthop replace id 101 group 1/2 active-backup

$IP nexthop replace id 3 via 2.2.2.2 dev dummy_b
$IP nexthop replace id 102 group 3/4 active-backup

$IP nexthop replace id 11 via 2.2.2.2 dev dummy_b
$IP nexthop replace id 106 group 11/12 active-backup

$IP nexthop replace id 14 via 2.2.2.2 dev dummy_b
$IP nexthop replace id 107 group 13/14 active-backup

$IP nexthop replace id 16 via 2.2.2.2 dev dummy_b
$IP nexthop replace id 108 group 15/16 active-backup

# Third sub-group

$IP nexthop replace id 19 via 2.2.2.2 dev dummy_b
$IP nexthop replace id 110 group 19/20 active-backup

$IP nexthop replace id 23 via 4.4.4.4 dev dummy_d
$IP nexthop replace id 112 group 23/24 active-backup

echo
echo "After intial state was restored:"
echo
$IP nexthop show

### Nexthop E is added ####
# According to:
# https://docs.cumulusnetworks.com/cumulus-linux-42/Layer-3/Equal-Cost-Multipath-Load-Sharing-Hardware-ECMP/#add-next-hops

# Nexthop 3, 9, 15 are active. Replace in a way that minimizes interruptions.
$IP nexthop replace id 1 via 2.2.2.2 dev dummy_b
$IP nexthop replace id 3 via 3.3.3.3 dev dummy_c
$IP nexthop replace id 5 via 4.4.4.4 dev dummy_d
$IP nexthop replace id 7 via 5.5.5.5 dev dummy_e
# Nexthop 9 remains the same
# Nexthop 11 remains the same
# Nexthop 13 remains the same
# Nexthop 15 remains the same
$IP nexthop replace id 17 via 5.5.5.5 dev dummy_e
$IP nexthop replace id 19 via 1.1.1.1 dev dummy_a
$IP nexthop replace id 21 via 2.2.2.2 dev dummy_b
$IP nexthop replace id 23 via 3.3.3.3 dev dummy_c

echo
echo "After nexthop E was added:"
echo
$IP nexthop show

ip netns del testns
```
