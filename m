Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0DAB3EE930
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 11:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235525AbhHQJKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 05:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234843AbhHQJKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 05:10:01 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60036C061764
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 02:09:28 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mFv62-0001lg-F9; Tue, 17 Aug 2021 11:09:22 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1mFv60-0000Su-7Z; Tue, 17 Aug 2021 11:09:20 +0200
Date:   Tue, 17 Aug 2021 11:09:20 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Jarkko Nikula <jarkko.nikula@linux.intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: Regression with commit e532a096be0e ("net: usb: asix: ax88772:
 add phylib support")
Message-ID: <20210817090920.7wviv7fsfzyhli5t@pengutronix.de>
References: <3904c728-1ea2-9c2b-ec11-296396fd2f7e@linux.intel.com>
 <20210816081314.3b251d2e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210816161822.td7jl4tv7zfbprty@pengutronix.de>
 <e575a7a9-2645-9ebc-fdea-f0421ecaf0e2@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e575a7a9-2645-9ebc-fdea-f0421ecaf0e2@linux.intel.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:33:59 up 257 days, 22:40, 27 users,  load average: 0.05, 0.12,
 0.10
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 17, 2021 at 11:23:40AM +0300, Jarkko Nikula wrote:
> Hi
> 
> On 8/16/21 7:18 PM, Oleksij Rempel wrote:
> > > > v5.13 works ok. v5.14-rc1 and today's head 761c6d7ec820 ("Merge tag
> > > > 'arc-5.14-rc6' of
> > > > git://git.kernel.org/pub/scm/linux/kernel/git/vgupta/arc") show the
> > > > regression.
> > > > 
> > > > I bisected regression into e532a096be0e ("net: usb: asix: ax88772: add
> > > > phylib support").
> > > 
> > It sounds like issue which was fixed with the patch:
> > "net: usb: asix: ax88772: suspend PHY on driver probe"
> > 
> > This patch was taken in to v5.14-rc2. Can you please test it?
> > 
> Unfortunately it does not fix and was included in last week head
> 761c6d7ec820. I tested now also linux-next tag next-20210816 and the issue
> remains.

OK thx, I'll need to your help to debug it:
- please send me complete log, or at least parts related to the asix
  (dmesg | grep -i Asix)
- do the interface is not able to go up at all? For example, it works on
  hot plug, but is not working on reboot.
- Can you please test it with other link partners.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
