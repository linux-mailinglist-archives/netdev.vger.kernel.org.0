Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 892765309C4
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 09:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiEWHEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 03:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbiEWHEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 03:04:02 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6475523677C
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 23:56:39 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1nt1wt-0007Lr-4Z; Mon, 23 May 2022 08:53:51 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1nt1wq-0001DV-Gs; Mon, 23 May 2022 08:53:48 +0200
Date:   Mon, 23 May 2022 08:53:48 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Hans Ulli Kroll <linux@ulli-kroll.de>
Cc:     linux-wireless@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        kernel@pengutronix.de, Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 00/10] RTW88: Add support for USB variants
Message-ID: <20220523065348.GK25578@pengutronix.de>
References: <20220518082318.3898514-1-s.hauer@pengutronix.de>
 <55f569899e4e894970b826548cd5439f5def2183.camel@ulli-kroll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55f569899e4e894970b826548cd5439f5def2183.camel@ulli-kroll.de>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:45:07 up 53 days, 19:14, 61 users,  load average: 0.03, 0.24,
 0.25
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

Hi Hans Ulli,

On Mon, May 23, 2022 at 06:07:16AM +0200, Hans Ulli Kroll wrote:
> On Wed, 2022-05-18 at 10:23 +0200, Sascha Hauer wrote:
> > This series adds support for the USB chip variants to the RTW88 driver.
> > 
> 
> Hi Sascha
> 
> glad you found some *working* devices for rtw88 !

Well, not fully. I had to add [3] = RTW_DEF_RFE(8822c, 0, 0), to the
rtw8822c_rfe_defs array.

> 
> I spend some of the weekend testing your driver submission.
> 
> for rtl8821cu devices I get following output
> 
> some Logilink device
> 
> [ 1686.605567] usb 1-5.1.2: New USB device found, idVendor=0bda, idProduct=c811, bcdDevice=
> 2.00
> [ 1686.614186] usb 1-5.1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [ 1686.621721] usb 1-5.1.2: Product: 802.11ac NIC
> [ 1686.626227] usb 1-5.1.2: Manufacturer: Realtek
> [ 1686.630695] usb 1-5.1.2: SerialNumber: 123456
> [ 1686.640480] rtw_8821cu 1-5.1.2:1.0: Firmware version 24.5.0, H2C version 12
> [ 1686.932828] rtw_8821cu 1-5.1.2:1.0: failed to download firmware
> [ 1686.945206] rtw_8821cu 1-5.1.2:1.0: failed to setup chip efuse info
> [ 1686.951538] rtw_8821cu 1-5.1.2:1.0: failed to setup chip information
> [ 1686.958402] rtw_8821cu: probe of 1-5.1.2:1.0 failed with error -22
> 
> above is same with some from Comfast
> 
> The worst in the list is one from EDUP
> 
> [ 1817.855704] rtw_8821cu 1-5.1.2:1.2: Firmware version 24.5.0, H2C version 12
> [ 1818.153918] rtw_8821cu 1-5.1.2:1.2: rfe 255 isn't supported
> [ 1818.165176] rtw_8821cu 1-5.1.2:1.2: failed to setup chip efuse info
> [ 1818.171505] rtw_8821cu 1-5.1.2:1.2: failed to setup chip information

Do these chips work with your out of tree variant of this driver?

Is the efuse info completely 0xff or only the field indicating the rfe
option?

> 
> rtl8822bu devices are working fine ...

Nice. Did you test a rtw8723du device as well?

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
