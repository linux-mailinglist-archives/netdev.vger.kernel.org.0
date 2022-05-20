Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA8F152E820
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 10:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347441AbiETI4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 04:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347396AbiETI4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 04:56:34 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB6A5DE6C
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 01:56:32 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1nryQr-00075f-K0; Fri, 20 May 2022 10:56:25 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1nryQq-0005Y9-NT; Fri, 20 May 2022 10:56:24 +0200
Date:   Fri, 20 May 2022 10:56:24 +0200
From:   "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
To:     Pkshih <pkshih@realtek.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux@ulli-kroll.de" <linux@ulli-kroll.de>,
        "martin.blumenstingl@googlemail.com" 
        <martin.blumenstingl@googlemail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "neojou@gmail.com" <neojou@gmail.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: Re: [PATCH 10/10] rtw88: Add rtw8822cu chipset support
Message-ID: <20220520085624.GF25578@pengutronix.de>
References: <20220518082318.3898514-1-s.hauer@pengutronix.de>
 <20220518082318.3898514-11-s.hauer@pengutronix.de>
 <b19fcc328a8e436d27579bbf9e217a2be71b57b5.camel@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b19fcc328a8e436d27579bbf9e217a2be71b57b5.camel@realtek.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:53:21 up 50 days, 21:23, 57 users,  load average: 0.04, 0.05,
 0.07
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 20, 2022 at 08:03:30AM +0000, Pkshih wrote:
> On Wed, 2022-05-18 at 10:23 +0200, Sascha Hauer wrote:
> > Add support for the rtw8822cu chipset based on
> > https://github.com/ulli-kroll/rtw88-usb.git
> > 
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > ---
> >  drivers/net/wireless/realtek/rtw88/Kconfig    | 11 +++++
> >  drivers/net/wireless/realtek/rtw88/Makefile   |  3 ++
> >  drivers/net/wireless/realtek/rtw88/rtw8822c.c | 24 +++++++++++
> >  .../net/wireless/realtek/rtw88/rtw8822cu.c    | 40 +++++++++++++++++++
> >  .../net/wireless/realtek/rtw88/rtw8822cu.h    | 15 +++++++
> >  5 files changed, 93 insertions(+)
> >  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822cu.c
> >  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822cu.h
> > 
> > 
> 
> [...]
> 
> > +MODULE_AUTHOR("Realtek Corporation");
> 
> Out of curiosity, there are many authors in your patchset.
> Do you collect these driver from various places?

No, the driver is completely based on
https://github.com/ulli-kroll/rtw88-usb.git

> 
> rtw8723du.c:MODULE_AUTHOR("Hans Ulli Kroll <linux@ulli-kroll.de>");
> rtw8821cu.c:MODULE_AUTHOR("Hans Ulli Kroll <linux@ulli-kroll.de>");
> rtw8822bu.c:MODULE_AUTHOR("Realtek Corporation");
> rtw8822cu.c:MODULE_AUTHOR("Realtek Corporation");
> usb.c:MODULE_AUTHOR("Realtek Corporation");

The driver is originally from Neo Jou (at least that's what the git log
tells me). The rtw8723du and rtw8821cu support was added later by Ulli
Kroll.

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
