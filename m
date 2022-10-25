Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48FF460CEE4
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 16:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbiJYOYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 10:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232574AbiJYOYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 10:24:01 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C81109D50
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 07:23:59 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id f22so7588848qto.3
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 07:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aEerMWHyvmyU5PYfWpEtRfJuOuQqMGt3PGGVgLgFm8Y=;
        b=I9wqFvxwIH2Y3eZ4ilZB/C85HRZyQ8TtJ6YDvcsgd+sva/U/KyF9KaixVU51fszRXF
         /NuKYz+CtfA8b6gKjspzLUK3CsLEFXFMofoQ7Rw63aOAbY3USvVrPSTdu+tZ2gvI7qbT
         sWmdqBTOpveyU960QOKhSnisWSb+AEt31D6UDLT66C0eQfooNj/B8akxLtMQraJc2nXg
         /UY84C0u7PAnUx2JC8bWxOKw86UoGxAWsQ9Pta6iItEB6x5cUtfzDUm4gdFt6pvleNyk
         26FAhZIJXYMKinV8AzkN5+NsFIdBQVIpP2QezTBaJJ7Y5wgD1SlX+VwT0Npkl2jvilVr
         ZgJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aEerMWHyvmyU5PYfWpEtRfJuOuQqMGt3PGGVgLgFm8Y=;
        b=0uD+jwsnN/1qbXikQMNnH1Oe9kcwevnMynzWaCv/2NLOvNGb66jm/br5MBDfxqfxVM
         Y31EVnMdOLdw/F+L+R4kwEpE8NCQxRgj537qNMBvXwomnahop8q424iAhN2LkWhP1Zbb
         hTEy6+Uv6IWU12sZi3D3ekA+3KBeTN7ZW1cToJHQveBw07vzipkCqLY+09o9FD4xxlt6
         N66TJmN1TjS+ZZzmDt5j0+EyH4Gh8LCaptsCPwkbgn6asRqdCcUOwMtsSMFoDolOZiXS
         2bg0Ine4rfZOK+pTWKlsLVKR2C1iw1q1FURn7XS70PiYSD9rri5NUDySq64dJrPlUd6A
         ZLKQ==
X-Gm-Message-State: ACrzQf2aVSwzA6g+06tM1DqJuWuZLOhb8s7kXnPPQhCFeu1d7aw+ufhW
        BxyBeAFOfWiBEyr/2zHRSjXYCQ==
X-Google-Smtp-Source: AMsMyM5V3SML4r6N4Nls3J7kaJMXqe96oAidLnzfadTvAeW2WWMtx5Y0SSUqCyqnSPIANDPchx2hzw==
X-Received: by 2002:a05:622a:40d:b0:397:bd61:ef1d with SMTP id n13-20020a05622a040d00b00397bd61ef1dmr32728619qtx.404.1666707838570;
        Tue, 25 Oct 2022 07:23:58 -0700 (PDT)
Received: from [192.168.1.11] ([64.57.193.93])
        by smtp.gmail.com with ESMTPSA id fy14-20020a05622a5a0e00b0039ccd7a0e10sm1639173qtb.62.2022.10.25.07.23.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Oct 2022 07:23:57 -0700 (PDT)
Message-ID: <d942c724-4520-4a7b-8c36-704032c68a36@linaro.org>
Date:   Tue, 25 Oct 2022 10:23:55 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [RFC net-next 2/2] net: dsa: Add driver for Maxlinear GSW1XX
 switch
Content-Language: en-US
To:     Camel Guo <camel.guo@axis.com>, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Rob Herring <robh@kernel.org>,
        kernel@axis.com
References: <20221025135243.4038706-1-camel.guo@axis.com>
 <20221025135243.4038706-3-camel.guo@axis.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221025135243.4038706-3-camel.guo@axis.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/10/2022 09:52, Camel Guo wrote:
> Add initial framework for Maxlinear's GSW1xx switch and
> currently only GSW145 in MDIO managed mode is supported.
> 
> Signed-off-by: Camel Guo <camel.guo@axis.com>
> ---

(...)

