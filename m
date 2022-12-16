Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5199A64F340
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 22:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbiLPVeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 16:34:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230480AbiLPVe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 16:34:26 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7523C6598F
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 13:34:25 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id y4so1940582iof.0
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 13:34:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4O3C1ibrA8mqSC/GREIx+zN2+v3HHkAuREG1a+CLcQ4=;
        b=H/EP0on7htHCxZYiWQiOK0jKfrJuc75EHQPleFDEeDaQAsUoRCLpkOwuqdnYfhMSeU
         oPuR/DbZ35vNg5rzcj319xHH7kcdrkQsSQHNAD8H0nWxZKpfNCKgcVx8gDqzXgr8qQjO
         1dJxg+d8K2mODZ3Wp8LdKrNYUh/W587PAFlFw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4O3C1ibrA8mqSC/GREIx+zN2+v3HHkAuREG1a+CLcQ4=;
        b=4jI9QYDJ0dvqSQmlcjEIkad8iP1dwauwDRtEi9GpxkknmGmg8j340ndhqw/7BpHf/6
         8N+u5ba0+tkvHJOy01Jf4xZPMWtRj9I2RJKEMUL6HQgm5VgG9SgjCEXM7Gbp0kaQ5cAY
         hNSOoNFIFnA5IF+leYng8ltqJOeBuWIFkTi7U7vSix4A/kTv0rxeQbKjBMbLOPRf7vZZ
         YspHVUk+DcDpZ4YuV+dzHmnbCN/KFwcntmSOLpO0l9qLkUnbIgNKxP6HZJKV3bi0mbiy
         2KWkvkYBDY31pyYBmo2CqIkoK3ROQFwfaji7tmvkS5gugwOoFwLoGlV1ls3DEkWs6F8K
         hDHg==
X-Gm-Message-State: AFqh2kpheabL88Qh8DnijbAAdRKWaPw1jcU1yMydAGcnzVh5boRx2OKl
        8cZa/JVOifOkfRCdVbqJJETH6A==
X-Google-Smtp-Source: AMrXdXsSzN2a3PWXO43BWzOpWb8gSkDLu5L1nSdXBwFTziUaQLxLMh/aQA3tPIGPT7GVjKRlvlayPA==
X-Received: by 2002:a6b:f407:0:b0:6e2:fc7f:13a0 with SMTP id i7-20020a6bf407000000b006e2fc7f13a0mr156704iog.13.1671226464831;
        Fri, 16 Dec 2022 13:34:24 -0800 (PST)
Received: from [172.22.22.4] ([98.61.227.136])
        by smtp.googlemail.com with ESMTPSA id p7-20020a02c807000000b003884192cc05sm1056057jao.120.2022.12.16.13.34.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Dec 2022 13:34:24 -0800 (PST)
Message-ID: <941d8fa9-9c7b-8e06-e87a-b1c9ed80a639@ieee.org>
Date:   Fri, 16 Dec 2022 15:34:23 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v3] net: ipa: Remove redundant comparison with
 zero
Content-Language: en-US
To:     Kang Minchul <tegongkang@gmail.com>, Alex Elder <elder@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221216211124.154459-1-tegongkang@gmail.com>
From:   Alex Elder <elder@ieee.org>
In-Reply-To: <20221216211124.154459-1-tegongkang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/16/22 3:11 PM, Kang Minchul wrote:
> platform_get_irq_byname() returns non-zero IRQ number on success,
> and negative error number on failure.
> 
> So comparing return value with zero is unnecessary.
> 
> Signed-off-by: Kang Minchul <tegongkang@gmail.com>
> ---
>   drivers/net/ipa/gsi.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
> index bea2da1c4c51..e05e94bd9ba0 100644
> --- a/drivers/net/ipa/gsi.c
> +++ b/drivers/net/ipa/gsi.c
> @@ -1302,7 +1302,7 @@ static int gsi_irq_init(struct gsi *gsi, struct platform_device *pdev)
>   	int ret;
>   
>   	ret = platform_get_irq_byname(pdev, "gsi");
> -	if (ret <= 0)
> +	if (ret < 0)
>   		return ret ? : -EINVAL;

In doing this, you assume platform_get_irq_byname() never
returns 0.  I accept that assumption now.  But in that case,
ret will *always* be non-zero if the branch is taken, so the
next line should simply be:

		return ret;

There are two other places in the IPA driver that follow exactly
the same pattern of getting the IRQ number and handling the
possibility that the value returned is (erroneously) 0.  If
you're making this change in one place, please do so in all
of them.

Frankly though, I think this change adds little value, and I
would be content to just leave everything as-is...

					-Alex

>   
>   	gsi->irq = ret;

