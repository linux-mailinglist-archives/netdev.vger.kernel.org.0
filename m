Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4D28511762
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 14:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234534AbiD0Mkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 08:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234432AbiD0Mkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 08:40:42 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CDC855237
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 05:37:29 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1njgv1-0001gD-RO; Wed, 27 Apr 2022 14:37:19 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1njgux-0006zz-Ra; Wed, 27 Apr 2022 14:37:15 +0200
Date:   Wed, 27 Apr 2022 14:37:15 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, Andre Edich <andre.edich@microchip.com>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next 0/7] Polling be gone on LAN95xx
Message-ID: <20220427123715.GC17577@pengutronix.de>
References: <cover.1651037513.git.lukas@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1651037513.git.lukas@wunner.de>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:27:44 up 28 days, 57 min, 81 users,  load average: 0.07, 0.09,
 0.13
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 07:48:00AM +0200, Lukas Wunner wrote:
> Do away with link status polling on LAN95XX USB Ethernet
> and rely on interrupts instead, thereby reducing bus traffic,
> CPU overhead and improving interface bringup latency.
> 
> The meat of the series is in patch [5/7].  The preceding and
> following patches are various cleanups to prepare for and
> adjust to interrupt-driven link state detection.
> 
> Please review and test.  Thanks!

Tested-by: Oleksij Rempel <o.rempel@pengutronix.de>

Tested on:
- LAN9514 (RPi2)
- LAN9512 (EVB)
- LAN9500 (EVB)

On USB unplug i get some not usable kernel message, but it is not the
show stopper for me:
smsc95xx 1-1.4.1:1.0 eth1: Error updating MAC full duplex mode
smsc95xx 1-1.4.1:1.0 eth1: hardware isn't capable of remote wakeup

Thank you!

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
