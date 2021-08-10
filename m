Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88BB23E82D2
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 20:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238010AbhHJSSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 14:18:40 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:54877 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240580AbhHJSQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 14:16:16 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 4C5615C01B4;
        Tue, 10 Aug 2021 14:15:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 10 Aug 2021 14:15:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Vp6gWF
        MbQEIBadV8a2hMEDPaqd1wy67mvLkVxiuGd70=; b=VfxsTNxJWhb9/KlGKp231j
        NmPXc9pfh4NMqybuagjZQ/Jp1zdTbdco9CqUJOeub6V6QJDkcW90WsL8pWay+tUZ
        fObsf+Pm29eHB0E164FTfzAgFWVT6YuSm+cUCNlS22B1KL9b84VPLwMGyRy3Mu6u
        U1UQYES9b/1K4YQGJ7Sui0MAxU+ZRgeLVJFCHsYBe+DDZ1fWXicp1nV8XnVfwxNq
        oUJnWj1hxCjqb5I7YvMYxY/J8AuU/iC5GN/zrvuOFjkibwCGXjyud0+c6PWf7/TJ
        Yn1O9oGhEoci79MD16QYKrUmgIp51Zq+ac+en/2Vyyu5bnHdIXCwobrrN1UhRGzA
        ==
X-ME-Sender: <xms:V8ISYUxIRIlZ_9C8N4GyX8BVzUQk_F8gzD7ilzMBmfrLCRDdZsldAg>
    <xme:V8ISYYQsDaGr86dWK4jyrqkBmycwHi8bRSagb9EUlVM-mTPWjWf9VkaeI3fmxsdTd
    bEYbtpTkw8YfN4>
X-ME-Received: <xmr:V8ISYWXkquHVyG7dmMkCgygzggGxFit736L-5_28OTeQzBUSnqqWyRvY7CZq0xbQ2hvFny6tYPRPf_9MdZIvjCBiX6fxRA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrjeelgdduvdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:V8ISYShp9QZynrEZNw3S6Xc8bJEaTPJFEBJWOEQui4BV056M9AiN-A>
    <xmx:V8ISYWB6G1BOgoerYdZLqWEAsdh4gGIjOKTv5fpB-w7St7dg553S2g>
    <xmx:V8ISYTL3C12OLngKIJKdKN3Gv5YL0WNP-Qm5BpfyPaJ75pBvtwRPSQ>
    <xmx:WMISYY1YxFA4fTYvHsh6u-R60yJ0Qp2U_Dx_dkQsDQhhuxdNj5SGoA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 10 Aug 2021 14:15:50 -0400 (EDT)
Date:   Tue, 10 Aug 2021 21:15:45 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        davem@davemloft.net, mkubecek@suse.cz, pali@kernel.org,
        vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 2/8] ethtool: Add ability to reset
 transceiver modules
Message-ID: <YRLCUc8NZnRZFUFs@shredder>
References: <20210809102152.719961-1-idosch@idosch.org>
 <20210809102152.719961-3-idosch@idosch.org>
 <YRF+a6C/wHa7+2Gs@lunn.ch>
 <YRJ5g/W11V0mjKHs@shredder>
 <20210810065423.076e3b0d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810065423.076e3b0d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 06:54:23AM -0700, Jakub Kicinski wrote:
> On Tue, 10 Aug 2021 16:05:07 +0300 Ido Schimmel wrote:
> > > Again, i'm wondering, why is user space doing the reset? Can you think
> > > of any other piece of hardware where Linux relies on user space
> > > performing a reset before the kernel can properly use it?
> > > 
> > > How long does a reset take? Table 10-1 says the reset pulse must be
> > > 10uS and table 10-2 says the reset should not take longer than
> > > 2000ms.  
> > 
> > Takes about 1.5ms to get an ACK on the reset request and another few
> > seconds to ensure module is in a valid operational state (will remove
> > RTNL in next version).
> 
> Hm. RTNL-lock-less ethtool ops are a little concerning. The devlink
> locking was much complicated by the unclear locking rules. Can we keep
> ethtool simple and put this functionality in a different API or make
> the reset async?

I thought there are already RTNL-lock-less ethtool ops, but maybe I
imagined it. Given that we also want to support firmware update on
modules and that user space might want to update several modules
simultaneously, do you have a suggestion on how to handle it from
locking perspective? The ethtool netlink backend has parallel ops, but
RTNL is a problem. Firmware flashing is currently synchronous in both
ethtool and devlink, but the latter does not hold RTNL.

> 
> > > So maybe reset it on ifup if it is in a bad state?  
> > 
> > We can have multiple ports (split) using the same module and in CMIS
> > each data path is controlled by a different state machine. Given the
> > complexity of these modules and possible faults, it is possible to
> > imagine a situation in which a few ports are fine and the rest are
> > unable to obtain a carrier.
> > 
> > Resetting the module on ifup of swp1s0 is not intuitive and it shouldn't
> > affect other split ports (e.g., swp1s1). With the dedicated reset
> > command we have the ability to enforce all the required restrictions
> > from the start instead of changing the behavior of existing commands.
> 
> Sounds similar to what ethtool --reset was trying to address (upper
> 16 bits). Could we reuse that? Whether its a SFP or other part of the
> port being reset may not be entirely important to the user, so perhaps
> it's not a bad idea to abstract that away and stick to "reset levels"?

Wasn't aware of this API. Looks like it is only implemented by a few
drivers, but man page says "phy    Transceiver/PHY", so I think we can
reuse it.

What do you mean by "reset levels"? The split between shared /
dedicated?

Just to make sure I understand, you suggest the following semantics?

# ethtool --reset swp1s0 phy
Error since module is used by several ports (split)

# ethtool --reset swp1s0 phy-shared
OK

# ethtool --reset swp1 phy
OK (no split)

# ethtool --reset swp1 phy-shared
OK