> +	priv->ds->dev = dev;
> +	priv->ds->num_ports = priv->hw_info->max_ports;
> +	priv->ds->priv = priv;
> +	priv->ds->ops = &gsw1xx_switch_ops;
> +	priv->dev = dev;
> +	version = gsw1xx_switch_r(priv, GSW1XX_IP_VERSION);
> +
> +	np = dev->of_node;
> +	switch (version) {
> +	case GSW1XX_IP_VERSION_2_3:
> +		if (!of_device_is_compatible(np, "mxl,gsw145-mdio"))
> +			return -EINVAL;
> +		break;
> +	default:
> +		dev_err(dev, "unknown GSW1XX_IP version: 0x%x", version);
> +		return -ENOENT;
> +	}
> +
> +	/* bring up the mdio bus */
> +	mdio_np = of_get_child_by_name(np, "mdio");
> +	if (!mdio_np) {
> +		dev_err(dev, "missing child mdio node\n");
> +		return -EINVAL;
> +	}
> +
> +	err = gsw1xx_mdio(priv, mdio_np);
> +	if (err) {
> +		dev_err(dev, "mdio probe failed\n");

dev_err_probe()

> +		goto put_mdio_node;
> +	}
> +
> +	err = dsa_register_switch(priv->ds);
> +	if (err) {
> +		dev_err(dev, "dsa switch register failed: %i\n", err);


dev_err_probe()

> +		goto mdio_bus;
> +	}
> +	if (!dsa_is_cpu_port(priv->ds, priv->hw_info->cpu_port)) {
> +		dev_err(dev,
> +			"wrong CPU port defined, HW only supports port: %i",
> +			priv->hw_info->cpu_port);
> +		err = -EINVAL;
> +		goto disable_switch;
> +	}
> +
> +	dev_set_drvdata(dev, priv);
> +
> +	return 0;
> +
> +disable_switch:
> +	gsw1xx_mdio_mask(priv, GSW1XX_MDIO_GLOB_ENABLE, 0, GSW1XX_MDIO_GLOB);
> +	dsa_unregister_switch(priv->ds);
> +mdio_bus:
> +	if (mdio_np) {
> +		mdiobus_unregister(priv->ds->slave_mii_bus);
> +		mdiobus_free(priv->ds->slave_mii_bus);
> +	}
> +put_mdio_node:
> +	of_node_put(mdio_np);
> +	return err;
> +}
> +EXPORT_SYMBOL(gsw1xx_probe);
> +
> +void gsw1xx_remove(struct gsw1xx_priv *priv)
> +{
> +	if (!priv)
> +		return;
> +
> +	/* disable the switch */
> +	gsw1xx_mdio_mask(priv, GSW1XX_MDIO_GLOB_ENABLE, 0, GSW1XX_MDIO_GLOB);
> +
> +	dsa_unregister_switch(priv->ds);
> +
> +	if (priv->ds->slave_mii_bus) {
> +		mdiobus_unregister(priv->ds->slave_mii_bus);
> +		of_node_put(priv->ds->slave_mii_bus->dev.of_node);
> +		mdiobus_free(priv->ds->slave_mii_bus);
> +	}
> +
> +	dev_set_drvdata(priv->dev, NULL);
> +}
> +EXPORT_SYMBOL(gsw1xx_remove);
> +
> +void gsw1xx_shutdown(struct gsw1xx_priv *priv)
> +{
> +	if (!priv)
> +		return;
> +
> +	/* disable the switch */
> +	gsw1xx_mdio_mask(priv, GSW1XX_MDIO_GLOB_ENABLE, 0, GSW1XX_MDIO_GLOB);
> +
> +	dsa_switch_shutdown(priv->ds);
> +
> +	dev_set_drvdata(priv->dev, NULL);
> +}
> +EXPORT_SYMBOL(gsw1xx_shutdown);

1. EXPORT_SYMBOL_GPL
2. Why do you do it in the first place? It's one driver, no need for
building two modules. Same applies to other places.

