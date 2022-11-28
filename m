Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5DF463A033
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 04:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiK1Dqj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 27 Nov 2022 22:46:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiK1Dqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 22:46:38 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0D52C10FC1;
        Sun, 27 Nov 2022 19:46:36 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2AS3jD5D1019835, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2AS3jD5D1019835
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Mon, 28 Nov 2022 11:45:13 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.9; Mon, 28 Nov 2022 11:45:58 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Mon, 28 Nov 2022 11:45:57 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Mon, 28 Nov 2022 11:45:57 +0800
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
Subject: RE: [PATCH v3 00/11] RTW88: Add support for USB variants
Thread-Topic: [PATCH v3 00/11] RTW88: Add support for USB variants
Thread-Index: AQHY/oI6X+HeQwQE6E+5y32AEGOa3q5TucCA
Date:   Mon, 28 Nov 2022 03:45:57 +0000
Message-ID: <71b14558ff904382a77b6b21982c078e@realtek.com>
References: <20221122145226.4065843-1-s.hauer@pengutronix.de>
In-Reply-To: <20221122145226.4065843-1-s.hauer@pengutronix.de>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS04.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/11/28_=3F=3F_12:28:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
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
> Subject: [PATCH v3 00/11] RTW88: Add support for USB variants
> 
> This is the third round of adding support for the USB variants to the
> RTW88 driver. There are a few changes to the last version which make it
> worth looking at this version.
> 
> First of all RTL8723du and RTL8821cu are tested working now. The issue
> here was that the txdesc checksum calculation was wrong. I found the
> correct calculation in various downstream drivers found on github.
> 
> The second big issue was that TX packet aggregation was wrong. When
> aggregating packets each packet start has to be aligned to eight bytes.
> The necessary alignment was added to the total URB length before
> checking if there is another packet to aggregate, so the URB length
> included that padding after the last packet, which is wrong.  Fixing
> this makes the driver work much more reliably.
> 

Thanks for your finding and fixes on this driver. I have reviewed this 
patchset and written some comments. No big problem.


> 
> Sascha Hauer (11):
>   rtw88: print firmware type in info message
>   rtw88: Call rtw_fw_beacon_filter_config() with rtwdev->mutex held
>   rtw88: Drop rf_lock
>   rtw88: Drop h2c.lock
>   rtw88: Drop coex mutex
>   rtw88: iterate over vif/sta list non-atomically
>   rtw88: Add common USB chip support
>   rtw88: Add rtw8821cu chipset support
>   rtw88: Add rtw8822bu chipset support
>   rtw88: Add rtw8822cu chipset support
>   rtw88: Add rtw8723du chipset support

Please use "wifi: rtw88: " as prefix in next version.

--
Ping-Ke


