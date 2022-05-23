Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3AAD530F9F
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 15:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235504AbiEWMf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 08:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235490AbiEWMf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 08:35:27 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ADC949C9D
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 05:35:09 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1nt7Gt-0005Is-VB; Mon, 23 May 2022 14:34:51 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1nt7Gs-0002S5-Hu; Mon, 23 May 2022 14:34:50 +0200
Date:   Mon, 23 May 2022 14:34:50 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Rin Cat =?utf-8?B?KOmItOeMqyk=?= <dev@rincat.ch>
Cc:     linux-wireless@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Hans Ulli Kroll <linux@ulli-kroll.de>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        kernel@pengutronix.de, Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 09/10] rtw88: Add rtw8822bu chipset support
Message-ID: <20220523123450.GP25578@pengutronix.de>
References: <20220518082318.3898514-1-s.hauer@pengutronix.de>
 <20220518082318.3898514-10-s.hauer@pengutronix.de>
 <5646cf79-248e-e80c-d1af-47887dc5232a@rincat.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5646cf79-248e-e80c-d1af-47887dc5232a@rincat.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:19:07 up 54 days, 48 min, 75 users,  load average: 0.06, 0.17,
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

On Mon, May 23, 2022 at 07:56:14AM -0400, Rin Cat (鈴猫) wrote:
> Hi, here are all current known vender rtw8822bu devices IDs from my
> maintained Realtek driver.
> https://github.com/RinCat/RTL88x2BU-Linux-Driver/blob/master/os_dep/linux/usb_intf.c#L239=

Man, how many incarnations of this driver are there? It's really about time
to mainline it.

Modulo the IDs posted by Nick Morrow already only this one is missing:

	{USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x331f, 0xff, 0xff, 0xff),
	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec)}, /* Dlink - DWA-183 D Ver */

Will add it for the next round.

Thanks,
  Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
