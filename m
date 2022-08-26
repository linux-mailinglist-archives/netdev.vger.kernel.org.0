Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD50A5A1F17
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 04:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244243AbiHZCqJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 25 Aug 2022 22:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235939AbiHZCqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 22:46:07 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C925F51A3B;
        Thu, 25 Aug 2022 19:46:05 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 27Q2iQoN5005022, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 27Q2iQoN5005022
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Fri, 26 Aug 2022 10:44:26 +0800
Received: from RTEXMBS01.realtek.com.tw (172.21.6.94) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 26 Aug 2022 10:44:41 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS01.realtek.com.tw (172.21.6.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Fri, 26 Aug 2022 10:44:40 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::d902:19b0:8613:5b97]) by
 RTEXMBS04.realtek.com.tw ([fe80::d902:19b0:8613:5b97%5]) with mapi id
 15.01.2375.007; Fri, 26 Aug 2022 10:44:40 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Yang Yingliang <yangyingliang@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        Bernie Huang <phhuang@realtek.com>
Subject: RE: [PATCH -next v2] wifi: rtw88: add missing destroy_workqueue() on error path in rtw_core_init()
Thread-Topic: [PATCH -next v2] wifi: rtw88: add missing destroy_workqueue() on
 error path in rtw_core_init()
Thread-Index: AQHYuPPXTVNverb67E6eoXZA/kccLq3AeYDg
Date:   Fri, 26 Aug 2022 02:44:40 +0000
Message-ID: <3388603e9a874c2d893b5fff8949390e@realtek.com>
References: <20220826023817.3908255-1-yangyingliang@huawei.com>
In-Reply-To: <20220826023817.3908255-1-yangyingliang@huawei.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/8/25_=3F=3F_11:50:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
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
> Sent: Friday, August 26, 2022 10:38 AM
> To: linux-kernel@vger.kernel.org; netdev@vger.kernel.org; linux-wireless@vger.kernel.org
> Cc: tony0620emma@gmail.com; kvalo@kernel.org; Bernie Huang <phhuang@realtek.com>
> Subject: [PATCH -next v2] wifi: rtw88: add missing destroy_workqueue() on error path in rtw_core_init()
> 
> Add the missing destroy_workqueue() before return from rtw_core_init()
> in error path.
> 
> Fixes: fe101716c7c9 ("rtw88: replace tx tasklet with work queue")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>

Thanks

> ---
> v2:
>   Change labe name to 'out'.
> ---
>  drivers/net/wireless/realtek/rtw88/main.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
> index 790dcfed1125..475ce0e3071c 100644
> --- a/drivers/net/wireless/realtek/rtw88/main.c
> +++ b/drivers/net/wireless/realtek/rtw88/main.c
> @@ -2094,7 +2094,7 @@ int rtw_core_init(struct rtw_dev *rtwdev)
>  	ret = rtw_load_firmware(rtwdev, RTW_NORMAL_FW);
>  	if (ret) {
>  		rtw_warn(rtwdev, "no firmware loaded\n");
> -		return ret;
> +		goto out;
>  	}
> 
>  	if (chip->wow_fw_name) {
> @@ -2104,11 +2104,15 @@ int rtw_core_init(struct rtw_dev *rtwdev)
>  			wait_for_completion(&rtwdev->fw.completion);
>  			if (rtwdev->fw.firmware)
>  				release_firmware(rtwdev->fw.firmware);
> -			return ret;
> +			goto out;
>  		}
>  	}
> 
>  	return 0;
> +
> +out:
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
