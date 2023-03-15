Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 784316BBEE5
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 22:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232602AbjCOVUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 17:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232891AbjCOVUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 17:20:10 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7642696F25
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 14:19:42 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id a13so4699329ilr.9
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 14:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678915177;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gEgaBMSBWRa1FO8K+pq3htlZswyE7CJJoK0ovlchw1I=;
        b=YiIhOeyY02wE3ltLusHCbz2wl5P8AO473XBp+MtFRPXivqiKfkeZzqZ/H1fjbgRraP
         jW3e+Xsfe4fPQi6EmjNlET7dKGGJNEJLl12vT2makAx1vagr3ZrTvAJzXM7pUEpzuqi7
         c8rLC7CQwAR7o/OXnSVjM/bQJBvgTQCoesQca0j31GkhuASIwKX6fJW6ixK8uJI/rZLW
         MyEIwUfn0FYP8emCY2ksTXttu7RpoEZXCFrlLk29zSpfWSBhMgi1nWTLMkUeKHuXix4h
         FJaMgVh8HCp87XEOGhHfPohCBvDIcVR9UO/EXCRYEU4ewIblG9NXCNd0LJU0edY4DTuH
         mzTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678915177;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gEgaBMSBWRa1FO8K+pq3htlZswyE7CJJoK0ovlchw1I=;
        b=nzMhiUC23gxgyZ5NcvpaMsU5l0l1sC09swEhDxiVGDSHM3Zpy8MpNk0qVhWSLl80NK
         ztwnv2zhbKBg4Cm7FFfNwcIWP8Q6LxzqLtdJ132wXAITk+ovrwWuaQVhBDSg2JW5MOdz
         rE2ek/u8cy2laMcaFmq95Ngxf4GF5ZOoTPdW0gekLKNNWC58uct60tcfKUdpuhKsPlC+
         yKX+tCcA6JRjQrdnJtxfMwBMyWcXi4uO0M4EFIpIG1sh7CKSBhjEES3bw/2O//dDXpQi
         O7bybgfrcyJM2ZepSHkMxT1kjcds2YRPVha7w6bEq6P7ueb3xaovTn0fjtmaakJQQ8HP
         LiSQ==
X-Gm-Message-State: AO0yUKXwS7E6+hnUgraEz/vEeX7cdN65rzeUQcD2ifQt9+BUNFN8SI6P
        LsbJZvv5rSD+FRU/k7HdfjrvtA==
X-Google-Smtp-Source: AK7set+mA5+bm+Q3QV52tP9dqfqAndeYtOlfo1M/58Toaw3iZ2GC6/onU19J8i39HhN2+Rgw4BsTuQ==
X-Received: by 2002:a05:6e02:1bc3:b0:323:2468:ba20 with SMTP id x3-20020a056e021bc300b003232468ba20mr5145198ilv.10.1678915176745;
        Wed, 15 Mar 2023 14:19:36 -0700 (PDT)
Received: from [172.22.22.4] ([98.61.227.136])
        by smtp.googlemail.com with ESMTPSA id a12-20020a92ce4c000000b0032304e1814bsm1881527ilr.40.2023.03.15.14.19.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 14:19:36 -0700 (PDT)
Message-ID: <6f7fa54c-6743-509b-a5d2-2d70ffb8c0e2@linaro.org>
Date:   Wed, 15 Mar 2023 16:19:35 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net v2 3/4] net: ipa: kill FILT_ROUT_CACHE_CFG IPA
 register
Content-Language: en-US
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230315193552.1646892-1-elder@linaro.org>
 <20230315193552.1646892-4-elder@linaro.org>
In-Reply-To: <20230315193552.1646892-4-elder@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/15/23 2:35 PM, Alex Elder wrote:
> A recent commit defined a few IPA registers used for IPA v5.0+.
> One of those was a mistake.  Although the filter and router caches
> get *flushed* using a single register, they use distinct registers
> (ENDP_FILTER_CACHE_CFG and ENDP_ROUTER_CACHE_CFG) for configuration.
> 
> And although there *exists* a FILT_ROUT_CACHE_CFG register, it is
> not needed in upstream code.  So get rid of definitions related to
> FILT_ROUT_CACHE_CFG, because they are not needed.
> 
> Fixes: de101ca79f97 ("net: ipa: define IPA v5.0+ registers")'

AGAIN!  This is a bad commit ID.  It should be 8ba59716d16a.

I've got a new series ready to go but I'll wait until
tomorrow to post it.

Sorry for the noise.

					-Alex


> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>   drivers/net/ipa/ipa_reg.c | 4 ++--
>   drivers/net/ipa/ipa_reg.h | 9 ---------
>   2 files changed, 2 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/ipa/ipa_reg.c b/drivers/net/ipa/ipa_reg.c
> index 735fa65916097..463a31dfa9f47 100644
> --- a/drivers/net/ipa/ipa_reg.c
> +++ b/drivers/net/ipa/ipa_reg.c
> @@ -39,7 +39,8 @@ static bool ipa_reg_id_valid(struct ipa *ipa, enum ipa_reg_id reg_id)
>   		return version <= IPA_VERSION_3_1;
>   
>   	case ENDP_FILTER_ROUTER_HSH_CFG:
> -		return version != IPA_VERSION_4_2;
> +		return version < IPA_VERSION_5_0 &&
> +			version != IPA_VERSION_4_2;
>   
>   	case IRQ_SUSPEND_EN:
>   	case IRQ_SUSPEND_CLR:
> @@ -52,7 +53,6 @@ static bool ipa_reg_id_valid(struct ipa *ipa, enum ipa_reg_id reg_id)
>   	case QSB_MAX_WRITES:
>   	case QSB_MAX_READS:
>   	case FILT_ROUT_HASH_EN:
> -	case FILT_ROUT_CACHE_CFG:
>   	case FILT_ROUT_HASH_FLUSH:
>   	case FILT_ROUT_CACHE_FLUSH:
>   	case STATE_AGGR_ACTIVE:
> diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
> index 28aa1351dd488..ff2be8be0f683 100644
> --- a/drivers/net/ipa/ipa_reg.h
> +++ b/drivers/net/ipa/ipa_reg.h
> @@ -61,7 +61,6 @@ enum ipa_reg_id {
>   	QSB_MAX_WRITES,
>   	QSB_MAX_READS,
>   	FILT_ROUT_HASH_EN,				/* Not IPA v5.0+ */
> -	FILT_ROUT_CACHE_CFG,				/* IPA v5.0+ */
>   	FILT_ROUT_HASH_FLUSH,				/* Not IPA v5.0+ */
>   	FILT_ROUT_CACHE_FLUSH,				/* IPA v5.0+ */
>   	STATE_AGGR_ACTIVE,
> @@ -206,14 +205,6 @@ enum ipa_reg_qsb_max_reads_field_id {
>   	GEN_QMB_1_MAX_READS_BEATS,			/* IPA v4.0+ */
>   };
>   
> -/* FILT_ROUT_CACHE_CFG register */
> -enum ipa_reg_filt_rout_cache_cfg_field_id {
> -	ROUTER_CACHE_EN,
> -	FILTER_CACHE_EN,
> -	LOW_PRI_HASH_HIT_DISABLE,
> -	LRU_EVICTION_THRESHOLD,
> -};
> -
>   /* FILT_ROUT_HASH_EN and FILT_ROUT_HASH_FLUSH registers */
>   enum ipa_reg_filt_rout_hash_field_id {
>   	IPV6_ROUTER_HASH,

