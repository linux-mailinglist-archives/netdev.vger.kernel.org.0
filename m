Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFBD6A7856
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 01:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbjCBAYO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 1 Mar 2023 19:24:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjCBAYN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 19:24:13 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C801B2E5;
        Wed,  1 Mar 2023 16:24:11 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 3220NcIhA001350, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 3220NcIhA001350
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Thu, 2 Mar 2023 08:23:38 +0800
Received: from RTEXMBS05.realtek.com.tw (172.21.6.98) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Thu, 2 Mar 2023 08:23:04 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS05.realtek.com.tw (172.21.6.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Thu, 2 Mar 2023 08:23:03 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02]) by
 RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02%5]) with mapi id
 15.01.2375.007; Thu, 2 Mar 2023 08:23:03 +0800
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
Subject: RE: [PATCH v2] rtlwifi: rtl8192se: Remove some unused variables
Thread-Topic: [PATCH v2] rtlwifi: rtl8192se: Remove some unused variables
Thread-Index: AQHZS+rSpy19DpHS5UeAkzV39mTD+67mocvQ
Date:   Thu, 2 Mar 2023 00:23:03 +0000
Message-ID: <cd3987d9c17d416aafd5f0fb0fae7a27@realtek.com>
References: <20230301030534.2102-1-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <20230301030534.2102-1-jiapeng.chong@linux.alibaba.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS05.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2023/3/1_=3F=3F_10:37:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
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
> Sent: Wednesday, March 1, 2023 11:06 AM
> To: Ping-Ke Shih <pkshih@realtek.com>
> Cc: kvalo@kernel.org; davem@davemloft.net; edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
> linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Jiapeng Chong
> <jiapeng.chong@linux.alibaba.com>; Abaci Robot <abaci@linux.alibaba.com>
> Subject: [PATCH v2] rtlwifi: rtl8192se: Remove some unused variables

Miss subject prefix "wifi: ".

> 
> Variable bcntime_cfg, bcn_cw and bcn_ifs are not effectively used, so
> delete it.
> 
> drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c:1555:6: warning:
> variable 'bcntime_cfg' set but not used.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4240
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>


> ---
> Changes in v2:
>   -Remove bcn_cw and bcn_ifs.
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

