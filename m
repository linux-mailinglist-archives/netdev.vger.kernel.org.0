Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15BDC1500CB
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 04:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbgBCDoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 22:44:44 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35889 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727088AbgBCDoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Feb 2020 22:44:44 -0500
Received: by mail-pg1-f195.google.com with SMTP id k3so7054970pgc.3;
        Sun, 02 Feb 2020 19:44:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Bbh17m95JWmY2JBmRZ1Ch0/eAxz99uHPB9xMTapYkps=;
        b=orgKLqvl792VkoBuZvUYdoXGgQg/TCaM2r9K9C51bXQJJeUtIQ2ciGXaZP9fCS1Ckw
         gUI3gMTDVnZ2e6DhjMHh/5qkRTJuW7MJ2e3NDfsfvEkGPvTNhBFWfuYQ0Wwc8H/kNplr
         oV37Q7jvD/bUzDDeEpx8O4QcyOtym63jHBAHYzqEdusgXyo8rcixKfxIn6qcn3fb5IOv
         6it0z88lvnGwBl4H+ai58L6xzrSuFrZnlwo8s6jpu6Kb+/n4e9lR7OeeH1a1lWByJAau
         QItn0Z5kmPaL3QkiU30C8Xea6j9pDwY2hyOGTX/kxMt7s5CBFEeLkqXbgM262xF6gJGU
         D1sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Bbh17m95JWmY2JBmRZ1Ch0/eAxz99uHPB9xMTapYkps=;
        b=U3BhZduguRTjrve65041ipxozMGrgnT9K/4YN0/83UuCpIEV3/sKyYBmvdQZfhcX5s
         qFUyN/I2mOHVYHn4CZFHhMkREKp0Thdu38eWg3EFXsxKt4+YLZX1Veam/9JFQU/nItux
         cGDswtLJtT/ZiDcwj6n+H2/jdUHfPC1oS9U3CIDqXZ6vB9oBvRuGyOCz8bHCmiKpHduk
         jSW5oKF9S1ZRSdZrATPpKGaTRZVTKfHrveF4Fi/xG2qYUPZam0pPh+razRUu5sfzox6R
         i3xnA5t9TybxYt7NvXKB1Zgkw72xqGWzcleWf29EuqeCyL65WgeclEWxDY5rzR1taHXs
         FgfA==
X-Gm-Message-State: APjAAAUOxNu9vQglEkTE1wY42vX86jdZrXyw0uexUm1mkEyIjAC8Ct2T
        xjA8tRKJpQW2Z4cuTz1dDrk+F7SP
X-Google-Smtp-Source: APXvYqwZjov/QNR/Rg1ERCafwjwLqgUEap7DQdRyTIwk7wzkSZC1znH7ZpaEhsd+C49DmncXXgsxSA==
X-Received: by 2002:a63:1d1a:: with SMTP id d26mr21949528pgd.98.1580701482997;
        Sun, 02 Feb 2020 19:44:42 -0800 (PST)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id k29sm19397260pfh.77.2020.02.02.19.44.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Feb 2020 19:44:42 -0800 (PST)
Subject: Re: [PATCH v1 3/7] net/fsl: add ACPI support for mdio bus
To:     Calvin Johnson <calvin.johnson@nxp.com>, linux.cj@gmail.com,
        Jon Nettleton <jon@solid-run.com>, linux@armlinux.org.uk,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        cristian.sovaiala@nxp.com, laurentiu.tudor@nxp.com,
        ioana.ciornei@nxp.com, V.Sethi@nxp.com, pankaj.bansal@nxp.com,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>
Cc:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20200131153440.20870-1-calvin.johnson@nxp.com>
 <20200131153440.20870-4-calvin.johnson@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 a9BQwACgnzGuH1BVeT2J0Ra+ZYgkx7DaPR0=
Message-ID: <6501a53b-40aa-5374-3c4a-6b21824f82fd@gmail.com>
Date:   Sun, 2 Feb 2020 19:44:40 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200131153440.20870-4-calvin.johnson@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/31/2020 7:34 AM, Calvin Johnson wrote:
> From: Calvin Johnson <calvin.johnson@oss.nxp.com>
> 
> Add ACPI support for MDIO bus registration while maintaining
> the existing DT support.
> 
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> ---

[snip]

>  	bus = mdiobus_alloc_size(sizeof(struct mdio_fsl_priv));
> @@ -263,25 +265,41 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
>  	bus->read = xgmac_mdio_read;
>  	bus->write = xgmac_mdio_write;
>  	bus->parent = &pdev->dev;
> -	snprintf(bus->id, MII_BUS_ID_SIZE, "%llx", (unsigned long long)res.start);
> +	snprintf(bus->id, MII_BUS_ID_SIZE, "%llx",
> +		 (unsigned long long)res->start);

You could omit this clean up change.

>  
>  	/* Set the PHY base address */
>  	priv = bus->priv;
> -	priv->mdio_base = of_iomap(np, 0);
> +	priv->mdio_base = devm_ioremap_resource(&pdev->dev, res);
>  	if (!priv->mdio_base) {

This probably needs to become IS_ERR() instead of a plain NULL check

>  		ret = -ENOMEM;
>  		goto err_ioremap;
>  	}
>  
> -	priv->is_little_endian = of_property_read_bool(pdev->dev.of_node,
> -						       "little-endian");
> -
> -	priv->has_a011043 = of_property_read_bool(pdev->dev.of_node,
> -						  "fsl,erratum-a011043");
> -
> -	ret = of_mdiobus_register(bus, np);
> -	if (ret) {
> -		dev_err(&pdev->dev, "cannot register MDIO bus\n");
> +	if (is_of_node(pdev->dev.fwnode)) {
> +		priv->is_little_endian = of_property_read_bool(pdev->dev.of_node,
> +							       "little-endian");
> +
> +		priv->has_a011043 = of_property_read_bool(pdev->dev.of_node,
> +							  "fsl,erratum-a011043");
> +
> +		ret = of_mdiobus_register(bus, np);
> +		if (ret) {
> +			dev_err(&pdev->dev, "cannot register MDIO bus\n");
> +			goto err_registration;
> +		}
> +	} else if (is_acpi_node(pdev->dev.fwnode)) {
> +		priv->is_little_endian =
> +			fwnode_property_read_bool(pdev->dev.fwnode,
> +						  "little-endian");
> +		ret = fwnode_mdiobus_register(bus, pdev->dev.fwnode);
> +		if (ret) {
> +			dev_err(&pdev->dev, "cannot register MDIO bus\n");
> +			goto err_registration;
> +		}

The little-endian property read can be moved out of the DT/ACPI paths
and you can just use device_property_read_bool() for that purpose.
Having both fwnode_mdiobus_register() and of_mdiobus_register() looks
fairly redundant, you could quite easily introduce a wrapper:
device_mdiobus_register() which internally takes the appropriate DT/ACPI
paths as needed.
-- 
Florian
