Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 199604EA16D
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 22:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344491AbiC1UZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 16:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344479AbiC1UZH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 16:25:07 -0400
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BCD01EAC6;
        Mon, 28 Mar 2022 13:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1648499006; x=1680035006;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ThsbKBussKR1IsuNjDkjqgFuF+bfP+1/CVYIaF3rgJA=;
  b=d//6fwVsRSfRosBTGisaEQTDRBS9FO/Xk4i5EDohOrJARZj+1HZ6UWhH
   z26Z7gsMMnb/NsVczgSU9qvBJGmIlj3lyXTBRInnrmIF/FPbUfS7Rz1bO
   sIbU6vn6Hx7Nk4i/XZEvs8oMVPROOww+1XuLQ16NmGPivbdReXUXkz9mO
   s=;
Received: from ironmsg-lv-alpha.qualcomm.com ([10.47.202.13])
  by alexa-out.qualcomm.com with ESMTP; 28 Mar 2022 13:23:24 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg-lv-alpha.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2022 13:23:08 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Mon, 28 Mar 2022 13:23:08 -0700
Received: from [10.110.35.108] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 28 Mar
 2022 13:23:07 -0700
Message-ID: <ff1ecd47-d42a-fa91-5c5c-e23ac183f525@quicinc.com>
Date:   Mon, 28 Mar 2022 13:23:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 19/22 v2] wcn36xx: Improve readability of
 wcn36xx_caps_name
Content-Language: en-US
To:     =?UTF-8?Q?Benjamin_St=c3=bcrz?= <benni@stuerz.xyz>
CC:     <loic.poulain@linaro.org>, Kalle Valo <kvalo@kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <wcn36xx@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20220326165909.506926-1-benni@stuerz.xyz>
 <20220326165909.506926-19-benni@stuerz.xyz>
 <f0ebc901-051a-c7fe-ca5a-bc798e7c31e7@quicinc.com>
 <720e4d68-683a-f729-f452-4a9e52a3c6fa@stuerz.xyz>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <720e4d68-683a-f729-f452-4a9e52a3c6fa@stuerz.xyz>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UPPERCASE_50_75
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(apologies for top-posting)
When you submit new patches you should not do so as a reply, but instead 
as a new thread with a new version number.

And since multiple folks have suggested that you submit on a 
per-subsystem basis I suggest that you re-send this as a singleton just 
to wcn36xx@lists.infradead.org and linux-wireless@vger.kernel.org along 
with the associated maintainers.

So I believe [PATCH v3] wcn36xx:... would be the correct subject, but 
I'm sure Kalle will let us know otherwise

On 3/28/2022 11:38 AM, Benjamin Stürz wrote:
> Make the array more readable and easier to maintain.
> 

Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>

> Signed-off-by: Benjamin Stürz <benni@stuerz.xyz>
> ---
>   drivers/net/wireless/ath/wcn36xx/main.c | 126 ++++++++++++------------
>   1 file changed, 65 insertions(+), 61 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/wcn36xx/main.c
> b/drivers/net/wireless/ath/wcn36xx/main.c
> index 95ea7d040d8c..ac9465dfae64 100644
> --- a/drivers/net/wireless/ath/wcn36xx/main.c
> +++ b/drivers/net/wireless/ath/wcn36xx/main.c
> @@ -192,70 +192,74 @@ static inline u8 get_sta_index(struct
> ieee80211_vif *vif,
>   	       sta_priv->sta_index;
>   }
> 

to be safe you may want an #undef here

