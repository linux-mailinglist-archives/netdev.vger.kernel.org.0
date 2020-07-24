Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8520322CC55
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 19:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbgGXRlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 13:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726652AbgGXRk7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 13:40:59 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E19C0619D3;
        Fri, 24 Jul 2020 10:40:59 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id f2so9021888wrp.7;
        Fri, 24 Jul 2020 10:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=S9B43df6SARWSY2yn5Mw8hYQx9HnwxrrN+45ssJMdow=;
        b=h74/M4LXnXYRy1Pf/GOEtCrKDQlOgbnlDLg+8sxiBYIiVRcOWaRq8GwxfbI6C5wKcj
         QZq1QmeKT9i7rzADKBv6S3JWCi5/L6r6YNndOsOTwqNwuN1GpS9Yzfp1d9eaDi5e8FrS
         Pt/yCpcF8/YXzMTn3ErMtIOyMUycHxg335LE5eqcqSmdaOWAWxR//tGhvm5tY/BtMvmB
         DcdlgRcTAMJQcWlLzWWYilXKve1xIIKlHoKVXSkCF6h/+2vThQCg0vD9+YCxbDznFggF
         coP+gZ/GthFalJfa+sxXm1AVESYseSvyAmP/BuJj1cA7KNFP3DN5aRjA1BeG9mEQFTt1
         0lFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=S9B43df6SARWSY2yn5Mw8hYQx9HnwxrrN+45ssJMdow=;
        b=rDEMSg5BkVsVTh03A5OYUjanCZp0SfpVtjCLLvlT9fKbxCEbWTuY2vzRI03v/W/hfs
         h7LP0iXfsbJSxIPa0+fHoMKV4yW5XhiyDfyY0vSUvmcOGQ3vJ1UdZzwSrsKBss1eF5MT
         8GuGTY9kI9+1ertKf15RNieIQv+zaTcGnXrPPOnB7EUtfsQPSbMGOyBeuFWO3rxmq5+O
         min8DDTH+5URd29YZJXxb1cYCvPnfWdqmD65HMd10XLy7WICEt260KxzSEawfKCN/ESq
         l8gKJxA0GmCQfIK1UuRyZ73+mFGeee361Iyxk5E96rhewWRM2E6WdQwAb2wu2TdH7Ziv
         tb5Q==
X-Gm-Message-State: AOAM531mg7l/w+4Tk3j2UNwRZtsm8EK0vi+9Z8wleAWN/2nYhYdJBr2K
        0Z+qpEdGAH7CL2NXxMLOmts=
X-Google-Smtp-Source: ABdhPJxNcAFCW97O2cbJdOXcxSTXX0LYYH8H59BxQgpZKhKdob21ay0VSnX1Hrp9ygvRIHStWEEtuw==
X-Received: by 2002:a5d:4649:: with SMTP id j9mr9052853wrs.270.1595612458236;
        Fri, 24 Jul 2020 10:40:58 -0700 (PDT)
Received: from [10.67.50.75] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id i67sm8105704wma.12.2020.07.24.10.40.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jul 2020 10:40:57 -0700 (PDT)
Subject: Re: [PATCH net-next v3 3/7] net: macb: parse PHY nodes found under an
 MDIO node
To:     Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        robh+dt@kernel.org, alexandre.belloni@bootlin.com,
        ludovic.desroches@microchip.com
References: <20200724105033.2124881-1-codrin.ciubotariu@microchip.com>
 <20200724105033.2124881-4-codrin.ciubotariu@microchip.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <426a15dd-62de-9ffb-baed-c527b9aa9b70@gmail.com>
Date:   Fri, 24 Jul 2020 10:40:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200724105033.2124881-4-codrin.ciubotariu@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/24/20 3:50 AM, Codrin Ciubotariu wrote:
> The MACB embeds an MDIO bus controller. For this reason, the PHY nodes
> were represented as sub-nodes in the MACB node. Generally, the
> Ethernet controller is different than the MDIO controller, so the PHYs
> are probed by a separate MDIO driver. Since adding the PHY nodes directly
> under the ETH node became deprecated, we adjust the MACB driver to look
> for an MDIO node and register the subnode MDIO devices.
> 
> Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
> ---
> 
> Changes in v3:
>  - moved the check for the mdio node at the beginnging of
>    macb_mdiobus_register(). This way, the mdio devices will be probed even
>    if macb is a fixed-link
> 
> Changes in v2:
>  - readded newline removed by mistake;
> 
>  drivers/net/ethernet/cadence/macb_main.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index 89fe7af5e408..cb0b3637651c 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -740,6 +740,16 @@ static int macb_mii_probe(struct net_device *dev)
>  static int macb_mdiobus_register(struct macb *bp)
>  {
>  	struct device_node *child, *np = bp->pdev->dev.of_node;
> +	struct device_node *mdio_node;
> +	int ret;
> +
> +	/* if an MDIO node is present, it should contain the PHY nodes */
> +	mdio_node = of_get_child_by_name(np, "mdio");
> +	if (mdio_node) {
> +		ret = of_mdiobus_register(bp->mii_bus, mdio_node);
> +		of_node_put(mdio_node);
> +		return ret;
> +	}

This does take care of registering the MDIO bus controller when present
as a sub-node, however if you also plan on making use of fixed-link, we
will have already returned.

>  
>  	if (of_phy_is_fixed_link(np))
>  		return mdiobus_register(bp->mii_bus);
> 

Really not sure what this is achieving, because we start off assuming
that we have an OF driven configuration, but later on we register the
MDIO bus with mdiobus_register() (and not of_mdiobus_register()), so no
scanning of the MDIO bus will happen.

How does the driver currently support being provided a fixed-link
property? Should not we at least have this pattern:

         */
        if (of_phy_is_fixed_link(dn)) {
                ret = of_phy_register_fixed_link(dn);
                if (ret)
			return ret;

                priv->phy_dn = dn;
        }

It does not look like you are breaking anything here, because it does
not look like this works at all.
-- 
Florian
