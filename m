Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6950136C39
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 12:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbgAJLoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 06:44:39 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40340 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727457AbgAJLoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 06:44:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=JVCI5ltq5loWQDRLCBbDSXh+p7gb//3OaspLnZclnJk=; b=HC6EBL5fFLkyccZhempoBSUhx
        Dwc42KL23k1E/mssytbx75CtpAfYIczC7Cab9HeNDieh9ywzLTFt1GAq/1Hny/cmUdlCe5lIXN02g
        Qmc3M+8XwoLM6TfXQzbi8Al89Z5P7DI3ePy2n7mTKr+G7ZPCFLHX8c3SDfgVPqDmAuTvkTL0LW2Qv
        Lqgwvrsed7NIR0Z5iTvFNx2SL8nihcfpaLBvhKQMsGE4r23PeEWg6asEInn1JuVw1wnm9OyIWpxpu
        mT6KGa1H/4X4eAlEMQx9Bq0nDNDqXYcPkczb/sEMYP8Rk5dRDhIARgfzhpJAjtLJevUpZe1XEJnCR
        kbrqzR4Yw==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:60578)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ipsiR-0002k8-0U; Fri, 10 Jan 2020 11:44:35 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ipsiP-0001TT-TK; Fri, 10 Jan 2020 11:44:33 +0000
Date:   Fri, 10 Jan 2020 11:44:33 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     =?utf-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: [drivers/net/phy/sfp] intermittent failure in state machine
 checks
Message-ID: <20200110114433.GZ25745@shell.armlinux.org.uk>
References: <bb2c2eed-5efa-00f6-0e52-1326669c1b0d@gmx.net>
 <20200109174322.GR25745@shell.armlinux.org.uk>
 <acd4d7e4-7f8e-d578-c9c9-b45f062f4fe2@gmx.net>
 <7ebee7c5-4bf3-134d-bc57-ea71e0bdfc60@gmx.net>
 <20200109215903.GV25745@shell.armlinux.org.uk>
 <c7b4bec1-3f1f-8a34-cf22-8fb1f68914f3@gmx.net>
 <20200109231034.GW25745@shell.armlinux.org.uk>
 <727cea4e-9bff-efd2-3939-437038a322ad@gmx.net>
 <20200110092700.GX25745@shell.armlinux.org.uk>
 <18687669-e6f5-79f1-6cf9-d62d65f195db@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <18687669-e6f5-79f1-6cf9-d62d65f195db@gmx.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 10, 2020 at 09:50:00AM +0000, ѽ҉ᶬḳ℠ wrote:
> On 10/01/2020 09:27, Russell King - ARM Linux admin wrote:
> > On Thu, Jan 09, 2020 at 11:50:14PM +0000, ѽ҉ᶬḳ℠ wrote:
> > > On 09/01/2020 23:10, Russell King - ARM Linux admin wrote:
> > > > Please don't use mii-tool with SFPs that do not have a PHY; the "PHY"
> > > > registers are emulated, and are there just for compatibility. Please
> > > > use ethtool in preference, especially for SFPs.
> > > Sure, just ethtool is not much of help for this particular matter, all there
> > > is ethtool -m and according to you the EEPROM dump is not to be relied on.
> > How about just "ethtool eth2" ?
> 
> Settings for eth2:
>         Supported ports: [ TP ]
>         Supported link modes:   1000baseX/Full
>         Supported pause frame use: Symmetric
>         Supports auto-negotiation: Yes
>         Supported FEC modes: Not reported
>         Advertised link modes:  1000baseX/Full
>         Advertised pause frame use: Symmetric
>         Advertised auto-negotiation: Yes
>         Advertised FEC modes: Not reported
>         Speed: 1000Mb/s
>         Duplex: Full
>         Port: Twisted Pair
>         PHYAD: 0
>         Transceiver: internal
>         Auto-negotiation: on
>         MDI-X: Unknown
>         Supports Wake-on: d
>         Wake-on: d
>         Link detected: yes

