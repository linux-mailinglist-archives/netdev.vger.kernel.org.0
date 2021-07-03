Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 862DE3BA703
	for <lists+netdev@lfdr.de>; Sat,  3 Jul 2021 06:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbhGCES0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Jul 2021 00:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbhGCESZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Jul 2021 00:18:25 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 516F5C061762
        for <netdev@vger.kernel.org>; Fri,  2 Jul 2021 21:15:52 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lzX4H-0001Gu-RT; Sat, 03 Jul 2021 06:15:49 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1lzX4G-0002K2-9w; Sat, 03 Jul 2021 06:15:48 +0200
Date:   Sat, 3 Jul 2021 06:15:48 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Brian Norris <briannorris@chromium.org>
Cc:     "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Ping-Ke Shih <pkshih@realtek.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 04/24] rtw89: add debug files
Message-ID: <20210703041548.nhe6iedtrkwihefo@pengutronix.de>
References: <20210618064625.14131-1-pkshih@realtek.com>
 <20210618064625.14131-5-pkshih@realtek.com>
 <20210702072308.GA4184@pengutronix.de>
 <CA+ASDXNjHJoXgRAM4E7TcLuz9zBmQkaBMuhK2DEVy3dnE-3XcA@mail.gmail.com>
 <20210702175740.5cdhmfp4ldiv6tn7@pengutronix.de>
 <CA+ASDXP0_Y1x_1OixJFWDCeZX3txV+xbwXcXfTbw1ZiGjSFiCQ@mail.gmail.com>
 <20210702193253.sjj75qp7kainvxza@pengutronix.de>
 <CA+ASDXP8JU+VXQV1ZHLsV88y_Ejr4YbS3YwDmWiKjhYsQ-F2Yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+ASDXP8JU+VXQV1ZHLsV88y_Ejr4YbS3YwDmWiKjhYsQ-F2Yw@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 05:56:09 up 212 days, 18:02, 44 users,  load average: 0.07, 0.04,
 0.01
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 02, 2021 at 01:00:27PM -0700, Brian Norris wrote:
> On Fri, Jul 2, 2021 at 12:32 PM Oleksij Rempel <o.rempel@pengutronix.de> wrote:
> > On Fri, Jul 02, 2021 at 11:38:26AM -0700, Brian Norris wrote:
> > > Well mainly, I don't really like people dreaming up arbitrary rules
> > > and enforcing them only on new submissions.
> >
> > It is technical discussion. There is no reason to get personal.
> 
> I'm not really intending to make this personal, so apologies if it
> appeared that way.
> 
> What I'm trying to get at is that
> (a) no other wireless driver does this, so why should this one? and
> (b) the feature you claim this driver can use does not appear suited
> to the task.
> 
> It's easier to make suggestions than to make them a reality.
> 
> > > If such a change was
> > > Recommended, it seems like a better first step would be to prove that
> > > existing drivers (where there are numerous examples) can be converted
> > > nicely, instead of pushing the work to new contributors arbitrarily.
> >
> > Hm, my experience as patch submitter is rather different, but who knows,
> > every subsystem has diffent rules. Good to know, wireless is different.
> 
> I'm not an arbiter for "wireless" -- so my thoughts are purely my own
> opinion. But I have noted some technical reasons why wireless drivers
> may be different than ethernet drivers, and the suggested (again,
> purely my own opinion) exercise might show you that your suggestion
> won't really work out in practice.

Ok, so we still need to find the way to go.
For example drivers/net/wireless/realtek/rtw89/debug.c is 2404 of potentially
removable code. Some one should review it or outoptimize it by using
existing frameworks.

As you noticed, not many people are willing to review this driver. IMO,
it is related to the RealTek reputation of making code drops with lots
of not not usable or duplicated code. So to say - offloading the dirty work to
the community. For example this patch set:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/log/drivers/staging/rts5139?h=v5.13&qt=author&q=rempel
This new rtw89 driver seems to confirm this reputation, but I cani't say it
for sure without spending a week on reverse engineering it.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
