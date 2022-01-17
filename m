Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBC04900C7
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 05:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234179AbiAQEW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 23:22:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232806AbiAQEW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jan 2022 23:22:58 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F039C061574
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 20:22:58 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id 133so5432342pgb.0
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 20:22:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=QN5XI1Rk67R44oN4m9FHTcTJdk9nxyw7rPhCMjSqoCY=;
        b=bJUzOJs/ScWdyY2vCQP8NL8RLCDeQRn9NJIxpYaHeuECQdaPo0V53/gFnJajINDB2f
         mhvHGvDEnq9RWoFq6+RkBhIbwUrrHGnTNmRB51CD8Mn7F0+DeLpjd+ainQjCge0XRcAf
         BbscV2zX6Ls0y4eLey+BrB3g5VFmz0yK+jvfYiHIiHj29LnJyCMOY0wK+EF1DCQk3ZvE
         Ap9fALMrk2Ee4BFmxRxWyVYRp63yKZFyPeITXQArAa3lDMq+EWRlTi5MHzXFbRDa9FFE
         BR9+dESguCw26Mv6n5Ifo5cbDjBwM6GhpyK0KFeDc/mWOv1gPR7cvQFYxVh4cFd8E5LZ
         jE3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QN5XI1Rk67R44oN4m9FHTcTJdk9nxyw7rPhCMjSqoCY=;
        b=pmF24SIb7vNu4O7twRjrtGEtY8o12fPL85iAr1LQ6UzsFZ+thaONtaCnH3dagv7dY0
         FViJNduAMhaRB4ATpnN/5I6cgcEiRpJr64Ma8Ep7SdhvRYxXUvUuXqMv9qfz/FfkLJRI
         My+wQsZ/orHUSfq+W9aRfPv1awlgUmXpQfj7Xq5hkBENkDeHdAzSdKKHIfvKouaVikHc
         MxLxvMLcYbvX41TSZDA16/fUIrDCApC9TBjYWIfsuqYhZbhN8FssNZLs8iEcMUoarid8
         36PbnHgbuKi4QMgJTS6rBa/3TDfx0m7Ol8xsfBFKEL7k/b97cdVjCn0d4UfMhu18zazK
         /EdQ==
X-Gm-Message-State: AOAM533Z1f4HerqLJCrSQtsZgiBS/Ea2KbfCTnYcylrP8kaj/u56HS3J
        zJ27p5ByZnF6B3yjC8C7tQ0KxYaUHO8=
X-Google-Smtp-Source: ABdhPJyfv4t9gWI2/3m5eR3vPv0ZzN8B7+BQR5NVAWwBYW2eDE2JeaK/8oKBnq2pMf15mtYwwUm/4g==
X-Received: by 2002:a65:66c5:: with SMTP id c5mr8964106pgw.126.1642393377449;
        Sun, 16 Jan 2022 20:22:57 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:10a9:f333:2ba1:b094? ([2600:8802:b00:4a48:10a9:f333:2ba1:b094])
        by smtp.gmail.com with ESMTPSA id a5sm1515526pgn.77.2022.01.16.20.22.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Jan 2022 20:22:56 -0800 (PST)
Message-ID: <feaf03db-6fb9-d79f-0f51-bbedca739785@gmail.com>
Date:   Sun, 16 Jan 2022 20:22:55 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v4 06/11] net: dsa: realtek: add new mdio
 interface for drivers
Content-Language: en-US
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        frank-w@public-files.de
References: <20220105031515.29276-1-luizluca@gmail.com>
 <20220105031515.29276-7-luizluca@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220105031515.29276-7-luizluca@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/4/2022 7:15 PM, Luiz Angelo Daros de Luca wrote:
> This driver is a mdio_driver instead of a platform driver (like
> realtek-smi).
> 
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---
>   drivers/net/dsa/realtek/Kconfig        |  11 +-
>   drivers/net/dsa/realtek/Makefile       |   1 +
>   drivers/net/dsa/realtek/realtek-mdio.c | 221 +++++++++++++++++++++++++
>   drivers/net/dsa/realtek/realtek.h      |   2 +
>   4 files changed, 233 insertions(+), 2 deletions(-)
>   create mode 100644 drivers/net/dsa/realtek/realtek-mdio.c
> 
> diff --git a/drivers/net/dsa/realtek/Kconfig b/drivers/net/dsa/realtek/Kconfig
> index cd1aa95b7bf0..73b26171fade 100644
> --- a/drivers/net/dsa/realtek/Kconfig
> +++ b/drivers/net/dsa/realtek/Kconfig
> @@ -9,6 +9,13 @@ menuconfig NET_DSA_REALTEK
>   	help
>   	  Select to enable support for Realtek Ethernet switch chips.
>   
> +config NET_DSA_REALTEK_MDIO
> +	tristate "Realtek MDIO connected switch driver"
> +	depends on NET_DSA_REALTEK
> +	default y

I suppose this is fine since we depend on NET_DSA_REALTEK.

[snip]

