Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A519C2C233F
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 11:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732263AbgKXKqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 05:46:46 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:54549 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732249AbgKXKqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 05:46:45 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 714C85C011C;
        Tue, 24 Nov 2020 05:46:44 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 24 Nov 2020 05:46:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=xE/w/b
        OjiGbig3nmwV2k4dnhP6o3dbsUdvNe0fMCuow=; b=hPmXC2ffV46amvq237ge5b
        ZV0LkA+WWS56dtkmDc4QJr0llDYgPR/QkZozjWAg9WUolCzMGU/uNw6DPG7brBWy
        VEP+sLPZs10X4TUpvJkkz9TcwzFhPcF846JQKdggjlgvV7YxkVAkLWgEENPU4MhM
        0gV4iU7NNyzmLDbD08GykuW082fgriCIdVkEpSxm+/Vb0pCqyFelgkQ/mV6G3Jz8
        KJxuA7Xj0XqN5vWzffdO1TkiV/VIIN3X1Oli2XZqMdOpYfQ6clONmOmFrfO7SfiU
        CrAP2ty43mcYVurGPp6Ely+vxIN8JByz+tr7hofSHK/SK+dLVDZHOqbJeDufaKzQ
        ==
X-ME-Sender: <xms:k-S8X_onOnzAL_COWyWqg63J4I7zEqjIaxpKckMinkGNH8yiQ5mOpw>
    <xme:k-S8X5q9GxPtpBdvfZf33TAxYr0yVDnxcvf4RXHlW48IkQhDY8ds5IrHKG17vMzWX
    Y6MTUvaXmskqKY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudegkedgudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheegrddugeejnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:k-S8X8NugFz1lmPR71-ZjHnCCo50SDTRceZzotwATpZsshApNkuPKw>
    <xmx:k-S8Xy7H2UDMpPV9EiT9R5ytfO2aVswzKw6P3uwtdqEYSY-A6y3sxw>
    <xmx:k-S8X-7mWATDT6yC_oU1_QlAPM-ex84Lvt2uIlfSdgH6-xCo08IW5w>
    <xmx:lOS8X-GjFLag_u_861rEQLxCAfJHdgLyQZHFYQpWMvRakAfT767vzA>
Received: from localhost (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id D2F253064AAA;
        Tue, 24 Nov 2020 05:46:42 -0500 (EST)
Date:   Tue, 24 Nov 2020 12:46:40 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: sfp: add debugfs support
Message-ID: <20201124104640.GA738122@shredder.lan>
References: <E1khJyS-0003UU-9O@rmk-PC.armlinux.org.uk>
 <20201124001431.GA2031446@lunn.ch>
 <20201124084151.GA722671@shredder.lan>
 <20201124094916.GD1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201124094916.GD1551@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 24, 2020 at 09:49:16AM +0000, Russell King - ARM Linux admin wrote:
> On Tue, Nov 24, 2020 at 10:41:51AM +0200, Ido Schimmel wrote:
> > On Tue, Nov 24, 2020 at 01:14:31AM +0100, Andrew Lunn wrote:
> > > On Mon, Nov 23, 2020 at 10:06:16PM +0000, Russell King wrote:
> > > > Add debugfs support to SFP so that the internal state of the SFP state
> > > > machines and hardware signal state can be viewed from userspace, rather
> > > > than having to compile a debug kernel to view state state transitions
> > > > in the kernel log.  The 'state' output looks like:
> > > > 
> > > > Module state: empty
> > > > Module probe attempts: 0 0
> > > > Device state: up
> > > > Main state: down
> > > > Fault recovery remaining retries: 5
> > > > PHY probe remaining retries: 12
> > > > moddef0: 0
> > > > rx_los: 1
> > > > tx_fault: 1
> > > > tx_disable: 1
> > > > 
> > > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > > 
> > > Hi Russell
> > > 
> > > This looks useful. I always seem to end up recompiling the kernel,
> > > which as you said, this should avoid.
> > 
> > FWIW, another option is to use drgn [1]. Especially when the state is
> > queried from the kernel and not hardware. We are using that in mlxsw
> > [2][3].
> 
> Presumably that requires /proc/kcore support, which 32-bit ARM doesn't
> have.

Yes, it does seem to be required for live debugging. I mostly work with
x86 systems, I guess it's completely different for Andrew and you.
