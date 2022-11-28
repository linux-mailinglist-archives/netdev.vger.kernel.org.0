Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 977D9639F5B
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 03:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbiK1COG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 27 Nov 2022 21:14:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiK1COF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 21:14:05 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5D929CFA;
        Sun, 27 Nov 2022 18:14:04 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2AS2CoT62031913, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2AS2CoT62031913
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Mon, 28 Nov 2022 10:12:50 +0800
Received: from RTEXDAG02.realtek.com.tw (172.21.6.101) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Mon, 28 Nov 2022 10:13:34 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG02.realtek.com.tw (172.21.6.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Mon, 28 Nov 2022 10:13:34 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Mon, 28 Nov 2022 10:13:33 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Neo Jou <neojou@gmail.com>, Hans Ulli Kroll <linux@ulli-kroll.de>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Martin Blumenstingl" <martin.blumenstingl@googlemail.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Johannes Berg <johannes@sipsolutions.net>,
        Alexander Hochbaum <alex@appudo.com>,
        Da Xue <da@libre.computer>,
        "Bernie Huang" <phhuang@realtek.com>,
        Viktor Petrenko <g0000ga@gmail.com>
Subject: RE: [PATCH v3 08/11] rtw88: Add rtw8821cu chipset support
Thread-Topic: [PATCH v3 08/11] rtw88: Add rtw8821cu chipset support
Thread-Index: AQHY/oJxlcE4AN1s7Ue+AOL9SzW7Xa5Tn5gw
Date:   Mon, 28 Nov 2022 02:13:33 +0000
Message-ID: <64d0d2c40be0404498cf09650d267320@realtek.com>
References: <20221122145226.4065843-1-s.hauer@pengutronix.de>
 <20221122145226.4065843-9-s.hauer@pengutronix.de>
In-Reply-To: <20221122145226.4065843-9-s.hauer@pengutronix.de>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXDAG02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/11/27_=3F=3F_10:48:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Sascha Hauer <s.hauer@pengutronix.de>
> Sent: Tuesday, November 22, 2022 10:52 PM
> To: linux-wireless@vger.kernel.org
> Cc: Neo Jou <neojou@gmail.com>; Hans Ulli Kroll <linux@ulli-kroll.de>; Ping-Ke Shih <pkshih@realtek.com>;
> Yan-Hsuan Chuang <tony0620emma@gmail.com>; Kalle Valo <kvalo@kernel.org>; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org; Martin Blumenstingl <martin.blumenstingl@googlemail.com>;
> kernel@pengutronix.de; Johannes Berg <johannes@sipsolutions.net>; Alexander Hochbaum <alex@appudo.com>;
> Da Xue <da@libre.computer>; Bernie Huang <phhuang@realtek.com>; Viktor Petrenko <g0000ga@gmail.com>;
> Sascha Hauer <s.hauer@pengutronix.de>
> Subject: [PATCH v3 08/11] rtw88: Add rtw8821cu chipset support
> 
> Add support for the rtw8821cu chipset based on
> https://github.com/ulli-kroll/rtw88-usb.git
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
> 
> Notes:
>     Changes since v2:
>     - Fix txdesc checksum calculation. The checksum must be calculated over
>       a fixed number of words.
> 
>  drivers/net/wireless/realtek/rtw88/Kconfig    | 11 ++++
>  drivers/net/wireless/realtek/rtw88/Makefile   |  3 ++
>  drivers/net/wireless/realtek/rtw88/rtw8821c.c | 18 +++++++
>  drivers/net/wireless/realtek/rtw88/rtw8821c.h | 21 ++++++++
>  .../net/wireless/realtek/rtw88/rtw8821cu.c    | 50 +++++++++++++++++++
>  .../net/wireless/realtek/rtw88/rtw8821cu.h    | 10 ++++
>  6 files changed, 113 insertions(+)
>  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8821cu.c
>  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8821cu.h
> 

[...]

> --- /dev/null
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8821cu.h
> @@ -0,0 +1,10 @@
> +/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
> +/* Copyright(c) 2018-2019  Realtek Corporation
> + */
> +
> +#ifndef __RTW_8821CU_H_
> +#define __RTW_8821CU_H_
> +
> +extern struct rtw_chip_info rtw8821c_hw_spec;

This has been moved to rtw8821c.h by
89d8f53ff6e ("wifi: rtw88: Fix Sparse warning for rtw8821c_hw_spec")

So, we don't need rtw8821cu.h anymore. 
Please apply this rule to other chips.

> +
> +#endif
> --
> 2.30.2

