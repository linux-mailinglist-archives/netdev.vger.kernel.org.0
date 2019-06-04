Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EEE035482
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 01:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbfFDXq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 19:46:27 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:38535 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbfFDXq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 19:46:27 -0400
Received: by mail-ed1-f68.google.com with SMTP id g13so2975356edu.5
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 16:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GkLxoU6X5vayiq9eo4d/cMpBXc73O4GqRJjLz/1eZiY=;
        b=Edxzp+A5V0kru6JP4uUciFKmXFO1re7FrkpESbGhzufyd7LWC2ZUwunCvDEbI+//ZK
         61QILvyj2/1E9M0EgnLROvF/WYcU9JJua1Ygl5W3ahSasYJL/7lHIRYzTv+/N1+MOfCv
         U+5FjzBCL0epHgSaioRvr1iuSaDvw6ywSlcMqZMvfXIk79dn84MOa83NvvQvJNuhSKOg
         PraUG/PAiY1hMgEM9sbpPdMfPs4qQr9tLYDxsRZEHtwjkVLmBxssGiYUR9QmP8/pI04m
         +mV9HMrCuEvCOvDhwnZ8P4Q+POg6HiOPKAZ4M+t4FS0dhTiGbB6ADAz7YIwJcYBYhDyT
         taaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GkLxoU6X5vayiq9eo4d/cMpBXc73O4GqRJjLz/1eZiY=;
        b=pwa4tQKFe88zj2xLVQNByZ4BKrDxaYU57Ol/W6eUOmaAXYJofEvXkTA17UdHlhUJHl
         foi2PX+i5OjB6Jx0DPlQDr0sq5+ENfhT0IUpVwNTtv6cKII6jvENEXLfd6IPEOWP0dDx
         8VTySUiw8F930RD+Ro7DCe1sOGl627y01rdlkOy+GRSY+fSYLORH9mvRqt6Gj2hzd8tZ
         4bl7/N4KZvmD19/QA/2xXXLu0IxBNLZkHlvkHr9CO+xAcn63K3BHlkcaLfnTiDn6BBaZ
         DcblEHKwW8k17EseDzqfa8orb5rcCprx8UWpKnd9AkOzB8OGe3P/ylrvHFIxro6mo6l3
         Zk5Q==
X-Gm-Message-State: APjAAAVJ7LXvP+Nfv497xWBmBhC2ljfrnCvfIIkYmUa8JruEh97biufH
        wHXcjq6kSy+QZWbbdziVIdM1uK1ySQMRH9t5acQ=
X-Google-Smtp-Source: APXvYqzbWjZNHENl2mNKMEmY390WFDFwqRGm4Z1Y3cqBOk1TrVu9Fv+GhPYEHbRP4aH3W2UaeiHdgoEELbm7Qh0Ou7A=
X-Received: by 2002:a50:c985:: with SMTP id w5mr37138561edh.140.1559691984713;
 Tue, 04 Jun 2019 16:46:24 -0700 (PDT)
MIME-Version: 1.0
References: <CA+h21hrJPAoieooUKY=dBxoteJ32DfAXHYtfm0rVi25g9gKuxg@mail.gmail.com>
 <20190604211221.GW19627@lunn.ch> <CA+h21hrqsH9FYtTOrCV+Bb0YANQvSnW9Uq=SoS7AJv9Wcw3A3w@mail.gmail.com>
 <31cc0e5e-810c-86ea-7766-ec37008c5f9d@gmail.com> <20190604214845.wlelh454qfnrs42s@shell.armlinux.org.uk>
 <CA+h21hrOPCVoDwbQa9uFVu3uVWtoP+2Vp2z94An2qtv=u8wWKg@mail.gmail.com>
 <20190604221626.4vjtsexoutqzblkl@shell.armlinux.org.uk> <CA+h21hrkQkBocwigiemhN_H+QJ3yWZaJt+aoBWhZiW3BNNQOXw@mail.gmail.com>
 <20190604225919.xpkykt2z3a7utiet@shell.armlinux.org.uk> <CA+h21hrT+XPfqePouzKB4UUfUawck831bKhAY6-BOunnvbmT1g@mail.gmail.com>
 <20190604232433.4v2qqxyihqi2rmjl@shell.armlinux.org.uk>
