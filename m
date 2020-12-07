Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97EB32D158D
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 17:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbgLGQG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 11:06:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727288AbgLGQG4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 11:06:56 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EAA4C061749
        for <netdev@vger.kernel.org>; Mon,  7 Dec 2020 08:06:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=PMMb36BoNKo/K4vLZCf7NCEAA+JKXKt1TiebagFvkS8=; b=JxI/fVvrqRzfTHOEkpkZlirmx
        T0j5RqhW/CAyHKzLAt6qr8I6gBeAWZw3ubsNJiukGgc5GPs4ql1D8xKVyEOPFmppFSNv/sTWzzw9p
        GHTrMd52vBWhJX7VXd12dKZiylv6Wnpq9we1QGZ6Hkf38YxfJYzO+EAeD2sGste8tkx1GPaJolM9E
        I3J1I0VvNuwxKZL9jCgeAG7H0LkzL4YUhO+OJyegmj0CZgRjNSsNCgVnnX9qmlD4/Ul1utWvS+sH2
        eniyLuIKpg5P40JE2bmByHrSY5Ddw3thpRbubzKI2ZPLgd73xwJ3zccnCArnhbFUxWhJm12zcnvOL
        y5Wprr9aw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:40976)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kmJ1Y-0007sn-OA; Mon, 07 Dec 2020 16:06:04 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kmJ1V-0004iT-Rd; Mon, 07 Dec 2020 16:06:01 +0000
Date:   Mon, 7 Dec 2020 16:06:01 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Ido Schimmel <idosch@idosch.org>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH net-next] net: sfp: add debugfs support
Message-ID: <20201207160601.GP1551@shell.armlinux.org.uk>
References: <E1khJyS-0003UU-9O@rmk-PC.armlinux.org.uk>
 <20201124001431.GA2031446@lunn.ch>
 <20201124084151.GA722671@shredder.lan>
 <20201124094916.GD1551@shell.armlinux.org.uk>
 <20201124104640.GA738122@shredder.lan>
 <20201202130318.GD1551@shell.armlinux.org.uk>
 <20201202085913.1eda0bba@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201202090147.48af58fd@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201202090147.48af58fd@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 02, 2020 at 09:01:47AM -0800, Jakub Kicinski wrote:
> On Wed, 2 Dec 2020 08:59:13 -0800 Jakub Kicinski wrote:
> > On Wed, 2 Dec 2020 13:03:18 +0000 Russell King - ARM Linux admin wrote:
> > > Jakub,
> > > 
> > > What's your opinion on this patch? It seems to have stalled...  
> > 
> > Sorry, I think I expected someone to do the obvious questioning..
> 
> Ah, no! I know what happened... Check out patchwork:
> 
> https://patchwork.kernel.org/project/netdevbpf/patch/E1khJyS-0003UU-9O@rmk-PC.armlinux.org.uk/
> 
> It says the patch did not apply cleanly to net-next ;)
> 
> Regardless let's hear what people thing about using ext_link (or
> similar) for the SFP signals.

There seems to have been no replies... I think I'll resend with
Andrew's r-b tag. If something better comes along in the future, we
can always change it - debugfs isn't an API.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
