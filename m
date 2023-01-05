Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6286265E1E1
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 01:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbjAEAoZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 4 Jan 2023 19:44:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240739AbjAEAnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 19:43:23 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EE4EC48598;
        Wed,  4 Jan 2023 16:42:08 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 3050eLabD019011, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 3050eLabD019011
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Thu, 5 Jan 2023 08:40:21 +0800
Received: from RTEXDAG02.realtek.com.tw (172.21.6.101) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Thu, 5 Jan 2023 08:41:17 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG02.realtek.com.tw (172.21.6.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Thu, 5 Jan 2023 08:41:16 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Thu, 5 Jan 2023 08:41:16 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        "leon@kernel.org" <leon@kernel.org>
CC:     "kvalo@kernel.org" <kvalo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] wifi: rtw89: Add missing check for alloc_workqueue
Thread-Topic: [PATCH v2] wifi: rtw89: Add missing check for alloc_workqueue
Thread-Index: AQHZIEjq9FFtsqr1yEeR9VNNUx0AXa6O/DPw
Date:   Thu, 5 Jan 2023 00:41:16 +0000
Message-ID: <dd7d393a20a4498f95ab397ff6bb8a1f@realtek.com>
References: <20230104142901.1611-1-jiasheng@iscas.ac.cn>
In-Reply-To: <20230104142901.1611-1-jiasheng@iscas.ac.cn>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXDAG02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2023/1/4_=3F=3F_11:28:00?=
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
> From: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> Sent: Wednesday, January 4, 2023 10:29 PM
> To: leon@kernel.org
> Cc: Ping-Ke Shih <pkshih@realtek.com>; kvalo@kernel.org; davem@davemloft.net; edumazet@google.com;
> kuba@kernel.org; pabeni@redhat.com; linux-wireless@vger.kernel.org; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org; Jiasheng Jiang <jiasheng@iscas.ac.cn>
> Subject: [PATCH v2] wifi: rtw89: Add missing check for alloc_workqueue
> 
> Add check for the return value of alloc_workqueue since it may return
> NULL pointer.
> Moreover, add destroy_workqueue when rtw89_load_firmware fails.
> 
> Fixes: e3ec7017f6a2 ("rtw89: add Realtek 802.11ax driver")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>

> ---
> CHangelog:
> 
> v1 -> v2:
> 
> 1. Add destroy_workqueue when rtw89_load_firmware fails.
> ---
>  drivers/net/wireless/realtek/rtw89/core.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
> index 931aff8b5dc9..e99eccf11c76 100644
> --- a/drivers/net/wireless/realtek/rtw89/core.c
> +++ b/drivers/net/wireless/realtek/rtw89/core.c
> @@ -3124,6 +3124,8 @@ int rtw89_core_init(struct rtw89_dev *rtwdev)
>  	INIT_DELAYED_WORK(&rtwdev->cfo_track_work, rtw89_phy_cfo_track_work);
>  	INIT_DELAYED_WORK(&rtwdev->forbid_ba_work, rtw89_forbid_ba_work);
>  	rtwdev->txq_wq = alloc_workqueue("rtw89_tx_wq", WQ_UNBOUND | WQ_HIGHPRI, 0);
> +	if (!rtwdev->txq_wq)
> +		return -ENOMEM;
>  	spin_lock_init(&rtwdev->ba_lock);
>  	spin_lock_init(&rtwdev->rpwm_lock);
>  	mutex_init(&rtwdev->mutex);
> @@ -3149,6 +3151,7 @@ int rtw89_core_init(struct rtw89_dev *rtwdev)
>  	ret = rtw89_load_firmware(rtwdev);
>  	if (ret) {
>  		rtw89_warn(rtwdev, "no firmware loaded\n");
> +		destroy_workqueue(rtwdev->txq_wq);
>  		return ret;
>  	}
>  	rtw89_ser_init(rtwdev);
> --
> 2.25.1

