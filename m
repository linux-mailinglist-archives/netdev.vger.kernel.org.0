Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA05D3EA7A0
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 17:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235158AbhHLPgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 11:36:11 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:43677 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231960AbhHLPf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 11:35:59 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailnew.nyi.internal (Postfix) with ESMTP id 14744580CA8;
        Thu, 12 Aug 2021 11:35:22 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Thu, 12 Aug 2021 11:35:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=VsCOGT
        8d3nyjdUYPfzFA5unKj0z9YloCYPBsM1uACu4=; b=THza58owx9DxO3Xfg2myXz
        HEAG2e1Wlx1KExQx9FvLZi02xOi232O/H9GBjWt2LzqnJzQwy3gz2dponEd+vEBY
        nwSiDFzAmm0Qz83WkKHgNRMaJWSuJxMcmY0LHWKUEQGu3ezXjl76nlkiS+JvcRj0
        8kTuPU6Ldb5tfSELs203e2LflxPMjIV4T6F4NNrIeHesxx8Cm/Wi4c3mJKRTY79b
        eHhRZqx0WSEHXjCXjneVff+kv2PBIRq8CaZNbtLXxiS3hvtn48pOn+sMI7teZ5gX
        AjeqsxwQPrn8l8AbxE8Fivht3X4Gc6YxY7ux64Eecla0HoJM1Id+qFASFZ4jMK0A
        ==
X-ME-Sender: <xms:uD8VYcLcdhO7Rp9sbf_F2OcynrGCsZ2phWyCbzNNzYUBm1dmIf07pw>
    <xme:uD8VYcJmwBr32lG2zqQWeQ5loP0mUfqGPGYRdExZaoOP6GXmOLgqttC1WyVkZVtUD
    TJ1R9mLDw7ucyU>
X-ME-Received: <xmr:uD8VYctkdi6e73MZGzFW_uHLEBZ9lWgDxfemZmjGmO2zQCiAI0cGmahNW0aWo9y7s0oG2-k3ZFCI3G0b6PHIPCYBi5Gfcw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrkeefgdeklecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:uD8VYZa4_mAaIzBz8HKvmU65l-5HqNdopze1UxZC7D08CNxnIqm05w>
    <xmx:uD8VYTYg16AdF-icli2CbxGzc7i6w_c3GLIEvfq4JWgnzRnbsUgKXw>
    <xmx:uD8VYVDXN8m-xP612sqWYEFD-DUebgAFFOPcM9Rh2OUdXcFC8nJuIA>
    <xmx:uj8VYUIje8Bj9qk3jv8Nf6jA9V1Ii23AfaLANIMVJ_7V5TsKOZa_Cw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Aug 2021 11:35:19 -0400 (EDT)
Date:   Thu, 12 Aug 2021 18:35:15 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [RFC PATCH net-next] net: bridge: switchdev: expose the port
 hwdom as a netlink attribute
Message-ID: <YRU/s7Zfl67FhI7+@shredder>
References: <20210812121703.3461228-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210812121703.3461228-1-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 12, 2021 at 03:17:03PM +0300, Vladimir Oltean wrote:
> It is useful for a user to see whether a bridge port is offloaded or
> not, and sometimes this may depend on hardware capability.
> 
> For example, a switchdev driver might be able to offload bonding/team
> interfaces as bridge ports, but only for certain xmit hash policies.
> When running into that situation, DSA for example prints a warning
> extack that the interface is not offloaded, but not all drivers do that.
> In fact, since the recent bridge switchdev explicit offloading API, all
> switchdev drivers should be able to fall back to software LAGs being
> bridge ports without having any explicit code to handle them. So they
> don't have the warning extack printed anywhere.

[...]

> With this change, the "hardware domain" concept becomes UAPI. It is a
> read-only link attribute which is zero for non-offloaded bridge ports,
> and has a non-zero value that is unique per bridge otherwise (i.e. two
> different bridge ports, in two different bridges, might have a hwdom of
> 1 and they are still different hardware domains).
> 
> ./ip -d link
> 13: sw1p3@swp2: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue master br0
> 		state LOWERLAYERDOWN mode DEFAULT group default qlen 1000
>     link/ether 00:04:9f:0a:0b:0c brd ff:ff:ff:ff:ff:ff promiscuity 1 minmtu 68
>     maxmtu 2021 bridge_slave state disabled priority 32 cost 100 hairpin off guard off
>     root_block off fastleave off learning on flood on port_id 0x8007 port_no 0x7
>     designated_port 32775 designated_cost 0 designated_bridge 8000.0:4:9f:a:b:c
>     designated_root 8000.0:4:9f:a:b:c hold_timer    0.00 message_age_timer    0.00
>     forward_delay_timer    0.00 topology_change_ack 0 config_pending 0 proxy_arp off
>     proxy_arp_wifi off mcast_router 1 mcast_fast_leave off mcast_flood on
>     mcast_to_unicast off neigh_suppress off group_fwd_mask 0 group_fwd_mask_str 0x0
>     vlan_tunnel off isolated off hwdom 2 addrgenmode none numtxqueues 8 numrxqueues 1
>     gso_max_size 65536 gso_max_segs 65535 portname p3 switchid 02000000 parentbus spi
>     parentdev spi2.1

Makes sense to me. Gives us further insight into the offload process. I
vaguely remember discussing this with Nik in the past. The
hwdom/fwd_mark is in the tree for long enough to be considered a stable
and useful concept.

You are saying that it is useful to expose despite already having
"switchid" exposed because you can have interfaces with the same
"switchid" that are not member in the same hardware domain? E.g., the
LAG example. If so, might be worth explicitly spelling it out in the
commit message.
