Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D56E4B808D
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 07:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbiBPGQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 01:16:04 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:40596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiBPGQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 01:16:03 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6B4C193B33
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 22:15:50 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nKDbB-0000UI-PG; Wed, 16 Feb 2022 07:15:33 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nKDb8-0005ju-14; Wed, 16 Feb 2022 07:15:30 +0100
Date:   Wed, 16 Feb 2022 07:15:29 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Tony Lindgren <tony@atomide.com>,
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
Message-ID: <20220216061529.GA19299@pengutronix.de>
References: <20220215080937.2263111-1-o.rempel@pengutronix.de>
 <20220215080937.2263111-5-o.rempel@pengutronix.de>
 <20220215081240.hhie4niqnc5tuka2@pengutronix.de>
 <20220215081645.GD672@pengutronix.de>
 <YgwTkr1UIGH6hgJ6@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YgwTkr1UIGH6hgJ6@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 07:02:13 up 67 days, 14:47, 42 users,  load average: 0.48, 0.27,
 0.17
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

On Tue, Feb 15, 2022 at 09:56:50PM +0100, Andrew Lunn wrote:
> > > > -	ethernet: usbether@2 {
> > > > -		compatible = "usb0424,9730";
> > > > +	ethernet: ethernet@2 {
> > > > +		compatible = "usb424,9730";
> > > 
> > > The change of the compatible is not mentioned in the patch description.
> > > Is this intentional?
> > 
> > No, I forgot to mentione it. According to the USB schema 0 should be
> > removed. So, this compatible was incorrect as well. With leading zero
> > present yaml schema was not able to detect and validate this node.
> 
> Does the current code not actually care about a leading 0? It will
> match with or without it? It would be good to mention that as well in
> the commit message, otherwise somebody like me is going to ask if this
> breaks backwards compatibility, since normally compatible is an exact
> string match.

Current kernel code do not care about exact this compatibles. There is
no driver matching against it. The USB Ethernet driver will take the
node provided by the USB core drivers without validating the compatible
against USB ID.
See:
drivers/usb/core/of.c
drivers/usb/core/message.c:2093

On other hand, DT validations tools do care about it and this nodes was
not detected automatically. I found it accidentally by grepping the
sources.

> And i actually think this is the sort of change which should be as a
> patch of its own. If this causes a regression, a git bisect would then
> tell you if it is the change of usbether -> ethernet, or 0424 to
> 424. That is part of why we ask for lots of small changes.

Sounds good, I'll update it.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
