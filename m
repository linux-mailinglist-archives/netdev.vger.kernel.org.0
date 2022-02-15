Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3315F4B62FC
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 06:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234123AbiBOFkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 00:40:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231965AbiBOFkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 00:40:03 -0500
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 787F01EC49;
        Mon, 14 Feb 2022 21:39:54 -0800 (PST)
Received: by mail-ej1-f43.google.com with SMTP id hw13so13312456ejc.9;
        Mon, 14 Feb 2022 21:39:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pI6mPl00vTpK3f3tU+nkJRNXfeeLji7DsRrYZoMuL28=;
        b=Kv5LdrPOFmUw/QKyTtxx6FoHTcx9Z9M5zGa//2Y7YAVpUNeW8+5Maqi65blco/AwVw
         DIMj/+qgub+EXHaUIwULGu/pWLSBynaho6zEw8zoRjtgKxrgP02D4RvTEiolPngj+PFy
         hHIDOjgnTIqDnfldYD+spkXMcmptdoiVbhtxUb/xM3cWmQ92RCZwCs3/Y7MEEq33++u0
         FYmqk08pbIaGAfPpMcEze5gTnS3lhCaTtpGkfxp/5epN/wkghb6upW4erB/EHNcJZlea
         qAOpBfxxVfqIgykEmu45pvsqEDnGpjZuTpRXL1YcB1pxBPeXTWZZQZ563EhUWM+GqdXQ
         P/gg==
X-Gm-Message-State: AOAM530Icc+7qGF+s5pZkvW+DETLnc1vGFyHVFjyiRoxJSo5/mrMJnF5
        mRfdQdNHk9xGcOssHkGCpOt5KuTmBWI=
X-Google-Smtp-Source: ABdhPJx1KEd7M47Poe3O/pL9pzDuNmZlAy/SCFA0I3siR4oFEJd2wxHArF4Kzxysk/JhZbhn2GyGmQ==
X-Received: by 2002:a17:906:2c9:: with SMTP id 9mr1687729ejk.32.1644903592957;
        Mon, 14 Feb 2022 21:39:52 -0800 (PST)
Received: from ?IPV6:2a0b:e7c0:0:107::49? ([2a0b:e7c0:0:107::49])
        by smtp.gmail.com with ESMTPSA id bv2sm11353540ejb.154.2022.02.14.21.39.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Feb 2022 21:39:52 -0800 (PST)
Message-ID: <f757acf0-63cc-ee03-a865-92fe43833190@kernel.org>
Date:   Tue, 15 Feb 2022 06:39:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH] ath5k: use swap() to make code cleaner
Content-Language: en-US
To:     davidcomponentone@gmail.com
Cc:     mickflemm@gmail.com, mcgrof@kernel.org, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Guang <yang.guang5@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
References: <2f993da5cb5d9fee93cedef852ca6eb2f9683ef0.1644839011.git.yang.guang5@zte.com.cn>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <2f993da5cb5d9fee93cedef852ca6eb2f9683ef0.1644839011.git.yang.guang5@zte.com.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15. 02. 22, 1:51, davidcomponentone@gmail.com wrote:
> From: Yang Guang <yang.guang5@zte.com.cn>
> 
> Use the macro 'swap()' defined in 'include/linux/minmax.h' to avoid
> opencoding it.

Why don't you include that file then?

> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Yang Guang <yang.guang5@zte.com.cn>
> Signed-off-by: David Yang <davidcomponentone@gmail.com>
> ---
>   drivers/net/wireless/ath/ath5k/phy.c | 5 +----
>   1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
> index 00f9e347d414..7fa7ba4952db 100644
> --- a/drivers/net/wireless/ath/ath5k/phy.c
> +++ b/drivers/net/wireless/ath/ath5k/phy.c
> @@ -1562,16 +1562,13 @@ static s16
>   ath5k_hw_get_median_noise_floor(struct ath5k_hw *ah)
>   {
>   	s16 sort[ATH5K_NF_CAL_HIST_MAX];
> -	s16 tmp;
>   	int i, j;
>   
>   	memcpy(sort, ah->ah_nfcal_hist.nfval, sizeof(sort));
>   	for (i = 0; i < ATH5K_NF_CAL_HIST_MAX - 1; i++) {
>   		for (j = 1; j < ATH5K_NF_CAL_HIST_MAX - i; j++) {
>   			if (sort[j] > sort[j - 1]) {
> -				tmp = sort[j];
> -				sort[j] = sort[j - 1];
> -				sort[j - 1] = tmp;
> +				sort(sort[j], sort[j - 1]);
>   			}
>   		}
>   	}


-- 
js
suse labs
