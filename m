Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE561658AF2
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 10:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233114AbiL2J1H convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 29 Dec 2022 04:27:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbiL2J1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 04:27:06 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 479AE2EE;
        Thu, 29 Dec 2022 01:27:05 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2BT9Pt6iA029915, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2BT9Pt6iA029915
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Thu, 29 Dec 2022 17:25:55 +0800
Received: from RTEXMBS02.realtek.com.tw (172.21.6.95) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Thu, 29 Dec 2022 17:26:49 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS02.realtek.com.tw (172.21.6.95) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Thu, 29 Dec 2022 17:26:49 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Thu, 29 Dec 2022 17:26:49 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "tehuang@realtek.com" <tehuang@realtek.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/4] rtw88: Four fixes found while working on SDIO support
Thread-Topic: [PATCH 0/4] rtw88: Four fixes found while working on SDIO
 support
Thread-Index: AQHZGsFtyqvVdb8Ir06VvN9lkSQirK6EmVQw
Date:   Thu, 29 Dec 2022 09:26:49 +0000
Message-ID: <84e2f2289e964834b1eaf60d4f9f5255@realtek.com>
References: <20221228133547.633797-1-martin.blumenstingl@googlemail.com>
In-Reply-To: <20221228133547.633797-1-martin.blumenstingl@googlemail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/12/29_=3F=3F_07:25:00?=
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
> From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Sent: Wednesday, December 28, 2022 9:36 PM
> To: linux-wireless@vger.kernel.org
> Cc: tony0620emma@gmail.com; kvalo@kernel.org; Ping-Ke Shih <pkshih@realtek.com>; tehuang@realtek.com;
> s.hauer@pengutronix.de; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Martin Blumenstingl
> <martin.blumenstingl@googlemail.com>
> Subject: [PATCH 0/4] rtw88: Four fixes found while working on SDIO support
> 
> This series consists of three patches which are fixing existing
> behavior (meaning: it either affects PCIe or USB or both) in the rtw88
> driver.
> 
> The first change adds the packed attribute to the eFuse structs. This
> was spotted by Ping-Ke while reviewing the SDIO support patches from
> [0].
> 
> The remaining three changes relate to locking (barrier hold) problems.
> We previously had discussed patches for this for SDIO support, but the
> problem never ocurred while testing USB cards. It turns out that these
> are still needed and I think that they also fix the same problems for
> USB users (it's not clear how often it happens there though).
> 
> The issue fixed by the second and third patches have been spotted by a
> user who tested rtw88 SDIO support. Everything is working fine for him
> but there are warnings [1] and [2] in the kernel log stating "Voluntary
> context switch within RCU read-side critical section!".
> 
> The solution in the third and fourth patch was actually suggested by
> Ping-Ke in [3]. Thanks again!
> 
> 
> [0] https://lore.kernel.org/linux-wireless/695c976e02ed44a2b2345a3ceb226fc4@realtek.com/
> [1] https://github.com/LibreELEC/LibreELEC.tv/pull/7301#issuecomment-1366421445
> [2] https://github.com/LibreELEC/LibreELEC.tv/pull/7301#issuecomment-1366610249
> [3] https://lore.kernel.org/lkml/e0aa1ba4336ab130712e1fcb425e6fd0adca4145.camel@realtek.com/
> 
> 
> Martin Blumenstingl (4):
>   rtw88: Add packed attribute to the eFuse structs

I think this patch depends on another patchset or oppositely.
Please point that out for reviewers.

>   rtw88: Configure the registers from rtw_bf_assoc() outside the RCU
>     lock
>   rtw88: Use rtw_iterate_vifs() for rtw_vif_watch_dog_iter()
>   rtw88: Use non-atomic rtw_iterate_stas() in rtw_ra_mask_info_update()
> 
>  drivers/net/wireless/realtek/rtw88/bf.c       | 13 ++++++------
>  drivers/net/wireless/realtek/rtw88/mac80211.c |  4 +++-
>  drivers/net/wireless/realtek/rtw88/main.c     |  6 ++++--
>  drivers/net/wireless/realtek/rtw88/main.h     |  6 +++---
>  drivers/net/wireless/realtek/rtw88/rtw8723d.h |  6 +++---
>  drivers/net/wireless/realtek/rtw88/rtw8821c.h | 20 +++++++++----------
>  drivers/net/wireless/realtek/rtw88/rtw8822b.h | 20 +++++++++----------
>  drivers/net/wireless/realtek/rtw88/rtw8822c.h | 20 +++++++++----------
>  8 files changed, 50 insertions(+), 45 deletions(-)
> 
> --
> 2.39.0

