Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 428243E8497
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 22:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbhHJUub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 16:50:31 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:51809 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230181AbhHJUua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 16:50:30 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 3B6725C01BE;
        Tue, 10 Aug 2021 16:50:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 10 Aug 2021 16:50:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=kG4qh8
        WFwMRA0cZrnkC5OcMRGEmlxP0cjZfeGw3Ebp4=; b=W65GEyMwPpb1SfVkzKoIVH
        97Z0sRRrfB2vt0T8iBQdBJ/U7ZKFgtiHKqHpPZvbVZiwyDsdshfOKZZOwBo901lR
        nR1M+rtkLTcj/ZSjUm61QB19Z3WTXV0C3X4HlAKMMw3Z1FAsHIqVVmLSGQob1Bde
        Xu1aK7xKM+lgGkE7ogCCVfeTMDnWNtA/HspeKM4cEObwbT6IBvUnuHL0doCfyFON
        odnoeGjUn1aqzwX8++xF5FmrMEoZN+wnNqxTrs/8zNjBduZ5oK9lk29gUr+wUyq1
        JLgcLa+ml4N4hm7Ij1ZWSbutfqUqkL90WUyfAMTQ26AoEm5kUykEqbfQznBlGPCA
        ==
X-ME-Sender: <xms:fuYSYcZeTLyEf6VkxLE_4IqT3JhWimeFHx5cuzvzmNJ4UtpfmzsE9w>
    <xme:fuYSYXZaKCTKZJnkm9S1uCRx_6TzcucHCCkF1tmY5aiGpaxG6iMZmg19ZVfGwUpwD
    iaFwYS0kPXI-dQ>
X-ME-Received: <xmr:fuYSYW_gnFa79Rt42hF62nfEDYbjQKG1TJHuFB1of76cumBO3HEBdQ0PlrHzrVeFmdIiBhbM2j-06nC_YhiAK4KYtOaDQQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrjeelgdduheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:fuYSYWq1pj9FJ4_cijngFW65o-SpuI1EKTxRdcqUq2VP1OCcOWESWw>
    <xmx:fuYSYXo-9EZEwCHSUFWH-a-52QFOd_Q_sy9HpK-b4-TmJ6Utp6wKyw>
    <xmx:fuYSYUTSfotPmweyeMpP8WlkLGQUbc_g2Pw2RuA40asrBCQsRMX5SQ>
    <xmx:gOYSYYcBR0W1EVOdbY2rC9PPae0NzPpAs4FIN50ZK_I_QFcFhVvwcA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 10 Aug 2021 16:50:05 -0400 (EDT)
Date:   Tue, 10 Aug 2021 23:50:04 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, mkubecek@suse.cz, pali@kernel.org,
        vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 2/8] ethtool: Add ability to reset
 transceiver modules
Message-ID: <YRLmfNkCD5hjsTuk@shredder>
References: <20210809102152.719961-1-idosch@idosch.org>
 <20210809102152.719961-3-idosch@idosch.org>
 <YRF+a6C/wHa7+2Gs@lunn.ch>
 <YRJ5g/W11V0mjKHs@shredder>
 <20210810065423.076e3b0d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YRLCUc8NZnRZFUFs@shredder>
 <20210810120030.5092ec22@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YRLTSC90Lu/3IyJa@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRLTSC90Lu/3IyJa@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 09:28:08PM +0200, Andrew Lunn wrote:
> > Hm, flashing is harder than reset. We can't unbind the driver while
> > it's in progress. I don't have any ready solution in mind, but I'd 
> > like to make sure the locking is clear and hard to get wrong. Maybe 
> > we could have a mix of ops, one called for "preparing" the flashing
> > called under rtnl and another for "commit" with "unlocked" in the name.
> > Drivers which don't want to deal with dropping rtnl lock can just do
> > everything in the first stage? Perhaps Andrew has better ideas, I'm
> > just spit-balling. Presumably there are already locks at play, locks
> > we would have to take in the case where Linux manages the PHY. Maybe
> > they dictate an architecture?
> 
> I don't think the way linux manages PHYs dictates the
> architecture. PHY cable test requires that the link is
> administratively up, so the PHY state machine is in play. It
> transitions into a testing state when cable test is started, and when
> the test is finished, it resets the PHY to put it back into running
> state. If you down the interface while the cable test is running, it
> aborts the cable test, and then downs the PHY.
> 
> Flashing firmware is a bit different. You need to ensure the interface
> is down. And i guess that gets interesting with split modules. You
> really should not abort an upgrade because the user wants to up the
> interface. So -EBUSY to open() seems like the best option, based on
> the state of the SFP state machine.
> 
> I suspect you are going to need a kernel thread to do the real
> work. So your "prepare" netlink op would pass the name of the firmware
> file. Some basic validation would be performed, that all the needed
> interfaces are down etc, and then the netlink OP would return. The
> thread then uses request_firmware() to get access to the firmware, and
> program it. Once complete, or on error, it can async notify user space
> that it is sorry, your module is toast, or firmware upgrade was
> successful.
> 
> This is just throwing out ideas...

Thanks Andrew and Jakub. I will look into these suggestions more closely
when I start working on modules firmware update.
