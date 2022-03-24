Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50E224E637D
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 13:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349696AbiCXMoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 08:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344696AbiCXMoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 08:44:02 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A316A94F6
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 05:42:26 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id n35so2634048wms.5
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 05:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nexus-software-ie.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=SRqP4OX0c96t915lu5xWOnRiTjEBkrJ/XwZE+rbqkCo=;
        b=P/WngdM3nakUoDenPDReFSCTsDEinjVUvPHE055Ojs+n098elhPOwpfy2UEwNBh1qJ
         tt3ufnp2NltgdfiCFwI2q4OueAnf0nZzzXhONkfOtLiprE7e+Fo7KsUJWM/ZqqV05FX0
         PriasQnURxxEA7nJ27996IH1yN6gLmPTC0GQe5Ad39FUz83F68sQyIG3gYTCiXLk3xpT
         FEQ1X3KCy3EBFkuOQH09DSDjWjJgKPbjzFc9uLqqYftyXfWAev7qmDlCUSVWBx6bIQpN
         xggBjDP8ii7xLyWTjKMnACvK4eVIHwGhfUlUUBbYbSJtZffe5Ee3oh6PNX4FxZIBoE8W
         gznQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SRqP4OX0c96t915lu5xWOnRiTjEBkrJ/XwZE+rbqkCo=;
        b=Cz6t5lohAxNGd3V7UVKi5/i7ChHZM5b3eH3wiE2t+b5ga2RLUD0Y37xFweldM5t3mz
         Iz8j2/uyhXOkr7+VYAWyTdmFEkIvIerisbQdd/TDXppTaolIpcgn8bY3Id3iDP6KIr4X
         QgDjlrNzzHq3NfvohmoU9vaucqm6V9iPQ8YzWZq0fHbit69ZoO6Tq9/f15XPIiLF6krZ
         TXWyL1za4D/u3KvOVaF64RFncfP3HO1/lR2xAAfouIqCsHaAuIaHqUrrcMqv5+IuLV/G
         lQFz+BNwqbMErmGZBx325EFMxGNsIFac8VfbpdROVIYRQzHSCMtDpsTjoe1ypsrjrgc1
         OZJw==
X-Gm-Message-State: AOAM533tpLdLYNKeI/jva5XlpF6se77VTRDRflBWEVB7MOmibuAPw38w
        6olY0J7r86wV4qrifz/Kk11p5w==
X-Google-Smtp-Source: ABdhPJzVIx6jSXipIQV5bTb6qn4mBgup/uRtzIUMfD9quLWIlEB+tpRKiLSI/72mYWvvTWaMAhbzfQ==
X-Received: by 2002:a05:600c:3b08:b0:38c:c8f1:16ca with SMTP id m8-20020a05600c3b0800b0038cc8f116camr4725686wms.192.1648125744801;
        Thu, 24 Mar 2022 05:42:24 -0700 (PDT)
Received: from [192.168.0.162] (188-141-3-169.dynamic.upc.ie. [188.141.3.169])
        by smtp.gmail.com with ESMTPSA id m3-20020a5d64a3000000b00203ed35b0aesm4175170wrp.108.2022.03.24.05.42.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Mar 2022 05:42:24 -0700 (PDT)
Message-ID: <9c90300e-ac2d-be53-a7c9-7b00a059204e@nexus-software.ie>
Date:   Thu, 24 Mar 2022 12:42:23 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v3] wcn36xx: Implement tx_rate reporting
Content-Language: en-US
To:     Edmond Gagnon <egagnon@squareup.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Benjamin Li <benl@squareup.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220318195804.4169686-3-egagnon@squareup.com>
 <20220323214533.1951791-1-egagnon@squareup.com>
