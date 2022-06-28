Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD9B455D627
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245408AbiF1GoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 02:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343521AbiF1GoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 02:44:07 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A67413DD7
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 23:44:06 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1o64x3-0004OA-2O; Tue, 28 Jun 2022 08:43:57 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1o64x1-00028S-5C; Tue, 28 Jun 2022 08:43:55 +0200
Date:   Tue, 28 Jun 2022 08:43:55 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH net-next v2 1/1] net: phy: ax88772a: fix lost pause
 advertisement configuration
Message-ID: <20220628064355.GD13092@pengutronix.de>
References: <20220626152703.18157-1-o.rempel@pengutronix.de>
 <20220627221705.0a49f3c9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220627221705.0a49f3c9@kernel.org>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
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

On Mon, Jun 27, 2022 at 10:17:05PM -0700, Jakub Kicinski wrote:
> On Sun, 26 Jun 2022 17:27:03 +0200 Oleksij Rempel wrote:
> > Subject: [PATCH net-next v2 1/1] net: phy: ax88772a: fix lost pause advertisement configuration
> > 
> > In case of asix_ax88772a_link_change_notify() workaround, we run soft
> > reset which will automatically clear MII_ADVERTISE configuration. The
> > PHYlib framework do not know about changed configuration state of the
> > PHY, so we need use phy_init_hw() to reinit PHY configuration.
> > 
> > Fixes: dde258469257 ("net: usb/phy: asix: add support for ax88772A/C PHYs")
> 
> Why net-next?

It is old bug but it will be notable only after this patch:
https://lore.kernel.org/all/20220624080208.3143093-1-o.rempel@pengutronix.de/

Should I resend it to net?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
