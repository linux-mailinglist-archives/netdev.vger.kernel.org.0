Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EED95A1DC8
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 02:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242180AbiHZApx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 25 Aug 2022 20:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235364AbiHZApw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 20:45:52 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A731BC7FB6;
        Thu, 25 Aug 2022 17:45:50 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 27Q0iRjuD005132, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 27Q0iRjuD005132
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Fri, 26 Aug 2022 08:44:27 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Fri, 26 Aug 2022 08:44:42 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Fri, 26 Aug 2022 08:44:42 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::d902:19b0:8613:5b97]) by
 RTEXMBS04.realtek.com.tw ([fe80::d902:19b0:8613:5b97%5]) with mapi id
 15.01.2375.007; Fri, 26 Aug 2022 08:44:42 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Yang Yingliang <yangyingliang@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        Bernie Huang <phhuang@realtek.com>
Subject: RE: [PATCH -next] wifi: rtw88: add missing destroy_workqueue() on error path in rtw_core_init()
Thread-Topic: [PATCH -next] wifi: rtw88: add missing destroy_workqueue() on
 error path in rtw_core_init()
Thread-Index: AQHYuIbMIe6iUQ1BjUawKWBN0SU+yq3AWAlQ
Date:   Fri, 26 Aug 2022 00:44:42 +0000
Message-ID: <2f08c305927a43d78d6ab86468609288@realtek.com>
References: <20220825133731.1877569-1-yangyingliang@huawei.com>
In-Reply-To: <20220825133731.1877569-1-yangyingliang@huawei.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS04.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/8/25_=3F=3F_10:39:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36504.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Yang Yingliang <yangyingliang@huawei.com>
> Sent: Thursday, August 25, 2022 9:38 PM
> To: linux-kernel@vger.kernel.org; netdev@vger.kernel.org; linux-wireless@vger.kernel.org
> Cc: tony0620emma@gmail.com; kvalo@kernel.org; Bernie Huang <phhuang@realtek.com>
> Subject: [PATCH -next] wifi: rtw88: add missing destroy_workqueue() on error path in rtw_core_init()
> 
> Add the missing destroy_workqueue() before return from rtw_core_init()
> in error path.
> 
> Fixes: fe101716c7c9 ("rtw88: replace tx tasklet with work queue")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/wireless/realtek/rtw88/main.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
> index 790dcfed1125..557213e52761 100644
> --- a/drivers/net/wireless/realtek/rtw88/main.c
> +++ b/drivers/net/wireless/realtek/rtw88/main.c
> @@ -2094,7 +2094,7 @@ int rtw_core_init(struct rtw_dev *rtwdev)
>  	ret = rtw_load_firmware(rtwdev, RTW_NORMAL_FW);
>  	if (ret) {
>  		rtw_warn(rtwdev, "no firmware loaded\n");
> -		return ret;
> +		goto destroy_workqueue;
>  	}
> 
>  	if (chip->wow_fw_name) {
> @@ -2104,11 +2104,15 @@ int rtw_core_init(struct rtw_dev *rtwdev)
>  			wait_for_completion(&rtwdev->fw.completion);
>  			if (rtwdev->fw.firmware)
>  				release_firmware(rtwdev->fw.firmware);
> -			return ret;
> +			goto destroy_workqueue;
>  		}
>  	}
> 
>  	return 0;
> +
> +destroy_workqueue:

It's not so good that the label 'destroy_workqueue' is the same as function name.
I suggest to just use 'out' instead.

> +	destroy_workqueue(rtwdev->tx_wq);
> +	return ret;
>  }
>  EXPORT_SYMBOL(rtw_core_init);
> 
> --
> 2.25.1
> 
> 
> ------Please consider the environment before printing this e-mail.
