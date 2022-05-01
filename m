Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAF451637B
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 11:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242880AbiEAJyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 05:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236939AbiEAJyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 05:54:19 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8988D1FA65
        for <netdev@vger.kernel.org>; Sun,  1 May 2022 02:50:50 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id p8so10271248pfh.8
        for <netdev@vger.kernel.org>; Sun, 01 May 2022 02:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=WJT5CIynMvfmL55s5kI64UJM3xfRDf5iZlBdfA0bFEA=;
        b=aLo7z9KzHFXI7/Ey+rD96JIGrPWmk3dAW6Qf1Y6Z8V6PRcG1w3GkWXNljeGRURfI7c
         ENpiJM/l7eANissgnsJlmfJO2Pbc1FmKzp3rz4QtWCy3gIUG4hL6AHfr3D9cZtDoY5zZ
         p//5PsgKUbsqiGrlgiBPOk7KkS2ADTLnLieiFNf8OlIzBzin19BoFe1jR/s/n67km9OF
         EZ4vYeYUerB0DF+8sV7IHxThgSpfeRVoLANiAUXni9Lso4fIKssNKim5FHBRcLYgxdbf
         R/WjKY0qh97cyEDA0zpLkD/NPBB5oDd3cmqJIizLWTaAcA5tShTDEsYA6pAAhNBdhkc3
         +6GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WJT5CIynMvfmL55s5kI64UJM3xfRDf5iZlBdfA0bFEA=;
        b=aH8xAyVQQ+5pPZ5DXYsyfAHnW3xd7xRgAQqplrYLRwtL9JwIstnXDYGI10T/+M6RcF
         QfHbFGKXge1h0g/QBwfKY8F661PZE/NfoK2jmSXEgsvUOx0s2mgKJeHsxZAJt9Wo6Ewh
         T0vO6/pRSBZrSTXzArsSJk139KDDh2PhGb0rVikQr+C7KAJ/437kHghI0W3V8cpRxr0M
         0T98qbZdTQ84g/IB1hbJF//UELnnZPmrGtPe2L8bKp7EmcKaKv//SmsHLU7SXOnzl6CL
         zF0l6i2lyHCwRG0Ivj6H0MmZsfCk4JNZCYXLOEu7MpmfMJBQZCYOQdOYvQmnpAXNVryf
         9KHw==
X-Gm-Message-State: AOAM53357bRPM+hF7vMbtpPeeSsOa6RhOYTtL2E6YuKVSJiudxVfC6JO
        neYqcgs4sh7Mq7OUUn8SmVIHoSAmNyE=
X-Google-Smtp-Source: ABdhPJxWyol/BBqvkU8UceTyWddc+YC6m06ngngCit+uQsvV0W4ErKR4Eu1jmKScYo4Tltnse9ytgg==
X-Received: by 2002:a65:4c0c:0:b0:3c1:5bb1:6701 with SMTP id u12-20020a654c0c000000b003c15bb16701mr5691564pgq.136.1651398650013;
        Sun, 01 May 2022 02:50:50 -0700 (PDT)
Received: from [192.168.0.4] ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id q11-20020a170902dacb00b0015e8d4eb27dsm2634260plx.199.2022.05.01.02.50.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 May 2022 02:50:48 -0700 (PDT)
Message-ID: <91c6b611-ad3f-f0ce-b228-529e5b48873e@gmail.com>
Date:   Sun, 1 May 2022 18:50:45 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [net-next PATCH] amt: Use BIT macros instead of open codes
Content-Language: en-US
To:     Juhee Kang <claudiajkang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
References: <20220430135622.103683-1-claudiajkang@gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <20220430135622.103683-1-claudiajkang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/30/22 22:56, Juhee Kang wrote:

Hi Juhee,
Thanks a lot for this work!

> Replace open code related to bit operation with BIT macros, which kernel
> provided. This patch provides no functional change.
> 
Reviewed-by: Taehee Yoo <ap420073@gmail.com>
Tested-by: Taehee Yoo <ap420073@gmail.com>

Thanks,
Taehee Yoo

> Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
> ---
>   drivers/net/amt.c | 2 +-
>   include/net/amt.h | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/amt.c b/drivers/net/amt.c
> index 10455c9b9da0..76c1969a03f5 100644
> --- a/drivers/net/amt.c
> +++ b/drivers/net/amt.c
> @@ -959,7 +959,7 @@ static void amt_req_work(struct work_struct *work)
>   	amt_update_gw_status(amt, AMT_STATUS_SENT_REQUEST, true);
>   	spin_lock_bh(&amt->lock);
>   out:
> -	exp = min_t(u32, (1 * (1 << amt->req_cnt)), AMT_MAX_REQ_TIMEOUT);
> +	exp = min_t(u32, (1 * BIT(amt->req_cnt)), AMT_MAX_REQ_TIMEOUT);
>   	mod_delayed_work(amt_wq, &amt->req_wq, msecs_to_jiffies(exp * 1000));
>   	spin_unlock_bh(&amt->lock);
>   }
> diff --git a/include/net/amt.h b/include/net/amt.h
> index 7a4db8b903ee..d2fd76b0a424 100644
> --- a/include/net/amt.h
> +++ b/include/net/amt.h
> @@ -354,7 +354,7 @@ struct amt_dev {
>   #define AMT_MAX_GROUP		32
>   #define AMT_MAX_SOURCE		128
>   #define AMT_HSIZE_SHIFT		8
> -#define AMT_HSIZE		(1 << AMT_HSIZE_SHIFT)
> +#define AMT_HSIZE		BIT(AMT_HSIZE_SHIFT)
>   
>   #define AMT_DISCOVERY_TIMEOUT	5000
>   #define AMT_INIT_REQ_TIMEOUT	1
