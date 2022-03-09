Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68FE94D3152
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 15:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233672AbiCIO4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 09:56:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233651AbiCIO4y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 09:56:54 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A91817E35D;
        Wed,  9 Mar 2022 06:55:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=DDFO3msfmfMsCk9eo6nmpXP8kD7WaaU6Xf1jlOnbKGw=; b=SbIesQddg81fpXICj6g698RyeH
        mzBZHB5QiGEBxIasXKxavKSS5t+Ha0nrORs/jZTKqvnYO/StMe1v3XTELVk1CKoHZPo1Qh2nE3UI5
        cu/47CvMeMSy2m0AXDvCHNXpvQBR+0uzhGxbdGMvjP3yIgZfX2pdK+zbqnh7lKpVy87/pmRMDPQKD
        T3KW4N5THnM7o1n7bDMfWSPLO+59aMiwC9z40YldTWY1rmuTZQXf5Vp9A41ay6u+BM+EV7aITudSm
        U/qGartnNqVJB5QZzUF46aW5lgHGU+L0NkqaWB2hVQ0VKs0b7hfbfbY48qXsqWZsdsZfzondf557P
        egTXMUoQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57742)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nRxjC-0001xl-UW; Wed, 09 Mar 2022 14:55:51 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nRxjB-00081l-46; Wed, 09 Mar 2022 14:55:49 +0000
Date:   Wed, 9 Mar 2022 14:55:49 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Divya.Koppera@microchip.com,
        netdev@vger.kernel.org, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, devicetree@vger.kernel.org,
        richardcochran@gmail.com, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, Madhuri.Sripada@microchip.com,
        Manohar.Puri@microchip.com
Subject: Re: [PATCH net-next 2/3] dt-bindings: net: micrel: Configure latency
 values and timestamping check for LAN8814 phy
Message-ID: <Yii/9RH67BEjNtLM@shell.armlinux.org.uk>
References: <YiILJ3tXs9Sba42B@lunn.ch>
 <CO1PR11MB4771237FE3F53EBE43B614F6E2089@CO1PR11MB4771.namprd11.prod.outlook.com>
 <YiYD2kAFq5EZhU+q@lunn.ch>
 <CO1PR11MB4771F7C1819E033EC613E262E2099@CO1PR11MB4771.namprd11.prod.outlook.com>
 <YidgHT8CLWrmhbTW@lunn.ch>
 <20220308154345.l4mk2oab4u5ydn5r@soft-dev3-1.localhost>
 <YiecBKGhVui1Gtb/@lunn.ch>
 <20220308221404.bwhujvsdp253t4g3@soft-dev3-1.localhost>
 <YifoltDp4/Fs+9op@lunn.ch>
 <20220309132443.axyzcsc5kyb26su4@soft-dev3-1.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220309132443.axyzcsc5kyb26su4@soft-dev3-1.localhost>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 09, 2022 at 02:24:43PM +0100, Horatiu Vultur wrote:
> The 03/09/2022 00:36, Andrew Lunn wrote:
> > 
> > On Tue, Mar 08, 2022 at 11:14:04PM +0100, Horatiu Vultur wrote:
> > > The 03/08/2022 19:10, Andrew Lunn wrote:
> > > >
> > > > > > So this is a function of the track length between the MAC and the PHY?
> > > > >
> > > > > Nope.
> > > > > This latency represents the time it takes for the frame to travel from RJ45
> > > > > module to the timestamping unit inside the PHY. To be more precisely,
> > > > > the timestamping unit will do the timestamp when it detects the end of
> > > > > the start of the frame. So it represents the time from when the frame
> > > > > reaches the RJ45 to when the end of start of the frame reaches the
> > > > > timestamping unit inside the PHY.
> > > >
> > > > I must be missing something here. How do you measure the latency
> > > > difference for a 1 meter cable vs a 100m cable?
> > >
> > > In the same way because the end result will be the same.
> > 
> > The latency from the RJ45 to the PHY will be the same. But the latency
> > from the link peer PHY to the local PHY will be much more, 500ns. In
> > order for this RJ45 to PHY delay to be meaningful, don't you also need
> > to know the length of the cable? Is there a configuration knob
> > somewhere for the cable length?
> > 
> > I'm assuming the ptp protocol does not try to measure the cable delay,
> > since if it did, there would be no need to know the RJ45-PHY delay, it
> > would be part of that.
> > 
> > > > Isn't this error all just in the noise?
> > >
> > > I am not sure I follow this question.
> > 
> > At minimum, you expect to have a 1m cable. The RJ45-PHY track length
> > is maybe 2cm? So 2% of the overall length. So you are trying to
> > correct the error this 2% causes. If you have a 100m cable, 0.02% is
> > RJ45-PHY part that you are trying to correct the error on. These
> > numbers seem so small, it seems pointless. It only seems to make sense
> > if you know the length of the cable, and to an accuracy of a few cm.
> 
> I am not trying to adjust for the length of the cable.
> If we have the following drawing:
> 
>  MAC                     PHY                    RJ45
> -----       --------------------------       --------
> |   |       |                        |       |       |
> |   |<----->|timestamp | FIFO | GPHY |<----->|       |<------> Peer
> |   |       |   unit                 |       |       |
> -----       --------------------------       --------
>                  ^                                   ^
>                  |            latency                |
>                  -------------------------------------
> 
> I am trying to calculate this latency, which includes a 2cm of track +
> latency inside the PHY. As Richard mentioned also the PHY introduce some
> latency which can be microseconds.

I think we understand this, and compensating for the delay in the PHY
is quite reasonable, which surely will be a fixed amount irrespective
of the board.

However, Andrew's point is that the latency introduced by the copper
wire between the PHY and the RJ45 is insignificant, so insignificant
it's not worth bothering with - and I agree.

> I understand if we consider that this latency should not be in the DT
> and be part of the driver because the latency over the 2cm or 1.5cm of track
> is almost nothing. But then what about the case when we want to add these
> latencies to a MAC? They will depend on the latency inside the PHY so
> those should come from DT.

If you want to measure it to the MAC, then yes, the latency through
the PHY needs to be considered, and we probably need some new
interfaces inside the kernel so that MAC drivers can query phylib
to discover what the delay is. I don't think this is soemthing that
should be thrown into firmware, since the delay inside the PHY
should be constant (depending on what MAC side interface mode is
selected.)

Having it in firmware means that we're reliant on people ensuring
that they've looked up the right value for the PHY and its interface
mode not just once, but for every board out there - and if an error
is found, it brings up the question whether it should be corrected
on all boards or just one (and then there'll be questions why some
people have chosen randomly different values.)

> So it really doesn't matter to me if I use a 1m cable or 100m cable.
> What it matters is to see that mean path delay will be ~5ns for 1m cable
> and ~500ns for 100m cable. And if is not, then I need to update the
> register to calculate correctly the latency from RJ45 to timestamp unit
> in the PHY.

Does this mean you ask the user how long the cable is? Do you get them
to measure it to the nearest millimeter?

What about the overlap in the RJ45 connectors, and the height of the
pins in the RJ45? Some RJ45 connectors have staggered lengths for
their pins which would affect the true length. What about the total
length of the conductors in the RJ45 socket to the point that the
RJ45 plug makes contact? What happens if production then has to
change the make of RJ45 socket due to supply issues (which given
what is going on in the world at the moment is not unlikely.)

If you care about the 20mm or so on the board, then you ought to care
about all these other factors as well, and I suspect you're going to
be hard pressed to gather all that.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
