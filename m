Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4692C28CB0C
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 11:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404082AbgJMJbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 05:31:02 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:38005 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390610AbgJMJbB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 05:31:01 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 372775C0176;
        Tue, 13 Oct 2020 03:49:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 13 Oct 2020 03:49:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=uhH87S
        uTLwOmdGo6Xi0xwbBFluQnKQd4OEMd3TyQekg=; b=ZT8338diSaZTy3nWjOtXFm
        5e7uPFLV5eyVQFN8EAszAR6jQRnLVomA3k1MkiALGE6rP0NoSjEHq7q7BibR1jz2
        LpBEetHdTXU5RU2ElXCZCBZf/aDTpqJp/IDLN5x0A0FglBP4Exmec4xOKi4q0ttC
        NwMQyF18hn1ZoMHS2OXy6TTaelApRu9yHgvZLa99aHAHfvJYsptIuIIM94oNx5KQ
        9f76xq0+97pk5Rhrnn9RLALwDRMutaNA2p26qfG22S5qas5rbIJdOUlUQ7908NB9
        +5NscNN7b1JjDwfk6Dkfd/WYyUB1ZLOGHOYM8CFqlM8fo8PZjsYyrt06yoJ/4Y3g
        ==
X-ME-Sender: <xms:DFyFX5dxvvn241B8f41-FtfR7u8_Nqes_rezcyHJh_p2jRxryQ4eYQ>
    <xme:DFyFX3MjTmFhakUpOBomEZh3wb0v2JCSYNE3YOZaqSvkjt7hlzGXiEq3PY6ro3JAl
    gszIMY-A4qaaSE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrheekgdduvdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdefjedrudegkeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:DFyFXyjCggHJ9OxcZjgZpWtrKrkJT2qVflxB8gd4dUc73L_qUqwChQ>
    <xmx:DFyFXy8H4BCP3VSm6cshRJAIc_qQu5CxWTLmnIcZAk0JPVwd2-ZcAw>
    <xmx:DFyFX1sNbxM5_INAuqKGriYKko1jqJkBBjNB366FvSSvBZ3aQXZzRw>
    <xmx:DVyFXz38hnj8hBD4Ds4xEpEV_AR7EifuJ3vNQOFIVuqE3w-O7kmtnA>
Received: from localhost (igld-84-229-37-148.inter.net.il [84.229.37.148])
        by mail.messagingengine.com (Postfix) with ESMTPA id 80B57328005E;
        Tue, 13 Oct 2020 03:49:32 -0400 (EDT)
Date:   Tue, 13 Oct 2020 10:49:30 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Ido Schimmel <idosch@mellanox.com>,
        Network Development <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>
Subject: Re: vxlan_asymmetric.sh test failed every time
Message-ID: <20201013074930.GA4024934@shredder>
References: <20201013043943.GL2531@dhcp-12-153.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201013043943.GL2531@dhcp-12-153.nay.redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 13, 2020 at 12:39:43PM +0800, Hangbin Liu wrote:
> Hi Ido,
> 
> When run vxlan_asymmetric.sh on RHEL8, It failed every time. I though that
> it may failed because the kernel version is too old. But today I tried with
> latest kernel, it still failed. Would you please help check if I missed
> any configuration?

Works OK for me:

$ sudo ./vxlan_asymmetric.sh veth0 veth1 veth2 veth3 veth4 veth5
TEST: ping: local->local vid 10->vid 20                             [ OK ]
TEST: ping: local->remote vid 10->vid 10                            [ OK ]
TEST: ping: local->remote vid 20->vid 20                            [ OK ]
TEST: ping: local->remote vid 10->vid 20                            [ OK ]
TEST: ping: local->remote vid 20->vid 10                            [ OK ]
INFO: deleting neighbours from vlan interfaces
TEST: ping: local->local vid 10->vid 20                             [ OK ]
TEST: ping: local->remote vid 10->vid 10                            [ OK ]
TEST: ping: local->remote vid 20->vid 20                            [ OK ]
TEST: ping: local->remote vid 10->vid 20                            [ OK ]
TEST: ping: local->remote vid 20->vid 10                            [ OK ]
TEST: neigh_suppress: on / neigh exists: yes                        [ OK ]
TEST: neigh_suppress: on / neigh exists: no                         [ OK ]
TEST: neigh_suppress: off / neigh exists: no                        [ OK ]
TEST: neigh_suppress: off / neigh exists: yes                       [ OK ]

# uname -r
5.9.0-rc8-custom-36808-gccdf7fae3afa

# ip -V
ip utility, iproute2-5.8.0

# netsniff-ng -v
netsniff-ng 0.6.7 (Polygon Window), Git id: (none)

The first failure might be related to your rp_filter settings. Can you
please try with this patch?

diff --git a/tools/testing/selftests/net/forwarding/vxlan_asymmetric.sh b/tools/testing/selftests/net/forwarding/vxlan_asymmetric.sh
index a0b5f57d6bd3..0727e2012b68 100755
--- a/tools/testing/selftests/net/forwarding/vxlan_asymmetric.sh
+++ b/tools/testing/selftests/net/forwarding/vxlan_asymmetric.sh
@@ -215,10 +215,16 @@ switch_create()
 
        bridge fdb add 00:00:5e:00:01:01 dev br1 self local vlan 10
        bridge fdb add 00:00:5e:00:01:01 dev br1 self local vlan 20
