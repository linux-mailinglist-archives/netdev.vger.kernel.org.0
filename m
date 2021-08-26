Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E19803F7F8F
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 02:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235440AbhHZA7q convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 25 Aug 2021 20:59:46 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:47535 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234396AbhHZA7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 20:59:43 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 17Q0wERN1006279, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36501.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 17Q0wERN1006279
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 26 Aug 2021 08:58:15 +0800
Received: from RTEXDAG02.realtek.com.tw (172.21.6.101) by
 RTEXH36501.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 26 Aug 2021 08:58:14 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG02.realtek.com.tw (172.21.6.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 26 Aug 2021 08:58:13 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::cdd5:82a3:e854:7098]) by
 RTEXMBS04.realtek.com.tw ([fe80::cdd5:82a3:e854:7098%5]) with mapi id
 15.01.2106.013; Thu, 26 Aug 2021 08:58:13 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Kees Cook <keescook@chromium.org>
CC:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Colin Ian King <colin.king@canonical.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joe Perches <joe@perches.com>,
        Kaixu Xia <kaixuxia@tencent.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
Subject: RE: [PATCH] rtlwifi: rtl8192de: Style clean-ups
Thread-Topic: [PATCH] rtlwifi: rtl8192de: Style clean-ups
Thread-Index: AQHXmd/DHYB2maO/lkCxyh94iMiVM6uE9bHg
Date:   Thu, 26 Aug 2021 00:58:13 +0000
Message-ID: <3e0b0efc0c0142bbb79cb11f927967bb@realtek.com>
References: <20210825183350.1145441-1-keescook@chromium.org>
In-Reply-To: <20210825183350.1145441-1-keescook@chromium.org>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.146]
x-kse-serverinfo: RTEXDAG02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2021/8/25_=3F=3F_08:00:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36501.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 08/26/2021 00:43:02
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 165781 [Aug 25 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: pkshih@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 457 457 f9912fc467375383fbac52a53ade5bbe1c769e2a
X-KSE-AntiSpam-Info: {Tracking_uf_ne_domains}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: realtek.com:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 08/26/2021 00:46:00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Kees Cook [mailto:keescook@chromium.org]
> Sent: Thursday, August 26, 2021 2:34 AM
> To: Pkshih
> Cc: Kees Cook; Kalle Valo; David S. Miller; Jakub Kicinski; Larry Finger; Colin Ian King;
> linux-wireless@vger.kernel.org; netdev@vger.kernel.org; Joe Perches; Kaixu Xia;
> linux-kernel@vger.kernel.org; linux-hardening@vger.kernel.org
> Subject: [PATCH] rtlwifi: rtl8192de: Style clean-ups
> 
> Clean up some style issues:
> - Use ARRAY_SIZE() even though it's a u8 array.
> - Remove redundant CHANNEL_MAX_NUMBER_2G define.
> Additionally fix some dead code WARNs.
> 
> Cc: Ping-Ke Shih <pkshih@realtek.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Colin Ian King <colin.king@canonical.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c | 8 +++-----
>  drivers/net/wireless/realtek/rtlwifi/wifi.h          | 1 -
>  2 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
> b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
> index b32fa7a75f17..9807c9e91998 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
> @@ -899,7 +899,7 @@ static u8 _rtl92c_phy_get_rightchnlplace(u8 chnl)
>  	u8 place = chnl;
> 
>  	if (chnl > 14) {
> -		for (place = 14; place < sizeof(channel5g); place++) {
> +		for (place = 14; place < ARRAY_SIZE(channel5g); place++) {

There are still many places we can use ARRAY_SIZE() instead of sizeof().
Could you fix them within this file, even this driver?
Otherwise, this patch looks good to me.

Acked-by: Ping-Ke Shih <pkshih@realtek.com>

>  			if (channel5g[place] == chnl) {
>  				place++;
>  				break;
> @@ -2861,16 +2861,14 @@ u8 rtl92d_phy_sw_chnl(struct ieee80211_hw *hw)
>  	case BAND_ON_5G:
>  		/* Get first channel error when change between
>  		 * 5G and 2.4G band. */
> -		if (channel <= 14)
> +		if (WARN_ONCE(channel <= 14, "rtl8192de: 5G but channel<=14\n"))
>  			return 0;
> -		WARN_ONCE((channel <= 14), "rtl8192de: 5G but channel<=14\n");
>  		break;
>  	case BAND_ON_2_4G:
>  		/* Get first channel error when change between
>  		 * 5G and 2.4G band. */
> -		if (channel > 14)
> +		if (WARN_ONCE(channel > 14, "rtl8192de: 2G but channel>14\n"))
>  			return 0;
> -		WARN_ONCE((channel > 14), "rtl8192de: 2G but channel>14\n");
>  		break;
>  	default:
>  		WARN_ONCE(true, "rtl8192de: Invalid WirelessMode(%#x)!!\n",
> diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h
> b/drivers/net/wireless/realtek/rtlwifi/wifi.h
> index aa07856411b1..31f9e9e5c680 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
> +++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
> @@ -108,7 +108,6 @@
>  #define	CHANNEL_GROUP_IDX_5GM		6
>  #define	CHANNEL_GROUP_IDX_5GH		9
>  #define	CHANNEL_GROUP_MAX_5G		9
> -#define CHANNEL_MAX_NUMBER_2G		14
>  #define AVG_THERMAL_NUM			8
>  #define AVG_THERMAL_NUM_88E		4
>  #define AVG_THERMAL_NUM_8723BE		4
> --
> 2.30.2

