Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11A57234B1A
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 20:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387794AbgGaScg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 14:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730040AbgGaScg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 14:32:36 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F16C2C061574;
        Fri, 31 Jul 2020 11:32:35 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id x9so33423986ljc.5;
        Fri, 31 Jul 2020 11:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=z/X7ymWwjbiuttKuTYyJMhSDfwg3TIeBUOgJd6KkalM=;
        b=AX4AUm3mdEABluzCIEY3WtfZ0tKfRF61z2mag875alovsfWKuMVGE1IuvLAXdiHHNS
         hCbybzfoIipZwEtjFuypnm8Y+56wmZL/to7xeE9USfDoJ+J5N/E7aPWV+CjQTF+yEYq3
         MLEC3ZqTUX2/GgiRmbScc28YV9utq41eUmSc92aVDaCA/FG5lNkHYkNrn0dhYZhfZo6t
         1+HDDrf+DcROAuadG286dLspIWiuAjFe+FpzTr1HE7xA4qZdpn8CcahhffqCIZUmcWqa
         3Le9aGLbkMjPM2V4BWGnEZ6W1qjninoKDdo78dm4eiQSilN/WSgWi39TWNa1mGcvempG
         S/vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z/X7ymWwjbiuttKuTYyJMhSDfwg3TIeBUOgJd6KkalM=;
        b=M8lZwitybw2b/QMYf5kapXE4WcqzsSvRoI+ssG1Z3CP0Ci8XE09yXBXVqSP8StGdkW
         4KzwIAmyhlnQtSImpalOaHAECR7xAWyg7UmUhpbzgUlryPThR7IOay2YNBARmqAcBQZu
         NwCPy9w2EvTE7ZpHEh0A7gYvq1v1q7mvpyaF6fQh0v6ajQrgmQcQEVkMQ2Q8uOtrbKOp
         8jod9kOGXuaWbm5hSYGUi6/xODid2TxzqQSPBxWmr29TC1UaYgsyQy+OXYZLsPufdtqz
         k0SvFHz+IytPsAnka+3WztCRcBueHbAa8u892IvYs3J+lxMX310EeSrX5FFUK6bwEo1q
         bhLQ==
X-Gm-Message-State: AOAM530vxWQDIMcbIMwphslfdVB5qaUEg9X+VwD7UBGwJcddZiJkk6ZE
        LRWwCODx3O7FCDfyuJWr/0g=
X-Google-Smtp-Source: ABdhPJwzh+LluJn2U/eWVgL6CKU6fHX8VJvv3t8EIF+ICEXQ7MIYYp0q9CVuXdPocDJoXstngFLOkg==
X-Received: by 2002:a2e:9c92:: with SMTP id x18mr2213457lji.70.1596220354441;
        Fri, 31 Jul 2020 11:32:34 -0700 (PDT)
Received: from wasted.omprussia.ru ([2a00:1fa0:225:dc3:11c8:9b9e:ad39:92d0])
        by smtp.gmail.com with ESMTPSA id s2sm1816717ljg.84.2020.07.31.11.32.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2020 11:32:33 -0700 (PDT)
Subject: Re: [PATCH v2] ravb: Fixed the problem that rmmod can not be done
To:     Yuusuke Ashizuka <ashiduka@fujitsu.com>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
References: <20200730035649.5940-1-ashiduka@fujitsu.com>
 <20200730100151.7490-1-ashiduka@fujitsu.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <0e7d72fe-ea70-612c-7a50-ad1ff905ddf4@gmail.com>
Date:   Fri, 31 Jul 2020 21:32:32 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200730100151.7490-1-ashiduka@fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/30/20 1:01 PM, Yuusuke Ashizuka wrote:

   CCing DaveM (as you should have done from the start)...

> ravb is a module driver, but I cannot rmmod it after insmod it.
> ravb does mdio_init() at the time of probe, and module->refcnt is incremented
> by alloc_mdio_bitbang() called after that.
> Therefore, even if ifup is not performed, the driver is in use and rmmod cannot
> be performed.
> 
> $ lsmod
> Module                  Size  Used by

   Did you also build mdio-bitbang.c as a module? For the in-kernal driver, not
