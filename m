Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69F0D5307BB
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 04:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352927AbiEWCgM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 22 May 2022 22:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353053AbiEWCgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 22:36:05 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF3DB5FBB;
        Sun, 22 May 2022 19:36:03 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 24N2ZW5i8020887, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 24N2ZW5i8020887
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 23 May 2022 10:35:32 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 23 May 2022 10:35:32 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 23 May 2022 10:35:32 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::34e7:ab63:3da4:27c6]) by
 RTEXMBS04.realtek.com.tw ([fe80::34e7:ab63:3da4:27c6%5]) with mapi id
 15.01.2308.021; Mon, 23 May 2022 10:35:32 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "colin.king@intel.com" <colin.king@intel.com>
Subject: RE: [PATCH net-next 3/8] wifi: rtlwifi: remove always-true condition pointed out by GCC 12
Thread-Topic: [PATCH net-next 3/8] wifi: rtlwifi: remove always-true condition
 pointed out by GCC 12
Thread-Index: AQHYbIHjnrV5IT1AtUasPUOuHqV18a0rwWxw
Date:   Mon, 23 May 2022 02:35:32 +0000
Message-ID: <8fb9d491692a4a2dabe783ffefc76ded@realtek.com>
References: <20220520194320.2356236-1-kuba@kernel.org>
 <20220520194320.2356236-4-kuba@kernel.org>
In-Reply-To: <20220520194320.2356236-4-kuba@kernel.org>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS04.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/5/23_=3F=3F_12:07:00?=
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
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Saturday, May 21, 2022 3:43 AM
> To: kvalo@kernel.org; johannes@sipsolutions.net
> Cc: netdev@vger.kernel.org; linux-wireless@vger.kernel.org; Jakub Kicinski <kuba@kernel.org>; Pkshih
> <pkshih@realtek.com>; keescook@chromium.org; colin.king@intel.com
> Subject: [PATCH net-next 3/8] wifi: rtlwifi: remove always-true condition pointed out by GCC 12
> 
> The .value is a two-dim array, not a pointer.
> 
> struct iqk_matrix_regs {
> 	bool iqk_done;
>         long value[1][IQK_MATRIX_REG_NUM];
> };
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: pkshih@realtek.com
> CC: kvalo@kernel.org
> CC: keescook@chromium.org
> CC: colin.king@intel.com
> CC: linux-wireless@vger.kernel.org
> ---
>  drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
> b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
> index 51fe51bb0504..15e6a6aded31 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
> @@ -2386,10 +2386,7 @@ void rtl92d_phy_reload_iqk_setting(struct ieee80211_hw *hw, u8 channel)
>  			rtl_dbg(rtlpriv, COMP_SCAN, DBG_LOUD,
>  				"Just Read IQK Matrix reg for channel:%d....\n",
>  				channel);
> -			if ((rtlphy->iqk_matrix[indexforchannel].
> -			     value[0] != NULL)

This is a typo since initial commit. Correct it by
-			     value[0] != NULL)
+			     value[0][0] != 0)

So, NACK this patch.

--
Ping-Ke

