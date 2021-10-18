Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E84E430E57
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 05:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbhJRDlb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 17 Oct 2021 23:41:31 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:60499 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231916AbhJRDl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 23:41:29 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 19I3d4sN5024726, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36503.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 19I3d4sN5024726
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 18 Oct 2021 11:39:04 +0800
Received: from RTEXDAG02.realtek.com.tw (172.21.6.101) by
 RTEXH36503.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Mon, 18 Oct 2021 11:39:04 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG02.realtek.com.tw (172.21.6.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Mon, 18 Oct 2021 11:39:03 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::cdd5:82a3:e854:7098]) by
 RTEXMBS04.realtek.com.tw ([fe80::cdd5:82a3:e854:7098%5]) with mapi id
 15.01.2106.013; Mon, 18 Oct 2021 11:39:03 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Yang Yingliang <yangyingliang@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
Subject: RE: [PATCH net-next] rtw89: fix return value check in rtw89_cam_send_sec_key_cmd()
Thread-Topic: [PATCH net-next] rtw89: fix return value check in
 rtw89_cam_send_sec_key_cmd()
Thread-Index: AQHXw8+LjeR4qgI7Tkacveo1F2lD6avYG4wg
Date:   Mon, 18 Oct 2021 03:39:03 +0000
Message-ID: <a4b733db61544d7a9fd0134cfe02fb44@realtek.com>
References: <20211018033102.1813058-1-yangyingliang@huawei.com>
In-Reply-To: <20211018033102.1813058-1-yangyingliang@huawei.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXDAG02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2021/10/18_=3F=3F_12:04:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36503.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 10/18/2021 03:26:20
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 166777 [Oct 17 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: pkshih@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 463 463 5854868460de3f0d8e8c0a4df98aeb05fb764a09
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;realtek.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 10/18/2021 03:28:00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Yang Yingliang <yangyingliang@huawei.com>
> Sent: Monday, October 18, 2021 11:31 AM
> To: linux-kernel@vger.kernel.org; netdev@vger.kernel.org; linux-wireless@vger.kernel.org
> Cc: Pkshih <pkshih@realtek.com>; kuba@kernel.org; davem@davemloft.net; kvalo@codeaurora.org
> Subject: [PATCH net-next] rtw89: fix return value check in rtw89_cam_send_sec_key_cmd()
> 
> Fix the return value check which testing the wrong variable
> in rtw89_cam_send_sec_key_cmd().
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: e3ec7017f6a2 ("rtw89: add Realtek 802.11ax driver")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>

> ---
>  drivers/net/wireless/realtek/rtw89/cam.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw89/cam.c
> b/drivers/net/wireless/realtek/rtw89/cam.c
> index c1e8c76c6aca..ad7a8155dbed 100644
> --- a/drivers/net/wireless/realtek/rtw89/cam.c
> +++ b/drivers/net/wireless/realtek/rtw89/cam.c
> @@ -77,7 +77,7 @@ static int rtw89_cam_send_sec_key_cmd(struct rtw89_dev *rtwdev,
>  		return 0;
> 
>  	ext_skb = rtw89_cam_get_sec_key_cmd(rtwdev, sec_cam, true);
> -	if (!skb) {
> +	if (!ext_skb) {
>  		rtw89_err(rtwdev, "failed to get ext sec key command\n");
>  		return -ENOMEM;
>  	}
> --
> 2.25.1
> 
> ------Please consider the environment before printing this e-mail.
