Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 704C71A4833
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 18:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgDJQE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 12:04:26 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35044 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbgDJQE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 12:04:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=lJOWCxjPL/ALfjLUilPMAQRc5v+T6imQJFxb2OX5QXU=; b=1Ra20NCxTc2181f1SK3OC19Qu
        YeMvGWGipEwINt7RrhJhAjQA2BWkb2NFMVti4JTPmEnNrFJ627+U47XQgeD/skIrFrLTclEvzuPy9
        wZQ0EGSTeEtRHcAIzJbkJ7+u+nfRZz69nI1z8tbYz8pUwBAFCZhvN3EQ4xNv33usFscjQD/ot98Xt
        qObYrl1ah3u1g55H/FOrdK0V7VZW1cf3BHnk1m32NMclJaXYw/NTeJ9lFB2cH9xR76/VZvOlQRW+z
        pmOctdphpxpe+f1/5raVX52E5AqN9FYKqkRz3INop4wkwrh3oz8MzZEkRD+2PxSAuPhvQaGYPWOCP
        deCTcvo/Q==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:44108)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jMw8c-0002OI-IK; Fri, 10 Apr 2020 17:04:14 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jMw8X-00045W-A9; Fri, 10 Apr 2020 17:04:09 +0100
Date:   Fri, 10 Apr 2020 17:04:09 +0100
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
Message-ID: <20200410160409.GC25745@shell.armlinux.org.uk>
References: <20200303155347.GS25745@shell.armlinux.org.uk>
 <E1j99sC-00011f-22@rmk-PC.armlinux.org.uk>
 <CAGnkfhx+JkD6a_8ojU6tEL_vk6vtwQpxbwU9+beDepL4dxgLyQ@mail.gmail.com>
 <20200410141914.GY25745@shell.armlinux.org.uk>
 <20200410143658.GM5827@shell.armlinux.org.uk>
 <CAGnkfhxPm6UWj8Dyt9S08vHdh9nwkTums+WfY14D52dsBsBPgQ@mail.gmail.com>
 <20200410145034.GA25745@shell.armlinux.org.uk>
 <CAGnkfhwOCLSG=3v2jy6tTxiPyX0H+Azj7Ni5t8_nkRi=rUfnUQ@mail.gmail.com>
 <20200410151627.GB25745@shell.armlinux.org.uk>
 <CAGnkfhyE8q3iM6oW73R2ZUys+osd6YVYWcDDp6-YDsxmyzgKrg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGnkfhyE8q3iM6oW73R2ZUys+osd6YVYWcDDp6-YDsxmyzgKrg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 10, 2020 at 05:18:41PM +0200, Matteo Croce wrote:
> On Fri, Apr 10, 2020 at 5:16 PM Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
> >
> > On Fri, Apr 10, 2020 at 04:59:44PM +0200, Matteo Croce wrote:
> > > On Fri, Apr 10, 2020 at 4:50 PM Russell King - ARM Linux admin
> > > <linux@armlinux.org.uk> wrote:
> > > >
> > > > On Fri, Apr 10, 2020 at 04:39:48PM +0200, Matteo Croce wrote:
> > > # ./mii-diag eth0 -p 32769
> > > Using the specified MII PHY index 32769.
> > > Basic registers of MII PHY #32769:  2040 0082 002b 09ab 0071 009a c000 0009.
> > >  Basic mode control register 0x2040: Auto-negotiation disabled, with
> > >  Speed fixed at 100 mbps, half-duplex.
> > >  Basic mode status register 0x0082 ... 0082.
> > >    Link status: not established.
> > >    *** Link Jabber! ***
> > >  Your link partner is generating 100baseTx link beat  (no autonegotiation).
> > >    End of basic transceiver information.
> > >
> > > root@macchiatobin:~# ip link show dev eth0
> > > 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP
> > > mode DEFAULT group default qlen 2048
> > >     link/ether 00:51:82:11:22:00 brd ff:ff:ff:ff:ff:ff
> > >
> > > But no traffic in any direction
> >
> > So you have the same version PHY hardware as I do.
> >
> > So, we need further diagnosis, which isn't possible without a more
> > advanced mii-diag tool - I'm sorting that out now, and will provide
> > a link to a git repo later this afternoon.
> >
> 
> Ok, I'll wait for the tool

Okay, please give this a go:

	git://git.armlinux.org.uk/~rmk/mii-diag/

Please send me the full output from:

# ./mii-diag eth0 -v -p 32768

It does colourise some of the output (which I should make conditional)
so don't be surprised if there's some escape codes in the output.
Please take this as alpha software; it needs a more work, and please
don't bother Donald Becker about it either!

You should see something like this:

mii-diag.c:v2.11 3/21/2005 Donald Becker (becker@scyld.com)
 http://www.scyld.com/diag/index.html
  Using the new SIOCGMIIPHY value on PHY 0 (BMCR 0x2040).
Using the specified MII PHY index 32768.
  No MII transceiver present!.
  Use '--force' to view the information anyway.
libmii.c:v2.11 2/28/2005  Donald Becker (becker@scyld.com)
 http://www.scyld.com/diag/index.html

 MII PHY #0:1 PMA/PMD transceiver registers:
   2040 0082 002b 09ab 0071 009a c000 0009
   9701 0000 0000 01a4 0000 0000 002b 09ab
   0000 0000 0000 0000 0000 0003 0000 0000
   0000 0000 0000 0000 0000 0000 0000 0000
   0000 0000 0000 0000 0000 0000 0000 0000
   0000 0000 0000 0000 0000 0000 0000 0000
   0000 0000 0000 0000 0000 0000 0000 0000
   0000 0000 0000 0000 0000 0000 0000 0000.
 Vendor ID is 00:0a:c2:--:--:--, model 26 rev. 11.
   Vendor/Part: Marvell Semiconductor 88X3310.
...

For a SFP cage connection, the relevant parts are:

MII PHY #0:3 PCS Subdevice #2 transceiver registers
MII PHY #0:4 PHY XS Subdevice #2 transceiver registers
MII PHY #0:7 AN Subdevice #2 transceiver registers
MII PHY #0:7 AN Subdevice #3 transceiver registers

which should all say that link is established.

Also, note that the 88x3310 is setup to link with the _first_ media
type that comes up, so if you have both a connection through the SFP+
cage and copper, the first that establishes link will be active and
the other media will remain inactive.  So, only have either the SFP+
cage populated or the RJ45, never both.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
