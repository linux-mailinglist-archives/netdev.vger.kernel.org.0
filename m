Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA5E44D166
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 06:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231730AbhKKFWb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 11 Nov 2021 00:22:31 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:36715 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbhKKFW0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 00:22:26 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 1AB5JKo64009230, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 1AB5JKo64009230
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 11 Nov 2021 13:19:20 +0800
Received: from RTEXMBS02.realtek.com.tw (172.21.6.95) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 11 Nov 2021 13:19:20 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS02.realtek.com.tw (172.21.6.95) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Thu, 11 Nov 2021 13:19:19 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::dc53:1026:298b:c584]) by
 RTEXMBS04.realtek.com.tw ([fe80::dc53:1026:298b:c584%5]) with mapi id
 15.01.2308.015; Thu, 11 Nov 2021 13:19:19 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "cgel.zte@gmail.com" <cgel.zte@gmail.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "deng.changcheng@zte.com.cn" <deng.changcheng@zte.com.cn>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zeal Robot <zealci@zte.com.cn>
Subject: RE: [PATCH] rtw89: remove unneeded variable
Thread-Topic: [PATCH] rtw89: remove unneeded variable
Thread-Index: AQHX1iwllMhddv70KEieF6Y/ho4Aj6v9yu3w
Date:   Thu, 11 Nov 2021 05:19:19 +0000
Message-ID: <2b0fcb779baf49caa58a4e7134af45b1@realtek.com>
References: <20211110121135.151187-1-deng.changcheng@zte.com.cn>
In-Reply-To: <20211110121135.151187-1-deng.changcheng@zte.com.cn>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2021/11/11_=3F=3F_04:20:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36504.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 11/11/2021 05:04:36
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 167193 [Nov 11 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: pkshih@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 465 465 eb31509370142567679dd183ac984a0cb2ee3296
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: realtek.com:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 11/11/2021 05:07:00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: cgel.zte@gmail.com <cgel.zte@gmail.com>
> Sent: Wednesday, November 10, 2021 8:12 PM
> To: kvalo@codeaurora.org
> Cc: davem@davemloft.net; kuba@kernel.org; deng.changcheng@zte.com.cn; Pkshih <pkshih@realtek.com>;
> linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Zeal Robot
> <zealci@zte.com.cn>
> Subject: [PATCH] rtw89: remove unneeded variable
> 
> From: Changcheng Deng <deng.changcheng@zte.com.cn>
> 
> Fix the following coccicheck review:
> ./drivers/net/wireless/realtek/rtw89/mac.c: 1096: 5-8: Unneeded variable
> 
> Remove unneeded variable used to store return value.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Changcheng Deng <deng.changcheng@zte.com.cn>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>

> ---
>  drivers/net/wireless/realtek/rtw89/mac.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw89/mac.c b/drivers/net/wireless/realtek/rtw89/mac.c
> index 0171a5a7b1de..b93ac242b305 100644
> --- a/drivers/net/wireless/realtek/rtw89/mac.c
> +++ b/drivers/net/wireless/realtek/rtw89/mac.c
> @@ -1093,7 +1093,6 @@ static int cmac_func_en(struct rtw89_dev *rtwdev, u8 mac_idx, bool en)
>  static int dmac_func_en(struct rtw89_dev *rtwdev)
>  {
>  	u32 val32;
> -	u32 ret = 0;
> 
>  	val32 = (B_AX_MAC_FUNC_EN | B_AX_DMAC_FUNC_EN | B_AX_MAC_SEC_EN |
>  		 B_AX_DISPATCHER_EN | B_AX_DLE_CPUIO_EN | B_AX_PKT_IN_EN |
> @@ -1107,7 +1106,7 @@ static int dmac_func_en(struct rtw89_dev *rtwdev)
>  		 B_AX_WD_RLS_CLK_EN);
>  	rtw89_write32(rtwdev, R_AX_DMAC_CLK_EN, val32);
> 
> -	return ret;
> +	return 0;
>  }
> 
>  static int chip_func_en(struct rtw89_dev *rtwdev)
> --
> 2.25.1

