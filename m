Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55B554D62CC
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 15:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349019AbiCKOFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 09:05:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239331AbiCKOFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 09:05:15 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E47DF7464;
        Fri, 11 Mar 2022 06:04:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1647007450; x=1678543450;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0g8YZ60F6koJZZ5mPXUhXc+2GWru9uudgvFhUcsgcW4=;
  b=beaOKpnksohKcVErRoo+TAxzUQd9brxNpMSz18hd8ZD2iebgF+hMPbY2
   5lXhekFSQCwzNPoNKBHqbnxqqnyrfT8ImW0kE3Iod071DB+CZA1e6lxC6
   P96AK2H/Y+tvyGbLEHkfjmjejQs3Vbm4Dy69FyLk3Pba2Ly8PuYdx5uxV
   Zss8RhhCcjOL1yT+q+2DoC1fvN5Vn/Zb3TnYllvVnA58ocbBzUNmm0BIg
   xvgm4uMg/sW/cEeL0hpxMROiO/P0lBjlTuELY+iCmjxmmhcu4qRyFWW+d
   B2fzmdSj2O1IRIYGAMIYgXbr4oZb+GaO6k5m92t5razpk+0TiAbvjxIY2
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,174,1643698800"; 
   d="scan'208";a="151697579"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Mar 2022 07:04:08 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 11 Mar 2022 07:04:08 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Fri, 11 Mar 2022 07:04:08 -0700
Date:   Fri, 11 Mar 2022 15:07:00 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>, <Divya.Koppera@microchip.com>,
        <netdev@vger.kernel.org>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <devicetree@vger.kernel.org>, <richardcochran@gmail.com>,
        <linux-kernel@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <Madhuri.Sripada@microchip.com>, <Manohar.Puri@microchip.com>
Subject: Re: [PATCH net-next 2/3] dt-bindings: net: micrel: Configure latency
 values and timestamping check for LAN8814 phy
Message-ID: <20220311140700.ibwyeu5bsz7tkibd@soft-dev3-1.localhost>
References: <CO1PR11MB4771237FE3F53EBE43B614F6E2089@CO1PR11MB4771.namprd11.prod.outlook.com>
 <YiYD2kAFq5EZhU+q@lunn.ch>
 <CO1PR11MB4771F7C1819E033EC613E262E2099@CO1PR11MB4771.namprd11.prod.outlook.com>
 <YidgHT8CLWrmhbTW@lunn.ch>
 <20220308154345.l4mk2oab4u5ydn5r@soft-dev3-1.localhost>
 <YiecBKGhVui1Gtb/@lunn.ch>
 <20220308221404.bwhujvsdp253t4g3@soft-dev3-1.localhost>
 <YifoltDp4/Fs+9op@lunn.ch>
 <20220309132443.axyzcsc5kyb26su4@soft-dev3-1.localhost>
 <Yii/9RH67BEjNtLM@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <Yii/9RH67BEjNtLM@shell.armlinux.org.uk>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 03/09/2022 14:55, Russell King (Oracle) wrote:
