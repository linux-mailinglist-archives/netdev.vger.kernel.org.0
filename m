Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77FFA34E67D
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 13:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbhC3Lpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 07:45:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231872AbhC3LpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 07:45:19 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE114C061574
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 04:45:18 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id c17so13901974ilj.7
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 04:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yWRk9LdoNDY5IodOZYxp8mN22m204NZlKnviULUNqNE=;
        b=KztInrHjSkQS7iiEFzOYm3oub750aXmA4wQZ0ZnngplvQGIudlNMc70vbrFKa2FPaB
         luQBBZVNbv1GY+yKv+zMuycdT5u5R/KsXcSHMDKrl5kDb96BOvZBYHVeKyJIAtCejWdq
         NKK71T+qbdA+2sK52u5L9MITz0HFosJH3qOsw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yWRk9LdoNDY5IodOZYxp8mN22m204NZlKnviULUNqNE=;
        b=AMqm/XcFg/PhC10wcm1/FNXNzY8HLj+E5D/WotNcMlrdv5JK0biEhxu6tXnekLQ1M5
         vom2bkOl/Sd28VHz+ykMzi3M5wpe70QZUoUKu48idp7X+LGXwXFEdIaSskijULozP0Go
         UqWU1Ts/Jks4HfBMm32zBhPutfB+LaAjVypil3RN/Qmp+aMGm0EALehZa566MuSwcIrj
         Tsma8W9sCsWG2BYFLzZI+mt7+OCZZnvutVA7/faJcSm5nV3RJEstqLdQxoGH14oJYdkH
         iCmqleb1UlWMa3ldC4vYSJt4wxYSmj+q91mRjSR/eUdgfNQAJH8GQnDB3OoMt2ao6dlt
         HYbA==
X-Gm-Message-State: AOAM530aZoZUEKfhCCdrm93jsPoInOtVD0fQvmBF2hSTW3yW4Uh0kKtz
        1wwTryBfiubEVb/XXgkHxjSucL9QXiZ4UBC9
X-Google-Smtp-Source: ABdhPJzLdLkGvPfLfZ/KuRbBbtdMpw14Wncqkt0g2Nqst56FdSGcIfdMhAx/sQP4GmxVdgGR4jEWGQ==
X-Received: by 2002:a05:6e02:f41:: with SMTP id y1mr23148060ilj.259.1617104716834;
        Tue, 30 Mar 2021 04:45:16 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id z10sm11268172ilm.19.2021.03.30.04.45.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Mar 2021 04:45:16 -0700 (PDT)
Subject: Re: [RESEND net-next 4/4] net: ipa: remove repeated words
To:     Huazhong Tan <tanhuazhong@huawei.com>, davem@davemloft.net,
        kuba@kernel.org, jesse.brandeburg@intel.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andrew@lunn.ch, elder@kernel.org
Cc:     netdev@vger.kernel.org, salil.mehta@huawei.com,
        yisen.zhuang@huawei.com, huangdaode@huawei.com,
        linuxarm@openeuler.org, linuxarm@huawei.com,
        Peng Li <lipeng321@huawei.com>
References: <1617089276-30268-1-git-send-email-tanhuazhong@huawei.com>
 <1617089276-30268-5-git-send-email-tanhuazhong@huawei.com>
From:   Alex Elder <elder@ieee.org>
Message-ID: <aaa900f4-d396-897f-cf37-0000357a472e@ieee.org>
Date:   Tue, 30 Mar 2021 06:45:15 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <1617089276-30268-5-git-send-email-tanhuazhong@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/30/21 2:27 AM, Huazhong Tan wrote:
> From: Peng Li <lipeng321@huawei.com>
> 
> Remove repeated words "that" and "the".
> 
> Signed-off-by: Peng Li <lipeng321@huawei.com>
> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>

Acked-by: Alex Elder <elder@linaro.org>

> ---
>   drivers/net/ipa/ipa_endpoint.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
> index 38e83cd..dd24179 100644
> --- a/drivers/net/ipa/ipa_endpoint.c
> +++ b/drivers/net/ipa/ipa_endpoint.c
> @@ -809,7 +809,7 @@ static u32 hol_block_timer_val(struct ipa *ipa, u32 microseconds)
>   	 * The best precision is achieved when the base value is as
>   	 * large as possible.  Find the highest set bit in the tick
>   	 * count, and extract the number of bits in the base field
> -	 * such that that high bit is included.
> +	 * such that high bit is included.
>   	 */
>   	high = fls(ticks);		/* 1..32 */
>   	width = HWEIGHT32(BASE_VALUE_FMASK);
> @@ -1448,7 +1448,7 @@ static int ipa_endpoint_reset_rx_aggr(struct ipa_endpoint *endpoint)
>   	if (ret)
>   		goto out_suspend_again;
>   
> -	/* Finally, reset and reconfigure the channel again (re-enabling the
> +	/* Finally, reset and reconfigure the channel again (re-enabling
>   	 * the doorbell engine if appropriate).  Sleep for 1 millisecond to
>   	 * complete the channel reset sequence.  Finish by suspending the
>   	 * channel again (if necessary).
> 

