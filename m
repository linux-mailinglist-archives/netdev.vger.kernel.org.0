Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFC22F8CBF
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 10:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbhAPJzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 04:55:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726595AbhAPJzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jan 2021 04:55:53 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83972C061757;
        Sat, 16 Jan 2021 01:55:12 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id u25so16899631lfc.2;
        Sat, 16 Jan 2021 01:55:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y28tRJhhoiCvoELiMGKRKxElE6yxaeeck1yAOz8t9W8=;
        b=czdMl4/Ku/KwisqwYx7KcjKBaYlnKeThg912tzF/uIRJbOhIlk8/52MbhNjr9elSN7
         09NNCpDQaxTfVRcB3Z929Xmd8PSTmFTGMbQqdd8yjImeVmPBk+OCM0PUrjpJDAzP0ISU
         iKcInFIcLyVlwOV2yR/Fds5vU4uSHBhwUGFpUG4StXMviwtNrWwDzHfhd0FPXiCSHcUi
         NN1dRTFSFC6/nE8sjsHKz+FnL1PEa5be29c8HZmfU0R7Y5Fm/4arFLNIONv4X4eGtagW
         XTzKQKV4ak/C49rjC4oxWkU/TEzs+jz9Jpj3T6eBtPJGNCOazFzLMQr+9JoMM1gZCFXG
         FpWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=y28tRJhhoiCvoELiMGKRKxElE6yxaeeck1yAOz8t9W8=;
        b=hPfxlpFrs3Sj4w3meHUleaTRgiMwc1wKSzIWLu6HpoGRzELPyiz9/jHXnvv6MxR+et
         4letNOBzzjx/8Mf/heCwaEpjh9BZd2+wxyeq8Zye280JS0bXSzLDZDWPGi5LuKyjIESW
         oAIeub8wNRkr3okwno8NFkzvno2fRyW4fqZ0E0AcKkUu8q5noq9+M/29iIlusaOryvXO
         US0jF85f+0xsIyAJg/K4Nakz8Z70bBEq2PxbTtzFV+5nNDCnKHouc/ZZ5qx3UMrVlizq
         /rJy9KwQzsq2c0VcN4Wsnm0pJpjom9mXYgqfY8/L2AozlDAtCQayck32Ctdr5i8LZ16P
         Tnrg==
X-Gm-Message-State: AOAM530Vc6wi5PLEmfcPTrAOyaHV4tIWX0Wk6W9qpDzMjukDup0BfOQj
        3vX5iRV7I5L1Op+nxGt8brFnqTteKWpbkA==
X-Google-Smtp-Source: ABdhPJwcz8Y5CfHPAsfZekp4IqvI4xm/ySjeRI1I9E9GuyrBQw9Hi7qxJEQQc/8CGjp0LEs0BaXeeQ==
X-Received: by 2002:a19:997:: with SMTP id 145mr8093829lfj.588.1610790910957;
        Sat, 16 Jan 2021 01:55:10 -0800 (PST)
Received: from [192.168.1.100] ([178.176.75.157])
        by smtp.gmail.com with ESMTPSA id t17sm1221138lfr.5.2021.01.16.01.55.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Jan 2021 01:55:10 -0800 (PST)
Subject: Re: [PATCH V2 4/4] net: ethernet: ravb: Enable optional refclk
To:     Adam Ford <aford173@gmail.com>, linux-renesas-soc@vger.kernel.org
Cc:     aford@beaconembedded.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210115201953.443710-1-aford173@gmail.com>
 <20210115201953.443710-4-aford173@gmail.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Organization: Brain-dead Software
Message-ID: <ce35708b-34ee-cc0a-3cf7-ff955f14db2d@gmail.com>
Date:   Sat, 16 Jan 2021 12:55:07 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210115201953.443710-4-aford173@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 15.01.2021 23:19, Adam Ford wrote:

> For devices that use a programmable clock for the avb reference clock,

    AVB.

> the driver may need to enable them.  Add code to find the optional clock
> and enable it when available.
> 
> Signed-off-by: Adam Ford <aford173@gmail.com>
[...]
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index bd30505fbc57..739e30f45daa 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -2148,6 +2148,14 @@ static int ravb_probe(struct platform_device *pdev)
>   		goto out_release;
>   	}
>   
> +	priv->refclk = devm_clk_get_optional(&pdev->dev, "refclk");
> +	if (IS_ERR(priv->refclk)) {
> +		error = PTR_ERR(priv->refclk);
> +		goto out_release;
> +	} else {

    No need for *else* after *goto*.

> +		(void)clk_prepare_enable(priv->refclk);

    You can really omit (void)...
    Also, I'm not seeing where do you call clk_disable_unprepare()...

[...]

MBR, Sergei
