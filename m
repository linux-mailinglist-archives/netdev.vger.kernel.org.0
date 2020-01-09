Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66F6C1362B5
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 22:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728686AbgAIViy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 16:38:54 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:59084 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbgAIViy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 16:38:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=IaRVjxZGObhzfteZ0Bq+IyzlKQKqWna7YJqxIDkUkuk=; b=V8dFgKKMJI2ngJhXC1xmNcXCy
        L0ZD0m/GH+amRL9Sdd2m5tW3igLsTmJOWE0aY3iHohnZpISMOCEE2tCEkkqbeiG/7uAxKjNgynbiW
        fqSbG16kTn4KZk9VtNioa3Wvt0E3Pbh+CcN+vdOz5RSL7jyre0+/axpOR1Wp4R2lWUn/n3fsDnjBe
        uUMtQr2PvfKl1Ec1jJHJNhUyXggwiBRQWHrI4SqowU4AYZVedZwBzYD/orNPftrckdp34NWADc+ED
        Obq3kA3dYlHO+mJ2sVLePjHGLOUUc384dx+tfl2x6tdHYNYuNdT56icCkx/M+Y5+V47h/B/OqWqWQ
        VypVXnQqA==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:60306)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ipfVz-0007Tg-8m; Thu, 09 Jan 2020 21:38:51 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ipfVy-0000pD-L7; Thu, 09 Jan 2020 21:38:50 +0000
Date:   Thu, 9 Jan 2020 21:38:50 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     =?utf-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: [drivers/net/phy/sfp] intermittent failure in state machine
 checks
Message-ID: <20200109213850.GT25745@shell.armlinux.org.uk>
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

That would be very very broken behaviour, but one which the kernel
doesn't care about.

If RX_LOS is active, we do *not* disable the NIC. We just use RX_LOS as
an additional input to evaluating whether the link is up.  The NIC will
still be configured for the appropriate mode irrespective of the state
of RX_LOS.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
