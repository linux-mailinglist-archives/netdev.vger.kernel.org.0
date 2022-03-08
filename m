Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F18D4D15FB
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 12:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343807AbiCHLQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 06:16:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346377AbiCHLQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 06:16:41 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC7046177
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 03:15:44 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nRXoO-0001bV-04; Tue, 08 Mar 2022 12:15:28 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nRXoM-0000Ry-4J; Tue, 08 Mar 2022 12:15:26 +0100
Date:   Tue, 8 Mar 2022 12:15:26 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Ray Jui <rjui@broadcom.com>, Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Scott Branden <sbranden@broadcom.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Tony Lindgren <tony@atomide.com>, kernel@pengutronix.de,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v5 5/9] ARM: dts: exynos: fix ethernet node name for
 different odroid boards
Message-ID: <20220308111526.GA1086@pengutronix.de>
References: <20220216074927.3619425-1-o.rempel@pengutronix.de>
 <20220216074927.3619425-6-o.rempel@pengutronix.de>
 <bbb7e8fa-757a-64c6-640e-c24bf3e56b82@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <bbb7e8fa-757a-64c6-640e-c24bf3e56b82@canonical.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:14:51 up 87 days, 20:00, 87 users,  load average: 0.94, 0.50,
 0.31
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 08, 2022 at 12:02:29PM +0100, Krzysztof Kozlowski wrote:
> On 16/02/2022 08:49, Oleksij Rempel wrote:
> > The node name of Ethernet controller should be "ethernet" instead of
> > "usbether" as required by Ethernet controller devicetree schema:
> >  Documentation/devicetree/bindings/net/ethernet-controller.yaml
> > 
> > This patch can potentially affect boot loaders patching against full
> > node path instead of using device aliases.
> > 
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> >  arch/arm/boot/dts/exynos4412-odroidu3.dts       | 2 +-
> >  arch/arm/boot/dts/exynos4412-odroidx.dts        | 2 +-
> >  arch/arm/boot/dts/exynos5410-odroidxu.dts       | 2 +-
> >  arch/arm/boot/dts/exynos5422-odroidxu3-lite.dts | 2 +-
> >  arch/arm/boot/dts/exynos5422-odroidxu3.dts      | 2 +-
> >  5 files changed, 5 insertions(+), 5 deletions(-)
> > 
> 
> Hi Oleksij,
> 
> Both Exynos patches look good, unfortunately I forgot about them a week
> ago when I was preparing late pull request and now it is too late for
> this cycle. I will pick them up after the merge window. Sorry, for this.

No problem. Thank you for the feedback :)

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
