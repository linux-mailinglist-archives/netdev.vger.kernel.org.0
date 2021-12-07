Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E941046BD19
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 14:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237502AbhLGOCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 09:02:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237454AbhLGOCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 09:02:37 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC83AC061746
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 05:59:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Zo4BPMaA/ZlGhiH0IM/2Qmxe/LcYL5fG7NI/MtiDFQ0=; b=BprXsUXL8FSRsCL+kKQK09blmK
        qOpvehWKpLiJyy7JCS25CuRXzfMq93p7Mqn2YRpI1laZ7TWWzmFJlHD15xI127ucWTFTv/tcV6EQO
        pbkrIf8JKWjrdQeQ+yrPItu3Su60qW9GyrGx9aiXoqo6ef4nVlKiDIpc8Go8vyqpei7l8mVp83Rv1
        b3GcgbFHk1tr+/7bSoNJnbz5Q9qZ6sksgRtVP7pkkUMZ1D+XAsa4tCUayeqC26iaDFbiebmghdC9R
        icvoB34MNvgCVm5XoEWbvQlwA+acBhy+4atJhfZGTP0HWYo+bvF8uVVLcOwi7dZ/lIvd8mKPsoIJb
        ygxa/l2w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56156)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1muazo-0006GF-1c; Tue, 07 Dec 2021 13:59:04 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1muazn-0005Nj-2X; Tue, 07 Dec 2021 13:59:03 +0000
Date:   Tue, 7 Dec 2021 13:59:03 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Martyn Welch <martyn.welch@collabora.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, kernel@collabora.com
Subject: Re: mv88e6240 configuration broken for B850v3
Message-ID: <Ya9op2QJwWRyqmDY@shell.armlinux.org.uk>
References: <20211206193730.oubyveywniyvptfk@skbuf>
 <Ya5tkXU3AXalFRg2@shell.armlinux.org.uk>
 <20211206202308.xoutfymjozfyhhkl@skbuf>
 <Ya53vXp7Wz5YPf7Y@shell.armlinux.org.uk>
 <20211206211341.ppllxa7ve2jdyzt4@skbuf>
 <Ya6ARQBGl2C4Z3il@shell.armlinux.org.uk>
 <Ya6FcTIbyO+zXj7V@shell.armlinux.org.uk>
 <20211206232735.vvjgm664y67nggmm@skbuf>
 <Ya6xrNbwZUxCbH3X@shell.armlinux.org.uk>
 <20211207132413.f4av4d3expfzhnwl@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211207132413.f4av4d3expfzhnwl@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 07, 2021 at 03:24:13PM +0200, Vladimir Oltean wrote:
> On Tue, Dec 07, 2021 at 12:58:20AM +0000, Russell King (Oracle) wrote:
> > > Anyway, so be it. Essentially, what is the most frustrating is that I
> > > haven't been doing anything else for the past 4 hours, and I still
> > > haven't understood enough of what you're saying to even understand why
> > > it is _relevant_ to Martyn's report. All I understand is that you're
> > > also looking in that area of the code for a completely unrelated reason
> > > which you've found adequate to mention here and now.
> > 
> > I hope you realise that _your_ attitude here is frustrating and
> > inflamatory. This is _not_ a "completely unrelated reason" - this
> > is about getting the right solution to Martyn's problem. I thought
> > about doing another detailed reply, but when I got to the part
> > about you wanting to check 6390X, I discarded that reply and
> > wrote this one instead. You clearly have a total distrust for
> > everything that I write in any email, so I just won't bother.
> 
> I think getting the right solution to Martyn's problem is the most
> important part. I'd be very happy if I understood it too, although that
> isn't mandatory, since it may be beyond me but still correct, and I hope
> I'm not standing in the way if that is the case.
> I've explained my current state of understanding, which is that I saw in
> the manual for 6097 that forcing the link is unnecessary for internal
> PHY ports regardless of whether the PPU is enabled or not. Yet, DSA will
> still force these ports down with your proposed change (because DSA lies
> that it is a MLO_AN_FIXED mode despite what's in the device tree), and
> it relies on unforcing them in mv88e6xxx_mac_config(), which in itself
> makes sense considering the other discussion about kexec and such. But
> it appears that it may not unforce them again - because that condition
> depends on mv88e6xxx_port_ppu_updates() which may be false. So if it is
> false, things are still broken.
> It isn't a matter of distrust and I'm sorry that you take it personal,
> but your proposed solution doesn't appear to me to have a clear
> correlation to the patch that introduced a regression.

The change that I have proposed is based on two patches:

1) Change mv88e6xxx_port_ppu_updates() to behave sensibly for the 6250
   family of DSA switches.

2) Un-force the link-down in mv88e6xxx_mac_config()

This gives us more consistency. The checks become:

a) mac_link_down():

        if ((!mv88e6xxx_port_ppu_updates(chip, port) ||
             mode == MLO_AN_FIXED) && ops->port_sync_link)
                err = ops->port_sync_link(chip, port, mode, false);

b) mac_link_up():

        if (!mv88e6xxx_port_ppu_updates(chip, port) ||
            mode == MLO_AN_FIXED) {
...
                if (ops->port_sync_link)
                        err = ops->port_sync_link(chip, port, mode, true);
        }

c) mac_config():

        if (chip->info->ops->port_set_link &&
            ((mode == MLO_AN_INBAND && p->interface != state->interface) ||
             (mode == MLO_AN_PHY && mv88e6xxx_port_ppu_updates(chip, port))))
                chip->info->ops->port_set_link(chip, port, LINK_UNFORCED);

The "(mode == MLO_AN_INBAND && p->interface != state->interface)"
expression comes from the existing code, so isn't something that
needs discussion.

We want to preserve the state of the link-force for MLO_AN_FIXED,
so the only case for discussion is the new MLO_AN_PHY. It can be
seen that all three methods above end up using the same decision,
and essentially if mv88e6xxx_port_ppu_updates() is true, meaning
there is a non-software method to handle the status updates, then
we (a) don't do any forcing in the mac_link_*() methods and turn
off the forcing in mac_config().

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
