Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5D83FDF10
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 17:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343837AbhIAPyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 11:54:40 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:53927 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244935AbhIAPyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 11:54:39 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 363D232003C0;
        Wed,  1 Sep 2021 11:53:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 01 Sep 2021 11:53:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=UiSTps
        M3QALh0eXo4eM6pKPHSFI/8X46NXPxLbMcCTM=; b=gT0Bd5jw7ZIO4OqS+okZWf
        MhSlUmEvjQ6JRYWJkft0Mp/Rr4e0GxuAcjzWIU0TbC4p2i9bSgyHSLsIKpetZ3f0
        WFftTgXM3DHlwiwryXIJduO1d5W00pRqw8EO5zYPhaTD67IvpnhfpM8CiMCqSQiL
        Wi3GIJtjmta5yc4rsOaCSshnpL2faSSgZf35SbET2Cmb4vdyY9H++b898NjUm/e2
        NaA+5MeyOdLc1vkqFgFnq2qzk80qHOrSf8TBxus4VS3iwQwHpxu3jm659gCPxZnh
        t6Q0faR4ceIJaSpBMTyoE7rgHr10vfawhDKOSEqblCaMG6jRa+2s9D/SMg5Bg1lA
        ==
X-ME-Sender: <xms:A6IvYTfQupKB3E1wFLwzpofWBOotVd0ep5yUd4Y8cokAJOGghcuXrg>
    <xme:A6IvYZMtRj2W1yJIcuhmsTSqte-FXu9XXWWYArMHFoqOt4ScJb_lRr0itOPSUx3bD
    PRAr7G22XTDNMA>
X-ME-Received: <xmr:A6IvYcjRt5j_75DNLtyWKatHEkUdP4I0GpUbaE0Zh37_LtALGqE_uEiNtMd205qeF4baehXb0hRE-2s5R7s3S8mKaOitSw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddvfedgleefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:A6IvYU9uAUbNBQEes4hlmiwKWXklvyhLd3ZPfzGzo_sGJgPvoYaqvg>
    <xmx:A6IvYfu1zoYqWfvxIbYJ8z77KgQ-8OfIpyCZIHsSajUaMthU13SLfw>
    <xmx:A6IvYTGazQsFQhvhmrtOqwZ73zkAdVeCSFo65Ib6n3rkBGkpoXXnzQ>
    <xmx:BKIvYY9CMtRRkpAD6oJ5pgdH03VhCIjD1eHZ4OLiosgFSxwsnGl58g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 1 Sep 2021 11:53:38 -0400 (EDT)
Date:   Wed, 1 Sep 2021 18:53:34 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pshelar@nicira.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+ff8e1b9f2f36481e2efc@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/2 net] ip_gre: add validation for csum_start
Message-ID: <YS+h/tqCJJiQei+W@shredder>
References: <20210819100447.00201b26@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210821071425.512834-1-chouhan.shreyansh630@gmail.com>
 <CA+FuTSeWY-0+VtERqAxNwmHAwmarYh_HQUoF3b0wHiwAaL+h+A@mail.gmail.com>
 <YS9puVgl/exGgrr3@shredder>
 <CA+FuTSfTCufYmJg5Vum1Q-ndUYh+1P1hLecFht9Qd1-AdnHmaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSfTCufYmJg5Vum1Q-ndUYh+1P1hLecFht9Qd1-AdnHmaQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the quick reply, Willem.

On Wed, Sep 01, 2021 at 09:46:48AM -0400, Willem de Bruijn wrote:
> Thanks for the detailed report, Ido.
> 
> This is a gre tunnel device with csum/ocsum enabled, correct?

Correct.

> 
> How was this packet generated: does it come from the local stack or is
> it a custom packet injected from userspace, e.g., with a packet socket
> with vnet_hdr?

The packet is received by a physical port and injected to the kernel's
Rx path by mlxsw (which does not support checksumming). The IPv4 routing
code then forwards the packet to the GRE tunnel.

