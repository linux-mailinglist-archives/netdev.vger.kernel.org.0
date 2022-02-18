Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 432214BB336
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 08:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbiBRH3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 02:29:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231938AbiBRH3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 02:29:23 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B44267240
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 23:29:06 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nKxhJ-0006e3-2p; Fri, 18 Feb 2022 08:28:57 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nKxhC-00053L-9p; Fri, 18 Feb 2022 08:28:50 +0100
Date:   Fri, 18 Feb 2022 08:28:50 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     alexandru.tachici@analog.com
Cc:     andrew@lunn.ch, davem@davemloft.net, devicetree@vger.kernel.org,
        hkallweit1@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, robh+dt@kernel.org
Subject: Re: [PATCH v4 4/7] net: phy: Add 10BASE-T1L support in phy-c45
Message-ID: <20220218072850.GA12479@pengutronix.de>
References: <20220207092753.GC23727@pengutronix.de>
 <20220209151220.15154-1-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220209151220.15154-1-alexandru.tachici@analog.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:24:08 up 69 days, 16:09, 69 users,  load average: 0.16, 0.17,
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

On Wed, Feb 09, 2022 at 05:12:20PM +0200, alexandru.tachici@analog.com wrote:
> > On Sat, Dec 11, 2021 at 10:07:49PM +0100, Andrew Lunn wrote:
> > > > +		ret = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_EXTABLE);
> > > > +		if (ret < 0)
> > > > +			return ret;
> > > > +
> > > > +		if (ret & MDIO_PMA_EXTABLE_BT1)
> > > 
> > > 
> > > This pattern of reading the MDIO_PMA_EXTABLE register and then looking
> > > for bit MDIO_PMA_EXTABLE_BT1 happens a lot. It is not something which
> > > is expected to change is it? So i wounder if it should be read once
> > > and stored away?
> > 
> > What is the state of this patches? Will you be able to make requested
> > changes and send new version?
> 
> I will come back with a V5 where I will add the requested changes.

I tested your patches with TI dp83td510. With some minor quirks on TI
side it seems to work fine. So you can have my:

Tested-by: Oleksij Rempel <o.rempel@pengutronix.de>

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
