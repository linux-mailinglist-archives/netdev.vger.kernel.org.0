Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E129A2A1D9C
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 12:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbgKALbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 06:31:44 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:33093 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726341AbgKALbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 06:31:44 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 0CC705C008B;
        Sun,  1 Nov 2020 06:31:43 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 01 Nov 2020 06:31:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=7XEc2g
        rxHRTPvjD+S2eEeNKOHoG3om/KaxKsBlP/8W0=; b=iftXFYQen2muZDWRGxynfG
        Oy6wBjLwiOxvXSTpZJ1o8t0FkMI9VMPR9ZlM8tU/V2HTYMCyWttUY7WYtYvbeXNh
        BxVMSFWRlWbWZd4BKLyLs3977HnUggb1kXIKpfy0lr7ma7hUQbux/DRxmsHAHvso
        vKbaBLdq0G5gRzmk0GUAcpEK/W0g1btkLww9N29mldUzOo2h0eoNQ0pmJeCGDPCL
        pPVRFASgANoY0BSny6QQRB0ULP8b+310Bt4cL9NHSCZc9wrAv98l1UCeEiWSxDPj
        YIprpXoVQiKWhddgYPL7CGDmgBg8MgwgQu13V4fHzIEXcWnk7jJMRXoH0mWOvIBA
        ==
X-ME-Sender: <xms:nJyeX7sBRcteZxX2gZnKqvC2NS-vDJl97v0eI97T48Q-zLbWr0_aIQ>
    <xme:nJyeX8faSZZCHM_ubtwzwbWl1l70hxECmhqp2E0UX3Z8p-hW3Tb3GWK5kTvmlTMPt
    8txXGPyjIXYlVc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrleelgdefudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necukfhppeekgedrvddvledrudehhedrudekvdenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:nJyeX-xI1ZCUtn7YDc_JgFz_IfLPcz7MKToeKENYxaBrib3c3B6dFQ>
    <xmx:nJyeX6OAx3AC70fjhXfAn2ALF2fAhFWs-i6gLLN7LR6lZL5u-jz96A>
    <xmx:nJyeX7_7C29cdqz7ize0Y9AgseRrWy1Ly9pqh2wyW1swVrU4g13O_g>
    <xmx:n5yeX9IhTYK3DmvYT5iNJhtjrwkZSJ6MXI71blGkSTUZFtu3CZGN0Q>
Received: from localhost (igld-84-229-155-182.inter.net.il [84.229.155.182])
        by mail.messagingengine.com (Postfix) with ESMTPA id 03B81306467D;
        Sun,  1 Nov 2020 06:31:39 -0500 (EST)
Date:   Sun, 1 Nov 2020 13:31:37 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH 4/4] net: dsa: tag_edsa: support reception of packets
 from lag devices
Message-ID: <20201101113137.GB698347@shredder>
References: <20201028120515.gf4yco64qlcwoou2@skbuf>
 <C6OMPK3XEMGG.1243CP066VN7O@wkz-x280>
 <20201028181824.3dccguch7d5iij2r@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028181824.3dccguch7d5iij2r@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 08:18:24PM +0200, Vladimir Oltean wrote:
> Yes, I expect that the bridge input would need to have one more entry
> path into it than just br_handle_frame.
> 
> I'm a bit confused and undecided right now, so let's look at it from a
> different perspective. Let's imagine a switchdev driver (DSA or not)
> which is able to offload IP forwarding. There are some interfaces that
> are bridged and one that is standalone. The setup looks as below.
> 
>  IP interfaces
>                 +---------------------------------------------------------+
>                 |                           br0                           |
>                 +---------------------------------------------------------+
> 
>  +------------+ +------------+ +------------+ +------------+ +------------+
>  |    swp0    | |    swp1    | |    swp2    | |    swp3    | |    eth0    |
>  +------------+ +------------+ +------------+ +------------+ +------------+
> 
>  Hardware interfaces
> 
>  +------------+ +------------+ +------------+ +------------+ +------------+
>  | DSA port 0 | | DSA port 1 | | DSA port 2 | | DSA port 3 | |   e1000    |
>  +------------+ +------------+ +------------+ +------------+ +------------+
> 
> Let's say you receive a packet on the standalone swp0, and you need to
> perform IP routing towards the bridged domain br0. Some switchdev/DSA
> ports are bridged and some aren't.
> 
> The switchdev/DSA switch will attempt to do the IP routing step first,
> and it _can_ do that because it is aware of the br0 interface, so it
> will decrement the TTL and replace the L2 header.
> 
> At this stage we have a modified IP packet, which corresponds with what
> should be injected into the hardware's view of the br0 interface. The
> packet is still in the switchdev/DSA hardware data path.
> 
> But then, the switchdev/DSA hardware will look up the FDB in the name of
> br0, in an attempt of finding the destination port for the packet. But
> the packet should be delivered to a station connected to eth0 (e1000,
> foreign interface). So that's part of the exception path, the packet
> should be delivered to the CPU.
> 
> But the packet was already modified by the hardware data path (IP
> forwarding has already taken place)! So how should the DSA/switchdev
> hardware deliver the packet to the CPU? It has 2 options:
> 
> (a) unwind the entire packet modification, cancel the IP forwarding and
>     deliver the unmodified packet to the CPU on behalf of swp0, the
>     ingress port. Then let software IP forwarding plus software bridging
>     deal with it, so that it can reach the e1000.

This is what happens in the Spectrum ASICs. If a packet hits some
exception in the data path, it is trapped from the Rx port unmodified.

> (b) deliver the packet to the CPU in the middle of the hardware
>     forwarding data path, where the exception/miss occurred, aka deliver
>     it on behalf of br0. Modified by IP forwarding. This is where we'd
>     have to manually inject skb->dev into br0 somehow.
