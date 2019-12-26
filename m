Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEE3A12AB34
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 10:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbfLZJWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 04:22:43 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:53001 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726109AbfLZJWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 04:22:42 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id DFCC721E92;
        Thu, 26 Dec 2019 04:22:41 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 26 Dec 2019 04:22:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=REY1eMqJRyUQSySLSqDXj/GrwvD64dndyl60EcO76
        Y8=; b=AdR3nSjb2FJZIrejCponSJZTNkpWmH1RbaoR/bAwrRXQMOg9l2idzEBvB
        nKngqhvEMqhPG42SQEIG48O15KDLveREIjchBs+ZfI98NVUQdXtoW4kBt6b/QWgw
        6tn1IQLwbFoi7dlRZwGLzIXiTTM+tIjNPbkQa+yFoxlWZ/NloWPDB6tzfJmRa/30
        QlgJ2UhCV+KVfEp622oCSKV2y2U0D1MNpt3sV7s4PFph9+kpbIMY191xQhY+mlx7
        fup3mHANn+sbtlNLB8MkXNqOPcO1tp5gVSba7qwGtdQ0F4z8Q3S8+vwQqoekBbz3
        oUcNzyt1K04oHtvh0EgSAk2LC3Q+Q==
X-ME-Sender: <xms:4HsEXg7j0ZRVKLDR4b1-0SycasaKwlNKt8Q6qrBYQp2QjNoOLmEHgA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddviedgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggugfgjsehtke
    ertddttddunecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucffohhmrghinhepghhithhhuhgsrdgtohhmnecukfhppedule
    efrdegjedrudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghh
    sehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:4HsEXpKOuyuvKr0OYkufUKgkHzE3llVft0nDnkXeLA__pWDGs7jdCg>
    <xmx:4HsEXqUnC1x03rtyb8c7ht_-7E72ktl4MPGQMmv-DFlz9yr0jXhCNg>
    <xmx:4HsEXlGn5PeXDag3q-eS7I2hcsOALkFywj0PcM93VYqdY3iNRyKlbw>
    <xmx:4XsEXrE1EkedTD0jIOrKxEB7pVWyXslNEljQPhENGl5JxNSZHsOwkA>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7486480059;
        Thu, 26 Dec 2019 04:22:40 -0500 (EST)
Date:   Thu, 26 Dec 2019 11:22:38 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     wenxu <wenxu@ucloud.cn>
Cc:     netdev@vger.kernel.org, mlxsw@mellanox.com
Subject: Re: Problem about gre tunnel route offload in mlxsw
Message-ID: <20191226092238.GA35973@splinter>
References: <1577267303-24780-1-git-send-email-wenxu@ucloud.cn>
 <6ed792a4-6f64-fe57-4e1e-215bfa701ccf@ucloud.cn>
 <20191225.195000.1150683636639114235.davem@davemloft.net>
 <8bb9cc6b-bda1-5808-d88c-6e33076ac264@ucloud.cn>
 <20191226074914.GA30900@splinter>
 <ca6e27e4-8bec-8591-9bab-d411649d1834@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ca6e27e4-8bec-8591-9bab-d411649d1834@ucloud.cn>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 26, 2019 at 04:22:48PM +0800, wenxu wrote:
> 
> On 12/26/2019 3:49 PM, Ido Schimmel wrote:
> > On Thu, Dec 26, 2019 at 01:07:33PM +0800, wenxu wrote:
> >> Hi mlxsw team,
> >>
> >>
> >> I did a route test with gre tunnel and vrf.
> >>
> >> This test under current net-next tree with following script:
> >>
> >>
> >> ifconfig enp3s0np31 up
> >> ip a a dev enp3s0np31 172.168.152.247/24
> >>
> >> ip l add dev vrf11 type vrf table 11
> >> ifconfig vrf11 up
> >> ip l set dev enp3s0np11 master vrf11
> >> ifconfig enp3s0np11 10.0.7.1/24 up
> >> ip tunnel add name gre11 mode gre local 172.168.152.247 remote 172.168.152.73 key 11 tos inherit  ttl inherit
> >> ip l set dev gre11 master vrf11
> >> ifconfig gre11 10.0.2.1/24 up
> >>
> >> ip l add dev vrf21 type vrf table 21
> >> ifconfig vrf21 up
> >> ip l set dev enp3s0np21 master vrf21
> >> ifconfig enp3s0np21 10.0.7.1/24 up
> >> ip tunnel add name gre21 mode gre local 172.168.152.247 remote 172.168.152.73 key 21 tos inherit  ttl inherit
> >> ip l set dev gre21 master vrf21
> >> ifconfig gre21 10.0.2.1/24 up
> >>
> >>
> >> If there is only one tunnel. The route rule can be offloaded. But two tunnel only with different key can't be offloaded.
> >>
> >> If I add a new address 172.168.152.248 for tunnel source and change the gre21 to
> >>
> >> "ip tunnel add name gre21 mode gre local 172.168.152.248 remote 172.168.152.73 key 21 tos inherit  ttl inherit"
> >>
> >> It's work.
> >>
> >> So it means dispatch based on tunnel key is not supported ?
> > Yes. See:
> > "No two tunnels that share underlay VRF shall share a local address
> > (i.e. dispatch based on tunnel key is not supported)"
> >
> > https://github.com/Mellanox/mlxsw/wiki/L3-Tunneling#features-and-limitations
> >
> >> It is a hardware limits or just software unsupported?
> > Software. In hardware you can perform decapsulation in the router or
> > using ACLs. mlxsw uses the former so the key is {tb_id, prefix}. With
> > ACLs it is possible to match on more attributes.
> >
> I find mlxsw use ACL through TC flower.

When I wrote that it is possible to use ACLs to perform the
decapsulation I meant that mlxsw will do that internally, instead of
using a local route with a decap action. Not that the user will do it.

> But currently It does't support ecn_*_keys in the flower match?

Yes.
https://github.com/Mellanox/mlxsw/wiki/ACLs#supported-keys

> 
> Also it doesn't support the action "redirect to GRE Tunnel device"?

Right. Only redirect to physical ports is currently supported.

> 
