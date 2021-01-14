Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 021312F5706
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 02:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbhANB6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 20:58:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728010AbhANB55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 20:57:57 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 310A7C0617BA;
        Wed, 13 Jan 2021 17:57:02 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id t16so5890953ejf.13;
        Wed, 13 Jan 2021 17:57:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JNyLbh+mVCrMKLHSLmGGHCyCN1HVxoe1UWX61n4ECyg=;
        b=ong3DUd452R9fGmS4nD6Uib7hChmoTeVNmxlxJh+51mVfYLBAmGR+hrOIEowZ66bP6
         Zp0xxs1p7STRjhqaEX4FxwdyLoGuTkXGNUB0kkHHZJ24iOYfYxABhi4zYsJu9etoPhXV
         Gih2dR5Nk8RF16WW2ECDELN9wQAvBRN5iBsyieE1PDKiPijJJE3iZ1MGX2zMG+q9ugpe
         LxGdynNLfHH2klD+N4w1jY0UxoNkGmLdG2x9Tkxmwbl5AB2cxDvM9H4oKSHMw2gU/L98
         Qhdo2lNvWm1LPsr+Kr9/pC4pkbIwrfIGKo14n0UsOICvuhkZyHRMAHrJRjgIgl6Phq5p
         xzWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JNyLbh+mVCrMKLHSLmGGHCyCN1HVxoe1UWX61n4ECyg=;
        b=BtAjaDl4V6nPFAUvcOQozZVtmpbAufSa9OA+4HN9L3WSNSjEitu8iFb7EpxYdeFnEA
         w4S0QAZ0yemy4hrfnotci6yAN/EC/jhXMy7bcSpK+410Q1sl7f1Tq1/GRmkSPD8L1K82
         qgrE0m1Y7JXya5k+Fs9+vjy2iPylA6GYtyXpYE65t0ojGuhTwwA+6Oyl4rxhg7YcRMzW
         GGUGPKFYnqRl4rA0j+V5SFHTJiZI6SwPBDN3Wiopb+7lOQEx7xrBE4gO/rApzuP/mhuJ
         V2iWbooJgocMMzJ/GPb5lacnMbLWiHGj1qDB1skZUjmhHjjbIa6cGKnn7DTb8U0KTWgQ
         DjdQ==
X-Gm-Message-State: AOAM530N+8wyWdHg9Z3uPSqP++L1qeEuVlzMaG2ahcavQ1VlDtfgEUNv
        MxnYWH0dyUG3suwkoPnDAuk=
X-Google-Smtp-Source: ABdhPJzCbk8ZfLuDWwc0hxBmqy01kFZs7tG7hFNCWDSoO7J7slchxXOcN7ow6xvhV7TRm6loe0po+g==
X-Received: by 2002:a17:907:3f9e:: with SMTP id hr30mr3526712ejc.445.1610589420907;
        Wed, 13 Jan 2021 17:57:00 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id i13sm1567523edu.22.2021.01.13.17.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 17:57:00 -0800 (PST)
Date:   Thu, 14 Jan 2021 03:56:59 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Rob Herring <robh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v4 2/3] net: dsa: add Arrow SpeedChips XRS700x
 driver
Message-ID: <20210114015659.33shdlfthywqdla7@skbuf>
References: <20210113145922.92848-1-george.mccollister@gmail.com>
 <20210113145922.92848-3-george.mccollister@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113145922.92848-3-george.mccollister@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 08:59:21AM -0600, George McCollister wrote:
> Add a driver with initial support for the Arrow SpeedChips XRS7000
> series of gigabit Ethernet switch chips which are typically used in
> critical networking applications.
> 
> The switches have up to three RGMII ports and one RMII port.
> Management to the switches can be performed over i2c or mdio.
> 
> Support for advanced features such as PTP and
> HSR/PRP (IEC 62439-3 Clause 5 & 4) is not included in this patch and
> may be added at a later date.
> 
> Signed-off-by: George McCollister <george.mccollister@gmail.com>
> ---

Some non-exhaustive feedback below.

> +static void xrs700x_teardown(struct dsa_switch *ds)
> +{
> +	struct xrs700x *priv = ds->priv;
> +
> +	cancel_delayed_work_sync(&priv->mib_work);
> +}
> +

> +static void xrs700x_mac_link_up(struct dsa_switch *ds, int port,
> +				unsigned int mode, phy_interface_t interface,
> +				struct phy_device *phydev,
> +				int speed, int duplex,
> +				bool tx_pause, bool rx_pause)
> +{
> +	struct xrs700x *priv = ds->priv;
> +	unsigned int val;
> +
> +	switch (speed) {
> +	case SPEED_1000:
> +		val = XRS_PORT_SPEED_1000;
> +		break;
> +	case SPEED_100:
> +		val = XRS_PORT_SPEED_100;
> +		break;
> +	case SPEED_10:
> +		val = XRS_PORT_SPEED_10;
> +		break;
> +	default:
> +		return;
> +	}
> +
> +	regmap_fields_write(priv->ps_sel_speed, port, val);
> +
> +	dev_dbg_ratelimited(priv->dev, "%s: port: %d mode: %u speed: %u\n",
> +			    __func__, port, mode, speed);
> +}

What PHY interface types does the switch support as of this patch?
No RGMII delay configuration needed?

