Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 740E66ADB51
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 11:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbjCGKEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 05:04:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbjCGKEc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 05:04:32 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48927392B2
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 02:04:30 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pZUBA-0005Gr-6M; Tue, 07 Mar 2023 11:04:20 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pZSrl-0004DT-O5; Tue, 07 Mar 2023 09:40:13 +0100
Date:   Tue, 7 Mar 2023 09:40:13 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Grant Grundler <grundler@chromium.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Lukas Wunner <lukas@wunner.de>,
        Eizan Miyamoto <eizan@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: asix: fix modprobe "sysfs: cannot create duplicate
 filename"
Message-ID: <20230307084013.GE11936@pengutronix.de>
References: <20230307005028.2065800-1-grundler@chromium.org>
 <84094771-7f98-0d8d-fe79-7c22e15a602d@gmail.com>
 <CANEJEGsYkxsbCj5O-O=QN8O0MEB-WY6FRJO6GFR0qt2sp4J8SA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CANEJEGsYkxsbCj5O-O=QN8O0MEB-WY6FRJO6GFR0qt2sp4J8SA@mail.gmail.com>
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
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Grant,

On Mon, Mar 06, 2023 at 10:22:06PM -0800, Grant Grundler wrote:
...
> [dropping Aton Lundin <glance@...> since it's bouncing ... and
> replying in "text only"]
> > Should we have a Fixes: tag here? One more question below
> 
> I have no idea which change/patch caused this problem. I'm happy to
> add whatever Fixes: tag folks suggest.
> 
> Looking at git blame, looks like the devm_mdiobus_* usage was
> introduced with e532a096be0e5:
> 
> commit e532a096be0e5e570b383e71d4560e7f04384e0f
> Author: Oleksij Rempel <linux@rempel-privat.de>
> Date:   Mon Jun 7 10:27:23 2021 +0200
> 
>     net: usb: asix: ax88772: add phylib support

Yes, this is the right commit.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
