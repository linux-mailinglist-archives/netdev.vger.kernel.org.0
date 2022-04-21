Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF79650A212
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 16:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389134AbiDUOXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 10:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377277AbiDUOXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 10:23:23 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 144AD3BBCA
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 07:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=erWhhQL+X5PajjiR0acf6R7oceU2fAT92N9blxu9ib0=; b=vPNMbOdwVSclCGrMUy0l5jPYH3
        ndU2vyYBkG6DhhrRqoZZRjF3OCrCt26tPp0F4u31iT5bIF4BHb0FHO5K7azds3G7OeHluRGuyaAD2
        gKpFYw49A8o6+E734/emxpp7cwEoTnGiKPSV2Hx5ytLHvtpXuHF7Vs/UZZNS4SJ1j5ggGQoEIjwJo
        MY8qLhvV6rSuew3INujq94ncVjdTZyqQ5W/hm+kA9wygforo0LzKysqw/TccN0FHZXcD7F2WLFiCr
        Cku6O4rK26pM89q4el57LFRuM9K14mH8kyzD4KGEjnkGeG3hNJvwn1j9OxO4BX9/6yFWj9Zdc5ObA
        vcjDqiQg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58356)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nhXfZ-0003US-AY; Thu, 21 Apr 2022 15:20:29 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nhXfW-0002ma-8O; Thu, 21 Apr 2022 15:20:26 +0100
Date:   Thu, 21 Apr 2022 15:20:26 +0100
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
Message-ID: <YmFoKm0UvrSgD7kp@shell.armlinux.org.uk>
References: <20220410104626.11517-1-josua@solid-run.com>
 <20220419102709.26432-1-josua@solid-run.com>
 <20220419102709.26432-4-josua@solid-run.com>
 <YmFNpLLLDzBNPqGf@lunn.ch>
 <YmFWFzYz/iV4t2cW@shell.armlinux.org.uk>
 <YmFcfhzOmi1GwTvS@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmFcfhzOmi1GwTvS@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 21, 2022 at 03:30:38PM +0200, Andrew Lunn wrote:
> > The only other ways around this that I can see would be to have some
> > way to flag in DT that the PHYs are "optional" - if they're not found
> > while probing the hardware, then don't whinge about them. Or have
> > u-boot discover which address the PHY is located, and update the DT
> > blob passed to the kernel to disable the PHY addresses that aren't
> > present. Or edit the DT to update the node name and reg property. Or
> > something along those lines.
> 
> uboot sounds like the best option. I don't know if we currently
> support the status property for PHYs. Maybe the .dtsi file should have
> them all status = "disabled"; and uboot can flip the populated ones to
> "okay". Or maybe the other way around to handle older bootloaders.

... which would immediately regress the networking on all SolidRun iMX6
platforms when booting "new" DT with existing u-boot, so clearly that
isn't a possible solution.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