That looks fine.

> > > > CONFIG_DEBUG_GPIO is not the same as having debugfs support enabled.
> > > > If debugfs is enabled, then gpiolib will provide the current state
> > > > of gpios through debugfs.  debugfs is normally mounted on
> > > > /sys/kernel/debug, but may not be mounted by default depending on
> > > > policy.  Looking in /proc/filesystems will tell you definitively
> > > > whether debugfs is enabled or not in the kernel.
> > > debugsfs is mounted but ls -af /sys/kernel/debug/gpio only producing
> > > (oddly):
> > > 
> > > /sys/kernel/debug/gpio
> > Try "cat /sys/kernel/debug/gpio"
> 
> gpiochip2: GPIOs 504-511, parent: i2c/8-0071, pca9538, can sleep:
>  gpio-504 (                    |tx-fault            ) in  lo IRQ
>  gpio-505 (                    |tx-disable          ) out lo
>  gpio-506 (                    |rate-select0        ) in  lo
>  gpio-507 (                    |los                 ) in  lo IRQ
>  gpio-508 (                    |mod-def0            ) in  lo IRQ

Which is also indicating everything is correct.  When the problem
occurs, check the state of the signals again as close as possible
to the event - it depends how long the transceiver keeps it
asserted.  You will probably find tx-fault is indicating
"in  hi IRQ".

> Meantime Allnet responded, which basically sums up to (blame ping pong - it
> is not me but go and look there instead...)
> 
> - driver support is not being handled by Allnet but by Metanoia, latter
> being designer and manufacturer
> - Allnet does not have the buying power to persuade Metanoia to look into
> the matter

... which is pretty standard; no one will rework their SFP unless
they fear their sales will be severely impacted by the issue.

> - it would appear that SFP.C is trying to communicate with Fiber-GBIC and
> fails since the signal reports may not be 100% compatible

That's a fun claim, but note carefully the wording "may" which implies
some uncertainty in the statement.

Let's look at the wording of the GBIC (SFF-8053) and SFP (INF-8074 -
SFP MSA) documents.  The wording for the "fault recovery" is identical
between the two, which concerns what happens when TX_FAULT is asserted
and how to recover from that.

Concerning the implementation of TX_FAULT, SFF-8053 states:

  If no transmitter safety circuitry is implemented, the TX_FAULT signal
  may be tied to its negated state.

but then says later in the document:

  If TX_FAULT is not implemented, the signal shall be held to the low
  state by the GBIC.

Meanwhile, INF-8074 similarly states:

  If no transmitter safety circuitry is implemented, the TX_FAULT signal
  may be tied to its negated state.

but later on has a similar statement:

  TX_FAULT shall be implemented by those module definitions of SFP
  transceiver supporting safety circuitry. If TX_FAULT is not
  implemented, the signal shall be held to the low state by the SFP
  transceiver.

"shall" in both cases is stronger than "may".  So, there seems to be
little difference between the GBIC and SFP usage of this signal.

Their claim is that sfp.c implements the older GBIC style of signal
reports.  My counter-claim is that (a) sfp.c is written to the SFP MSA
and not the GBIC standard, and (b) there is no difference as far as the
TX_FAULT signal is concerned between the GBIC standard and the SFP MSA.

But... it doesn't matter that much, there's a module out there (and it
isn't the only one) which does "funny stuff" with its TX_FAULT signal.
Either we decide we want to support it and implement a quirk, or we
decide we don't want to support it.

There is an option bit in the EEPROM that is supposed to indicate
whether the module supports TX_FAULT, but, as you can guess, there are
problems with using that, as:

1) there are a lot of modules, particularly optical modules, that
   implement TX_FAULT correctly but don't set the option bit to say
   that they support the signal.

2) the other module I'm aware of that does "funny stuff" with its
   TX_FAULT signal does have the TX_FAULT option bit set.

So, the option bit is completely untrustworthy and, therefore, is
meaningless (which is why we don't use it.)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
