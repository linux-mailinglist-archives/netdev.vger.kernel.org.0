Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1452E52E71B
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 10:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346890AbiETIQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 04:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242281AbiETIQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 04:16:58 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3736D60BAE
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 01:16:57 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1nrxoV-0001il-A1; Fri, 20 May 2022 10:16:47 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1nrxoS-0004CF-BI; Fri, 20 May 2022 10:16:44 +0200
Date:   Fri, 20 May 2022 10:16:44 +0200
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
Subject: Re: [PATCH 07/10] rtw88: Add rtw8723du chipset support
Message-ID: <20220520081644.GD25578@pengutronix.de>
References: <20220518082318.3898514-1-s.hauer@pengutronix.de>
 <20220518082318.3898514-8-s.hauer@pengutronix.de>
 <819189eb24ecece40e9d0c2a51f54d4084bb9493.camel@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <819189eb24ecece40e9d0c2a51f54d4084bb9493.camel@realtek.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:16:18 up 50 days, 20:45, 53 users,  load average: 0.03, 0.08,
 0.12
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

On Fri, May 20, 2022 at 07:47:44AM +0000, Pkshih wrote:
> On Wed, 2022-05-18 at 10:23 +0200, Sascha Hauer wrote:
> > Add support for the rtw8723du chipset based on
> > https://github.com/ulli-kroll/rtw88-usb.git
> > 
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > ---
> >  drivers/net/wireless/realtek/rtw88/Kconfig    | 11 +++++
> >  drivers/net/wireless/realtek/rtw88/Makefile   |  3 ++
> >  drivers/net/wireless/realtek/rtw88/rtw8723d.c | 19 +++++++++
> >  drivers/net/wireless/realtek/rtw88/rtw8723d.h |  1 +
> >  .../net/wireless/realtek/rtw88/rtw8723du.c    | 40 +++++++++++++++++++
> >  .../net/wireless/realtek/rtw88/rtw8723du.h    | 13 ++++++
> >  6 files changed, 87 insertions(+)
> >  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723du.c
> >  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723du.h
> > 
> > 
> 
> [...]
> 
> > diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723du.c
> > b/drivers/net/wireless/realtek/rtw88/rtw8723du.c
> > new file mode 100644
> > index 0000000000000..910f64c168131
> > --- /dev/null
> > +++ b/drivers/net/wireless/realtek/rtw88/rtw8723du.c
> > @@ -0,0 +1,40 @@
> > +// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
> > +/* Copyright(c) 2018-2019  Realtek Corporation
> > + */
> > +
> > +#include <linux/module.h>
> > +#include <linux/usb.h>
> > +#include "main.h"
> > +#include "rtw8723du.h"
> > +#include "usb.h"
> > +
> > +static const struct usb_device_id rtw_8723du_id_table[] = {
> > +	/*
> > +	 * ULLI :
> > +	 * ID found in rtw8822bu sources
> > +	 */
> 
> checkpatch.pl will tell us this comment block should be
> 
> /* ULLI :
>  * ID found in rtw8822bu sources
>  */
> 
> But, I think we can just "/* ULLI: ID found in rtw8822bu sources */" 
> if we really want to keep this comment.

I'll drop this comment.

> > +
> > +#ifndef __RTW_8723DU_H_
> > +#define __RTW_8723DU_H_
> > +
> > +/* USB Vendor/Product IDs */
> > +#define RTW_USB_VENDOR_ID_REALTEK		0x0BDA
> 
> rtw8821cu.h and rtw8822bu.h define this too.
> Can we move it to usb.h?

Yes.

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
