Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8203A2B9297
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 13:33:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727216AbgKSMaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 07:30:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgKSMaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 07:30:16 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0228C0613CF;
        Thu, 19 Nov 2020 04:30:15 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id w24so6600680wmi.0;
        Thu, 19 Nov 2020 04:30:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=QlqkN556Z49lQcx0JT0IHaJ4dDGmyG5HBtei0m8ZDK0=;
        b=uWKXMulA/l2HDQwFoxDoO0K+E4/PnXJoCvDZy0KJ/f/jfwMuAHQS0w5NZnBMnYW28T
         i2CTXqH4/TYe/RXPJa2lQMPd6SkC5SRKWNLepdma2rhbkOeFGcb2SLH2GC8Nur94ptmn
         u0OidKFo47z1P0Hk044BkMENkjasROBW0y83zizTmL7LTW0rKShdNkR78W4rdQdWm5rE
         jdESRO56vLcwtmjAEvrRqtsGECDehFfIzqVEbzjZg7kzKQrTNe+4wqebK+MMgH0aLPMK
         r8dQCSTOOd6CSQamlNeY0pnwPYea8BA/Wn3niLk8z61yLNAbJZ/9Tu6yI+WoflKT8hGQ
         NWvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=QlqkN556Z49lQcx0JT0IHaJ4dDGmyG5HBtei0m8ZDK0=;
        b=P9IGWo0HleE+AvLtb7ZbP6LdQURGUf9Grk5uOmLTD8s+MEgUAf8fMYRffyw8BmVE7Q
         H3bTmXf+nmKo6GrZ0rH6+QpvRvQSYTd+WhTN12I1NSNiPgUzjqtOfBMF94g6pj3sT6rE
         AXM7fvyIt44yA3/Y9nIS3lIfwbzUEAzeyw97/1rC5EVtzdWu4RwwHOxvUgNiLqqZX8Bz
         ip6lalb65jPQuqad7bZygjrZYK6O2FPt1LZ38JK/KaTsR/P95/ajGzapb5mIx72v/j0o
         8xKBGk5gdgJ2gqMEh+p77O6uHSKpL6tqgKuSBEpQfayUp8CqsLAoDUTWGlvwG2InyNU7
         phgA==
X-Gm-Message-State: AOAM530LUR2sOHg0mN/i3B0uEXfWbEbH6inQYGNo8/fwDFH+thFnz3qC
        43eSnhrqmyQvnbRJxTvy2iASYsYkpVD2Aw==
X-Google-Smtp-Source: ABdhPJwn42w0d1UXsMoJq025+Vw8IYfhyncqwDJfPhvbaBFx+yDmHU+m6exFyEM3E0+LTM7RdKeSNw==
X-Received: by 2002:a1c:4909:: with SMTP id w9mr4271659wma.15.1605789014302;
        Thu, 19 Nov 2020 04:30:14 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:180e:21bb:3b0d:82c8? (p200300ea8f232800180e21bb3b0d82c8.dip0.t-ipconnect.de. [2003:ea:8f23:2800:180e:21bb:3b0d:82c8])
        by smtp.googlemail.com with ESMTPSA id h20sm9012300wmb.29.2020.11.19.04.30.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2020 04:30:13 -0800 (PST)
Subject: Re: [PATCH] mdio_bus: suppress err message for reset gpio
 EPROBE_DEFER
To:     Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Cc:     linux-kernel@vger.kernel.org
References: <20201118142426.25369-1-grygorii.strashko@ti.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <0329ed05-371b-0bb5-4f85-75ecaff6a70b@gmail.com>
Date:   Thu, 19 Nov 2020 13:30:09 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201118142426.25369-1-grygorii.strashko@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 18.11.2020 um 15:24 schrieb Grygorii Strashko:
> The mdio_bus may have dependencies from GPIO controller and so got
> deferred. Now it will print error message every time -EPROBE_DEFER is
> returned from:
> __mdiobus_register()
>  |-devm_gpiod_get_optional()
> without actually identifying error code.
> 
> "mdio_bus 4a101000.mdio: mii_bus 4a101000.mdio couldn't get reset GPIO"
> 
> Hence, suppress error message when devm_gpiod_get_optional() returning
> -EPROBE_DEFER case.
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
>  drivers/net/phy/mdio_bus.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index 757e950fb745..54fc13043656 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -546,10 +546,11 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
>  	/* de-assert bus level PHY GPIO reset */
>  	gpiod = devm_gpiod_get_optional(&bus->dev, "reset", GPIOD_OUT_LOW);
>  	if (IS_ERR(gpiod)) {
> -		dev_err(&bus->dev, "mii_bus %s couldn't get reset GPIO\n",
> -			bus->id);
> +		err = PTR_ERR(gpiod);
> +		if (err != -EPROBE_DEFER)
> +			dev_err(&bus->dev, "mii_bus %s couldn't get reset GPIO %d\n", bus->id, err);
>  		device_del(&bus->dev);
> -		return PTR_ERR(gpiod);
> +		return err;
>  	} else	if (gpiod) {
>  		bus->reset_gpiod = gpiod;
>  
> 

Using dev_err_probe() here would simplify the code.
