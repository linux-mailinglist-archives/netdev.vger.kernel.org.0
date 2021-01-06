Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5574D2EC2B1
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 18:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbhAFRsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 12:48:16 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:50903 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726109AbhAFRsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 12:48:15 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 55449580464;
        Wed,  6 Jan 2021 12:47:29 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 06 Jan 2021 12:47:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=GWGpFj
        W4wRt1rQT1v5tIhQyTh/KDGZjii9Tx6Q3/8Tc=; b=HsRCMgB84JEYOPEeiFFfyx
        bybGFpIEsbVWycOTqKcKg7a8/EgOj7PNd4sLMmvbVN9FwBJiF6iijQmkbOHA3/ky
        8+6aixaHCfqt+Q+TMgc9Jl4nWWfw378T7xnv8kCynffo6Ossz+6luBM08awrQMzy
        mZQ9Cm+q4yLjEXXsmTEpq446TXTEOfisulN7M+YtlrkvG3rYaPE3ZKCbBv5IQRYR
        91N4F8v+a9UoWLYhZuYjkHMeLyAkJXImmWpTFD/YJlPs/r8Q3l4SI6/aBuk6eaMW
        jHZi6veCXKlnkJ/08i/Y872aDIFnOfSU3fjvepSFD6G+7fEEubnLZhOYjqsknPoA
        ==
X-ME-Sender: <xms:rff1X65S8r8JSCjBf_9I58nv6khqr5Up-ODUc1IhvuaAZMyIyhm8zQ>
    <xme:rff1Xz6k09R4ObvrUfKSxYpS0YxCoSlmAHwixf4ezQciMSTIsmHxU7L0zEo0XA-2u
    l6iTvs31lvkcIs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdegtddguddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheefrdeggeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:rff1X5f6NOgzcBdeCrXtDEa9psup7D8yvnMw8KWywB8css_CTkCw5g>
    <xmx:rff1X3LIybH71qq2Tk4inqpaxB9FdMl_j5Lbn5xwFXItSbqdJfKwew>
    <xmx:rff1X-KIXN5uK8NzCk0fx8k-Kvb-FWO2uf6kYQLjr68v4Gn0CDVzAw>
    <xmx:sff1Xy8N8RuGOaKnReNhCH_5UhspJe5W48H0wP_Dm_R9Q-aWQUH2kQ>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id BE2A11080064;
        Wed,  6 Jan 2021 12:47:24 -0500 (EST)
Date:   Wed, 6 Jan 2021 19:47:23 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>
Subject: Re: [PATCH v2 net-next 04/10] net: switchdev: remove the transaction
 structure from port attributes
Message-ID: <20210106174723.GC1082997@shredder.lan>
References: <20210106131006.577312-1-olteanv@gmail.com>
 <20210106131006.577312-5-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210106131006.577312-5-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 06, 2021 at 03:10:00PM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Since the introduction of the switchdev API, port attributes were
> transmitted to drivers for offloading using a two-step transactional
> model, with a prepare phase that was supposed to catch all errors, and a
> commit phase that was supposed to never fail.
> 
> Some classes of failures can never be avoided, like hardware access, or
> memory allocation. In the latter case, merely attempting to move the
> memory allocation to the preparation phase makes it impossible to avoid
> memory leaks, since commit 91cf8eceffc1 ("switchdev: Remove unused
> transaction item queue") which has removed the unused mechanism of
> passing on the allocated memory between one phase and another.
> 
> It is time we admit that separating the preparation from the commit
> phase is something that is best left for the driver to decide, and not
> something that should be baked into the API, especially since there are
> no switchdev callers that depend on this.
> 
> This patch removes the struct switchdev_trans member from switchdev port
> attribute notifier structures, and converts drivers to not look at this
> member.
> 
> In part, this patch contains a revert of my previous commit 2e554a7a5d8a
> ("net: dsa: propagate switchdev vlan_filtering prepare phase to
> drivers").
> 
> For the most part, the conversion was trivial except for:
> - Rocker's world implementation based on Broadcom OF-DPA had an odd
>   implementation of ofdpa_port_attr_bridge_flags_set. The conversion was
>   done mechanically, by pasting the implementation twice, then only
>   keeping the code that would get executed during prepare phase on top,
>   then only keeping the code that gets executed during the commit phase
>   on bottom, then simplifying the resulting code until this was obtained.
> - DSA's offloading of STP state, bridge flags, VLAN filtering and
>   multicast router could be converted right away. But the ageing time
>   could not, so a shim was introduced and this was left for a further
>   commit.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Acked-by: Jiri Pirko <jiri@nvidia.com>
> Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de> # hellcreek
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org> # RTL8366RB

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