In-Reply-To: <20190604232433.4v2qqxyihqi2rmjl@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 5 Jun 2019 02:46:13 +0300
Message-ID: <CA+h21hpDyDLChzrqX19bU81+ss3psVesNftCqN7+7+GFkMe_-A@mail.gmail.com>
Subject: Re: Cutting the link on ndo_stop - phy_stop or phy_disconnect?
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 5 Jun 2019 at 02:24, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Wed, Jun 05, 2019 at 02:03:19AM +0300, Vladimir Oltean wrote:
> > On Wed, 5 Jun 2019 at 01:59, Russell King - ARM Linux admin
> > <linux@armlinux.org.uk> wrote:
> > >
> > > On Wed, Jun 05, 2019 at 01:44:08AM +0300, Vladimir Oltean wrote:
> > > > You caught me.
> > > >
> > > > But even ignoring the NIC case, isn't the PHY state machine
> > > > inconsistent with itself? It is ok with callink phy_suspend upon
> > > > ndo_stop, but it won't call phy_suspend after phy_connect, when the
> > > > netdev is implicitly stopped?
> > >
> > > The PHY state machine isn't inconsistent with itself, but it does
> > > have strange behaviour.
> > >
> > > When the PHY is attached, the PHY is resumed and the state machine
> > > is in PHY_READY state.  If it goes through a start/stop cycle, the
> > > state machine transitions to PHY_HALTED and attempts to place the
> > > PHY into a low power state.  So the PHY state is consistent with
> > > the state machine state (we don't end up in the same state but with
> > > the PHY in a different state.)
> > >
> > > What we do have is a difference between the PHY state (and state
> > > machine state) between the boot scenario, and the interface up/down
> > > scenario, the latter behaviour having been introduced by a commit
> > > back in 2013:
> > >
> > >     net: phy: suspend phydev when going to HALTED
> > >
> > >     When phydev is going to HALTED state, we can try to suspend it to
> > >     safe more power. phy_suspend helper will check if PHY can be suspended,
> > >     so just call it when entering HALTED state.
> > >
> > > --
> > > RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> > > FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> > > According to speedtest.net: 11.9Mbps down 500kbps up
> >
> > I am really not into the PHYLIB internals, but basically what you're
> > telling me is that running "ip link set dev eth0 down" is a
> > stronger/more imperative condition than not running "ip link set dev
> > eth0 up"... Does it also suspend the PHY if I put the interface down
> > while it was already down?
>
> No - but that has nothing to do with phylib internals, more to do with
> the higher levels of networking.  ndo_stop() will not be called unless
> ndo_open() has already been called.  In other words, setting an already
> down device down via "ip link set dev eth0 down" is a no-op.
>
> So, let's a common scenario.  You power up a board.  The PHY comes up
> and establishes a link.  The boot loader runs, loads the kernel, which

This may or may not be the case. As you pointed out a few emails back,
this is a system-level issue that requires a system-level solution -
so cutting the link in U-boot is not out of the question.

> then boots.  Your network driver is a module, and hasn't been loaded
> yet.  The link is still up.
>
> The modular network driver gets loaded, and initialises.  Userspace
> does not bring the network device up, and the network driver does not
> attach or connect to the PHY (which is actually quite common).  So,
> the link is still up.
>
> The modular PHY driver gets loaded, and binds to the PHY.  The link
> is still up.

I would rather say, 'even if the link is not up, Linux brings it up
(possibly prematurely) via phy_resume'.
But let's consider the case where the link *was* up. The general idea
is 'implement your workarounds in whatever other way, that link is
welcome!'.

>
> Userspace configures the network interface, which causes the PHY
> device to be attached to the network device, and phy_start() to be
> called on it - the negotiation advertisement is configured, and
> negotiation restarted if necessary.

In general (the typical driver that isn't bothered by the presence of
an unrequested Ethernet link during initialization), U-boot may
negociate a mode without flow control, and Linux one with. So in
practice, AN is going to restart anyway, which makes the argument for
preserving that link established by the predecessors less strong.

>
> When userspace deconfigures the network interface, phy_stop() will
> be called, and, as the network driver attached the PHY in its
> ndo_open() function, the network driver will detach the PHY from
> the network interface to reverse those effects.  The PHY will be
> suspended, but more so than that, if there is a reset line, the
> reset line will be activated to the PHY.
>
> The above is an illustration of one sequence that /can/ happen.
> Other sequences are also possible.
>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> According to speedtest.net: 11.9Mbps down 500kbps up

Regards,
-Vladimir
