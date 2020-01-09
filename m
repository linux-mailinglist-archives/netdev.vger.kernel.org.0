Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C386E1362EE
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 22:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728980AbgAIV7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 16:59:09 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:59330 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbgAIV7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 16:59:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Y1KZyHRFeGHv//z/SmNDGneqRls/FEBEFDkKZCT40Ss=; b=kQXEPvCQeq5Bae2OTx41jPeN7
        ctNSK4Twsja2vnr2uEeUFZwMzXjhXcwasAOJmRWA1OOWRefd2I/nOvFM/NpRfCLJ0YYa1msCQpZzb
        /xQtpPEObg2wfBNhU8SU4w72NXCoeEmNf/Tu1C3CwLO1RL4TjCGTCbxq9MsZPLhv9ZFvMuEJ2dTYb
        bmAz4yTZYIKOit7A60N9549YG+eSBNhNSaDWfqKvNZDk7nKv9Wmwlan66DBu9p4lk6EmaSeCMFfTn
        eEFSiXiMUQRqkD9eDuk7+ZTdEM6xCg7Ws+AiwvtzWKbFeub5t8AgF2pd6mpfLQJenUoGC7/lbbHWa
        tfTxaDVZQ==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:60310)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ipfpY-0007Zb-S7; Thu, 09 Jan 2020 21:59:05 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ipfpX-0000qS-RK; Thu, 09 Jan 2020 21:59:03 +0000
Date:   Thu, 9 Jan 2020 21:59:03 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     =?utf-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: [drivers/net/phy/sfp] intermittent failure in state machine
 checks
Message-ID: <20200109215903.GV25745@shell.armlinux.org.uk>
References: <d8d595ff-ec35-3426-ec43-9afd67c15e3d@gmx.net>
 <20200109144106.GA24459@lunn.ch>
 <513d6fe7-65b2-733b-1d17-b3a40b8161cf@gmx.net>
 <20200109155809.GQ25745@shell.armlinux.org.uk>
 <bb2c2eed-5efa-00f6-0e52-1326669c1b0d@gmx.net>
 <20200109174322.GR25745@shell.armlinux.org.uk>
 <acd4d7e4-7f8e-d578-c9c9-b45f062f4fe2@gmx.net>
 <7ebee7c5-4bf3-134d-bc57-ea71e0bdfc60@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7ebee7c5-4bf3-134d-bc57-ea71e0bdfc60@gmx.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 09, 2020 at 07:42:27PM +0000, ѽ҉ᶬḳ℠ wrote:
> On 09/01/2020 19:01, ѽ҉ᶬḳ℠ wrote:
> > On 09/01/2020 17:43, Russell King - ARM Linux admin wrote:
> > > On Thu, Jan 09, 2020 at 05:35:23PM +0000, ѽ҉ᶬḳ℠ wrote:
> > > > Thank you for the extensive feedback and explanation.
> > > > 
> > > > Pardon for having mixed up the semantics on module
> > > > specifications vs. EEPROM
> > > > dump...
> > > > 
> > > > The module (chipset) been designed by Metanoia, not sure who is
> > > > the actual
> > > > manufacturer, and probably just been branded Allnet.
> > > > The designer provides some proprietary management software
> > > > (called EBM) to
> > > > their wholesale buyers only
> > > I have one of their early MT-V5311 modules, but it has no accessible
> > > EEPROM, and even if it did, it would be of no use to me being
> > > unapproved for connection to the BT Openreach network.  (BT SIN 498
> > > specifies non-standard power profile to avoid crosstalk issues with
> > > existing ADSL infrastructure, and I believe they regularly check the
> > > connected modem type and firmware versions against an approved list.)
> > > 
> > > I haven't noticed the module I have asserting its TX_FAULT signal,
> > > but then its RJ45 has never been connected to anything.
> > > 
> > 
> > The curious (and sort of inexplicable) thing is that the module in
> > general works, i.e. at some point it must pass the sm checks or
> > connectivity would be failing constantly and thus the module being
> > generally unusable.
> > 
> > The reported issues however are intermittent, usually reliably
> > reproducible with
> > 
> > ifdown <iface> && ifup <iface>
> > 
> > or rebooting the router that hosts the module.
> > 
> > If some times passes, not sure but seems in excess of 3 minutes, between
> > ifdown and ifup the sm checks mostly are not failing.
> > It somehow "feels" that the module is storing some link signal
> > information in a register which does not suit the sm check routine and
> > only when that register clears the sm check routine passes and
> > connectivity is restored.
> > ____
> > 
> > Since there are probably other such SFP modules, xDSL and g.fast, out
> > there that do not provide laser safety circuitry by design (since not
> > providing connectivity over fibre) would it perhaps not make sense to
> > try checking for the existence of laser safety circuitry first prior
> > getting to the sm checks?
> > ____
> > 
> 
> I am wondering whether this mentioned in
> https://gitlab.labs.nic.cz/turris/turris-build/issues/89 is the cause of the
> issue perhaps:
> 
> Even when/after the SFP module is recognized and the link mode it set for
> the NIC to the proper value there can still be the link-up signal mismatch
> that we have seen on many non-ethernet SFPs. The thing is that one of the
> SFP pins is called LOS (loss of signal) and when the pin is in active state
> it is being interpreted by the Linux kernel as "link is down", turn off the
> NIC. Unfortunatelly we have seen chicken-and-egg problem with some GPON and
> DSL SFPs - the SFP does not come up and deassert LOS unless there is SGMII
> link from NIC and NIC is not coming up unless LOS is deasserted.

Also, note that the Metanoia MT-V5311 (at least mine) uses 1000BASE-X
not SGMII. It sends a 16-bit configuration word of 0x61a0, which is:

		1000BASE-X			SGMII
Bit 15	0	No next page			Link down
	1	Ack				Ack
	1	Remote fault 2			Reserved (0)
	0	Remote fault 1			Duplex (0 = Half)

	0	Reserved (0)			Speed bit 1
	0	Reserved (0)			Speed bit 0 (00=10Mbps)
	0	Reserved (0)			Reserved (0)
	1	Asymetric pause direction	Reserved (0)

	1	Pause				Reserved (0)
	0	Half duplex not supported	Reserved (0)
	1	Full duplex supported		Reserved (0)
	0	Reserved (0)			Reserved (0)

	0	Reserved (0)			Reserved (0)
	0	Reserved (0)			Reserved (0)
	0	Reserved (0)			Reserved (0)
Bit 0	0	Reserved (0)			Must be 1

So it clearly fits 802.3 Clause 37 1000BASE-X format, reporting 1G
Full duplex, and not SGMII (10M Half duplex).

I have a platform here that allows me to get at the raw config_reg
word that the other end has sent which allows analysis as per the
above.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