being able to rmmod the 'ravb' one sounds logical. :-)

> ravb                   40960  1
> $ rmmod ravb
> rmmod: ERROR: Module ravb is in use
> 
> Fixed to execute mdio_init() at open and free_mdio() at close, thereby rmmod is

    Call ravb_mdio_init() at open and free_mdio_bitbang() at close.

> possible in the ifdown state.

Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")

> Signed-off-by: Yuusuke Ashizuka <ashiduka@fujitsu.com>

Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>

[...]
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index 99f7aae102ce..df89d09b253e 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -1342,6 +1342,51 @@ static inline int ravb_hook_irq(unsigned int irq, irq_handler_t handler,
>  	return error;
>  }
>  
> +/* MDIO bus init function */
> +static int ravb_mdio_init(struct ravb_private *priv)
> +{
> +	struct platform_device *pdev = priv->pdev;
> +	struct device *dev = &pdev->dev;
> +	int error;
> +
> +	/* Bitbang init */
> +	priv->mdiobb.ops = &bb_ops;
> +
> +	/* MII controller setting */
> +	priv->mii_bus = alloc_mdio_bitbang(&priv->mdiobb);
> +	if (!priv->mii_bus)
> +		return -ENOMEM;
> +
> +	/* Hook up MII support for ethtool */
> +	priv->mii_bus->name = "ravb_mii";
> +	priv->mii_bus->parent = dev;
> +	snprintf(priv->mii_bus->id, MII_BUS_ID_SIZE, "%s-%x",
> +		 pdev->name, pdev->id);
> +
> +	/* Register MDIO bus */
> +	error = of_mdiobus_register(priv->mii_bus, dev->of_node);
> +	if (error)
> +		goto out_free_bus;
> +
> +	return 0;
> +
> +out_free_bus:
> +	free_mdio_bitbang(priv->mii_bus);
> +	return error;
> +}
> +
> +/* MDIO bus release function */
> +static int ravb_mdio_release(struct ravb_private *priv)
> +{
> +	/* Unregister mdio bus */
> +	mdiobus_unregister(priv->mii_bus);
> +
> +	/* Free bitbang info */
> +	free_mdio_bitbang(priv->mii_bus);
> +
> +	return 0;
> +}
> +
[...]
> @@ -1887,51 +1942,6 @@ static const struct net_device_ops ravb_netdev_ops = {
>  	.ndo_set_features	= ravb_set_features,
>  };
>  
> -/* MDIO bus init function */
> -static int ravb_mdio_init(struct ravb_private *priv)
> -{
> -	struct platform_device *pdev = priv->pdev;
> -	struct device *dev = &pdev->dev;
> -	int error;
> -
> -	/* Bitbang init */
> -	priv->mdiobb.ops = &bb_ops;
> -
> -	/* MII controller setting */
> -	priv->mii_bus = alloc_mdio_bitbang(&priv->mdiobb);
> -	if (!priv->mii_bus)
> -		return -ENOMEM;
> -
> -	/* Hook up MII support for ethtool */
> -	priv->mii_bus->name = "ravb_mii";
> -	priv->mii_bus->parent = dev;
> -	snprintf(priv->mii_bus->id, MII_BUS_ID_SIZE, "%s-%x",
> -		 pdev->name, pdev->id);
> -
> -	/* Register MDIO bus */
> -	error = of_mdiobus_register(priv->mii_bus, dev->of_node);
> -	if (error)
> -		goto out_free_bus;
> -
> -	return 0;
> -
> -out_free_bus:
> -	free_mdio_bitbang(priv->mii_bus);
> -	return error;
> -}
> -
> -/* MDIO bus release function */
> -static int ravb_mdio_release(struct ravb_private *priv)
> -{
> -	/* Unregister mdio bus */
> -	mdiobus_unregister(priv->mii_bus);
> -
> -	/* Free bitbang info */
> -	free_mdio_bitbang(priv->mii_bus);
> -
> -	return 0;
> -}
> -

   Dave, would you tolerate the forward declarations here instead (to avoid the function moves, to be later
done in the net-next tree)?

[...]

MBR, Sergei
