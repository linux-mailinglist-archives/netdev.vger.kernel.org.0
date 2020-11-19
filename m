Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3972B9CC2
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 22:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbgKSVLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 16:11:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727083AbgKSVLy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 16:11:54 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 600A4C0613CF;
        Thu, 19 Nov 2020 13:11:54 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id s8so7872766wrw.10;
        Thu, 19 Nov 2020 13:11:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=xAEPwvEPYS3L/+MiZsMsZlySFXVuaEeQYDAWzPYqN7A=;
        b=g30ZQ7KN8bSR+mJ3uM/nbY4IyvBfS1gxQ2jq2c2M8zKyCcrx/wAXRhVKkZhpabupHs
         kHXlb8H3p3FtKKiKc8by8mpkSIvpv7Geg+V4biqYvfX4Mcw5tls8OQ4hMPBAtctPmlEZ
         lUXqP8AsxWxu0kKXDBbep7MP3558PHbPXDYLvhtAJbvTIXHq3ULCxUSaZ3ExNloDbFxF
         mytZFPwJx0p8nhbadSsJ93zJR9TYm1RHqkHjnyA1sR3n+WNTcP0AIrwUKN1dt8g9jn9p
         +X/eCPPY4AQL/c0rnZSxvD4IuvXoY06ZWvRi79i48tOqGxV7BwyGCywts8iVECNn4zwi
         YPWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=xAEPwvEPYS3L/+MiZsMsZlySFXVuaEeQYDAWzPYqN7A=;
        b=pWdXAJyT5477m0iDroeR6DmKfAI7xnaUGI3CHOu/XBf0rj8B2azz0CIkCyki3E1B+M
         jvkBMZVzIZqq+pe3ZO9GFs+5t1lpdTZoHfTQeDRSjEKaQo77JDCEDT0oZCcNHA+JLZGf
         7/8bWomGjKM1d96KaFulYUWz+bQuB9y0cnaqDkm+m1MhaY7cChwWFYxjPPC+vXOPHyj+
         8H/sQBXg925Wxmh+B87vaFTfn3ZGSCxTKVzvdxBwhjVR6eI3pv9gvPMQ+BHa8Up+wmO+
         k3MQ7VOcwVKmW0x62P9pu1iZ38KHi9hf1R6ddpVH79WX4+gsRSnSs15tjbcUIvYiVFoN
         vtFA==
X-Gm-Message-State: AOAM530jUTkIr6YeOXTXs//XAsTnmR8aoCVRFLuHWwhDS+Yum5LIMaV9
        D3OXlrznlRNnnN0xYHVEki1hLTvSsCBkaQ==
X-Google-Smtp-Source: ABdhPJwb0MbUZe7hHtBmimzCBsUQ7dVEKYgxVzrOJRzOxxjOVIsJpnfAlW5feja5QR8SZYmCeIH/Jw==
X-Received: by 2002:adf:a198:: with SMTP id u24mr11389193wru.219.1605820312878;
        Thu, 19 Nov 2020 13:11:52 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:6d7c:9ea3:dfaa:d617? (p200300ea8f2328006d7c9ea3dfaad617.dip0.t-ipconnect.de. [2003:ea:8f23:2800:6d7c:9ea3:dfaa:d617])
        by smtp.googlemail.com with ESMTPSA id z3sm1712237wrw.87.2020.11.19.13.11.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2020 13:11:52 -0800 (PST)
Subject: Re: [PATCH v2] mdio_bus: suppress err message for reset gpio
 EPROBE_DEFER
To:     Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Cc:     linux-kernel@vger.kernel.org
References: <20201119203446.20857-1-grygorii.strashko@ti.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <1a59fbe1-6a5d-81a3-4a86-fa3b5dbfdf8e@gmail.com>
Date:   Thu, 19 Nov 2020 22:11:48 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201119203446.20857-1-grygorii.strashko@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 19.11.2020 um 21:34 schrieb Grygorii Strashko:
> The mdio_bus may have dependencies from GPIO controller and so got
> deferred. Now it will print error message every time -EPROBE_DEFER is
> returned which from:
> __mdiobus_register()
>  |-devm_gpiod_get_optional()
> without actually identifying error code.
> 
> "mdio_bus 4a101000.mdio: mii_bus 4a101000.mdio couldn't get reset GPIO"
> 
> Hence, suppress error message for devm_gpiod_get_optional() returning
> -EPROBE_DEFER case by using dev_err_probe().
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
>  drivers/net/phy/mdio_bus.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index 757e950fb745..83cd61c3dd01 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -546,10 +546,10 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
>  	/* de-assert bus level PHY GPIO reset */
>  	gpiod = devm_gpiod_get_optional(&bus->dev, "reset", GPIOD_OUT_LOW);
>  	if (IS_ERR(gpiod)) {
> -		dev_err(&bus->dev, "mii_bus %s couldn't get reset GPIO\n",
> -			bus->id);
> +		err = dev_err_probe(&bus->dev, PTR_ERR(gpiod),
> +				    "mii_bus %s couldn't get reset GPIO\n", bus->id);

Doesn't checkpatch complain about line length > 80 here?

>  		device_del(&bus->dev);
> -		return PTR_ERR(gpiod);
> +		return err;
>  	} else	if (gpiod) {
>  		bus->reset_gpiod = gpiod;
>  
> 

Last but not least the net or net-next patch annotation is missing.
I'd be fine with treating the change as an improvement (net-next).

Apart from that change looks good to me.