> +static int realtek_mdio_read_reg(struct realtek_priv *priv, u32 addr, u32 *data)
> +{
> +	u32 phy_id = priv->phy_id;
> +	struct mii_bus *bus = priv->bus;
> +
> +	mutex_lock(&bus->mdio_lock);
> +
> +	bus->write(bus, phy_id, REALTEK_MDIO_CTRL0_REG, REALTEK_MDIO_ADDR_OP);
> +	bus->write(bus, phy_id, REALTEK_MDIO_START_REG, REALTEK_MDIO_START_OP);
> +	bus->write(bus, phy_id, REALTEK_MDIO_ADDRESS_REG, addr);
> +	bus->write(bus, phy_id, REALTEK_MDIO_START_REG, REALTEK_MDIO_START_OP);
> +	bus->write(bus, phy_id, REALTEK_MDIO_CTRL1_REG, REALTEK_MDIO_READ_OP);
> +	bus->write(bus, phy_id, REALTEK_MDIO_START_REG, REALTEK_MDIO_START_OP);
> +	*data = bus->read(bus, phy_id, REALTEK_MDIO_DATA_READ_REG);

Do you have no way to return an error for instance, if you read from a 
non-existent PHY device on the MDIO bus, -EIO would be expected for 
instance. If the data returned is 0xffff that ought to be enough.

> +
> +	mutex_unlock(&bus->mdio_lock);
> +
> +	return 0;
> +}
> +
> +static int realtek_mdio_write_reg(struct realtek_priv *priv, u32 addr, u32 data)
> +{
> +	u32 phy_id = priv->phy_id;
> +	struct mii_bus *bus = priv->bus;
> +
> +	mutex_lock(&bus->mdio_lock);
> +
> +	bus->write(bus, phy_id, REALTEK_MDIO_CTRL0_REG, REALTEK_MDIO_ADDR_OP);
> +	bus->write(bus, phy_id, REALTEK_MDIO_START_REG, REALTEK_MDIO_START_OP);
> +	bus->write(bus, phy_id, REALTEK_MDIO_ADDRESS_REG, addr);

This repeats between read and writes, might be worth a helper function.

> +	bus->write(bus, phy_id, REALTEK_MDIO_START_REG, REALTEK_MDIO_START_OP);
> +	bus->write(bus, phy_id, REALTEK_MDIO_DATA_WRITE_REG, data);
> +	bus->write(bus, phy_id, REALTEK_MDIO_START_REG, REALTEK_MDIO_START_OP);
> +	bus->write(bus, phy_id, REALTEK_MDIO_CTRL1_REG, REALTEK_MDIO_WRITE_OP);
> +
> +	mutex_unlock(&bus->mdio_lock);
> +
> +	return 0;
> +}
> +
> +/* Regmap accessors */
> +
> +static int realtek_mdio_write(void *ctx, u32 reg, u32 val)
> +{
> +	struct realtek_priv *priv = ctx;
> +
> +	return realtek_mdio_write_reg(priv, reg, val);
> +}
> +
> +static int realtek_mdio_read(void *ctx, u32 reg, u32 *val)
> +{
> +	struct realtek_priv *priv = ctx;
> +
> +	return realtek_mdio_read_reg(priv, reg, val);
> +}

Do you see a value for this function as oppposed to inlining the bodies 
of realtek_mdio_read_reg and realtek_mdio_write_reg directly into these 
two functions?

> +
> +static const struct regmap_config realtek_mdio_regmap_config = {
> +	.reg_bits = 10, /* A4..A0 R4..R0 */
> +	.val_bits = 16,
> +	.reg_stride = 1,
> +	/* PHY regs are at 0x8000 */
> +	.max_register = 0xffff,
> +	.reg_format_endian = REGMAP_ENDIAN_BIG,
> +	.reg_read = realtek_mdio_read,
> +	.reg_write = realtek_mdio_write,
> +	.cache_type = REGCACHE_NONE,
> +};
> +
> +static int realtek_mdio_probe(struct mdio_device *mdiodev)
> +{
> +	struct realtek_priv *priv;
> +	struct device *dev = &mdiodev->dev;
> +	const struct realtek_variant *var;
> +	int ret;
> +	struct device_node *np;
> +
> +	var = of_device_get_match_data(dev);

Don't you have to check that var is non-NULL just in case?

> +	priv = devm_kzalloc(&mdiodev->dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	priv->map = devm_regmap_init(dev, NULL, priv, &realtek_mdio_regmap_config);
> +	if (IS_ERR(priv->map)) {
> +		ret = PTR_ERR(priv->map);
> +		dev_err(dev, "regmap init failed: %d\n", ret);
> +		return ret;
> +	}
> +
> +	priv->phy_id = mdiodev->addr;

Please use a more descriptive variable name such as mdio_addr or 
something like that. I know that phy_id is typically used but it could 
also mean a 32-bit PHY unique identifier, which a MDIO device does not 
have typically.

Looks fine otherwise.
-- 
Florian
