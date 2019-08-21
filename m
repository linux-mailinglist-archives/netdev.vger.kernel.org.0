Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD48D9838D
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 20:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728412AbfHUStv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 14:49:51 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:29465 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727504AbfHUStv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 14:49:51 -0400
Received-SPF: Pass (esa5.microchip.iphmx.com: domain of
  Allan.Nielsen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="Allan.Nielsen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa5.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa5.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Allan.Nielsen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: N1DHthJefdVPBM2fae9rSFG3mp/ISP7wq15BVC+4UmoZjR/z1GTKCAejtcIcsFG3I2fnBCnrW7
 9DE/UEhwtSxjHPPC2K4rTeQ2oRl2DEdZBoO73qAVY/qrDTTrd6nxNaaxE8gjXq2I51t9R5FEJt
 9uyzYSh+J7u5vGtPzZ95QzpOh1JDmfRc0nb1NHxygbYgWudn57G0b3wJVwk12Q/P6yuSfghZIV
 2hea9DbQuUpFrLozaBtorf0h4wdzarPxFpY04AOjiUui55WGmEl+wjBXFSZjAIDh+lQjYbbdj6
 TiE=
X-IronPort-AV: E=Sophos;i="5.64,412,1559545200"; 
   d="scan'208";a="44486278"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Aug 2019 11:49:50 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 21 Aug 2019 11:49:49 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Wed, 21 Aug 2019 11:49:49 -0700
Date:   Wed, 21 Aug 2019 20:49:48 +0200
From:   "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        <netdev@vger.kernel.org>, <andrew@lunn.ch>,
        <kernel@pengutronix.de>, <hkallweit1@gmail.com>,
        <Ravi.Hegde@microchip.com>, <Tristram.Ha@microchip.com>,
        <Yuiko.Oshino@microchip.com>, <Woojung.Huh@microchip.com>
Subject: Re: net: micrel: confusion about phyids used in driver
Message-ID: <20190821184947.43iilefgrjn4zrtl@lx-anielsen.microsemi.net>
References: <20190509202929.wg3slwnrfhu4f6no@pengutronix.de>
 <da599967-c423-80dd-945d-5b993c041e90@gmail.com>
 <20190509210745.GD11588@lunn.ch>
 <20190510072243.h6h3bgvr2ovsh5g5@pengutronix.de>
 <20190702203152.gviukfldjhdnmu7j@pengutronix.de>
 <BL0PR11MB3251651EB9BC45DF4282D51D8EF80@BL0PR11MB3251.namprd11.prod.outlook.com>
 <20190808083637.g77loqpgkzi63u55@pengutronix.de>
 <20190820202503.xauhbrj24p3vcoxp@pengutronix.de>
 <1057c2c2-e1f0-75ba-3878-dbd52805e0cc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1057c2c2-e1f0-75ba-3878-dbd52805e0cc@gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 08/21/2019 10:24, Florian Fainelli wrote:
> +Allan,
> 
> On 8/20/19 1:25 PM, Uwe Kleine-König wrote:
> > Hello Nicolas,
> > 
> > there are some open questions regarding details about some PHYs
> > supported in the drivers/net/phy/micrel.c driver.
> > 
> > On Thu, Aug 08, 2019 at 10:36:37AM +0200, Uwe Kleine-König wrote:
> >> On Tue, Jul 02, 2019 at 08:55:07PM +0000, Yuiko.Oshino@microchip.com wrote:
> >>>> On Fri, May 10, 2019 at 09:22:43AM +0200, Uwe Kleine-König wrote:
> >>>>> On Thu, May 09, 2019 at 11:07:45PM +0200, Andrew Lunn wrote:
> >>>>>> On Thu, May 09, 2019 at 10:55:29PM +0200, Heiner Kallweit wrote:
> >>>>>>> On 09.05.2019 22:29, Uwe Kleine-König wrote:
> >>>>>>>> I have a board here that has a KSZ8051MLL (datasheet:
> >>>>>>>> http://ww1.microchip.com/downloads/en/DeviceDoc/ksz8051mll.pdf, phyid:
> >>>>>>>> 0x0022155x) assembled. The actual phyid is 0x00221556.
> > 
> > The short version is that a phy with ID 0x00221556 matches two
> > phy_driver entries in the driver:
> > 
> > 	{ .phy_id = PHY_ID_KSZ8031, .phy_id_mask = 0x00ffffff, ... },
> > 	{ .phy_id = PHY_ID_KSZ8051, .phy_id_mask = MICREL_PHY_ID_MASK, ... }
> > 
> > The driver doesn't behave optimal for "my" KSZ8051MLL with both entries
> > ... It seems to work, but not all features of the phy are used and the
> > bootlog claims this was a KSZ8031 because that's the first match in the
> > list.
> > 
> > So we're in need of someone who can get their hands on some more
> > detailed documentation than publicly available to allow to make the
> > driver handle the KSZ8051MLL correctly without breaking other stuff.
> > 
> > I assume you are in a different department of Microchip than the people
> > caring for PHYs, but maybe you can still help finding someone who cares?
> 
> Allan, is this something you could help with? Thanks!
Sorry, I'm new in Microchip (was aquired through Microsemi), and I know next to
nothing about the Micrel stuff.

Woojung: Can you comment on this, or try to direct this to someone who knows
something...

> >>>>>>> I think the datasheets are the source of the confusion. If the
> >>>>>>> datasheets for different chips list 0x0022155x as PHYID each, and
> >>>>>>> authors of support for additional chips don't check the existing
> >>>>>>> code, then happens what happened.
> >>>>>>>
> >>>>>>> However it's not a rare exception and not Microchip-specific that
> >>>>>>> sometimes vendors use the same PHYID for different chips.
> >>>>>
> >>>>> From the vendor's POV it is even sensible to reuse the phy IDs iff the
> >>>>> chips are "compatible".
> >>>>>
> >>>>> Assuming that the last nibble of the phy ID actually helps to
> >>>>> distinguish the different (not completely) compatible chips, we need
> >>>>> some more detailed information than available in the data sheets I have.
> >>>>> There is one person in the recipents of this mail with an
> >>>>> @microchip.com address (hint, hint!).
> >>>>
> >>>> can you give some input here or forward to a person who can?
> >>>
> >>> I forward this to the team.
> >>
> >> This thread still sits in my inbox waiting for some feedback. Did
> >> something happen on your side?
> > 
> > This is still true, didn't hear back from Yuiko Oshino for some time
> > now.
> > 
> > Best regards
> > Uwe
> > 
> 
> 
> -- 
> Florian

-- 
/Allan
