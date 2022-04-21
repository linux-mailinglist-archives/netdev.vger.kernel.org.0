Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB34250A04E
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 15:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbiDUNG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 09:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiDUNG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 09:06:26 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0912E33A1C
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 06:03:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=n34MESTxoTi663KNIe+Bu4jyOR4C9XJEHsvpgD5OsDg=; b=DWG+acvLIkYqCz2g3HtGYwujqy
        YX+ukm9K4yUSBUPbMpu4eOf7gN826d2Ft/ymGOghqfmej0Pe54b3c21Q2ap4nkmh8aB4qdWQdIifn
        uFDmUV8X2SAmyfCl5/lESq7Mgfk5h8R0mTOoxh4NGPkph3uIns0Y5KidYzdc6Mc2Cwatn1E/W1Tzn
        PUAiWX/pYmRHzQ5nG0sJfdp98ey60qHbUn/QTOeQImmLLy8VTExMHFuKjGhKxrE55hihnELSgSwaP
        0an36f5FfgKjxCL3xrTIV0oXsIxQ7CWgX1D2rrknAbtE1KXrQeh7R7pPIPcAY+OS+Xq0vBV+2YgDh
        dE1+z1Ww==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58352)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nhWSv-0003Pv-QO; Thu, 21 Apr 2022 14:03:21 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nhWSt-0002ji-AK; Thu, 21 Apr 2022 14:03:19 +0100
Date:   Thu, 21 Apr 2022 14:03:19 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Josua Mayer <josua@solid-run.com>, netdev@vger.kernel.org,
        alvaro.karsz@solid-run.com, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>
Subject: Re: [PATCH v2 3/3] ARM: dts: imx6qdl-sr-som: update phy
 configuration for som revision 1.9
Message-ID: <YmFWFzYz/iV4t2cW@shell.armlinux.org.uk>
References: <20220410104626.11517-1-josua@solid-run.com>
 <20220419102709.26432-1-josua@solid-run.com>
 <20220419102709.26432-4-josua@solid-run.com>
 <YmFNpLLLDzBNPqGf@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmFNpLLLDzBNPqGf@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 21, 2022 at 02:27:16PM +0200, Andrew Lunn wrote:
> On Tue, Apr 19, 2022 at 01:27:09PM +0300, Josua Mayer wrote:
> > Since SoM revision 1.9 the PHY has been replaced with an ADIN1300,
> > add an entry for it next to the original.
> > 
> > Co-developed-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
> > Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
> > Signed-off-by: Josua Mayer <josua@solid-run.com>
> > ---
> > V1 -> V2: changed dts property name
> > 
> >  arch/arm/boot/dts/imx6qdl-sr-som.dtsi | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/arch/arm/boot/dts/imx6qdl-sr-som.dtsi b/arch/arm/boot/dts/imx6qdl-sr-som.dtsi
> > index f86efd0ccc40..d46182095d79 100644
> > --- a/arch/arm/boot/dts/imx6qdl-sr-som.dtsi
> > +++ b/arch/arm/boot/dts/imx6qdl-sr-som.dtsi
> > @@ -83,6 +83,12 @@ ethernet-phy@4 {
> >  			qca,clk-out-frequency = <125000000>;
> >  			qca,smarteee-tw-us-1g = <24>;
> >  		};
> > +
> > +		/* ADIN1300 (som rev 1.9 or later) */
> > +		ethernet-phy@1 {
> > +			reg = <1>;
> > +			adi,phy-output-clock = "125mhz-free-running";
> > +		};
> 
> There is currently the comment:
> 
>                  * The PHY can appear at either address 0 or 4 due to the
>                  * configuration (LED) pin not being pulled sufficiently.
>                  */
> 
> It would be good to add another comment about this PHY at address 1.

There is an issue with this approach. Listing the "possible" PHYs in DT
so we can configure them leads to the kernel complaining at boot time
with:

mdio_bus 2188000.ethernet-1: MDIO device at address 4 is missing.

So with this patch, we'll also get:

mdio_bus 2188000.ethernet-1: MDIO device at address 1 is missing.

which is not great for the user to see. Arguably though, it's down to
broken hardware design in the case of the AR8035, since this is caused
by insufficient pull on the LED pin to ensure the hardware address is
reliable configured.

However, adding this for a rev 1.9 uSOM where we know that the PHY is
different matter. I think we should be aiming for a new revision of
DT for the uSOM with the AR8035 nodes removed and the ADIN added,
rather than trying to stuff them all into a single DT and have the
kernel complain about not just one missing PHY, but now two.

The only other ways around this that I can see would be to have some
way to flag in DT that the PHYs are "optional" - if they're not found
while probing the hardware, then don't whinge about them. Or have
u-boot discover which address the PHY is located, and update the DT
blob passed to the kernel to disable the PHY addresses that aren't
present. Or edit the DT to update the node name and reg property. Or
something along those lines.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
