Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 653383BA45C
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 21:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbhGBTfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 15:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbhGBTff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 15:35:35 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29BAFC061762
        for <netdev@vger.kernel.org>; Fri,  2 Jul 2021 12:33:03 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lzOuF-0003KJ-Lc; Fri, 02 Jul 2021 21:32:55 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1lzOuD-0002ls-UJ; Fri, 02 Jul 2021 21:32:53 +0200
Date:   Fri, 2 Jul 2021 21:32:53 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH 04/24] rtw89: add debug files
Message-ID: <20210702193253.sjj75qp7kainvxza@pengutronix.de>
References: <20210618064625.14131-1-pkshih@realtek.com>
 <20210618064625.14131-5-pkshih@realtek.com>
 <20210702072308.GA4184@pengutronix.de>
 <CA+ASDXNjHJoXgRAM4E7TcLuz9zBmQkaBMuhK2DEVy3dnE-3XcA@mail.gmail.com>
 <20210702175740.5cdhmfp4ldiv6tn7@pengutronix.de>
 <CA+ASDXP0_Y1x_1OixJFWDCeZX3txV+xbwXcXfTbw1ZiGjSFiCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+ASDXP0_Y1x_1OixJFWDCeZX3txV+xbwXcXfTbw1ZiGjSFiCQ@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 20:42:37 up 212 days,  8:49, 37 users,  load average: 0.02, 0.04,
 0.05
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 02, 2021 at 11:38:26AM -0700, Brian Norris wrote:
> On Fri, Jul 2, 2021 at 10:57 AM Oleksij Rempel <o.rempel@pengutronix.de> wrote:
> > On Fri, Jul 02, 2021 at 10:08:53AM -0700, Brian Norris wrote:
> > > On Fri, Jul 2, 2021 at 12:23 AM Oleksij Rempel <o.rempel@pengutronix.de> wrote:
> > > > For dynamic debugging we usually use ethtool msglvl.
> > > > Please, convert all dev_err/warn/inf.... to netif_ counterparts
> > >
> > > Have you ever looked at a WiFi driver?
> >
> > Yes. You can parse the kernel log for my commits.
> 
> OK! So I see you've touched a lot of ath9k, >3 years ago. You might
> notice that it is one such example -- it supports exactly the same
> kind of debugfs file, with a set of ath_dbg() log types. Why doesn't
> it use this netif debug logging?

Ok, you right, ath mask would will set netif msg level on limit.

> > > I haven't seen a single one that uses netif_*() for logging.
> > > On the other hand, almost every
> > > single one has a similar module parameter or debugfs knob for enabling
> > > different types of debug messages.
> > >
> > > As it stands, the NETIF_* categories don't really align at all with
> > > the kinds of message categories most WiFi drivers support. Do you
> > > propose adding a bunch of new options to the netif debug feature?
> >
> > Why not? It make no sense or it is just "it is tradition, we never do
> > it!" ?
> 
> Well mainly, I don't really like people dreaming up arbitrary rules
> and enforcing them only on new submissions.

It is technical discussion. There is no reason to get personal.

> If such a change was
> Recommended, it seems like a better first step would be to prove that
> existing drivers (where there are numerous examples) can be converted
> nicely, instead of pushing the work to new contributors arbitrarily.

Hm, my experience as patch submitter is rather different, but who knows,
every subsystem has diffent rules. Good to know, wireless is different.

> Otherwise, the bar for new contributions gets exceedingly high -- this
> one has already sat for more than 6 months with depressingly little
> useful feedback.

Ok, I compared this driver with different realtek drivers. Most of them have
own DHCP detection code? It is not hardware specific operation. There is no
need to review code duplicates just again. Is it so hard to share this code
at least for realtek drivers? Do reviewers have a lot of free time to
re-read code duplicates?

> I also know very little about this netif log level feature, but if it
> really depends on ethtool (seems like it does?) -- I don't even bother
> installing ethtool on most of my systems. It's much easier to poke at
> debugfs, sysfs, etc., than to construct the relevant ethtool ioctl()s
> or netlink messages. It also seems that these debug knobs can't be set
> before the driver finishes coming up, so one would still need a module
> parameter to mirror some of the same features. Additionally, a WiFi
> driver doesn't even have a netdev to speak of until after a lot of the
> interesting stuff comes up (much of the mac80211 framework focuses on
> a |struct ieee80211_hw| and a |struct wiphy|), so I'm not sure your
> suggestion really fits these sorts of drivers (and the things they
> might like to support debug-logging for) at all.

Ok, i have nothing against unified realtek specif debugging code, as common
athers code do.

> Anyway, if Ping-Ke wants to paint this bikeshed for you, I won't stop him.

Well, i can provide a lot of "bikeshed". For example PCI related error
detection in this code. What level of review it will be?

> > Even dynamic printk provide even more granularity. So module parameter looks
> > like stone age against all existing possibilities.
> 
> Dynamic printk seems a bit beside the point (it's pretty different
> than either of the methods we're talking about), but I'll bite: many
> distributors disable it. It's easier to get targeted debugging for a
> few modules you care about, than the entire dynamic debug feature for
> ~every print in the kernel.

There are two side of each patch: reviewer and submitter. Both side have
limited time budget. If reviewer is not allowed to request improve things to
save submitters timer, why is it OK to waste reviewers time by applying
code dups?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
iAmtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
