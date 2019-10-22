Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 173C6DFA11
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 03:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730494AbfJVBTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 21:19:49 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33409 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727264AbfJVBTt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 21:19:49 -0400
Received: by mail-pg1-f194.google.com with SMTP id i76so8904772pgc.0
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 18:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=uDSg4A54dsDuaDB2Hw6bY/bN6/PuAXCu2xOrwY7Vw2o=;
        b=yKzrj/oUI66YEzqbB7gcMIAsSxaONvbzK+td4VuVNKvWQyA5kCYO1hVMkBgk/PkDe/
         rsFvYRrpSj7HUAv3OgvOa2CcWz/ahO/SU+6RrGBypsC6XpHtra86gTbiCCwz7fDzHx44
         pJ01irXxg6t+HESS3CKkmmTRHCGdKopAtyyY05lTQb2Puu6ddlC3nsx+7QShxxn5VpwQ
         b5mqSqNNyejvmkpySe4vqg9N+B+Z/kp0j6FtILzx424AzXpfptrOI1RlLLUtqYcfP713
         4YWo0BXP2YcrNpSTQiQy0NUWea3Vm/b1X8eJqlBAUynsmFMAcDL1Fyz9PQ7MNNU+PPcP
         bINw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=uDSg4A54dsDuaDB2Hw6bY/bN6/PuAXCu2xOrwY7Vw2o=;
        b=qisGpOw7C9xYLOOma7zjfc8GPhaNGw1ItxhTs7HDHQpKkUi076p9d68vxFTFXSCO+V
         hFGnHff46OTz8WYdsQjKgWZebMebStuI0q+FlGZq5VSveMsbV/7Yb0unJunX+0zy2h/d
         HnY60FBdxiNGq3Yy9+8HhC6PYLKso5DYUKwmUC3qRCpwU3WeaS2yoqqdti02GyQ8kEzZ
         zw2PPqwfIQC91Qyz69hzdlq1qkA2TXu838Cjt3R+hJWJxtpV18M/2yZMtgoX/hI9e8fA
         1A+dKKiDwwyKO0XwqUTypnPVNfnB+4dKWFTajGNd+7vWPkuoPK6bt17HsAbeV7WYjAXD
         NAEQ==
X-Gm-Message-State: APjAAAUtnrE/v6RvpbPyM+rSpv2xOrcBBi1frZyR6+7WuxNcaOiYWR3H
        Z7mn4L80MzFuLcwnEQT/9zd8yA==
X-Google-Smtp-Source: APXvYqximPmw28QNVTpp1Qa1kdX83fKLpMg6bb7HFZnwYR0dBqvYKWhtQweY5XjKjWZNf+0902K31A==
X-Received: by 2002:a63:5417:: with SMTP id i23mr839710pgb.305.1571707188360;
        Mon, 21 Oct 2019 18:19:48 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id v1sm28267717pfg.26.2019.10.21.18.19.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 18:19:48 -0700 (PDT)
Date:   Mon, 21 Oct 2019 18:19:45 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 05/10] net: ethernet: ixp4xx: Standard module init
Message-ID: <20191021181945.708d3da3@cakuba.netronome.com>
In-Reply-To: <20191021000824.531-6-linus.walleij@linaro.org>
References: <20191021000824.531-1-linus.walleij@linaro.org>
        <20191021000824.531-6-linus.walleij@linaro.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Oct 2019 02:08:19 +0200, Linus Walleij wrote:
> @@ -1376,7 +1365,7 @@ static const struct net_device_ops ixp4xx_netdev_ops = {
>  	.ndo_validate_addr = eth_validate_addr,
>  };
>  
> -static int eth_init_one(struct platform_device *pdev)
> +static int ixp4xx_eth_probe(struct platform_device *pdev)
>  {
>  	struct port *port;
>  	struct net_device *dev;
> @@ -1396,14 +1385,46 @@ static int eth_init_one(struct platform_device *pdev)
>  
>  	switch (port->id) {
>  	case IXP4XX_ETH_NPEA:
> +		/* If the MDIO bus is not up yet, defer probe */
> +		if (!mdio_bus)
> +			return -EPROBE_DEFER;

There's an allocation at the top of this function. All the rest of the
code does goto err_xyz. I don't think you can just return directly here,
or anywhere below.

>  		port->regs = (struct eth_regs __iomem *)IXP4XX_EthA_BASE_VIRT;
>  		regs_phys  = IXP4XX_EthA_BASE_PHYS;
>  		break;
>  	case IXP4XX_ETH_NPEB:
> +		/*
> +		 * On all except IXP43x, NPE-B is used for the MDIO bus.
> +		 * If there is no NPE-B in the feature set, bail out, else
> +		 * register the MDIO bus.
> +		 */
> +		if (!cpu_is_ixp43x()) {
> +			if (!(ixp4xx_read_feature_bits() &
> +			      IXP4XX_FEATURE_NPEB_ETH0))
> +				return -ENODEV;
> +			/* Else register the MDIO bus on NPE-B */
> +			if ((err = ixp4xx_mdio_register(IXP4XX_EthC_BASE_VIRT)))
> +				return err;
> +		}
> +		if (!mdio_bus)
> +			return -EPROBE_DEFER;
>  		port->regs = (struct eth_regs __iomem *)IXP4XX_EthB_BASE_VIRT;
>  		regs_phys  = IXP4XX_EthB_BASE_PHYS;
>  		break;
>  	case IXP4XX_ETH_NPEC:
> +		/*
> +		 * IXP43x lacks NPE-B and uses NPE-C for the MDIO bus access,
> +		 * of there is no NPE-C, no bus, nothing works, so bail out.
> +		 */
> +		if (cpu_is_ixp43x()) {
> +			if (!(ixp4xx_read_feature_bits() &
> +			      IXP4XX_FEATURE_NPEC_ETH))
> +				return -ENODEV;
> +			/* Else register the MDIO bus on NPE-C */
> +			if ((err = ixp4xx_mdio_register(IXP4XX_EthC_BASE_VIRT)))
> +				return err;
> +		}
> +		if (!mdio_bus)
> +			return -EPROBE_DEFER;
>  		port->regs = (struct eth_regs __iomem *)IXP4XX_EthC_BASE_VIRT;
>  		regs_phys  = IXP4XX_EthC_BASE_PHYS;
>  		break;