> +
> +static int xrs700x_bridge_common(struct dsa_switch *ds, int port,
> +				 struct net_device *bridge, bool join)
> +{
> +	unsigned int i, cpu_mask = 0, mask = 0;
> +	struct xrs700x *priv = ds->priv;
> +	int ret;
> +
> +	for (i = 0; i < ds->num_ports; i++) {
> +		if (dsa_is_cpu_port(ds, i))
> +			continue;
> +
> +		cpu_mask |= BIT(i);
> +
> +		if (dsa_to_port(ds, i)->bridge_dev == bridge)
> +			continue;
> +
> +		mask |= BIT(i);
> +	}
> +
> +	for (i = 0; i < ds->num_ports; i++) {
> +		if (dsa_to_port(ds, i)->bridge_dev != bridge)
> +			continue;
> +
> +		ret = regmap_write(priv->regmap, XRS_PORT_FWD_MASK(i), mask);

Maybe it would be worth mentioning in a comment that PORT_FWD_MASK's
encoding is "1 = Disable forwarding to the port", otherwise this is
confusing.

> +		if (ret)
> +			return ret;
> +	}
> +
> +	if (!join) {
> +		ret = regmap_write(priv->regmap, XRS_PORT_FWD_MASK(port),
> +				   cpu_mask);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}

> +static int xrs700x_detect(struct xrs700x *dev)
> +{
> +	const struct xrs700x_info *info;
> +	unsigned int id;
> +	int ret;
> +
> +	ret = regmap_read(dev->regmap, XRS_DEV_ID0, &id);
> +	if (ret) {
> +		dev_err(dev->dev, "error %d while reading switch id.\n",
> +			ret);
> +		return ret;
> +	}
> +
> +	info = of_device_get_match_data(dev->dev);
> +	if (!info)
> +		return -EINVAL;
> +
> +	if (info->id == id) {
> +		dev->ds->num_ports = info->num_ports;
> +		dev_info(dev->dev, "%s detected.\n", info->name);
> +		return 0;
> +	}
> +
> +	dev_err(dev->dev, "expected switch id 0x%x but found 0x%x.\n",
> +		info->id, id);

I've been there too, not the smartest of decisions in the long run. See
commit 0b0e299720bb ("net: dsa: sja1105: use detected device id instead
of DT one on mismatch") if you want a sneak preview of how this is going
to feel two years from now. If you can detect the device id you're
probably better off with a single compatible string.

> +
> +	return -ENODEV;
> +}
> +
> +static int xrs700x_alloc_port_mib(struct xrs700x *dev, int port)
> +{
> +	struct xrs700x_port *p = &dev->ports[port];
> +	size_t mib_size = sizeof(*p->mib_data) * ARRAY_SIZE(xrs700x_mibs);

Reverse Christmas tree ordering... sorry.

> +int xrs700x_switch_register(struct xrs700x *dev)
> +{
> +	int ret;
> +	int i;
> +
> +	ret = xrs700x_detect(dev);
> +	if (ret)
> +		return ret;
> +
> +	ret = xrs700x_setup_regmap_range(dev);
> +	if (ret)
> +		return ret;
> +
> +	dev->ports = devm_kzalloc(dev->dev,
> +				  sizeof(*dev->ports) * dev->ds->num_ports,
> +				  GFP_KERNEL);

devm_kcalloc?

> +	if (!dev->ports)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < dev->ds->num_ports; i++) {
> +		ret = xrs700x_alloc_port_mib(dev, i);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	ret = dsa_register_switch(dev->ds);
> +
> +	return ret;

return dsa_register_switch

> +}
> +EXPORT_SYMBOL(xrs700x_switch_register);
> +
> +void xrs700x_switch_remove(struct xrs700x *dev)
> +{
> +	cancel_delayed_work_sync(&dev->mib_work);

Is it not enough that this is called from xrs700x_teardown too, which is
in the call path of dsa_unregister_switch below?

> +
> +	dsa_unregister_switch(dev->ds);
> +}
> +EXPORT_SYMBOL(xrs700x_switch_remove);
> diff --git a/drivers/net/dsa/xrs700x/xrs700x_mdio.c b/drivers/net/dsa/xrs700x/xrs700x_mdio.c
> new file mode 100644
> index 000000000000..4fa6cc8f871c
> --- /dev/null
> +++ b/drivers/net/dsa/xrs700x/xrs700x_mdio.c
> +static int xrs700x_mdio_reg_read(void *context, unsigned int reg,
> +				 unsigned int *val)
> +{
> +	struct mdio_device *mdiodev = context;
> +	struct device *dev = &mdiodev->dev;
> +	u16 uval;
> +	int ret;
> +
> +	uval = (u16)FIELD_GET(GENMASK(31, 16), reg);
> +
> +	ret = mdiobus_write(mdiodev->bus, mdiodev->addr, XRS_MDIO_IBA1, uval);
> +	if (ret < 0) {
> +		dev_err(dev, "xrs mdiobus_write returned %d\n", ret);
> +		return ret;
> +	}
> +
> +	uval = (u16)((reg & GENMASK(15, 1)) | XRS_IB_READ);

What happened to bit 0 of "reg"?

> +
> +	ret = mdiobus_write(mdiodev->bus, mdiodev->addr, XRS_MDIO_IBA0, uval);
> +	if (ret < 0) {
> +		dev_err(dev, "xrs mdiobus_write returned %d\n", ret);
> +		return ret;
> +	}
> +
> +	ret = mdiobus_read(mdiodev->bus, mdiodev->addr, XRS_MDIO_IBD);
> +	if (ret < 0) {
> +		dev_err(dev, "xrs mdiobus_read returned %d\n", ret);
> +		return ret;
> +	}
> +
> +	*val = (unsigned int)ret;
> +
> +	return 0;
> +}

> +static int xrs700x_mdio_probe(struct mdio_device *mdiodev)
> +{
> +	struct xrs700x *dev;

May boil down to preference too, but I don't believe "dev" is a happy
name to give to a driver private data structure.