I was able to reproduce the issue using veth pairs and a packet socket
[1]. Running the reproducer with the debug patch from before, I get the
following output [2].

[1]
#!/bin/bash

ip link add name veth0 type veth peer name veth1
ip link add name veth2 type veth peer name veth3
ip link add name veth4 type veth peer name veth5

ip netns add h1
ip netns add r1
ip netns add r2
ip netns add h2

# h1
ip -n h1 link set dev lo up
ip link set dev veth0 netns h1
ip -n h1 link set dev veth0 up
ip -n h1 address add 192.0.2.1/28 dev veth0
ip -n h1 route add default via 192.0.2.2

# r1
## underlay
ip netns exec r1 sysctl -wq net.ipv4.conf.all.forwarding=1
ip -n r1 link set dev lo up
ip -n r1 address add 1.1.1.1/32 dev lo
ip link set dev veth1 netns r1
ip link set dev veth2 netns r1
ip -n r1 link set dev veth1 up
ip -n r1 link set dev veth2 up
ip -n r1 address add 192.0.2.2/28 dev veth1
ip -n r1 address add 192.0.2.17/28 dev veth2
ip -n r1 route add 2.2.2.2/32 via 192.0.2.18
## overlay
ip -n r1 tunnel add name gre2 mode gre local 1.1.1.1 remote 2.2.2.2 csum
ip -n r1 link set dev gre2 up
ip -n r1 route add 192.0.2.34/32 dev gre2

# r2
## underlay
ip netns exec r2 sysctl -wq net.ipv4.conf.all.forwarding=1
ip -n r2 link set dev lo up
ip -n r2 address add 2.2.2.2/32 dev lo
ip link set dev veth3 netns r2
ip link set dev veth4 netns r2
ip -n r2 link set dev veth3 up
ip -n r2 link set dev veth4 up
ip -n r2 address add 192.0.2.18/28 dev veth3
ip -n r2 address add 192.0.2.33/28 dev veth4
ip -n r2 route add 1.1.1.1/32 via 192.0.2.17
## overlay
ip -n r2 tunnel add name gre2 mode gre local 2.2.2.2 remote 1.1.1.1 csum
ip -n r2 link set dev gre2 up
ip -n r2 route add 192.0.2.1/32 dev gre2

# h2
ip -n h2 link set dev lo up
ip link set dev veth5 netns h2
ip -n h2 link set dev veth5 up
ip -n h2 address add 192.0.2.34/28 dev veth5
ip -n h2 route add default via 192.0.2.33

# test
dmac=$(ip -n r1 -j -p link show dev veth1 | jq -r '.[]["address"]')
ip netns exec h1 mausezahn -a own -b "$dmac" -A 192.0.2.1 -B 192.0.2.34 \
	-t udp "sp=12345,dp=54321" -p 100 -c 10 -d 1msec -q

ip -n r1 -s link show dev gre2

ip netns del h2
ip netns del r2
ip netns del r1
ip netns del h1

[2]
skb len=128 headroom=80 headlen=128 tailroom=496
mac=(80,0) net=(80,20) trans=100
shinfo(txflags=0 nr_frags=0 gso(size=0 type=0 segs=0))
csum(0x0 ip_summed=0 complete_sw=0 valid=0 level=0)
hash(0x0 sw=0 l4=0) proto=0x0800 pkttype=0 iif=16
dev name=gre2 feat=0x0x00000006401d5869
skb linear:   00000000: 45 00 00 80 00 00 00 00 fe 11 38 49 c0 00 02 01
skb linear:   00000010: c0 00 02 22 30 39 d4 31 00 6c 85 96 42 42 42 42
skb linear:   00000020: 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42
skb linear:   00000030: 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42
skb linear:   00000040: 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42
skb linear:   00000050: 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42
skb linear:   00000060: 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42
skb linear:   00000070: 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42
