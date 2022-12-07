Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6D126450B4
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 02:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiLGBGb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 6 Dec 2022 20:06:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiLGBGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 20:06:30 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 36F0ADFA5;
        Tue,  6 Dec 2022 17:06:28 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2B715DEH0016408, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2B715DEH0016408
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Wed, 7 Dec 2022 09:05:13 +0800
Received: from RTEXMBS05.realtek.com.tw (172.21.6.98) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.9; Wed, 7 Dec 2022 09:06:00 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS05.realtek.com.tw (172.21.6.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Wed, 7 Dec 2022 09:06:00 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Wed, 7 Dec 2022 09:06:00 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Peter Kosyh <pkosyh@yandex.ru>
CC:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
Subject: RE: [PATCH] rtlwifi: btcoexist: fix conditions branches that are never executed
Thread-Topic: [PATCH] rtlwifi: btcoexist: fix conditions branches that are
 never executed
Thread-Index: AQHZCWBsVE1fupnf1UyGMvz9xEveQ65hmHsA
Date:   Wed, 7 Dec 2022 01:06:00 +0000
Message-ID: <76613dd5c4154c24bb53efd2551dd33c@realtek.com>
References: <20221206104919.739746-1-pkosyh@yandex.ru>
In-Reply-To: <20221206104919.739746-1-pkosyh@yandex.ru>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS05.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/12/6_=3F=3F_10:14:00?=
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
> From: Peter Kosyh <pkosyh@yandex.ru>
> Sent: Tuesday, December 6, 2022 6:49 PM
> To: Ping-Ke Shih <pkshih@realtek.com>
> Cc: Peter Kosyh <pkosyh@yandex.ru>; Kalle Valo <kvalo@kernel.org>; David S. Miller <davem@davemloft.net>;
> Eric Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; linux-wireless@vger.kernel.org;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; lvc-project@linuxtesting.org
> Subject: [PATCH] rtlwifi: btcoexist: fix conditions branches that are never executed
> 
> Commit 40ca18823515 ("rtlwifi: btcoex: 23b 1ant: fine tune for wifi not
>  connected") introduced never executed branches.
> 
> Compile test only.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Signed-off-by: Peter Kosyh <pkosyh@yandex.ru>

I compare with vendor driver and confirm these changes are correct.
Thank you.

Acked-by: Ping-Ke Shih <pkshih@realtek.com>


> ---
> I'm not sure that patch do right thing! But these two places are really
> never executed and should be fixed. I hope that Ping-Ka could check this.
> 
>  .../net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
> b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
> index 70492929d7e4..039bbedb41c2 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
> @@ -1903,7 +1903,7 @@ btc8723b1ant_action_wifi_not_conn_scan(struct btc_coexist *btcoexist)
>  						true, 32);
>  			halbtc8723b1ant_coex_table_with_type(btcoexist,
>  							     NORMAL_EXEC, 4);
> -		} else if (bt_link_info->a2dp_exist) {
> +		} else if (bt_link_info->pan_exist) {
>  			halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
>  						true, 22);
>  			halbtc8723b1ant_coex_table_with_type(btcoexist,
> @@ -1964,8 +1964,7 @@ static void btc8723b1ant_action_wifi_conn_scan(struct btc_coexist *btcoexist)
>  						true, 32);
>  			halbtc8723b1ant_coex_table_with_type(btcoexist,
>  							     NORMAL_EXEC, 4);
> -		} else if (bt_link_info->a2dp_exist &&
> -			   bt_link_info->pan_exist) {
> +		} else if (bt_link_info->pan_exist) {
>  			halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
>  						true, 22);
>  			halbtc8723b1ant_coex_table_with_type(btcoexist,
> --
> 2.38.1

