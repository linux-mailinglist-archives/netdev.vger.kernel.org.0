Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1E642A976
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 18:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbhJLQdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 12:33:45 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:53561 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229565AbhJLQdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 12:33:45 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 0223F5C017F;
        Tue, 12 Oct 2021 12:31:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 12 Oct 2021 12:31:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=yXtvIh
        zyQ3mF1lRMx2azuLdQH1oEZYIastE4ke77L2k=; b=AblIlqbtRvjMAd/NV3CtkG
        RGLhm1qCIf3gniYOgrGZr8V4vVvqBlkvR+Tc3N1Pc2aka5sJWzF3K6XoVxgDM7nh
        vT/B7oxOBwWbAD2uid4tn99F/HDMen3CQD/L6hCCwoVa+BqD6GEa2DNSYbt+o6b9
        YgraCKbSkoGx7PsqOTMXE7fIHLSy0/CD2QHLjF1djOoDxWqX/k2hiZPR/XokXXA1
        XeMCf/JAbst85ac9NOysAy/luhCd5OZPvTstRZ+bF+wX2zscWzoN/pUseY1Z87iF
        NIAtkMJvEI9+Jje9Lmo0zOYz79yND9S//w+kMU07Bfj/eYZYed/DIQ8Znp8A5MMA
        ==
X-ME-Sender: <xms:brhlYe30orrFm84xbUDqbQ3RiErq3xN7iIHodKa27mY9JdiyxnDE9A>
    <xme:brhlYRFT4XeOThKzQ7VHnI08jFBv6z-6dgNiOZqvXuGAq6Mp19XMd20C7Le1BqPLY
    kaMIGQM4EA9u48>
X-ME-Received: <xmr:brhlYW78ncSe4ofxIYRMtCYh2yGK6ZwOBE4ko9PVdipGxpNHqdRm3fgdBiONKlB_paMUPB_SCcc4DbK7YbTWdTvS60b27g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddtkedgleekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedvhffgueevjeeufffhffffuddtfeeugefhfeehveduieevvdefieevkeduueeh
    jeenucffohhmrghinheplhhinhhugihplhhumhgsvghrshgtohhnfhdrohhrghenucevlh
    hushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhes
    ihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:brhlYf26WgYpoZecd1u9g8dTcaY8rkb3I9fZ9VpTUvHIKM5bs-n-gA>
    <xmx:brhlYRGwIDzYVGJwXVT1hMGNbPvdoERtJsfnVyszoBL9yyJfKcsurw>
    <xmx:brhlYY_ZrIaCYrXXLsrjdV3JlcOFej0o0X8SS8O65GxnbtVtJN2yxw>
    <xmx:brhlYW5vGzAcZpt696JG8Bmssr1D4krVnFNkPhJEMODf0xum4g67Ag>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 12 Oct 2021 12:31:41 -0400 (EDT)
Date:   Tue, 12 Oct 2021 19:31:38 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, roopa@nvidia.com,
        dsahern@kernel.org, m@lambda.lt, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH net-next 4/4] net, neigh: Add NTF_MANAGED flag for
 managed neighbor entries
Message-ID: <YWW4alF5eSUS0QVK@shredder>
References: <20211011121238.25542-1-daniel@iogearbox.net>
 <20211011121238.25542-5-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211011121238.25542-5-daniel@iogearbox.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 11, 2021 at 02:12:38PM +0200, Daniel Borkmann wrote:
> Allow a user space control plane to insert entries with a new NTF_EXT_MANAGED
> flag. The flag then indicates to the kernel that the neighbor entry should be
> periodically probed for keeping the entry in NUD_REACHABLE state iff possible.

Nice idea

> 
> The use case for this is targeting XDP or tc BPF load-balancers which use
> the bpf_fib_lookup() BPF helper in order to piggyback on neighbor resolution
> for their backends. Given they cannot be resolved in fast-path,

Out of curiosity, can you explain why that is? Because XDP is only fast
path? At least that's what I understand from commit 87f5fc7e48dd ("bpf:
Provide helper to do forwarding lookups in kernel FIB table") and it is
similar to L3 offload

> a control plane inserts the L3 (without L2) entries manually into the
> neighbor table and lets the kernel do the neighbor resolution either
> on the gateway or on the backend directly in case the latter resides
> in the same L2. This avoids to deal with L2 in the control plane and
> to rebuild what the kernel already does best anyway.

Are you using 'fib_multipath_use_neigh' sysctl to avoid going through
failed nexthops? Looking at how the bpf_fib_lookup() helper is
implemented, seems that you can benefit from it in XDP

> 
> NTF_EXT_MANAGED can be combined with NTF_EXT_LEARNED in order to avoid GC
> eviction. The kernel then adds NTF_MANAGED flagged entries to a per-neighbor
> table which gets triggered by the system work queue to periodically call
> neigh_event_send() for performing the resolution. The implementation allows
> migration from/to NTF_MANAGED neighbor entries, so that already existing
> entries can be converted by the control plane if needed. Potentially, we could
> make the interval for periodically calling neigh_event_send() configurable;
> right now it's set to DELAY_PROBE_TIME which is also in line with mlxsw which
> has similar driver-internal infrastructure c723c735fa6b ("mlxsw: spectrum_router:
> Periodically update the kernel's neigh table"). In future, the latter could
> possibly reuse the NTF_MANAGED neighbors as well.

Yes, mlxsw can set this flag on neighbours used for its nexthops. Looks
like the use cases are similar: Avoid going to slow path, either from
XDP or HW.

In our HW the nexthop table is squashed together with the neighbour
table, so that it provides {netdev, MAC} and not {netdev, IP} with which
the kernel performs another lookup in its neighbour table. We want to
avoid situations where we perform multipathing between valid and failed
nexthop (basically, fib_multipath_use_neigh=1), so we only program valid
nexthop. But it means that nothing will trigger the resolution of the
failed nexthops, thus the need to probe the neighbours.

> 
> Example:
> 
>   # ./ip/ip n replace 192.168.178.30 dev enp5s0 managed extern_learn
>   # ./ip/ip n
>   192.168.178.30 dev enp5s0 lladdr f4:8c:50:5e:71:9a managed extern_learn REACHABLE
>   [...]
> 
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Acked-by: Roopa Prabhu <roopa@nvidia.com>
> Link: https://linuxplumbersconf.org/event/11/contributions/953/

I was going to ask why not just default the kernel to resolve GW IPs (it
knows them when the nexthops are configured), but then I saw slide 34. I
guess that's what you meant by "... or on the backend directly in case
the latter resides in the same L2"?