From:   Bryan O'Donoghue <pure.logic@nexus-software.ie>
In-Reply-To: <20220323214533.1951791-1-egagnon@squareup.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/03/2022 21:45, Edmond Gagnon wrote:
> Currently, the driver reports a tx_rate of 6.0 MBit/s no matter the true
> rate:
> 
> root@linaro-developer:~# iw wlan0 link
> Connected to 6c:f3:7f:eb:9b:92 (on wlan0)
>          SSID: SQ-DEVICETEST
>          freq: 5200
>          RX: 4141 bytes (32 packets)
>          TX: 2082 bytes (15 packets)
>          signal: -77 dBm
>          rx bitrate: 135.0 MBit/s MCS 6 40MHz short GI
>          tx bitrate: 6.0 MBit/s
> 
>          bss flags:      short-slot-time
>          dtim period:    1
>          beacon int:     100
> 
> This patch requests HAL_GLOBAL_CLASS_A_STATS_INFO via a hal_get_stats
> firmware message and reports it via ieee80211_ops::sta_statistics.
> 
> root@linaro-developer:~# iw wlan0 link
> Connected to 6c:f3:7f:eb:73:b2 (on wlan0)
>          SSID: SQ-DEVICETEST
>          freq: 5700
>          RX: 26788094 bytes (19859 packets)
>          TX: 1101376 bytes (12119 packets)
>          signal: -75 dBm
>          rx bitrate: 135.0 MBit/s MCS 6 40MHz short GI
>          tx bitrate: 108.0 MBit/s VHT-MCS 5 40MHz VHT-NSS 1
> 
>          bss flags:      short-slot-time
>          dtim period:    1
>          beacon int:     100
> 
> Tested on MSM8939 with WCN3680B running firmware CNSS-PR-2-0-1-2-c1-00083,
> and verified by sniffing frames over the air with Wireshark to ensure the
> MCS indices match.
> 
> Signed-off-by: Edmond Gagnon <egagnon@squareup.com>
> Reviewed-by: Benjamin Li <benl@squareup.com>
> ---
> 
> Changes in v3:
>   - Refactored to report tx_rate via ieee80211_ops::sta_statistics
>   - Dropped get_sta_index patch
>   - Addressed style comments
> Changes in v2:
>   - Refactored to use existing wcn36xx_hal_get_stats_{req,rsp}_msg structs.
>   - Added more notes about testing.
>   - Reduced reporting interval to 3000msec.
>   - Assorted type and memory safety fixes.
>   - Make wcn36xx_smd_get_stats friendlier to future message implementors.
> 
>   drivers/net/wireless/ath/wcn36xx/hal.h  |  7 +++-
>   drivers/net/wireless/ath/wcn36xx/main.c | 16 +++++++
>   drivers/net/wireless/ath/wcn36xx/smd.c  | 56 +++++++++++++++++++++++++
>   drivers/net/wireless/ath/wcn36xx/smd.h  |  2 +
>   drivers/net/wireless/ath/wcn36xx/txrx.c | 29 +++++++++++++
>   drivers/net/wireless/ath/wcn36xx/txrx.h |  1 +
>   6 files changed, 110 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/wcn36xx/hal.h b/drivers/net/wireless/ath/wcn36xx/hal.h
> index 2a1db9756fd5..46a49f0a51b3 100644
> --- a/drivers/net/wireless/ath/wcn36xx/hal.h
> +++ b/drivers/net/wireless/ath/wcn36xx/hal.h
> @@ -2626,7 +2626,12 @@ enum tx_rate_info {
>   	HAL_TX_RATE_SGI = 0x8,
>   
>   	/* Rate with Long guard interval */
> -	HAL_TX_RATE_LGI = 0x10
> +	HAL_TX_RATE_LGI = 0x10,
> +
> +	/* VHT rates */
> +	HAL_TX_RATE_VHT20  = 0x20,
> +	HAL_TX_RATE_VHT40  = 0x40,
> +	HAL_TX_RATE_VHT80  = 0x80,
>   };
>   
>   struct ani_global_class_a_stats_info {
> diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
> index b545d4b2b8c4..fc76b090c39f 100644
> --- a/drivers/net/wireless/ath/wcn36xx/main.c
> +++ b/drivers/net/wireless/ath/wcn36xx/main.c
> @@ -1400,6 +1400,21 @@ static int wcn36xx_get_survey(struct ieee80211_hw *hw, int idx,
>   	return 0;
>   }
>   
> +static void wcn36xx_sta_statistics(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
> +				   struct ieee80211_sta *sta, struct station_info *sinfo)


Consider running this through checkpatch.pl and fixing most of the 
complaints, use your discretion.

scripts/checkpatch.pl --strict 
~/Development/patches/linux/wifi/v3-wcn36xx-Implement-tx_rate-reporting.patch

static void wcn36xx_sta_statistics(struct ieee80211_hw *hw,
                                    struct ieee80211_vif *vif,
                                    struct ieee80211_sta *sta,
                                    struct station_info *sinfo)

> +{
> +	struct wcn36xx *wcn;
> +	u8 sta_index;
> +	int status = 0;
> +
> +	wcn = hw->priv;
> +	sta_index = get_sta_index(vif, wcn36xx_sta_to_priv(sta));
> +	status = wcn36xx_smd_get_stats(wcn, sta_index, HAL_GLOBAL_CLASS_A_STATS_INFO, sinfo);

status = wcn36xx_smd_get_stats(wcn, sta_index,
                                HAL_GLOBAL_CLASS_A_STATS_INFO, sinfo);


> +
> +	if (status)
> +		wcn36xx_err("wcn36xx_smd_get_stats failed\n");
> +}
> +
>   static const struct ieee80211_ops wcn36xx_ops = {
>   	.start			= wcn36xx_start,
>   	.stop			= wcn36xx_stop,
> @@ -1423,6 +1438,7 @@ static const struct ieee80211_ops wcn36xx_ops = {
>   	.set_rts_threshold	= wcn36xx_set_rts_threshold,
>   	.sta_add		= wcn36xx_sta_add,
>   	.sta_remove		= wcn36xx_sta_remove,
> +	.sta_statistics		= wcn36xx_sta_statistics,
>   	.ampdu_action		= wcn36xx_ampdu_action,
>   #if IS_ENABLED(CONFIG_IPV6)
>   	.ipv6_addr_change	= wcn36xx_ipv6_addr_change,
> diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
> index caeb68901326..8f9aa892e5ec 100644
> --- a/drivers/net/wireless/ath/wcn36xx/smd.c
> +++ b/drivers/net/wireless/ath/wcn36xx/smd.c
> @@ -2627,6 +2627,61 @@ int wcn36xx_smd_del_ba(struct wcn36xx *wcn, u16 tid, u8 direction, u8 sta_index)
>   	return ret;
>   }
>   
> +int wcn36xx_smd_get_stats(struct wcn36xx *wcn, u8 sta_index, u32 stats_mask,
> +			  struct station_info *sinfo)
> +{
> +	struct wcn36xx_hal_stats_req_msg msg_body;
> +	struct wcn36xx_hal_stats_rsp_msg *rsp;
         struct ani_global_class_a_stats_info *stats_info;
> +	void *rsp_body;
> +	int ret = 0;
> +
> +	if (stats_mask & ~HAL_GLOBAL_CLASS_A_STATS_INFO) {
> +		wcn36xx_err("stats_mask 0x%x contains unimplemented types\n",
> +			    stats_mask);
> +		return -EINVAL;
> +	}
> +
> +	mutex_lock(&wcn->hal_mutex);
> +	INIT_HAL_MSG(msg_body, WCN36XX_HAL_GET_STATS_REQ);
> +
> +	msg_body.sta_id = sta_index;
> +	msg_body.stats_mask = stats_mask;
> +
> +	PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
> +
> +	ret = wcn36xx_smd_send_and_wait(wcn, msg_body.header.len);
> +	if (ret) {
> +		wcn36xx_err("sending hal_get_stats failed\n");
> +		goto out;
> +	}
> +
> +	ret = wcn36xx_smd_rsp_status_check(wcn->hal_buf, wcn->hal_rsp_len);
> +	if (ret) {
> +		wcn36xx_err("hal_get_stats response failed err=%d\n", ret);
> +		goto out;
> +	}
> +
> +	rsp = (struct wcn36xx_hal_stats_rsp_msg *)wcn->hal_buf;
> +	rsp_body = (wcn->hal_buf + sizeof(struct wcn36xx_hal_stats_rsp_msg));
> +
> +	if (rsp->stats_mask != stats_mask) {
> +		wcn36xx_err("stats_mask 0x%x differs from requested 0x%x\n",
> +			    rsp->stats_mask, stats_mask);
> +		goto out;
> +	}
> +
If you take a pointer and cast it, then you won't have this very long 
line with the cast

         stats_info = (struct ani_global_class_a_stats_info *)rsp_body;
> +	if (rsp->stats_mask & HAL_GLOBAL_CLASS_A_STATS_INFO) {
> +		wcn36xx_process_tx_rate((struct ani_global_class_a_stats_info *)rsp_body,
> +					&sinfo->txrate);
                 wcn36xx_process_tx_rate(stats_info, &sinfo->txrate);


Other than that LGTM

Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
