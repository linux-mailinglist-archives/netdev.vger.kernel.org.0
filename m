Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 533AE435A4C
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 07:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbhJUFYv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 21 Oct 2021 01:24:51 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:45248 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbhJUFYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 01:24:50 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 19L5MFg34020726, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36503.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 19L5MFg34020726
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 21 Oct 2021 13:22:15 +0800
Received: from RTEXMBS02.realtek.com.tw (172.21.6.95) by
 RTEXH36503.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 21 Oct 2021 13:22:15 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS02.realtek.com.tw (172.21.6.95) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Thu, 21 Oct 2021 13:22:14 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::dc53:1026:298b:c584]) by
 RTEXMBS04.realtek.com.tw ([fe80::dc53:1026:298b:c584%5]) with mapi id
 15.01.2308.015; Thu, 21 Oct 2021 13:22:14 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "cgel.zte@gmail.com" <cgel.zte@gmail.com>
CC:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lv Ruyi <lv.ruyi@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>
Subject: RE: [PATCH V2] rtw89: fix error function parameter
Thread-Topic: [PATCH V2] rtw89: fix error function parameter
Thread-Index: AQHXxjMeRRjTNVoE9kuuBjc0ZANcEavc6bvQ
Date:   Thu, 21 Oct 2021 05:22:14 +0000
Message-ID: <e5dfff36092b4caaaa85610baf64f295@realtek.com>
References: <3e121f8f6dd4411eace22a7030824ce4@realtek.com>
 <20211021042035.1042463-1-lv.ruyi@zte.com.cn>
In-Reply-To: <20211021042035.1042463-1-lv.ruyi@zte.com.cn>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2021/10/21_=3F=3F_03:10:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36503.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 10/21/2021 05:01:20
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 166865 [Oct 20 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: pkshih@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 463 463 5854868460de3f0d8e8c0a4df98aeb05fb764a09
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: realtek.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 10/21/2021 05:04:00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: cgel.zte@gmail.com <cgel.zte@gmail.com>
> Sent: Thursday, October 21, 2021 12:21 PM
> To: Pkshih <pkshih@realtek.com>
> Cc: kvalo@codeaurora.org; davem@davemloft.net; kuba@kernel.org; linux-wireless@vger.kernel.org;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Lv Ruyi <lv.ruyi@zte.com.cn>; Zeal Robot
> <zealci@zte.com.cn>
> Subject: [PATCH V2] rtw89: fix error function parameter
> 
> From: Lv Ruyi <lv.ruyi@zte.com.cn>
> 
> This patch fixes the following Coccinelle warning:
> drivers/net/wireless/realtek/rtw89/rtw8852a.c:753:
> WARNING  possible condition with no effect (if == else)
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>

I think you can say something about the changes of v2 followed by '---', like

---
v2: fix tabs are converted to spaces

> ---
>  drivers/net/wireless/realtek/rtw89/rtw8852a.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852a.c
> b/drivers/net/wireless/realtek/rtw89/rtw8852a.c
> index b1b87f0aadbb..5c6ffca3a324 100644
> --- a/drivers/net/wireless/realtek/rtw89/rtw8852a.c
> +++ b/drivers/net/wireless/realtek/rtw89/rtw8852a.c
> @@ -757,7 +757,7 @@ static void rtw8852a_ctrl_ch(struct rtw89_dev *rtwdev, u8 central_ch,
>  		else
  ^^^^^^
I have confirmed this is a tab.

>  			rtw89_phy_write32_idx(rtwdev, R_P1_MODE,
>  					      B_P1_MODE_SEL,
> -					      1, phy_idx);
> +					      0, phy_idx);
>  		/* SCO compensate FC setting */
>  		sco_comp = rtw8852a_sco_mapping(central_ch);
>  		rtw89_phy_write32_idx(rtwdev, R_FC0_BW, B_FC0_BW_INV,
> --
> 2.25.1