+
+       sysctl_set net.ipv4.conf.all.rp_filter 0
+       sysctl_set net.ipv4.conf.vlan10-v.rp_filter 0
+       sysctl_set net.ipv4.conf.vlan20-v.rp_filter 0
 }
 
 switch_destroy()
 {
+       sysctl_restore net.ipv4.conf.all.rp_filter
+
        bridge fdb del 00:00:5e:00:01:01 dev br1 self local vlan 20
        bridge fdb del 00:00:5e:00:01:01 dev br1 self local vlan 10
 
@@ -359,6 +365,10 @@ ns_switch_create()
 
        bridge fdb add 00:00:5e:00:01:01 dev br1 self local vlan 10
        bridge fdb add 00:00:5e:00:01:01 dev br1 self local vlan 20
+
+       sysctl_set net.ipv4.conf.all.rp_filter 0
+       sysctl_set net.ipv4.conf.vlan10-v.rp_filter 0
+       sysctl_set net.ipv4.conf.vlan20-v.rp_filter 0
 }
 export -f ns_switch_create

> 
> # uname -r
> 5.9.0
> # ip -V
> ip utility, iproute2-ss200602
> # netsniff-ng -v
> netsniff-ng 0.6.6 (Syro), Git id: (none)
> # cp forwarding.config.sample forwarding.config
> 
> # ./vxlan_asymmetric.sh
> RTNETLINK answers: File exists
> TEST: ping: local->local vid 10->vid 20                             [FAIL]
> TEST: ping: local->remote vid 10->vid 10                            [ OK ]
> TEST: ping: local->remote vid 20->vid 20                            [ OK ]
> TEST: ping: local->remote vid 10->vid 20                            [FAIL]
> TEST: ping: local->remote vid 20->vid 10                            [FAIL]
> INFO: deleting neighbours from vlan interfaces
> TEST: ping: local->local vid 10->vid 20                             [FAIL]
> TEST: ping: local->remote vid 10->vid 10                            [ OK ]
> TEST: ping: local->remote vid 20->vid 20                            [ OK ]
> TEST: ping: local->remote vid 10->vid 20                            [FAIL]
> TEST: ping: local->remote vid 20->vid 10                            [FAIL]
> TEST: neigh_suppress: on / neigh exists: yes                        [ OK ]
> TEST: neigh_suppress: on / neigh exists: no                         [ OK ]
> TEST: neigh_suppress: off / neigh exists: no                        [ OK ]
> TEST: neigh_suppress: off / neigh exists: yes                       [ OK ]
> 
> # dmesg
> [...snip...]
> [ 1518.885526] device br1 entered promiscuous mode
> [ 1518.886211] device br1 left promiscuous mode
> [ 1518.890637] device br1 entered promiscuous mode
> [ 1518.941524] br1: received packet on vx10 with own address as source address (addr:00:00:5e:00:01:01, vlan:10)
> [ 1518.949522] br1: received packet on vx10 with own address as source address (addr:00:00:5e:00:01:01, vlan:10)
> [ 1519.165569] br1: received packet on vx10 with own address as source address (addr:00:00:5e:00:01:01, vlan:10)
> [ 1519.166900] IPv6: vlan10-v: IPv6 duplicate address fe80::200:5eff:fe00:101 used by 00:00:5e:00:01:01 detected!
> [ 1519.392633] br1: received packet on vx20 with own address as source address (addr:00:00:5e:00:01:01, vlan:20)
> [ 1519.741559] br1: received packet on vx20 with own address as source address (addr:00:00:5e:00:01:01, vlan:20)
> [ 1519.861641] br1: received packet on vx20 with own address as source address (addr:00:00:5e:00:01:01, vlan:20)
> [ 1519.862993] IPv6: vlan20-v: IPv6 duplicate address fe80::200:5eff:fe00:101 used by 00:00:5e:00:01:01 detected!
> [ 1520.181565] br1: received packet on vx10 with own address as source address (addr:00:00:5e:00:01:01, vlan:10)
> [ 1520.182739] br1: received packet on vx10 with own address as source address (addr:00:00:5e:00:01:01, vlan:10)
> [ 1524.853572] net_ratelimit: 4 callbacks suppressed
> [ 1524.854346] br1: received packet on vx10 with own address as source address (addr:00:00:5e:00:01:01, vlan:10)
> [ 1525.365565] br1: received packet on vx20 with own address as source address (addr:00:00:5e:00:01:01, vlan:20)
> [ 1533.557792] br1: received packet on vx10 with own address as source address (addr:00:00:5e:00:01:01, vlan:10)
> [ 1534.069921] br1: received packet on vx20 with own address as source address (addr:00:00:5e:00:01:01, vlan:20)
> [ 1550.965225] br1: received packet on vx20 with own address as source address (addr:00:00:5e:00:01:01, vlan:20)
> [ 1551.477294] br1: received packet on vx10 with own address as source address (addr:00:00:5e:00:01:01, vlan:10)
> [ 1558.064257] device w3 left promiscuous mode
> [ 1558.073279] br1: port 4(w3) entered disabled state
> [...snip...]
> 
> Thanks
> Hangbin
