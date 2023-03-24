Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6056A6C776D
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 06:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbjCXFfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 01:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjCXFfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 01:35:19 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E485E113C6
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 22:35:16 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pfa54-0006qX-8b; Fri, 24 Mar 2023 06:35:14 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pfa52-0003Du-9R; Fri, 24 Mar 2023 06:35:12 +0100
Date:   Fri, 24 Mar 2023 06:35:12 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Arun Ramadoss <arun.ramadoss@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, Eric Dumazet <edumazet@google.com>,
        Vladimir Oltean <olteanv@gmail.com>, kernel@pengutronix.de,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net v1 2/6] net: dsa: microchip: ksz8: fix
 ksz8_fdb_dump() to extract all 1024 entries
Message-ID: <20230324053512.GG23237@pengutronix.de>
References: <20230322143130.1432106-1-o.rempel@pengutronix.de>
 <20230322143130.1432106-3-o.rempel@pengutronix.de>
 <20230323154101.1afd0081@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230323154101.1afd0081@kernel.org>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 03:41:01PM -0700, Jakub Kicinski wrote:
> On Wed, 22 Mar 2023 15:31:26 +0100 Oleksij Rempel wrote:
> > Fixes: d23a5e18606c ("net: dsa: microchip: move ksz8->masks to ksz_common")
> 
> The code move broke it? Looks like it was 5,0 before and 5,0 after 
> the change? We need a real tag, pointing to where the code was first
> added.

ack. will fix it.

> Any reason you didn't CC Arun, just an omission or they're no longer
> @microchip?

He is not in MAINTAINERS for drivers/net/dsa/microchip/* even if he is
practically maintaining it  .. :)

> Arun, would you be able to review this series?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
