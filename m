Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 331803BA3CC
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 19:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbhGBSAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 14:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbhGBSAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 14:00:23 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB0DC061762
        for <netdev@vger.kernel.org>; Fri,  2 Jul 2021 10:57:51 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lzNQ6-0002qZ-7L; Fri, 02 Jul 2021 19:57:42 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1lzNQ4-0007tS-OI; Fri, 02 Jul 2021 19:57:40 +0200
Date:   Fri, 2 Jul 2021 19:57:40 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 04/24] rtw89: add debug files
Message-ID: <20210702175740.5cdhmfp4ldiv6tn7@pengutronix.de>
References: <20210618064625.14131-1-pkshih@realtek.com>
 <20210618064625.14131-5-pkshih@realtek.com>
 <20210702072308.GA4184@pengutronix.de>
 <CA+ASDXNjHJoXgRAM4E7TcLuz9zBmQkaBMuhK2DEVy3dnE-3XcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+ASDXNjHJoXgRAM4E7TcLuz9zBmQkaBMuhK2DEVy3dnE-3XcA@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 19:42:32 up 212 days,  7:48, 46 users,  load average: 0.16, 0.14,
 0.05
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 02, 2021 at 10:08:53AM -0700, Brian Norris wrote:
> On Fri, Jul 2, 2021 at 12:23 AM Oleksij Rempel <o.rempel@pengutronix.de> wrote:
> > On Fri, Jun 18, 2021 at 02:46:05PM +0800, Ping-Ke Shih wrote:
> > > +#ifdef CONFIG_RTW89_DEBUGMSG
> > > +unsigned int rtw89_debug_mask;
> > > +EXPORT_SYMBOL(rtw89_debug_mask);
> > > +module_param_named(debug_mask, rtw89_debug_mask, uint, 0644);
> > > +MODULE_PARM_DESC(debug_mask, "Debugging mask");
> > > +#endif
> >
> >
> > For dynamic debugging we usually use ethtool msglvl.
> > Please, convert all dev_err/warn/inf.... to netif_ counterparts
> 
> Have you ever looked at a WiFi driver?

Yes. You can parse the kernel log for my commits.

> I haven't seen a single one that uses netif_*() for logging.
> On the other hand, almost every
> single one has a similar module parameter or debugfs knob for enabling
> different types of debug messages.
> 
> As it stands, the NETIF_* categories don't really align at all with
> the kinds of message categories most WiFi drivers support. Do you
> propose adding a bunch of new options to the netif debug feature?

Why not? It make no sense or it is just "it is tradition, we never do
it!" ? 

Even dynamic printk provide even more granularity. So module parameter looks
like stone age against all existing possibilities.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
