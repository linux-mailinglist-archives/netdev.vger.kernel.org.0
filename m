Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 639DD1A485C
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 18:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgDJQX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 12:23:26 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35286 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726234AbgDJQXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 12:23:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=vc0KTI11z6UG0jeGMHn+oL4VCmazbxeYViH4wlzR8VU=; b=IX5H8ONyEZVY2HvuY/JV09MW0
        SslDjc07+6Y0ZCxqYi0FrAktmWp45c/DWuIu4nvDCMLMkwo+HjKW/wxedtNaKY6cmqJ3W0pyXLBOl
        MuKAqAeV2roftXwD6fbKF1cmnwerlyGWIkt7u6jlmC3ijH09wU+SOK9Ie6xCEmUriWygYRZURc+AJ
        KplTUsfXpQk0sPQPYzjfEifVbk25u5vMwr+L0sEDov76B8kOyWcV+pGOhKJVxtyoGRCdj8zMAMdyC
        Mwcm2hk6Btw92SgrjbVGWAyYo9tcDVP0/C6MkJjuUUEb+UDcQ3N52Sxr9AJMYgwICn+unDXpo/ygA
        vNJIVh3gw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48250)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jMwR1-0002Sp-5r; Fri, 10 Apr 2020 17:23:15 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jMwQz-00049c-CN; Fri, 10 Apr 2020 17:23:13 +0100
Date:   Fri, 10 Apr 2020 17:23:13 +0100
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
Message-ID: <20200410162313.GD25745@shell.armlinux.org.uk>
References: <CAGnkfhx+JkD6a_8ojU6tEL_vk6vtwQpxbwU9+beDepL4dxgLyQ@mail.gmail.com>
 <20200410141914.GY25745@shell.armlinux.org.uk>
 <20200410143658.GM5827@shell.armlinux.org.uk>
 <CAGnkfhxPm6UWj8Dyt9S08vHdh9nwkTums+WfY14D52dsBsBPgQ@mail.gmail.com>
 <20200410145034.GA25745@shell.armlinux.org.uk>
 <CAGnkfhwOCLSG=3v2jy6tTxiPyX0H+Azj7Ni5t8_nkRi=rUfnUQ@mail.gmail.com>
 <20200410151627.GB25745@shell.armlinux.org.uk>
 <CAGnkfhyE8q3iM6oW73R2ZUys+osd6YVYWcDDp6-YDsxmyzgKrg@mail.gmail.com>
 <20200410160409.GC25745@shell.armlinux.org.uk>
 <CAGnkfhxSjQcX=Di7XMdDCA=zCf7=Jtv2CFR=4keYeib6x=tbFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGnkfhxSjQcX=Di7XMdDCA=zCf7=Jtv2CFR=4keYeib6x=tbFA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 10, 2020 at 06:07:46PM +0200, Matteo Croce wrote:
> On Fri, Apr 10, 2020 at 6:04 PM Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
> >
> > On Fri, Apr 10, 2020 at 05:18:41PM +0200, Matteo Croce wrote:
> > > On Fri, Apr 10, 2020 at 5:16 PM Russell King - ARM Linux admin
> > > <linux@armlinux.org.uk> wrote:
> > > >
> > > > On Fri, Apr 10, 2020 at 04:59:44PM +0200, Matteo Croce wrote:
> > > > > On Fri, Apr 10, 2020 at 4:50 PM Russell King - ARM Linux admin
> > > > > <linux@armlinux.org.uk> wrote:
> > > > > >
> > > > > > On Fri, Apr 10, 2020 at 04:39:48PM +0200, Matteo Croce wrote:
> > > > > # ./mii-diag eth0 -p 32769
> > > > > Using the specified MII PHY index 32769.
> > > > > Basic registers of MII PHY #32769:  2040 0082 002b 09ab 0071 009a c000 0009.
> > > > >  Basic mode control register 0x2040: Auto-negotiation disabled, with
> > > > >  Speed fixed at 100 mbps, half-duplex.
> > > > >  Basic mode status register 0x0082 ... 0082.
> > > > >    Link status: not established.
> > > > >    *** Link Jabber! ***
> > > > >  Your link partner is generating 100baseTx link beat  (no autonegotiation).
> > > > >    End of basic transceiver information.
> > > > >
> > > > > root@macchiatobin:~# ip link show dev eth0
> > > > > 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP
> > > > > mode DEFAULT group default qlen 2048
> > > > >     link/ether 00:51:82:11:22:00 brd ff:ff:ff:ff:ff:ff
> > > > >
> > > > > But no traffic in any direction
> > > >
> > > > So you have the same version PHY hardware as I do.
> > > >
> > > > So, we need further diagnosis, which isn't possible without a more
> > > > advanced mii-diag tool - I'm sorting that out now, and will provide
> > > > a link to a git repo later this afternoon.
> > > >
> > >
> > > Ok, I'll wait for the tool
> >
> > Okay, please give this a go:
> >
> >         git://git.armlinux.org.uk/~rmk/mii-diag/
> >
> > Please send me the full output from:
> >
> > # ./mii-diag eth0 -v -p 32768
> >
> 
> Hi,
> 
> here it is:

Thanks.  It seems that the PHY is reporting that everything is fine,
all the various blocks associated with the SFP+ cage are reporting
that link is established, and link is established with the host.

I wonder - can you tcpdump to see whether any traffic is being
received at either end of the link, in case it's only one direction
that is a problem?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
