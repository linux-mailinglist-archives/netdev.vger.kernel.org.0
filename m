Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3286D4D2FD6
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 14:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232073AbiCINWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 08:22:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbiCINWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 08:22:52 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC273179250;
        Wed,  9 Mar 2022 05:21:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646832112; x=1678368112;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tTDgNztZKtwKkjKcjqCPLfR/uvNtEaC1J22Ey8KVphM=;
  b=TdQIckVhIfOVQBFKZUoP8+B2dyKJiYAi9DT0imznNlRRdyTtNuyPJ4RJ
   tXs9B9lMzhzEM5OmYSEQstgkcCecp4z9T2ac4r4Ou+NuQ/iETlDa552TA
   nt+/7cR1djtEM8hzOYQSiHvQEvlxx+TTqQtKYlwlCdjyl5BvYSX8Np8n5
   qTxo0QtS9+QBRwTQCT6xJFpSIlCXs+HiWxVFxi0i2CwtcfT0yxUeLI405
   YR1AD7rtHF45ddr9SclkwUEUrrWXG9a3GqECOUTNPqceXZ1t5C9dX6S4V
   GT95I7b+uq2pl8s0BA0dWHK75dRedG4jx4e/HwmfaPwIZ2cGjOV+5rNck
   A==;
X-IronPort-AV: E=Sophos;i="5.90,167,1643698800"; 
   d="scan'208";a="151404825"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Mar 2022 06:21:51 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 9 Mar 2022 06:21:51 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Wed, 9 Mar 2022 06:21:50 -0700
Date:   Wed, 9 Mar 2022 14:24:43 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <Divya.Koppera@microchip.com>, <netdev@vger.kernel.org>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <devicetree@vger.kernel.org>, <richardcochran@gmail.com>,
        <linux-kernel@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <Madhuri.Sripada@microchip.com>, <Manohar.Puri@microchip.com>
Subject: Re: [PATCH net-next 2/3] dt-bindings: net: micrel: Configure latency
 values and timestamping check for LAN8814 phy
Message-ID: <20220309132443.axyzcsc5kyb26su4@soft-dev3-1.localhost>
References: <20220304093418.31645-3-Divya.Koppera@microchip.com>
 <YiILJ3tXs9Sba42B@lunn.ch>
 <CO1PR11MB4771237FE3F53EBE43B614F6E2089@CO1PR11MB4771.namprd11.prod.outlook.com>
 <YiYD2kAFq5EZhU+q@lunn.ch>
 <CO1PR11MB4771F7C1819E033EC613E262E2099@CO1PR11MB4771.namprd11.prod.outlook.com>
 <YidgHT8CLWrmhbTW@lunn.ch>
 <20220308154345.l4mk2oab4u5ydn5r@soft-dev3-1.localhost>
 <YiecBKGhVui1Gtb/@lunn.ch>
 <20220308221404.bwhujvsdp253t4g3@soft-dev3-1.localhost>
 <YifoltDp4/Fs+9op@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <YifoltDp4/Fs+9op@lunn.ch>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 03/09/2022 00:36, Andrew Lunn wrote:
> 
> On Tue, Mar 08, 2022 at 11:14:04PM +0100, Horatiu Vultur wrote:
> > The 03/08/2022 19:10, Andrew Lunn wrote:
> > >
> > > > > So this is a function of the track length between the MAC and the PHY?
> > > >
> > > > Nope.
> > > > This latency represents the time it takes for the frame to travel from RJ45
> > > > module to the timestamping unit inside the PHY. To be more precisely,
> > > > the timestamping unit will do the timestamp when it detects the end of
> > > > the start of the frame. So it represents the time from when the frame
> > > > reaches the RJ45 to when the end of start of the frame reaches the
> > > > timestamping unit inside the PHY.
> > >
> > > I must be missing something here. How do you measure the latency
> > > difference for a 1 meter cable vs a 100m cable?
> >
> > In the same way because the end result will be the same.
> 
> The latency from the RJ45 to the PHY will be the same. But the latency
> from the link peer PHY to the local PHY will be much more, 500ns. In
> order for this RJ45 to PHY delay to be meaningful, don't you also need
> to know the length of the cable? Is there a configuration knob
> somewhere for the cable length?
> 
> I'm assuming the ptp protocol does not try to measure the cable delay,
> since if it did, there would be no need to know the RJ45-PHY delay, it
> would be part of that.
> 
> > > Isn't this error all just in the noise?
> >
> > I am not sure I follow this question.
> 
> At minimum, you expect to have a 1m cable. The RJ45-PHY track length
> is maybe 2cm? So 2% of the overall length. So you are trying to
> correct the error this 2% causes. If you have a 100m cable, 0.02% is
> RJ45-PHY part that you are trying to correct the error on. These
> numbers seem so small, it seems pointless. It only seems to make sense
> if you know the length of the cable, and to an accuracy of a few cm.

I am not trying to adjust for the length of the cable.
If we have the following drawing:

 MAC                     PHY                    RJ45
-----       --------------------------       --------
|   |       |                        |       |       |
|   |<----->|timestamp | FIFO | GPHY |<----->|       |<------> Peer
|   |       |   unit                 |       |       |
-----       --------------------------       --------
                 ^                                   ^
                 |            latency                |
                 -------------------------------------

I am trying to calculate this latency, which includes a 2cm of track +
latency inside the PHY. As Richard mentioned also the PHY introduce some
latency which can be microseconds.

I understand if we consider that this latency should not be in the DT
and be part of the driver because the latency over the 2cm or 1.5cm of track
is almost nothing. But then what about the case when we want to add these
latencies to a MAC? They will depend on the latency inside the PHY so
those should come from DT.

So it really doesn't matter to me if I use a 1m cable or 100m cable.
What it matters is to see that mean path delay will be ~5ns for 1m cable
and ~500ns for 100m cable. And if is not, then I need to update the
register to calculate correctly the latency from RJ45 to timestamp unit
in the PHY.

> 

>    Andrew

-- 
/Horatiu
