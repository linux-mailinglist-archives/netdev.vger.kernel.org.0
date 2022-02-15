Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B39B34B65CA
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 09:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234908AbiBOIRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 03:17:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233692AbiBOIRL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 03:17:11 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50095811AB
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 00:17:02 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nJt0w-0004Wb-Ba; Tue, 15 Feb 2022 09:16:46 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nJt0v-0000QV-3a; Tue, 15 Feb 2022 09:16:45 +0100
Date:   Tue, 15 Feb 2022 09:16:45 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Tony Lindgren <tony@atomide.com>,
        linux-samsung-soc@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Jakub Kicinski <kuba@kernel.org>, devicetree@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        Ray Jui <rjui@broadcom.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        linux-rpi-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Scott Branden <sbranden@broadcom.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Shawn Guo <shawnguo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v3 5/8] ARM: dts: exynos: fix ethernet node name for
 different odroid boards
Message-ID: <20220215081645.GD672@pengutronix.de>
References: <20220215080937.2263111-1-o.rempel@pengutronix.de>
 <20220215080937.2263111-5-o.rempel@pengutronix.de>
 <20220215081240.hhie4niqnc5tuka2@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220215081240.hhie4niqnc5tuka2@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:13:37 up 66 days, 16:59, 71 users,  load average: 0.06, 0.15,
 0.16
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 15, 2022 at 09:12:40AM +0100, Marc Kleine-Budde wrote:
> On 15.02.2022 09:09:34, Oleksij Rempel wrote:
> > The node name of Ethernet controller should be "ethernet" instead of
> > "usbether"
> > 
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> >  arch/arm/boot/dts/exynos4412-odroidu3.dts       | 4 ++--
> >  arch/arm/boot/dts/exynos4412-odroidx.dts        | 8 ++++----
> >  arch/arm/boot/dts/exynos5410-odroidxu.dts       | 4 ++--
> >  arch/arm/boot/dts/exynos5422-odroidxu3-lite.dts | 6 +++---
> >  arch/arm/boot/dts/exynos5422-odroidxu3.dts      | 6 +++---
> >  5 files changed, 14 insertions(+), 14 deletions(-)
> > 
> > diff --git a/arch/arm/boot/dts/exynos4412-odroidu3.dts b/arch/arm/boot/dts/exynos4412-odroidu3.dts
> > index efaf7533e84f..36c369c42b77 100644
> > --- a/arch/arm/boot/dts/exynos4412-odroidu3.dts
> > +++ b/arch/arm/boot/dts/exynos4412-odroidu3.dts
> > @@ -119,8 +119,8 @@ &ehci {
> >  	phys = <&exynos_usbphy 2>, <&exynos_usbphy 3>;
> >  	phy-names = "hsic0", "hsic1";
> >  
> > -	ethernet: usbether@2 {
> > -		compatible = "usb0424,9730";
> > +	ethernet: ethernet@2 {
> > +		compatible = "usb424,9730";
> 
> The change of the compatible is not mentioned in the patch description.
> Is this intentional?

No, I forgot to mentione it. According to the USB schema 0 should be
removed. So, this compatible was incorrect as well. With leading zero
present yaml schema was not able to detect and validate this node.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
