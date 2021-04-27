Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5A136CB73
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 21:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237848AbhD0TFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 15:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237640AbhD0TFs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 15:05:48 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E18C061574
        for <netdev@vger.kernel.org>; Tue, 27 Apr 2021 12:05:05 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lbT0y-0006It-Vf; Tue, 27 Apr 2021 21:04:56 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1lbT0v-0000X7-9h; Tue, 27 Apr 2021 21:04:53 +0200
Date:   Tue, 27 Apr 2021 21:04:53 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: linux-next: Tree for Apr 27 (net_selftest)
Message-ID: <20210427190453.w2skxqbgg5ap2fle@pengutronix.de>
References: <20210427174004.767b488a@canb.auug.org.au>
 <5a34cdf6-5efa-fab9-1c4f-699541a990a1@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5a34cdf6-5efa-fab9-1c4f-699541a990a1@infradead.org>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 21:03:08 up 146 days,  9:09, 46 users,  load average: 0.07, 0.13,
 0.10
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Apr 27, 2021 at 09:56:18AM -0700, Randy Dunlap wrote:
> On 4/27/21 12:40 AM, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20210426:
> > 
> 
> 
> on x86_64:
> 
> ld: drivers/net/ethernet/freescale/fec_main.o: in function `fec_enet_get_sset_count':
> fec_main.c:(.text+0x1445): undefined reference to `net_selftest_get_count'
> ld: drivers/net/ethernet/freescale/fec_main.o: in function `fec_enet_get_strings':
> fec_main.c:(.text+0x14a8): undefined reference to `net_selftest_get_strings'
> ld: drivers/net/ethernet/freescale/fec_main.o:(.rodata+0xc28): undefined reference to `net_selftest'
> 
> 
> Full randconfig file is attached.

thank you! I can reproduce it, will take closer look tomorrow.

> 
> -- 
> ~Randy
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> 

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
