Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8664D6A7980
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 03:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbjCBCa0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 1 Mar 2023 21:30:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjCBCaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 21:30:25 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A7A515E7;
        Wed,  1 Mar 2023 18:30:21 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 3222TfLvA015735, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 3222TfLvA015735
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Thu, 2 Mar 2023 10:29:41 +0800
Received: from RTEXDAG01.realtek.com.tw (172.21.6.100) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Thu, 2 Mar 2023 10:29:48 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG01.realtek.com.tw (172.21.6.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Thu, 2 Mar 2023 10:29:48 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02]) by
 RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02%5]) with mapi id
 15.01.2375.007; Thu, 2 Mar 2023 10:29:48 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
CC:     "kvalo@kernel.org" <kvalo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: RE: [PATCH v3] wifi: rtl8192se: Remove some unused variables
Thread-Topic: [PATCH v3] wifi: rtl8192se: Remove some unused variables
Thread-Index: AQHZTK101MBs6ayKpUm4YIb/EX9OZq7mxBcA
Date:   Thu, 2 Mar 2023 02:29:47 +0000
Message-ID: <af7fd28b95a348c9a12970be96ac8279@realtek.com>
References: <20230302021813.30349-1-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <20230302021813.30349-1-jiapeng.chong@linux.alibaba.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXDAG01.realtek.com.tw, 9
x-kse-antispam-interceptor-info: fallback
x-kse-antivirus-interceptor-info: fallback
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> Sent: Thursday, March 2, 2023 10:18 AM
> To: Ping-Ke Shih <pkshih@realtek.com>
> Cc: kvalo@kernel.org; davem@davemloft.net; edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
> linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Jiapeng Chong
> <jiapeng.chong@linux.alibaba.com>; Abaci Robot <abaci@linux.alibaba.com>
> Subject: [PATCH v3] wifi: rtl8192se: Remove some unused variables

It should be 
"wifi: rtlwifi: rtl8192se: ..."

> 
> Variable bcntime_cfg, bcn_cw and bcn_ifs are not effectively used, so
> delete it.
> 
> drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c:1555:6: warning: variable 'bcntime_cfg' set but not
> used.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4240
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
> Changes in v3:
>   -Change the subject.
> 
>  drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c | 9 ---------
>  1 file changed, 9 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
> b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
> index bd0b7e365edb..a8b5bf45b1bb 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
> @@ -1552,8 +1552,6 @@ void rtl92se_set_beacon_related_registers(struct ieee80211_hw *hw)
>  {
>         struct rtl_priv *rtlpriv = rtl_priv(hw);
>         struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
> -       u16 bcntime_cfg = 0;
> -       u16 bcn_cw = 6, bcn_ifs = 0xf;
>         u16 atim_window = 2;
> 
>         /* ATIM Window (in unit of TU). */
> @@ -1576,13 +1574,6 @@ void rtl92se_set_beacon_related_registers(struct ieee80211_hw *hw)
>          * other ad hoc STA */
>         rtl_write_byte(rtlpriv, BCN_ERR_THRESH, 100);
> 
> -       /* Beacon Time Configuration */
> -       if (mac->opmode == NL80211_IFTYPE_ADHOC)
> -               bcntime_cfg |= (bcn_cw << BCN_TCFG_CW_SHIFT);
> -
> -       /* TODO: bcn_ifs may required to be changed on ASIC */
> -       bcntime_cfg |= bcn_ifs << BCN_TCFG_IFS;
> -
>         /*for beacon changed */
>         rtl92s_phy_set_beacon_hwreg(hw, mac->beacon_interval);
>  }
> --
> 2.20.1.7.g153144c

