Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CDB7285A34
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 10:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbgJGIOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 04:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbgJGIOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 04:14:17 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03761C061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 01:14:17 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1kQ4aR-0003Yj-DZ; Wed, 07 Oct 2020 10:14:11 +0200
Received: from mfe by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1kQ4aQ-0007hj-72; Wed, 07 Oct 2020 10:14:10 +0200
Date:   Wed, 7 Oct 2020 10:14:10 +0200
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Marek Vasut <marex@denx.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, mkl@pengutronix.de,
        kernel@pengutronix.de, David Jander <david@protonic.nl>
Subject: Re: PHY reset question
Message-ID: <20201007081410.jk5fi6x5w3ab3726@pengutronix.de>
References: <20201006080424.GA6988@pengutronix.de>
 <2cc5ea02-707e-dbb5-c081-4c5202bd5815@gmail.com>
 <42d4c4b2-d3ea-9130-ef7f-3d1955116fdc@denx.de>
 <0687984c-5768-7c71-5796-8e16169f5192@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0687984c-5768-7c71-5796-8e16169f5192@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:07:33 up 326 days, 23:26, 362 users,  load average: 0.15, 0.21,
 0.14
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek,

On 20-10-06 14:11, Florian Fainelli wrote:
> On 10/6/2020 1:24 PM, Marek Vasut wrote:

...

> > If this happens on MX6 with FEC, can you please try these two patches?
> > 
> > https://patchwork.ozlabs.org/project/netdev/patch/20201006135253.97395-1-marex@denx.de/
> > 
> > https://patchwork.ozlabs.org/project/netdev/patch/20201006202029.254212-1-marex@denx.de/
> 
> Your patches are not scaling across multiple Ethernet MAC drivers
> unfortunately, so I am not sure this should be even remotely considered a
> viable solution.

Recently I added clk support for the smcs driver [1] and dropped the
PHY_RST_AFTER_CLK_EN flag for LAN8710/20 devices because I had the same
issues. Hope this will help you too.

[1] https://www.spinics.net/lists/netdev/msg682080.html

Regards,
  Marco
