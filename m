Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 889F44670AF
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 04:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244433AbhLCD0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 22:26:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbhLCD0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 22:26:40 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4243EC06174A;
        Thu,  2 Dec 2021 19:23:17 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id j11so1730426pgs.2;
        Thu, 02 Dec 2021 19:23:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=SZcoSQC4tK0BM2V0ptt5rU8q5yfPbEErr3YDPv1t14g=;
        b=okL6ZZYKfXl3K+ctD5TI6k3CpwmDCbsMX5V4FUQDzmC2e6esrJmh6yx//6mMrtxgGD
         vK0cPlts9crBLkRxmYWy6itaX3ZLe9YqPRiEuzkA0szVscmkTT/ddinsbzHK94UAt8XN
         qqGqSdlpZSltgxwduVaNdEfQYxYYKrhhBGAEgNy4cfr+a00AQsR/hRsyk80CM2ITy1Y7
         7jkkKxpgX9086ncJ/iYFG3vD8oa6Xu4ncDA3+DAwHtASKzkluq2UJhQPIw0Y3dFWX8BA
         iGhxxq/tXRvLSoagYfzjfXFhieGHJ5GyrnsTJBrZFy2zxvV8o6OSGnK8jRucFVgRgjNJ
         /0Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SZcoSQC4tK0BM2V0ptt5rU8q5yfPbEErr3YDPv1t14g=;
        b=Y+1cyJz5fVdBY1+YLUebXYpzQzplSaWNn94DPQF07HkZg6NKEW4BAS9yz5Lkn/svPq
         Y9MEEFx95QF9B6X8doJDcFvv3wkMXp+AgsCplm+/fyYsA+ZqQkg0kXEHkepJNLUio5KB
         9y9p3h2X3Hr2ziiSE1QzdcNZFVdPTeS1JA92+Qk4Wf6NP3jxTZ1uBPNHkt55nhB7+Yp3
         So5TbQwH//7Xi/c/X2qITGPjJV4WZ28/8j/6hTHDoenE9vAlTcQNcbCmsWn2GQ+XTfJN
         Selfn2YEMK8RUkNgALpYdCLhzCzlRZNl12iJeugQdJv526sm6FpDOh9ciDJk/ud0kE79
         JvXQ==
X-Gm-Message-State: AOAM530XDAgWGBidiZb5mlSCoLXXS7UKryeWCU54HC14dA0uzlI6/+Kw
        dqRsOJS+zxRFOwhSHptkHIg=
X-Google-Smtp-Source: ABdhPJxEBfglBpaRkhl8Uys2pcFwaClQdsQICQ/6kOnrkc+XVQSI8Vprk670oahYuX/mtAYSSMcNpg==
X-Received: by 2002:a63:4a4b:: with SMTP id j11mr2588286pgl.580.1638501796741;
        Thu, 02 Dec 2021 19:23:16 -0800 (PST)
Received: from [10.230.2.23] ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id s21sm1197580pfk.3.2021.12.02.19.23.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Dec 2021 19:23:16 -0800 (PST)
Message-ID: <43da99eb-6279-bf7a-3039-3f59f14ceadc@gmail.com>
Date:   Thu, 2 Dec 2021 19:23:14 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v2] net: broadcom: Catch the Exception
Content-Language: en-US
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>, rafal@milecki.pl,
        bcm-kernel-feedback-list@broadcom.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org, fw@strlen.de
References: <20211203030250.1512671-1-jiasheng@iscas.ac.cn>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211203030250.1512671-1-jiasheng@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/2/2021 7:02 PM, Jiasheng Jiang wrote:
> The return value of dma_set_coherent_mask() is not always 0.
> To catch the exception in case that dma is not support the mask.
> 
> Fixes: 9d61d138ab30 ("net: broadcom: rename BCM4908 driver & update DT binding")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>

Can you come up with a better subject, maybe:

net: bcm4908: Handle dma_set_coherent_mask error codes

or something like that?

> ---
> Changelog
> 
> v1 -> v2
> 
> * Change 1. Correct the Fixes tags.
> * Change 2. CC Florian.
> ---
>   drivers/net/ethernet/broadcom/bcm4908_enet.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bcm4908_enet.c b/drivers/net/ethernet/broadcom/bcm4908_enet.c
> index 02a569500234..376f81796a29 100644
> --- a/drivers/net/ethernet/broadcom/bcm4908_enet.c
> +++ b/drivers/net/ethernet/broadcom/bcm4908_enet.c
> @@ -708,7 +708,9 @@ static int bcm4908_enet_probe(struct platform_device *pdev)
>   
>   	enet->irq_tx = platform_get_irq_byname(pdev, "tx");
>   
> -	dma_set_coherent_mask(dev, DMA_BIT_MASK(32));
> +	err = dma_set_coherent_mask(dev, DMA_BIT_MASK(32));
> +	if (err)
> +		return err;
>   
>   	err = bcm4908_enet_dma_alloc(enet);
>   	if (err)
> 

-- 
Florian
