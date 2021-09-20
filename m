Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFEF94118EC
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 18:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242284AbhITQMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 12:12:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242267AbhITQMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 12:12:38 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F26BC061762;
        Mon, 20 Sep 2021 09:11:11 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id e7so17856397pgk.2;
        Mon, 20 Sep 2021 09:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rPMpZa96NEA0M8G9+ImT3ZUEkgCGM/b1/dET3teurMA=;
        b=Y1mK/z+w/oM74SpRPnezBrQOmRwTXjt7rRGCyxgbBm6QtC6nVUq93YBsKubFFv8rcD
         YJH1DKh2WkZYdxDirdocFP3mAzjfRC0LaKpnx3NHRWyGPE/dNljX+SqLOCf6xxAN+9CL
         1XYGRbXu1ZBwzKPdASlCgZM9o6yKCrDKpUz9o69yrs+I3CTKs0dxibnt1D9sA/KtpwG3
         VTEkg7b9IHhvmmdWBOMbeaM3FIC6A2/G0bMxhhmIPZ3uHG7wSCGwhjjvsj2oXHnnaQT6
         4orCfpE//LyPGTWThQYJ2wXjMO53kl8IEHazTTZxgjsVbjQA9EDLnxnFuPnPhtt5bB4U
         tiBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rPMpZa96NEA0M8G9+ImT3ZUEkgCGM/b1/dET3teurMA=;
        b=TQmbqtxD8D317SfEo4A+c/a/PC1iFABcs5unfva857IhSLONkykAZspVFkfIyKqCtt
         ggZ0cqfI6PorZDCeJ2/2ebrN3YHYmnoWdglIEfgK5xLyKwCrRb7Qi0KAgfHlxqy4prxd
         OMVWcF2q0F2+8y8kG0pz+dTeP1QPuqBPKHOqcL5P6bgpnxx/GOSQFJyuLhtaKTjBRAlc
         RwhQLdvFr5aYjyBVU6XiZ7qk0ywmQKXI+xdgKHNyqvkwp3rLrzNZsu7PAaOmFOlhADaw
         VbZcdQ0AO3ky50aYQxq/ag7xW+zKYjji6irQRH1Qafz41d84VsvpK13fduMIF6Noa2mf
         dK0A==
X-Gm-Message-State: AOAM532y9MJdNFtXqv1W9HwC6wMJ2bNpqY6w9EPc9KuGZsSQQNs2a2bs
        0gWV1x0gdJSKCBDKgjQA2HE=
X-Google-Smtp-Source: ABdhPJzqCE6FSt4dk3fzvpzxWJ2Ka4RI6uerqMrDYfaANMBfYTfhiOGU+lSmpMrf1NxNBpwV/1VZCg==
X-Received: by 2002:a63:f959:: with SMTP id q25mr24318824pgk.79.1632154270684;
        Mon, 20 Sep 2021 09:11:10 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b20sm14978846pfp.26.2021.09.20.09.11.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Sep 2021 09:11:10 -0700 (PDT)
Subject: Re: [PATCH net-next] net: bgmac: support MDIO described in DT
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20210920123441.9088-1-zajec5@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <168e00d3-f335-4e62-341f-224e79a08558@gmail.com>
Date:   Mon, 20 Sep 2021 09:11:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210920123441.9088-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/20/21 5:34 AM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Check ethernet controller DT node for "mdio" subnode and use it with
> of_mdiobus_register() when present. That allows specifying MDIO and its
> PHY devices in a standard DT based way.
> 
> This is required for BCM53573 SoC support which has an MDIO attached
> switch.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
>  drivers/net/ethernet/broadcom/bgmac-bcma-mdio.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bgmac-bcma-mdio.c b/drivers/net/ethernet/broadcom/bgmac-bcma-mdio.c
> index 6ce80cbcb48e..086739e4f40a 100644
> --- a/drivers/net/ethernet/broadcom/bgmac-bcma-mdio.c
> +++ b/drivers/net/ethernet/broadcom/bgmac-bcma-mdio.c
> @@ -10,6 +10,7 @@
>  
>  #include <linux/bcma/bcma.h>
>  #include <linux/brcmphy.h>
> +#include <linux/of_mdio.h>
>  #include "bgmac.h"
>  
>  static bool bcma_mdio_wait_value(struct bcma_device *core, u16 reg, u32 mask,
> @@ -211,6 +212,7 @@ struct mii_bus *bcma_mdio_mii_register(struct bgmac *bgmac)
>  {
>  	struct bcma_device *core = bgmac->bcma.core;
>  	struct mii_bus *mii_bus;
> +	struct device_node *np;
>  	int err;
>  
>  	mii_bus = mdiobus_alloc();
> @@ -229,7 +231,9 @@ struct mii_bus *bcma_mdio_mii_register(struct bgmac *bgmac)
>  	mii_bus->parent = &core->dev;
>  	mii_bus->phy_mask = ~(1 << bgmac->phyaddr);
>  
> -	err = mdiobus_register(mii_bus);
> +	np = of_get_child_by_name(core->dev.of_node, "mdio");

I believe this leaks np and the use case is not exactly clear to me
here. AFAICT the Northstar SoCs have two MDIO controllers: one for
internal PHYs and one for external PHYs which how you would attach a
switch to the chip (in chipcommonA). Is 53573 somewhat different here?
What is the MDIO bus driver that is being used?
-- 
Florian
