Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAD2E275538
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 12:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgIWKKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 06:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbgIWKKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 06:10:13 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E18C0613CE;
        Wed, 23 Sep 2020 03:10:12 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id e23so26963796eja.3;
        Wed, 23 Sep 2020 03:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Eo/wSw4VIaIgxNkRQAPfjQYoKWETuFA6eRrgAzJ/XHo=;
        b=sojKp23CaX/x5UEyerSOlNDBFebtWUgmFC6eFuTcwwNJ7d7SJso1iRZrB7vS+w6C32
         /G/PecH5ThYjOz59Zv5MTey5MBP5wS7oMWP8fXdc5CqesGf0HZEIUnr94RsSwxvqEI04
         8EuBBgPSCKUwouPToc8fNMb4USiMc7LvI5HUEPRlHcaKXEAlBQuW79PLLOVkkEAApOLV
         tuHHPZT8CmqjGAYBUN/ovQbj66TVXhuczf5NFvkHGPiOrcOLRLrYHcbc+4yzZniv1/tg
         j6Pn3k6Cj7FUFCZpYd9CWb7G05Ms2EkQ8lU5tHUIbsB2NhbHyiNuKxaRSsIYfKIYFtZK
         B4yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Eo/wSw4VIaIgxNkRQAPfjQYoKWETuFA6eRrgAzJ/XHo=;
        b=A0dC5ttg79/UBx3u4fT8iv5zU3olEcLFNHlZnK6K/hfhvjApQz1ZD9D9QeuV4gqdro
         DhHe705x2Ldaqt9e+qf+hnfFJkUocUXm6Be4+iq5gcxqxVBYd7ooD7dL8vMWG+39vbSd
         Wx6zFLdwPcmXw2a+ePcsZMJUJSS8oqEoyJEqfvX0YqyrKCH/VW9u2gCha1bM1RmwxDqI
         537znF+RAk0SQ8zc1yE5XoLRU3LfBWmx/mG3svUet/nFt1wujnYF2vjz2woGVvWnE6rY
         tTKZR/iSeLv4Fwa8RVQV5VbVjVWE8mrKBmkumFiAwcQkSUUlCD2N/q9MLqya6ETobEfQ
         INxA==
X-Gm-Message-State: AOAM5325c8DqSEC19h+ykYzqGW5OQo/UcKj4X0/zSZEOKbNb1EpLiKU1
        yBAe59ChwGqIzJPR1lva9aI=
X-Google-Smtp-Source: ABdhPJy4MFuh2nJ+sqmUw8qLN2KweoxRQYNgVcrUhHzkAb8PmNU9BOQ5xqb5u7GVk1y5wltS0kBxXg==
X-Received: by 2002:a17:906:9389:: with SMTP id l9mr9624357ejx.537.1600855811493;
        Wed, 23 Sep 2020 03:10:11 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:c43a:de91:4527:c1ba? (p200300ea8f235700c43ade914527c1ba.dip0.t-ipconnect.de. [2003:ea:8f23:5700:c43a:de91:4527:c1ba])
        by smtp.googlemail.com with ESMTPSA id r16sm14064588ejb.110.2020.09.23.03.10.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2020 03:10:11 -0700 (PDT)
Subject: Re: [PATCH] net: mdio: Remove redundant parameter and check
To:     Tang Bin <tangbin@cmss.chinamobile.com>, davem@davemloft.net,
        andrew@lunn.ch, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Shengju <zhangshengju@cmss.chinamobile.com>
References: <20200923100532.18452-1-tangbin@cmss.chinamobile.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <860585f8-65a7-3363-18cd-dc398772ba00@gmail.com>
Date:   Wed, 23 Sep 2020 12:10:06 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200923100532.18452-1-tangbin@cmss.chinamobile.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23.09.2020 12:05, Tang Bin wrote:
> In the function ipq8064_mdio_probe(), of_mdiobus_register() might
> returned zero, so the direct return can simplify code. Thus remove
> redundant parameter and check.
> 
> Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
> Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
> ---
>  drivers/net/mdio/mdio-ipq8064.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/mdio/mdio-ipq8064.c b/drivers/net/mdio/mdio-ipq8064.c
> index 1bd1885..33cccce 100644
> --- a/drivers/net/mdio/mdio-ipq8064.c
> +++ b/drivers/net/mdio/mdio-ipq8064.c
> @@ -102,7 +102,6 @@ ipq8064_mdio_probe(struct platform_device *pdev)
>  	struct device_node *np = pdev->dev.of_node;
>  	struct ipq8064_mdio *priv;
>  	struct mii_bus *bus;
> -	int ret;
>  
>  	bus = devm_mdiobus_alloc_size(&pdev->dev, sizeof(*priv));
>  	if (!bus)
> @@ -125,12 +124,9 @@ ipq8064_mdio_probe(struct platform_device *pdev)
>  		return PTR_ERR(priv->base);
>  	}
>  
> -	ret = of_mdiobus_register(bus, np);
> -	if (ret)
> -		return ret;
> -
>  	platform_set_drvdata(pdev, bus);

Before your patch this is called only after of_mdiobus_register()
returns successfully. Now it's called unconditionally before.
Are you sure this can't have a side effect?

> -	return 0;
> +
> +	return of_mdiobus_register(bus, np);
>  }
>  
>  static int
> 

