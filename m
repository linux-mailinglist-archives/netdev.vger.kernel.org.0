Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 896FB4D1BEE
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 16:40:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243045AbiCHPlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 10:41:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345898AbiCHPlu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 10:41:50 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365B14ECD4;
        Tue,  8 Mar 2022 07:40:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646754054; x=1678290054;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NzNzwhD5Vp7SgosRFhjzNuPWzbCIrT4UeOhxKam0WG4=;
  b=NGOiX0Fd9hrBl+o/4/zVCLvz6J1wwLig9uUeFbEphxRuXedKxIBG4vr+
   CAK0VGZaCi9cM10o2U9E2IXSfhUc+N+0U73be8Xh2CMFDnqpN/rGbutjT
   4wvc8K2SdaD4gwSBRSSlVR5lsVT2TTafIvIuJskiaKRB2CuhIvtIaMyHv
   giCxOlY7jP/l7zwXmcB0AdHzm+r5oo85Y78igu1Q/TG+YWwx4963CDXuj
   G8iRCAu8xb/7GIWF8aL/uwxatgKl+/+GWQ+iDCTPmLvNrdO91Gl6zrUjX
   OXp8TXKOOobxxUi/JRMCnjXq4QOHOpXixZHIR7FHJgLw8R3PJpWkMUMuw
   w==;
X-IronPort-AV: E=Sophos;i="5.90,165,1643698800"; 
   d="scan'208";a="164948629"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Mar 2022 08:40:53 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 8 Mar 2022 08:40:53 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Tue, 8 Mar 2022 08:40:53 -0700
Date:   Tue, 8 Mar 2022 16:43:45 +0100
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
Message-ID: <20220308154345.l4mk2oab4u5ydn5r@soft-dev3-1.localhost>
References: <20220304093418.31645-1-Divya.Koppera@microchip.com>
 <20220304093418.31645-3-Divya.Koppera@microchip.com>
 <YiILJ3tXs9Sba42B@lunn.ch>
 <CO1PR11MB4771237FE3F53EBE43B614F6E2089@CO1PR11MB4771.namprd11.prod.outlook.com>
 <YiYD2kAFq5EZhU+q@lunn.ch>
 <CO1PR11MB4771F7C1819E033EC613E262E2099@CO1PR11MB4771.namprd11.prod.outlook.com>
 <YidgHT8CLWrmhbTW@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <YidgHT8CLWrmhbTW@lunn.ch>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

The 03/08/2022 14:54, Andrew Lunn wrote:
> 
> > > Thanks for the reply, but you did not answer my question:
> > >
> > >   Does this mean the hardware itself cannot tell you it is missing the
> > >   needed hardware?
> > >
> > > Don't you have different IDs in register 2 and 3 for those devices with clock
> > > register and those without?
> > >
> >
> 
> > The purpose of this option is, if both PHY and MAC supports
> > timestamping then always timestamping is done in PHY.  If
> > timestamping need to be done in MAC we need a way to stop PHY
> > timestamping. If this flag is used then timestamping is taken care
> > by MAC.
> 
> This is not a valid use of DT, since this is configuration, not
> describing the hardware. There has been recent extension in the UAPI
> to allow user space to do this configuration. Please look at that
> work.

Ah ... now we have found Richard patch series.
So we will remove this option and once Richard's patch series will be
accepted we will use that.

> 
> > Sorry I answered wrong. Latency values vary depending on the position of PHY in board.
> > We have used this PHY in different hardware's, where latency values differs based on PHY positioning.
> > So we used latency option in DTS file.
> > If you have other ideas or I'm wrong please let me know?
> 
> So this is a function of the track length between the MAC and the PHY?

Nope.
This latency represents the time it takes for the frame to travel from RJ45
module to the timestamping unit inside the PHY. To be more precisely,
the timestamping unit will do the timestamp when it detects the end of
the start of the frame. So it represents the time from when the frame
reaches the RJ45 to when the end of start of the frame reaches the
timestamping unit inside the PHY.

And because each board manufacture could put the same PHY but in
different places, then each of them would have a different latency.
That is the main reason why we put this latencies in the DT and not put
them inside the driver. Because we think each board manufacture will
need to use different values.

Another reason is that we want the board manufacture to determine these
values and not the end users. I have seen that also Richard commenting
on this, saying that the latencies should not be in DT.
Currently I don't know where else they can be. I know that ptp4l has
these option in SW to update the ingress/egress latencies but if someone
else is running another application, what will they do?

> How do you determine these values?

This is a little bit more complicated.
So first you will need a device that you know already that is
calibrated. Then you connect the device that you want to calibrate to
the calibrated one with a known length cable. We presume that there is a
5ns delay per meter of the cable. And then basically we run ptp4l on
each device where the master will be the calibrated one and the slave
will be the device that will be calibrated. When we run ptp4l we can see
mean path delay, and we subtract the delay introduced by the cable(5ns)
and then we take this value and divided by 2. And then
the result is added to the current rx latency and subtracted from tx
latency.
This is how we have calculated the values.

> There is no point having
> configuration values if you don't document how to determine what value
> should be used.

I agree, we should do a better job at this and also explaining what
these values represent. Definitely we will do that in the next patch.

> 
>        Andrew

-- 
/Horatiu
