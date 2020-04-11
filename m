Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 488411A4EF1
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 10:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725923AbgDKIhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 04:37:23 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:45724 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbgDKIhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Apr 2020 04:37:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Ll6RhuVfdlh/XngE+fca5jUOVkWyC1wNY/8ygc6mamA=; b=FDdUJo9qefhe33riIg0a5zD67
        ZvxYLQC7yYQYFuLK9+BMnmtqtXc2U7AZILCikAvjF7Yr1YfrrQHZF3mXorO/KDosSaME4sJHS1+Yg
        IFmv1ObVKEk2RgRRMefwa4I1xRZ13E7QT0XxvfXWByxVZQRZiZX5+z5lHQUZNP2f3JTVEXELSYKky
        ph12xoASELGErXBnqTvCKzCme+G86BhBZ9bbdZ0pbhmIc5cBzWWnqhi82euPp79bqrtP533DNrrkQ
        Fq/5TKofChUOTnXq+jkfnbZxGkmyBC9WgC5Ri/dWe5cCqRc2kEHzP1Gbsy0ODiWAvPZS/AD6M863S
        cJHnC0qiQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48566)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jNBdQ-0006GS-Se; Sat, 11 Apr 2020 09:37:11 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jNBdK-0004tC-Eh; Sat, 11 Apr 2020 09:36:58 +0100
Date:   Sat, 11 Apr 2020 09:36:58 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Luka Perkov <luka.perkov@sartura.hr>
Subject: Re: [PATCH net-next v2 3/3] net: phy: marvell10g: place in powersave
 mode at probe
Message-ID: <20200411083658.GF25745@shell.armlinux.org.uk>
References: <20200410143658.GM5827@shell.armlinux.org.uk>
 <CAGnkfhxPm6UWj8Dyt9S08vHdh9nwkTums+WfY14D52dsBsBPgQ@mail.gmail.com>
 <20200410145034.GA25745@shell.armlinux.org.uk>
 <CAGnkfhwOCLSG=3v2jy6tTxiPyX0H+Azj7Ni5t8_nkRi=rUfnUQ@mail.gmail.com>
 <20200410151627.GB25745@shell.armlinux.org.uk>
 <CAGnkfhyE8q3iM6oW73R2ZUys+osd6YVYWcDDp6-YDsxmyzgKrg@mail.gmail.com>
 <20200410160409.GC25745@shell.armlinux.org.uk>
 <CAGnkfhxSjQcX=Di7XMdDCA=zCf7=Jtv2CFR=4keYeib6x=tbFA@mail.gmail.com>
 <20200410162313.GD25745@shell.armlinux.org.uk>
 <CAGnkfhwedGe4_JAy5Ok7bxYPi_C9bqVWh1fjV6eGy2Ss+-hSag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGnkfhwedGe4_JAy5Ok7bxYPi_C9bqVWh1fjV6eGy2Ss+-hSag@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 10, 2020 at 06:30:48PM +0200, Matteo Croce wrote:
> On Fri, Apr 10, 2020 at 6:23 PM Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
> >
> > On Fri, Apr 10, 2020 at 06:07:46PM +0200, Matteo Croce wrote:
> > > On Fri, Apr 10, 2020 at 6:04 PM Russell King - ARM Linux admin
> > > <linux@armlinux.org.uk> wrote:
> > > >
> > > > On Fri, Apr 10, 2020 at 05:18:41PM +0200, Matteo Croce wrote:
> > > > > On Fri, Apr 10, 2020 at 5:16 PM Russell King - ARM Linux admin
> > > > > <linux@armlinux.org.uk> wrote:
> > > > > >
> > > > > > On Fri, Apr 10, 2020 at 04:59:44PM +0200, Matteo Croce wrote:
> > > > > > > On Fri, Apr 10, 2020 at 4:50 PM Russell King - ARM Linux admin
> > > > > > > <linux@armlinux.org.uk> wrote:
> > > > > > > >
> > > > > > > > On Fri, Apr 10, 2020 at 04:39:48PM +0200, Matteo Croce wrote:
> > > > > > > # ./mii-diag eth0 -p 32769
> > > > > > > Using the specified MII PHY index 32769.
> > > > > > > Basic registers of MII PHY #32769:  2040 0082 002b 09ab 0071 009a c000 0009.
> > > > > > >  Basic mode control register 0x2040: Auto-negotiation disabled, with
> > > > > > >  Speed fixed at 100 mbps, half-duplex.
> > > > > > >  Basic mode status register 0x0082 ... 0082.
> > > > > > >    Link status: not established.
> > > > > > >    *** Link Jabber! ***
> > > > > > >  Your link partner is generating 100baseTx link beat  (no autonegotiation).
> > > > > > >    End of basic transceiver information.
> > > > > > >
> > > > > > > root@macchiatobin:~# ip link show dev eth0
> > > > > > > 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP
> > > > > > > mode DEFAULT group default qlen 2048
> > > > > > >     link/ether 00:51:82:11:22:00 brd ff:ff:ff:ff:ff:ff
> > > > > > >
> > > > > > > But no traffic in any direction
> > > > > >
> > > > > > So you have the same version PHY hardware as I do.
> > > > > >
> > > > > > So, we need further diagnosis, which isn't possible without a more
> > > > > > advanced mii-diag tool - I'm sorting that out now, and will provide
> > > > > > a link to a git repo later this afternoon.
> > > > > >
> > > > >
> > > > > Ok, I'll wait for the tool
> > > >
> > > > Okay, please give this a go:
> > > >
> > > >         git://git.armlinux.org.uk/~rmk/mii-diag/
> > > >
> > > > Please send me the full output from:
> > > >
> > > > # ./mii-diag eth0 -v -p 32768
> > > >
> > >
> > > Hi,
> > >
> > > here it is:
> >
> > Thanks.  It seems that the PHY is reporting that everything is fine,
> > all the various blocks associated with the SFP+ cage are reporting
> > that link is established, and link is established with the host.
> >
> > I wonder - can you tcpdump to see whether any traffic is being
> > received at either end of the link, in case it's only one direction
> > that is a problem?
> >
> 
> Hi,
> 
> The problem is in both directions, I can't receive anything, and sent
> can't be received from the other end.
> 
> # ip -s link show dev eth0
> 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP
> mode DEFAULT group default qlen 2048
>     link/ether 00:51:82:11:22:00 brd ff:ff:ff:ff:ff:ff
>     RX: bytes  packets  errors  dropped overrun mcast
>     0          0        0       0       0       0
>     TX: bytes  packets  errors  dropped carrier collsns
>     252        6        0       0       0       0
> 
> If it can help, I can provide you access to the box.

Those statistics look suspicious - do you have IPv6 enabled?  If so,
those six packets are likely to be router discovery packets for IPv6.

Yes, I think having access to the box would be helpful to speed up
the diagnosis.  Also, having details of what is on the other end of
the DAC cable would be useful too.  Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