> +#define DEFINE(s) [s] = #s
> +
>   static const char * const wcn36xx_caps_names[] = {
> -	"MCC",				/* 0 */
> -	"P2P",				/* 1 */
> -	"DOT11AC",			/* 2 */
> -	"SLM_SESSIONIZATION",		/* 3 */
> -	"DOT11AC_OPMODE",		/* 4 */
> -	"SAP32STA",			/* 5 */
> -	"TDLS",				/* 6 */
> -	"P2P_GO_NOA_DECOUPLE_INIT_SCAN",/* 7 */
> -	"WLANACTIVE_OFFLOAD",		/* 8 */
> -	"BEACON_OFFLOAD",		/* 9 */
> -	"SCAN_OFFLOAD",			/* 10 */
> -	"ROAM_OFFLOAD",			/* 11 */
> -	"BCN_MISS_OFFLOAD",		/* 12 */
> -	"STA_POWERSAVE",		/* 13 */
> -	"STA_ADVANCED_PWRSAVE",		/* 14 */
> -	"AP_UAPSD",			/* 15 */
> -	"AP_DFS",			/* 16 */
> -	"BLOCKACK",			/* 17 */
> -	"PHY_ERR",			/* 18 */
> -	"BCN_FILTER",			/* 19 */
> -	"RTT",				/* 20 */
> -	"RATECTRL",			/* 21 */
> -	"WOW",				/* 22 */
> -	"WLAN_ROAM_SCAN_OFFLOAD",	/* 23 */
> -	"SPECULATIVE_PS_POLL",		/* 24 */
> -	"SCAN_SCH",			/* 25 */
> -	"IBSS_HEARTBEAT_OFFLOAD",	/* 26 */
> -	"WLAN_SCAN_OFFLOAD",		/* 27 */
> -	"WLAN_PERIODIC_TX_PTRN",	/* 28 */
> -	"ADVANCE_TDLS",			/* 29 */
> -	"BATCH_SCAN",			/* 30 */
> -	"FW_IN_TX_PATH",		/* 31 */
> -	"EXTENDED_NSOFFLOAD_SLOT",	/* 32 */
> -	"CH_SWITCH_V1",			/* 33 */
> -	"HT40_OBSS_SCAN",		/* 34 */
> -	"UPDATE_CHANNEL_LIST",		/* 35 */
> -	"WLAN_MCADDR_FLT",		/* 36 */
> -	"WLAN_CH144",			/* 37 */
> -	"NAN",				/* 38 */
> -	"TDLS_SCAN_COEXISTENCE",	/* 39 */
> -	"LINK_LAYER_STATS_MEAS",	/* 40 */
> -	"MU_MIMO",			/* 41 */
> -	"EXTENDED_SCAN",		/* 42 */
> -	"DYNAMIC_WMM_PS",		/* 43 */
> -	"MAC_SPOOFED_SCAN",		/* 44 */
> -	"BMU_ERROR_GENERIC_RECOVERY",	/* 45 */
> -	"DISA",				/* 46 */
> -	"FW_STATS",			/* 47 */
> -	"WPS_PRBRSP_TMPL",		/* 48 */
> -	"BCN_IE_FLT_DELTA",		/* 49 */
> -	"TDLS_OFF_CHANNEL",		/* 51 */
> -	"RTT3",				/* 52 */
> -	"MGMT_FRAME_LOGGING",		/* 53 */
> -	"ENHANCED_TXBD_COMPLETION",	/* 54 */
> -	"LOGGING_ENHANCEMENT",		/* 55 */
> -	"EXT_SCAN_ENHANCED",		/* 56 */
> -	"MEMORY_DUMP_SUPPORTED",	/* 57 */
> -	"PER_PKT_STATS_SUPPORTED",	/* 58 */
> -	"EXT_LL_STAT",			/* 60 */
> -	"WIFI_CONFIG",			/* 61 */
> -	"ANTENNA_DIVERSITY_SELECTION",	/* 62 */
> +	DEFINE(MCC),
> +	DEFINE(P2P),
> +	DEFINE(DOT11AC),
> +	DEFINE(SLM_SESSIONIZATION),
> +	DEFINE(DOT11AC_OPMODE),
> +	DEFINE(SAP32STA),
> +	DEFINE(TDLS),
> +	DEFINE(P2P_GO_NOA_DECOUPLE_INIT_SCAN),
> +	DEFINE(WLANACTIVE_OFFLOAD),
> +	DEFINE(BEACON_OFFLOAD),
> +	DEFINE(SCAN_OFFLOAD),
> +	DEFINE(ROAM_OFFLOAD),
> +	DEFINE(BCN_MISS_OFFLOAD),
> +	DEFINE(STA_POWERSAVE),
> +	DEFINE(STA_ADVANCED_PWRSAVE),
> +	DEFINE(AP_UAPSD),
> +	DEFINE(AP_DFS),
> +	DEFINE(BLOCKACK),
> +	DEFINE(PHY_ERR),
> +	DEFINE(BCN_FILTER),
> +	DEFINE(RTT),
> +	DEFINE(RATECTRL),
> +	DEFINE(WOW),
> +	DEFINE(WLAN_ROAM_SCAN_OFFLOAD),
> +	DEFINE(SPECULATIVE_PS_POLL),
> +	DEFINE(SCAN_SCH),
> +	DEFINE(IBSS_HEARTBEAT_OFFLOAD),
> +	DEFINE(WLAN_SCAN_OFFLOAD),
> +	DEFINE(WLAN_PERIODIC_TX_PTRN),
> +	DEFINE(ADVANCE_TDLS),
> +	DEFINE(BATCH_SCAN),
> +	DEFINE(FW_IN_TX_PATH),
> +	DEFINE(EXTENDED_NSOFFLOAD_SLOT),
> +	DEFINE(CH_SWITCH_V1),
> +	DEFINE(HT40_OBSS_SCAN),
> +	DEFINE(UPDATE_CHANNEL_LIST),
> +	DEFINE(WLAN_MCADDR_FLT),
> +	DEFINE(WLAN_CH144),
> +	DEFINE(NAN),
> +	DEFINE(TDLS_SCAN_COEXISTENCE),
> +	DEFINE(LINK_LAYER_STATS_MEAS),
> +	DEFINE(MU_MIMO),
> +	DEFINE(EXTENDED_SCAN),
> +	DEFINE(DYNAMIC_WMM_PS),
> +	DEFINE(MAC_SPOOFED_SCAN),
> +	DEFINE(BMU_ERROR_GENERIC_RECOVERY),
> +	DEFINE(DISA),
> +	DEFINE(FW_STATS),
> +	DEFINE(WPS_PRBRSP_TMPL),
> +	DEFINE(BCN_IE_FLT_DELTA),
> +	DEFINE(TDLS_OFF_CHANNEL),
> +	DEFINE(RTT3),
> +	DEFINE(MGMT_FRAME_LOGGING),
> +	DEFINE(ENHANCED_TXBD_COMPLETION),
> +	DEFINE(LOGGING_ENHANCEMENT),
> +	DEFINE(EXT_SCAN_ENHANCED),
> +	DEFINE(MEMORY_DUMP_SUPPORTED),
> +	DEFINE(PER_PKT_STATS_SUPPORTED),
> +	DEFINE(EXT_LL_STAT),
> +	DEFINE(WIFI_CONFIG),
> +	DEFINE(ANTENNA_DIVERSITY_SELECTION),
>   };
> 
> +#undef DEFINE
> +
>   static const char *wcn36xx_get_cap_name(enum place_holder_in_cap_bitmap x)
>   {
>   	if (x >= ARRAY_SIZE(wcn36xx_caps_names))
