Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 186A21FFE53
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 00:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731610AbgFRWtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 18:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731210AbgFRWta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 18:49:30 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F1EC06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 15:49:30 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id j4so3109090plk.3
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 15:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AVBbEBwFV5AHc0D3OsXIDDrCNs6C5zeTANXKHBUvRuY=;
        b=nFNGMUPvgNQPRTuxS5D6RzKkH0TCKEoPFFjxptmPrwr1McA1vW0TcGKc+xy7o1/sO3
         KwaHUQ+jexrATilFwOqstK0BemzSSmUhYeJkMqf6SlQ5Pm2E84hBQp9qdy7v6Yoid5h3
         dvBBE/Npl2+cdwlJnQssjnBmZdHOqB7e0CshS8JXZRRIrqoQJUJs7I6geQ8PukZ1CxZl
         EyPe2olwX9IYEiOGbuyjYROLQbb3BJNOcz+wgBWzUu+TXMysNOL8Q8MlP5R2HolNuN2i
         q3tX4DoRWNsgZrwZe94egbpYAr7EdrRUk2JQ/cc2NSHwx78fcNcsWodKKwKSoW/rLU8S
         xzFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AVBbEBwFV5AHc0D3OsXIDDrCNs6C5zeTANXKHBUvRuY=;
        b=l/8rJRp3Atl/UTpZcPS2CtEWZN+hBRHyMmy3ABSg9mRZMUvIioxm/PLpH6rwGHDqoc
         X2fxyOYxI4YHVdwQijBZgHEnOT7VJi9UZ08Qv3P0oy/twmAx7n/2dr6PHlz1njJQHuaC
         yM2rXWUaqalzjC7D6F0+Uh3EWHDNoFN54S7KfA1vAPbrrtax3U7ZhjKOgsPxZ7XKAji/
         BUAmmepYM56Ko84GfFzeSTtEU0Y/WP02sS3LEEO+RERinelNXBvKe8/YyT/hO5tK4JtM
         3q+EDYq8TnJrQfaIasrlvjU88/VLlYT1cdO6Y5Ch5EGTOhJgnVXNvZERfSHnHAB9IOrL
         Jcmg==
X-Gm-Message-State: AOAM53024Wpz4zu6BBUPEE9qrNUI6abZzHJOxbb1IsEbMIkaYTA1uir3
        2DXT1yy+DiiJD1xoBODuNeA=
X-Google-Smtp-Source: ABdhPJz4xR1muoq016E6/3oNRlEMDCadddpTpbJtSVOSJKt9gKJk5cKyv6XbbrzYgqZsoQnR6iwC+Q==
X-Received: by 2002:a17:90a:c003:: with SMTP id p3mr615185pjt.178.1592520569687;
        Thu, 18 Jun 2020 15:49:29 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n1sm3479519pjn.24.2020.06.18.15.49.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2020 15:49:28 -0700 (PDT)
Subject: Re: [PATCH v1 3/3] net/fsl: enable extended scanning in xgmac_mdio
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Cc:     netdev@vger.kernel.org, linux.cj@gmail.com
References: <20200617171536.12014-1-calvin.johnson@oss.nxp.com>
 <20200617171536.12014-4-calvin.johnson@oss.nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5117a9de-f123-8755-434a-b0166088bf5f@gmail.com>
Date:   Thu, 18 Jun 2020 15:49:26 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200617171536.12014-4-calvin.johnson@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/17/2020 10:15 AM, Calvin Johnson wrote:
> From: Jeremy Linton <jeremy.linton@arm.com>
> 
> Since we know the xgmac hardware always has a c45
> complaint bus, lets try scanning for c22 capable
> phys first. If we fail to find any, then it with
> fall back to c45 automatically.

s/complaint/compliant/
s/lets/let's/
s/phys/PHYs/
s/with/will/

> 
> Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> 
> ---
> 
>  drivers/net/ethernet/freescale/xgmac_mdio.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
> index fb7f8caff643..5732ca13b821 100644
> --- a/drivers/net/ethernet/freescale/xgmac_mdio.c
> +++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
> @@ -263,6 +263,7 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
>  	bus->read = xgmac_mdio_read;
>  	bus->write = xgmac_mdio_write;
>  	bus->parent = &pdev->dev;
> +	bus->probe_capabilities = MDIOBUS_C22_C45;
>  	snprintf(bus->id, MII_BUS_ID_SIZE, "%llx", (unsigned long long)res->start);
>  
>  	/* Set the PHY base address */
> 

-- 
Florian
