Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B295868E9E8
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 09:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbjBHIad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 03:30:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjBHIac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 03:30:32 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2821B457C2
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 00:30:31 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pPfqO-0007Z6-QC; Wed, 08 Feb 2023 09:30:20 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pPfqL-00041i-JF; Wed, 08 Feb 2023 09:30:17 +0100
Date:   Wed, 8 Feb 2023 09:30:17 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Wei Fang <wei.fang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH net-next v5 00/23] net: add EEE support for KSZ9477 and
 AR8035 with i.MX6
Message-ID: <20230208083017.GI12366@pengutronix.de>
References: <20230206135050.3237952-1-o.rempel@pengutronix.de>
 <20230207212555.79ffbc26@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230207212555.79ffbc26@kernel.org>
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
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 07, 2023 at 09:25:55PM -0800, Jakub Kicinski wrote:
> On Mon,  6 Feb 2023 14:50:27 +0100 Oleksij Rempel wrote:
> > With this patch series we provide EEE control for KSZ9477 family of switches and
> > AR8035 with i.MX6 configuration.
> > According to my tests, on a system with KSZ8563 switch and 100Mbit idle link,
> > we consume 0,192W less power per port if EEE is enabled.
> 
> Can we carve this series up a little bit to avoid large reposts?
> Perhaps you can hold off on reposting the cleanup patches starting
> at patch 17 - repost those separately after the first 16 go in?

ACK. Sounds good.
I'll make a cut on 00/09 patch. SmartEEE need probably more discussion and
changes.

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
