Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8837E658AED
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 10:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232990AbiL2JZa convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 29 Dec 2022 04:25:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiL2JZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 04:25:29 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E39AFFD00;
        Thu, 29 Dec 2022 01:25:24 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2BT9NxtqE021772, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2BT9NxtqE021772
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Thu, 29 Dec 2022 17:23:59 +0800
Received: from RTEXDAG02.realtek.com.tw (172.21.6.101) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.9; Thu, 29 Dec 2022 17:24:53 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG02.realtek.com.tw (172.21.6.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Thu, 29 Dec 2022 17:24:52 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Thu, 29 Dec 2022 17:24:52 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "tehuang@realtek.com" <tehuang@realtek.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/4] rtw88: Add packed attribute to the eFuse structs
Thread-Topic: [PATCH 1/4] rtw88: Add packed attribute to the eFuse structs
Thread-Index: AQHZGsFtJHlbRNsmYUOpTa0F4ufSPq6EmMng
Date:   Thu, 29 Dec 2022 09:24:52 +0000
Message-ID: <92eb7dfa8b7d447e966a2751e174b642@realtek.com>
References: <20221228133547.633797-1-martin.blumenstingl@googlemail.com>
 <20221228133547.633797-2-martin.blumenstingl@googlemail.com>
In-Reply-To: <20221228133547.633797-2-martin.blumenstingl@googlemail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXDAG02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/12/29_=3F=3F_07:25:00?=
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
> From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Sent: Wednesday, December 28, 2022 9:36 PM
> To: linux-wireless@vger.kernel.org
> Cc: tony0620emma@gmail.com; kvalo@kernel.org; Ping-Ke Shih <pkshih@realtek.com>; tehuang@realtek.com;
> s.hauer@pengutronix.de; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Martin Blumenstingl
> <martin.blumenstingl@googlemail.com>
> Subject: [PATCH 1/4] rtw88: Add packed attribute to the eFuse structs
> 
> The eFuse definitions in the rtw88 are using structs to describe the
> eFuse contents. Add the packed attribute to all structs used for the
> eFuse description so the compiler doesn't add gaps or re-order
> attributes.
> 
> Also change the type of the res2..res3 eFuse fields to u16 to avoid the
> following warning, now that their surrounding struct has the packed
> attribute:
>   note: offset of packed bit-field 'res2' has changed in GCC 4.4
> 
> Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
> Fixes: ab0a031ecf29 ("rtw88: 8723d: Add read_efuse to recognize efuse info from map")
> Fixes: 769a29ce2af4 ("rtw88: 8821c: add basic functions")
> Fixes: 87caeef032fc ("wifi: rtw88: Add rtw8723du chipset support")
> Fixes: aff5ffd718de ("wifi: rtw88: Add rtw8821cu chipset support")
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
>  drivers/net/wireless/realtek/rtw88/main.h     |  6 +++---
>  drivers/net/wireless/realtek/rtw88/rtw8723d.h |  6 +++---
>  drivers/net/wireless/realtek/rtw88/rtw8821c.h | 20 +++++++++----------
>  drivers/net/wireless/realtek/rtw88/rtw8822b.h | 20 +++++++++----------
>  drivers/net/wireless/realtek/rtw88/rtw8822c.h | 20 +++++++++----------
>  5 files changed, 36 insertions(+), 36 deletions(-)
> 

[...]

> @@ -43,13 +43,13 @@ struct rtw8821ce_efuse {
>  	u8 link_cap[4];
>  	u8 link_control[2];
>  	u8 serial_number[8];
> -	u8 res0:2;			/* 0xf4 */
> -	u8 ltr_en:1;
> -	u8 res1:2;
> -	u8 obff:2;
> -	u8 res2:3;
> -	u8 obff_cap:2;
> -	u8 res3:4;
> +	u16 res0:2;			/* 0xf4 */
> +	u16 ltr_en:1;
> +	u16 res1:2;
> +	u16 obff:2;
> +	u16 res2:3;
> +	u16 obff_cap:2;
> +	u16 res3:4;

These should be __le16. Though bit fields are suitable to efuse layout, 
we don't access these fields for now. It would be well.

[...]

