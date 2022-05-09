Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 019F55201D7
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 18:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238775AbiEIQFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 12:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238781AbiEIQFk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 12:05:40 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F44D18386
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 09:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=hkXIZPIWJhBZO2HP+VwjgYsToa3JLMmKuKC6FcNWf/A=; b=rQF0Q6dUfp/7W1QWNnE4f6Gl8L
        OIKBwN+SQ98ZBEwND/c9itxhhiji28PywiD+emPBqAsjUTWRTNDVrUAEbWG3yYSCRTAx+uZT1H85A
        cBCjFtfmoNPPG4LsdRo5VXMSch/UO7Ww5BtRX1zjOqfgrCn55H5aF1dMKdu62+d/LphA//UUWtUsm
        z6UKK/5MQy2/1vZFHECqg8BUghGDZ5HCSd5c9MUgNny2HPEL13ZGDCNwu7n5jQ5WYOCInk8d3nNYe
        DzTS0RzuAoMNrw2kU/VVwRA3xBY3VAqTxuq2mnIEDLZWUHANQNff8f1M6LnLp1/z72nl1xOdBqN1/
        /OvDts6A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:60650)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1no5pM-0003JX-Jc; Mon, 09 May 2022 17:01:41 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1no5pL-0005EO-AC; Mon, 09 May 2022 17:01:39 +0100
Date:   Mon, 9 May 2022 17:01:39 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Josua Mayer <josua@solid-run.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        alvaro.karsz@solid-run.com, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>
Subject: Re: [PATCH v2 3/3] ARM: dts: imx6qdl-sr-som: update phy
 configuration for som revision 1.9
Message-ID: <Ynk6410e5IMI40SE@shell.armlinux.org.uk>
References: <20220410104626.11517-1-josua@solid-run.com>
 <20220419102709.26432-1-josua@solid-run.com>
 <20220419102709.26432-4-josua@solid-run.com>
 <YmFNpLLLDzBNPqGf@lunn.ch>
 <YmFWFzYz/iV4t2cW@shell.armlinux.org.uk>
 <YmFcfhzOmi1GwTvS@lunn.ch>
 <YmFoKm0UvrSgD7kp@shell.armlinux.org.uk>
 <f9769cbd-6c1e-0fee-d643-9b764fe98c61@solid-run.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9769cbd-6c1e-0fee-d643-9b764fe98c61@solid-run.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 10:15:31AM +0300, Josua Mayer wrote:
> Hi Russell,
> 
> Am 21.04.22 um 17:20 schrieb Russell King (Oracle):
> > On Thu, Apr 21, 2022 at 03:30:38PM +0200, Andrew Lunn wrote:
> > > > The only other ways around this that I can see would be to have some
> > > > way to flag in DT that the PHYs are "optional" - if they're not found
> > > > while probing the hardware, then don't whinge about them. Or have
> > > > u-boot discover which address the PHY is located, and update the DT
> > > > blob passed to the kernel to disable the PHY addresses that aren't
> > > > present. Or edit the DT to update the node name and reg property. Or
> > > > something along those lines.
> > > uboot sounds like the best option. I don't know if we currently
> > > support the status property for PHYs. Maybe the .dtsi file should have
> > > them all status = "disabled"; and uboot can flip the populated ones to
> > > "okay". Or maybe the other way around to handle older bootloaders.
> > ... which would immediately regress the networking on all SolidRun iMX6
> > platforms when booting "new" DT with existing u-boot, so clearly that
> > isn't a possible solution.
> 
> So to summarize - you don't want to see a third phy spamming the console
> with probe errors ...

Exactly - it's bad enough that we have to list two PHYs because the PHY
could appear at either address 0 or address 4 depending on the direction
of the wind on any given day - and all because the PHY uses the LED pin
to determine its address, and which doesn't give a strong enough pull
that the address can be reliably determined. Every time the PHY gets a
hardware reset, it can change its address.

> I think a combination of the suggestions would be doable:
> - Add the new phy to dt, with status disabled
> - keep the existing phys unchanged
> - after probing in u-boot, disable the two old entries, and enable the new
> one

Exactly.

> It is not very convenient since that means changes to u-boot are necessary,
> but it can be done - and won't break existing users only updating Linux.

We wouldn't have the first problem of needing two PHYs if the hardware
had been fixed after I reported the problem...

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