> +
> +static const struct regmap_range gsw1xx_valid_regs[] = {
> +	/* GSWIP Core Registers */
> +	regmap_reg_range(GSW1XX_IP_BASE_ADDR,
> +			 GSW1XX_IP_BASE_ADDR + GSW1XX_IP_REG_LEN),
> +	/* Top Level PDI Registers, MDIO Master Reigsters */
> +	regmap_reg_range(GSW1XX_MDIO_BASE_ADDR,
> +			 GSW1XX_MDIO_BASE_ADDR + GSW1XX_MDIO_REG_LEN),
> +};
> +
> +const struct regmap_access_table gsw1xx_register_set = {
> +	.yes_ranges = gsw1xx_valid_regs,
> +	.n_yes_ranges = ARRAY_SIZE(gsw1xx_valid_regs),
> +};
> +EXPORT_SYMBOL(gsw1xx_register_set);
> +
> +MODULE_AUTHOR("Camel Guo <camel.guo@axis.com>");
> +MODULE_DESCRIPTION("Core Driver for MaxLinear GSM1XX ethernet switch");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/net/dsa/gsw1xx_mdio.c b/drivers/net/dsa/gsw1xx_mdio.c
> new file mode 100644
> index 000000000000..8328001041ed
> --- /dev/null
> +++ b/drivers/net/dsa/gsw1xx_mdio.c
> @@ -0,0 +1,128 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * MaxLinear switch driver for GSW1XX in MDIO managed mode
> + */
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/mdio.h>
> +#include <linux/phy.h>
> +#include <linux/of.h>
> +
> +#include "gsw1xx.h"
> +
> +#define GSW1XX_SMDIO_TARGET_BASE_ADDR_REG	0x1F
> +
> +static int gsw1xx_mdio_write(void *ctx, uint32_t reg, uint32_t val)
> +{
> +	struct mdio_device *mdiodev = (struct mdio_device *)ctx;
> +	int ret = 0;
> +
> +	mutex_lock_nested(&mdiodev->bus->mdio_lock, MDIO_MUTEX_NESTED);
> +
> +	ret = mdiodev->bus->write(mdiodev->bus, mdiodev->addr,
> +				  GSW1XX_SMDIO_TARGET_BASE_ADDR_REG, reg);
> +	if (ret < 0)
> +		goto out;
> +
> +	ret = mdiodev->bus->write(mdiodev->bus, mdiodev->addr, 0, val);
> +
> +out:
> +	mutex_unlock(&mdiodev->bus->mdio_lock);
> +
> +	return ret;
> +}
> +
> +static int gsw1xx_mdio_read(void *ctx, uint32_t reg, uint32_t *val)
> +{
> +	struct mdio_device *mdiodev = (struct mdio_device *)ctx;
> +	int ret = 0;
> +
> +	mutex_lock_nested(&mdiodev->bus->mdio_lock, MDIO_MUTEX_NESTED);
> +
> +	ret = mdiodev->bus->write(mdiodev->bus, mdiodev->addr,
> +				  GSW1XX_SMDIO_TARGET_BASE_ADDR_REG, reg);
> +	if (ret < 0)
> +		goto out;
> +
> +	*val = mdiodev->bus->read(mdiodev->bus, mdiodev->addr, 0);
> +
> +out:
> +	mutex_unlock(&mdiodev->bus->mdio_lock);
> +
> +	return ret;
> +}
> +
> +static const struct regmap_config gsw1xx_mdio_regmap_config = {
> +	.reg_bits = 16,
> +	.val_bits = 16,
> +	.reg_stride = 1,
> +
> +	.disable_locking = true,
> +
> +	.volatile_table = &gsw1xx_register_set,
> +	.wr_table = &gsw1xx_register_set,
> +	.rd_table = &gsw1xx_register_set,
> +
> +	.reg_read = gsw1xx_mdio_read,
> +	.reg_write = gsw1xx_mdio_write,
> +
> +	.cache_type = REGCACHE_NONE,
> +};
> +
> +static int gsw1xx_mdio_probe(struct mdio_device *mdiodev)
> +{
> +	struct gsw1xx_priv *priv;
> +	struct device *dev = &mdiodev->dev;
> +	int ret;
> +
> +	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	priv->regmap = devm_regmap_init(dev, NULL, mdiodev,
> +					&gsw1xx_mdio_regmap_config);
> +	if (IS_ERR(priv->regmap)) {
> +		ret = PTR_ERR(priv->regmap);
> +		dev_err(dev, "regmap init failed: %d\n", ret);
> +		return ret;

return dev_err_probe().

> +	}
> +
> +	return gsw1xx_probe(priv, dev);
> +}
> +
> +static void gsw1xx_mdio_remove(struct mdio_device *mdiodev)
> +{
> +	gsw1xx_remove(dev_get_drvdata(&mdiodev->dev));
> +}
> +
> +static void gsw1xx_mdio_shutdown(struct mdio_device *mdiodev)
> +{
> +	gsw1xx_shutdown(dev_get_drvdata(&mdiodev->dev));
> +}
> +
> +static const struct gsw1xx_hw_info gsw145_hw_info = {
> +	.max_ports = 6,
> +	.cpu_port = 5,
> +};
> +
> +static const struct of_device_id gsw1xx_mdio_of_match[] = {
> +	{ .compatible = "mxl,gsw145-mdio", .data = &gsw145_hw_info },
> +	{ /* sentinel */ },
> +};
> +MODULE_DEVICE_TABLE(of, gsw1xx_mdio_of_match);
> +
> +static struct mdio_driver gsw1xx_mdio_driver = {
> +	.probe  = gsw1xx_mdio_probe,
> +	.remove = gsw1xx_mdio_remove,
> +	.shutdown = gsw1xx_mdio_shutdown,
> +	.mdiodrv.driver = {
> +		.name = "GSW1XX_MDIO",
> +		.of_match_table = of_match_ptr(gsw1xx_mdio_of_match),

of_match_ptr requires maybe_unused. Or just drop it.

Best regards,
Krzysztof