> 
> On Wed, Mar 09, 2022 at 02:24:43PM +0100, Horatiu Vultur wrote:
> > The 03/09/2022 00:36, Andrew Lunn wrote:
> > >
> > > On Tue, Mar 08, 2022 at 11:14:04PM +0100, Horatiu Vultur wrote:
> > > > The 03/08/2022 19:10, Andrew Lunn wrote:
> > > > >
> > > > > > > So this is a function of the track length between the MAC and the PHY?
> > > > > >
> > > > > > Nope.
> > > > > > This latency represents the time it takes for the frame to travel from RJ45
> > > > > > module to the timestamping unit inside the PHY. To be more precisely,
> > > > > > the timestamping unit will do the timestamp when it detects the end of
> > > > > > the start of the frame. So it represents the time from when the frame
> > > > > > reaches the RJ45 to when the end of start of the frame reaches the
> > > > > > timestamping unit inside the PHY.
> > > > >
> > > > > I must be missing something here. How do you measure the latency
> > > > > difference for a 1 meter cable vs a 100m cable?
> > > >
> > > > In the same way because the end result will be the same.
> > >
> > > The latency from the RJ45 to the PHY will be the same. But the latency
> > > from the link peer PHY to the local PHY will be much more, 500ns. In
> > > order for this RJ45 to PHY delay to be meaningful, don't you also need
> > > to know the length of the cable? Is there a configuration knob
> > > somewhere for the cable length?
> > >
> > > I'm assuming the ptp protocol does not try to measure the cable delay,
> > > since if it did, there would be no need to know the RJ45-PHY delay, it
> > > would be part of that.
> > >
> > > > > Isn't this error all just in the noise?
> > > >
> > > > I am not sure I follow this question.
> > >
> > > At minimum, you expect to have a 1m cable. The RJ45-PHY track length
> > > is maybe 2cm? So 2% of the overall length. So you are trying to
> > > correct the error this 2% causes. If you have a 100m cable, 0.02% is
> > > RJ45-PHY part that you are trying to correct the error on. These
> > > numbers seem so small, it seems pointless. It only seems to make sense
> > > if you know the length of the cable, and to an accuracy of a few cm.
> >
> > I am not trying to adjust for the length of the cable.
> > If we have the following drawing:
> >
> >  MAC                     PHY                    RJ45
> > -----       --------------------------       --------
> > |   |       |                        |       |       |
> > |   |<----->|timestamp | FIFO | GPHY |<----->|       |<------> Peer
> > |   |       |   unit                 |       |       |
> > -----       --------------------------       --------
> >                  ^                                   ^
> >                  |            latency                |
> >                  -------------------------------------
> >
> > I am trying to calculate this latency, which includes a 2cm of track +
> > latency inside the PHY. As Richard mentioned also the PHY introduce some
> > latency which can be microseconds.
> 
> I think we understand this, and compensating for the delay in the PHY
> is quite reasonable, which surely will be a fixed amount irrespective
> of the board.
> 
> However, Andrew's point is that the latency introduced by the copper
> wire between the PHY and the RJ45 is insignificant, so insignificant
> it's not worth bothering with - and I agree.

OK, that is fine for me, we can ignore the latency introduced by the
copper wire.

> 
> > I understand if we consider that this latency should not be in the DT
> > and be part of the driver because the latency over the 2cm or 1.5cm of track
> > is almost nothing. But then what about the case when we want to add these
> > latencies to a MAC? They will depend on the latency inside the PHY so
> > those should come from DT.
> 
> If you want to measure it to the MAC, then yes, the latency through
> the PHY needs to be considered, and we probably need some new
> interfaces inside the kernel so that MAC drivers can query phylib
> to discover what the delay is.

Does that mean that each PHY needs to implement a new API? Because that
would be a little bit of work to do there.

> I don't think this is soemthing that
> should be thrown into firmware, since the delay inside the PHY
> should be constant (depending on what MAC side interface mode is
> selected.)
> 
> Having it in firmware means that we're reliant on people ensuring
> that they've looked up the right value for the PHY and its interface
> mode not just once, but for every board out there - and if an error
> is found, it brings up the question whether it should be corrected
> on all boards or just one (and then there'll be questions why some
> people have chosen randomly different values.)
> 
> > So it really doesn't matter to me if I use a 1m cable or 100m cable.
> > What it matters is to see that mean path delay will be ~5ns for 1m cable
> > and ~500ns for 100m cable. And if is not, then I need to update the
> > register to calculate correctly the latency from RJ45 to timestamp unit
> > in the PHY.
> 
> Does this mean you ask the user how long the cable is? Do you get them
> to measure it to the nearest millimeter?

My expectation is that the end user should not care about the length of
the cable. He just needs to start ptp4l and have some sane results.
Only the board manufacture were supposed to know the length of the
cable to set their latency values.

> 
> What about the overlap in the RJ45 connectors, and the height of the
> pins in the RJ45? Some RJ45 connectors have staggered lengths for
> their pins which would affect the true length. What about the total
> length of the conductors in the RJ45 socket to the point that the
> RJ45 plug makes contact? What happens if production then has to
> change the make of RJ45 socket due to supply issues (which given
> what is going on in the world at the moment is not unlikely.)

If they don't introduce any significat latency then we can ignore them.

> 
> If you care about the 20mm or so on the board, then you ought to care
> about all these other factors as well, and I suspect you're going to
> be hard pressed to gather all that.
> 
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

-- 
/Horatiu
