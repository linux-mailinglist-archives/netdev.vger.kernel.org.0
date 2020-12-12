Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 262FF2D88C9
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 18:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439564AbgLLRzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 12:55:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727514AbgLLRzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 12:55:43 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 662FDC0613CF;
        Sat, 12 Dec 2020 09:55:03 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id a8so19731575lfb.3;
        Sat, 12 Dec 2020 09:55:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t/n/SZO57zH+6NrngqhLDU18rnISd3B9T8WfYcT9OVY=;
        b=Az53OnX215u3j5WV+PfOQiLX82i72LtCP7dvEQ96A8kK3qS8C3Yv4xUDOQWladxXs9
         2SkA373eLzlsNOLBxk4M/73cAVEALP6c9NrqovDL5ZgLf93wbEVJwB+fOjdgbU3d8WLw
         ibdYNObpMFPqCF7iRkEC9uVt5PV6NLsdHDKH5Mf37lkPsn+068an5K7wFCR4Quc221X0
         5a76gyRf8R9oSvTwnuBYqMDBX92VLARbOd2fYRqP6ioFKCvghQhuZB1kTReh1DVcMsCJ
         JYoeb8GDnrBHwj8sQDto795RDI+Kl+FZEBUgUSl1H7A+huK96BUAnoS1RULfbbfam+l1
         B4rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=t/n/SZO57zH+6NrngqhLDU18rnISd3B9T8WfYcT9OVY=;
        b=Y9fnv8rKCnjEaK+yLlO75LSh2rkg0hb3An3AZHrmNmiebX3BaazFGX9lnphUobNl36
         lkPErQVt0CJs/+pwFVrl1M6fdCf7jayiKuXb/0qn/JPwRB0IcZUY7l8Yrbex1i6aJhgH
         iWsbT0Jub98QXJOq/rl/ipyObj2fNQw12UJbfrLoLKkHIChkbg+lZnfFIOWxZRVQsuig
         o8VF8X852b+SaQ1rHGPXAUeMGneJdovvJn4JELOX/5TYngib73KMmmXcqq+4Q0rQeLWq
         h0hgjC3kQ3j+DNW9PIdvrOXwodj/qqDB/m5g8w0EIJPJmM4t67qQ9EFrCrbUGzrH6/5M
         g48g==
X-Gm-Message-State: AOAM532tLO9WY1GelwjKho/89WOcJvC5dcO2J05vrow4gWZ4I4c4xKhd
        z3fRZVftGUaO6tZZaFtOaLSh0u3hkuU=
X-Google-Smtp-Source: ABdhPJz63qGvDMQ6+R7rSAFJUdfoExgTKPuNQY/FDHF03Qjn2z2Y9LdCAD6ipINPbcjxSxfthnxnuw==
X-Received: by 2002:ac2:5691:: with SMTP id 17mr7391498lfr.537.1607795701603;
        Sat, 12 Dec 2020 09:55:01 -0800 (PST)
Received: from [192.168.1.100] ([31.173.85.216])
        by smtp.gmail.com with ESMTPSA id k11sm1353981lfj.170.2020.12.12.09.55.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Dec 2020 09:55:01 -0800 (PST)
Subject: Re: [RFC] ravb: Add support for optional txc_refclk
To:     Adam Ford <aford173@gmail.com>, linux-renesas-soc@vger.kernel.org
Cc:     aford@beaconembedded.com, charles.stevens@logicpd.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201212165648.166220-1-aford173@gmail.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Organization: Brain-dead Software
Message-ID: <7f5f8ef2-3e4f-5076-0558-26b48e75b674@gmail.com>
Date:   Sat, 12 Dec 2020 20:54:58 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201212165648.166220-1-aford173@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 12.12.2020 19:56, Adam Ford wrote:

> The SoC expects the txv_refclk is provided, but if it is provided
> by a programmable clock, there needs to be a way to get and enable
> this clock to operate.  It needs to be optional since it's only
> necessary for those with programmable clocks.
> 
> Signed-off-by: Adam Ford <aford173@gmail.com>
[...]
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index bd30505fbc57..4c3f95923ef2 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -2148,6 +2148,18 @@ static int ravb_probe(struct platform_device *pdev)
>   		goto out_release;
>   	}
>   
> +	priv->ref_clk = devm_clk_get(&pdev->dev, "txc_refclk");

    Why not devm_clk_get_optional()?

> +	if (IS_ERR(priv->ref_clk)) {
> +		if (PTR_ERR(priv->ref_clk) == -EPROBE_DEFER) {
> +			/* for Probe defer return error */
> +			error = PTR_ERR(priv->ref_clk);
> +			goto out_release;
> +		}
> +		/* Ignore other errors since it's optional */
> +	} else {
> +		(void)clk_prepare_enable(priv->ref_clk);
> +	}
> +
>   	ndev->max_mtu = 2048 - (ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN);
>   	ndev->min_mtu = ETH_MIN_MTU;
>   

MBR, Sergei
