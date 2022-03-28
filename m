Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAD194E9C11
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 18:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241816AbiC1QTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 12:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241774AbiC1QT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 12:19:27 -0400
Received: from alexa-out-sd-01.qualcomm.com (alexa-out-sd-01.qualcomm.com [199.106.114.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00E23E5DC;
        Mon, 28 Mar 2022 09:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1648484267; x=1680020267;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Eu7nJy5jkPS6ql5ANPoXUckpfZ6g40U1vF2Yo2ODg4c=;
  b=lWeb1oJMQ0HozGS+eGbIRSBM70ecG0kNOWkFHmOM/8VfoOy75JCLoOb4
   d47bbHtIXAkYOjAlBNW0AoXXVcWbG5tVN29cajuIQEVQ8nwDfHSXvscLI
   8mEC8S3Z/VJIDvO+2/MEaYOobW+KYXjxtQ5n5Wam2hweqmslucbf1Rpki
   4=;
Received: from unknown (HELO ironmsg05-sd.qualcomm.com) ([10.53.140.145])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 28 Mar 2022 09:17:46 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg05-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2022 09:17:44 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Mon, 28 Mar 2022 09:17:44 -0700
Received: from [10.110.35.108] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 28 Mar
 2022 09:17:41 -0700
Message-ID: <f0ebc901-051a-c7fe-ca5a-bc798e7c31e7@quicinc.com>
Date:   Mon, 28 Mar 2022 09:17:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 19/22] wnc36xx: Replace comments with C99 initializers
Content-Language: en-US
To:     =?UTF-8?Q?Benjamin_St=c3=bcrz?= <benni@stuerz.xyz>,
        <andrew@lunn.ch>
CC:     <sebastian.hesselbarth@gmail.com>, <gregory.clement@bootlin.com>,
        <linux@armlinux.org.uk>, <linux@simtec.co.uk>, <krzk@kernel.org>,
        <alim.akhtar@samsung.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
        <hpa@zytor.com>, <robert.moore@intel.com>,
        <rafael.j.wysocki@intel.com>, <lenb@kernel.org>,
        <3chas3@gmail.com>, <laforge@gnumonks.org>, <arnd@arndb.de>,
        <gregkh@linuxfoundation.org>, <mchehab@kernel.org>,
        <tony.luck@intel.com>, <james.morse@arm.com>, <rric@kernel.org>,
        <linus.walleij@linaro.org>, <brgl@bgdev.pl>,
        <mike.marciniszyn@cornelisnetworks.com>,
        <dennis.dalessandro@cornelisnetworks.com>, <jgg@ziepe.ca>,
        <pali@kernel.org>, <dmitry.torokhov@gmail.com>,
        <isdn@linux-pingi.de>, <benh@kernel.crashing.org>,
        <fbarrat@linux.ibm.com>, <ajd@linux.ibm.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <nico@fluxnic.net>, <loic.poulain@linaro.org>, <kvalo@kernel.org>,
        <pkshih@realtek.com>, <bhelgaas@google.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-ia64@vger.kernel.org>,
        <linux-acpi@vger.kernel.org>, <devel@acpica.org>,
        <linux-atm-general@lists.sourceforge.net>,
        <netdev@vger.kernel.org>, <linux-edac@vger.kernel.org>,
        <linux-gpio@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-input@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-media@vger.kernel.org>, <wcn36xx@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <linux-pci@vger.kernel.org>
References: <20220326165909.506926-1-benni@stuerz.xyz>
 <20220326165909.506926-19-benni@stuerz.xyz>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <20220326165909.506926-19-benni@stuerz.xyz>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UPPERCASE_50_75
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/26/2022 9:59 AM, Benjamin Stürz wrote:
> This replaces comments with C99's designated
> initializers because the kernel supports them now.
> 
> Signed-off-by: Benjamin Stürz <benni@stuerz.xyz>
> ---
>   drivers/net/wireless/ath/wcn36xx/main.c | 122 ++++++++++++------------
>   1 file changed, 61 insertions(+), 61 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
> index 95ea7d040d8c..0fed64bd37b4 100644
> --- a/drivers/net/wireless/ath/wcn36xx/main.c
> +++ b/drivers/net/wireless/ath/wcn36xx/main.c
> @@ -193,67 +193,67 @@ static inline u8 get_sta_index(struct ieee80211_vif *vif,
>   }
>   
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
> +	[0]  = "MCC",
> +	[1]  = "P2P",
> +	[2]  = "DOT11AC",
> +	[3]  = "SLM_SESSIONIZATION",
> +	[4]  = "DOT11AC_OPMODE",
> +	[5]  = "SAP32STA",
> +	[6]  = "TDLS",
> +	[7]  = "P2P_GO_NOA_DECOUPLE_INIT_SCAN",
> +	[8]  = "WLANACTIVE_OFFLOAD",
> +	[9]  = "BEACON_OFFLOAD",
> +	[10] = "SCAN_OFFLOAD",
> +	[11] = "ROAM_OFFLOAD",
> +	[12] = "BCN_MISS_OFFLOAD",
> +	[13] = "STA_POWERSAVE",
> +	[14] = "STA_ADVANCED_PWRSAVE",
> +	[15] = "AP_UAPSD",
> +	[16] = "AP_DFS",
> +	[17] = "BLOCKACK",
> +	[18] = "PHY_ERR",
> +	[19] = "BCN_FILTER",
> +	[20] = "RTT",
> +	[21] = "RATECTRL",
> +	[22] = "WOW",
> +	[23] = "WLAN_ROAM_SCAN_OFFLOAD",
> +	[24] = "SPECULATIVE_PS_POLL",
> +	[25] = "SCAN_SCH",
> +	[26] = "IBSS_HEARTBEAT_OFFLOAD",
> +	[27] = "WLAN_SCAN_OFFLOAD",
> +	[28] = "WLAN_PERIODIC_TX_PTRN",
> +	[29] = "ADVANCE_TDLS",
> +	[30] = "BATCH_SCAN",
> +	[31] = "FW_IN_TX_PATH",
> +	[32] = "EXTENDED_NSOFFLOAD_SLOT",
> +	[33] = "CH_SWITCH_V1",
> +	[34] = "HT40_OBSS_SCAN",
> +	[35] = "UPDATE_CHANNEL_LIST",
> +	[36] = "WLAN_MCADDR_FLT",
> +	[37] = "WLAN_CH144",
> +	[38] = "NAN",
> +	[39] = "TDLS_SCAN_COEXISTENCE",
> +	[40] = "LINK_LAYER_STATS_MEAS",
> +	[41] = "MU_MIMO",
> +	[42] = "EXTENDED_SCAN",
> +	[43] = "DYNAMIC_WMM_PS",
> +	[44] = "MAC_SPOOFED_SCAN",
> +	[45] = "BMU_ERROR_GENERIC_RECOVERY",
> +	[46] = "DISA",
> +	[47] = "FW_STATS",
> +	[48] = "WPS_PRBRSP_TMPL",
> +	[49] = "BCN_IE_FLT_DELTA",
> +	[51] = "TDLS_OFF_CHANNEL",
> +	[52] = "RTT3",
> +	[53] = "MGMT_FRAME_LOGGING",
> +	[54] = "ENHANCED_TXBD_COMPLETION",
> +	[55] = "LOGGING_ENHANCEMENT",
> +	[56] = "EXT_SCAN_ENHANCED",
> +	[57] = "MEMORY_DUMP_SUPPORTED",
> +	[58] = "PER_PKT_STATS_SUPPORTED",
> +	[60] = "EXT_LL_STAT",
> +	[61] = "WIFI_CONFIG",
> +	[62] = "ANTENNA_DIVERSITY_SELECTION",
>   };
>   
>   static const char *wcn36xx_get_cap_name(enum place_holder_in_cap_bitmap x)

I know there has been much discussion on this series. For this specific 
patch this would be a great change if you use the actual enumerations 
from enum place_holder_in_cap_bitmap as the index values,
i.e.
  [MCC] = "MCC",
  etc.

So a v2 for this patch would be appreciated



