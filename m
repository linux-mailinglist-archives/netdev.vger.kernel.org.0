Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEFE5519FBE
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 14:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235723AbiEDMoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 08:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349876AbiEDMnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 08:43:52 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F2BF76
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 05:40:15 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nmEIZ-0004Hb-Rc; Wed, 04 May 2022 14:40:07 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nmEIY-0006tO-Ru; Wed, 04 May 2022 14:40:06 +0200
Date:   Wed, 4 May 2022 14:40:06 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/2] net: phy:
 genphy_c45_baset1_an_config_aneg: do no set unknown configuration
Message-ID: <20220504124006.GB19760@pengutronix.de>
References: <20220504110655.1470008-1-o.rempel@pengutronix.de>
 <20220504110655.1470008-2-o.rempel@pengutronix.de>
 <YnJxOXcSVGW+g0ZP@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YnJxOXcSVGW+g0ZP@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:39:47 up 35 days,  1:09, 85 users,  load average: 0.10, 0.14,
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

On Wed, May 04, 2022 at 02:27:37PM +0200, Andrew Lunn wrote:
> On Wed, May 04, 2022 at 01:06:54PM +0200, Oleksij Rempel wrote:
> > Do not change default master/slave autoneg configuration if no
> > changes was requested.
> > 
> > Fixes: 3da8ffd8545f ("net: phy: Add 10BASE-T1L support in phy-c45")
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> 
> Hi Oleksij
> 
> I'm i right in saying 3da8ffd8545f is only in net-next?

ack.

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
