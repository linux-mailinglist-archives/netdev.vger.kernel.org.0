Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD5D5643B21
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 03:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233637AbiLFCCo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 5 Dec 2022 21:02:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbiLFCCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 21:02:42 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A7646103E;
        Mon,  5 Dec 2022 18:02:37 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2B621C0L0016505, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2B621C0L0016505
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Tue, 6 Dec 2022 10:01:12 +0800
Received: from RTEXMBS02.realtek.com.tw (172.21.6.95) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Tue, 6 Dec 2022 10:01:59 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS02.realtek.com.tw (172.21.6.95) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Tue, 6 Dec 2022 10:01:59 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Tue, 6 Dec 2022 10:01:59 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Peter Kosyh <pkosyh@yandex.ru>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Kalle Valo <kvalo@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
Subject: RE: [PATCH] rtlwifi: rtl8192se: remove redundant rtl_get_bbreg call
Thread-Topic: [PATCH] rtlwifi: rtl8192se: remove redundant rtl_get_bbreg call
Thread-Index: AQHZCIlNZy/RMGZSW0e7asaR+s5GG65gGCIQ
Date:   Tue, 6 Dec 2022 02:01:58 +0000
Message-ID: <cf3d07ff543d4c009dbf51ad7a4d4b21@realtek.com>
References: <20221205085342.677329-1-pkosyh@yandex.ru>
In-Reply-To: <20221205085342.677329-1-pkosyh@yandex.ru>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/12/5_=3F=3F_10:48:00?=
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
> From: Peter Kosyh <pkosyh@yandex.ru>
> Sent: Monday, December 5, 2022 4:54 PM
> To: Ping-Ke Shih <pkshih@realtek.com>
> Cc: Peter Kosyh <pkosyh@yandex.ru>; David S. Miller <davem@davemloft.net>; Eric Dumazet
> <edumazet@google.com>; Kalle Valo <kvalo@kernel.org>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> <pabeni@redhat.com>; linux-wireless@vger.kernel.org; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org; lvc-project@linuxtesting.org
> Subject: [PATCH] rtlwifi: rtl8192se: remove redundant rtl_get_bbreg call
> 
> Extra rtl_get_bbreg looks like redundant reading. The read has
> already been done in the "else" branch. Compile test only.

Originally, the code is 

01 if (rfpi_enable)
02     val = get_from_interface_A();
03 else
04    val = get_from_interface_B();
05
06 val = get_from_interface_B();

This patch is to remove line 06, and it looks like logic is changed. However,
'rfpi_enable' is decided by 0x820[8] and 0x828[8] set by rtl8192sephy_reg_2t2rarray[]
table, and 'rfpi_enable' is always false. I think this is why nobody can't
encounter problem and find this bug.

> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Signed-off-by: Peter Kosyh <pkosyh@yandex.ru>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>

> ---
> If this code is important for the operation of the hardware, then it would
> be nice to comment on it.
> 
>  drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c
> b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c
> index aaa004d4d6d0..09591a0b5a81 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c
> @@ -115,9 +115,6 @@ static u32 _rtl92s_phy_rf_serial_read(struct ieee80211_hw *hw,
>  		retvalue = rtl_get_bbreg(hw, pphyreg->rf_rb,
>  					 BLSSI_READBACK_DATA);
> 
> -	retvalue = rtl_get_bbreg(hw, pphyreg->rf_rb,
> -				 BLSSI_READBACK_DATA);
> -
>  	rtl_dbg(rtlpriv, COMP_RF, DBG_TRACE, "RFR-%d Addr[0x%x]=0x%x\n",
>  		rfpath, pphyreg->rf_rb, retvalue);
> 
> --
> 2.38.1

