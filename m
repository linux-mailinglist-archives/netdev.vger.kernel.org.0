Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB473580987
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 04:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236904AbiGZCjL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 25 Jul 2022 22:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiGZCjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 22:39:10 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2ED452982A;
        Mon, 25 Jul 2022 19:39:08 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 26Q2c1mI5003030, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 26Q2c1mI5003030
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Tue, 26 Jul 2022 10:38:01 +0800
Received: from RTEXDAG01.realtek.com.tw (172.21.6.100) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Tue, 26 Jul 2022 10:38:07 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG01.realtek.com.tw (172.21.6.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Tue, 26 Jul 2022 10:37:10 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::415c:a915:a507:e600]) by
 RTEXMBS04.realtek.com.tw ([fe80::415c:a915:a507:e600%5]) with mapi id
 15.01.2308.027; Tue, 26 Jul 2022 10:38:06 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     "williamsukatube@163.com" <williamsukatube@163.com>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     William Dean <williamsukatube@gmail.com>,
        Hacash Robot <hacashRobot@santino.com>
Subject: RE: [PATCH] rtw88: check the return value of alloc_workqueue()
Thread-Topic: [PATCH] rtw88: check the return value of alloc_workqueue()
Thread-Index: AQHYnl76EnGR994/20i9s4ZrF2kwK62P9GPw
Date:   Tue, 26 Jul 2022 02:38:06 +0000
Message-ID: <303b6e26a6514b5485a3ca5286ae98c6@realtek.com>
References: <20220723063756.2956189-1-williamsukatube@163.com>
In-Reply-To: <20220723063756.2956189-1-williamsukatube@163.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXDAG01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/7/26_=3F=3F_12:18:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36504.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: williamsukatube@163.com <williamsukatube@163.com>
> Sent: Saturday, July 23, 2022 2:38 PM
> To: tony0620emma@gmail.com; kvalo@kernel.org; davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> pabeni@redhat.com; linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Cc: William Dean <williamsukatube@gmail.com>; Hacash Robot <hacashRobot@santino.com>
> Subject: [PATCH] rtw88: check the return value of alloc_workqueue()
> 
> From: William Dean <williamsukatube@gmail.com>
> 
> The function alloc_workqueue() in rtw_core_init() can fail, but
> there is no check of its return value. To fix this bug, its return value
> should be checked with new error handling code.
> 
> Fixes: fe101716c7c9d ("rtw88: replace tx tasklet with work queue")
> Reported-by: Hacash Robot <hacashRobot@santino.com>
> Signed-off-by: William Dean <williamsukatube@gmail.com>

Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>

Thank you

> ---
>  drivers/net/wireless/realtek/rtw88/main.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
> index efabd5b1bf5b..645ef1d01895 100644
> --- a/drivers/net/wireless/realtek/rtw88/main.c
> +++ b/drivers/net/wireless/realtek/rtw88/main.c
> @@ -1984,6 +1984,10 @@ int rtw_core_init(struct rtw_dev *rtwdev)
>  	timer_setup(&rtwdev->tx_report.purge_timer,
>  		    rtw_tx_report_purge_timer, 0);
>  	rtwdev->tx_wq = alloc_workqueue("rtw_tx_wq", WQ_UNBOUND | WQ_HIGHPRI, 0);
> +	if (!rtwdev->tx_wq) {
> +		rtw_warn(rtwdev, "alloc_workqueue rtw_tx_wq failed\n");
> +		return -ENOMEM;
> +	}
> 
>  	INIT_DELAYED_WORK(&rtwdev->watch_dog_work, rtw_watch_dog_work);
>  	INIT_DELAYED_WORK(&coex->bt_relink_work, rtw_coex_bt_relink_work);
> --
> 2.25.1

