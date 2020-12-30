Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01C6B2E76E2
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 08:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbgL3HkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 02:40:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbgL3HkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 02:40:21 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74DC2C061799;
        Tue, 29 Dec 2020 23:39:40 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id e25so4051407wme.0;
        Tue, 29 Dec 2020 23:39:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VoageHVyQwQIev+16Mnsb5ZnXBMyXkFkXmFZo+1yxQA=;
        b=HrodpEuclV05O13YNB2TWQGwRUJJ2rQfZmvzm8ZR2NyvqEhTaLX90XwUXXTQNFdJ85
         nmogI4vonAJog/90BP2pENUrxHu4dv8b8VxFsskI0pUc5GMxK2t64yGyqt1KtA6zSyN0
         HwJBWhApKrQW5DJfWCkz0nEH+PlHWdnhp9HC/qhkarMlV/kVA5FdYPo0lpLSwF0zURen
         LnYR3hWH2mwUubHAZUnjyB7e1CLg+f17FJYZ14bM11VAFi6vPr01/6mYeg48+0tQij48
         Uv2l4CsUDaZTeokNeeplH/+TZB/9KrLF1gPgoXlk4GKhiqD2rWCHZUSoP3LATaHsLh+G
         2vRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VoageHVyQwQIev+16Mnsb5ZnXBMyXkFkXmFZo+1yxQA=;
        b=LKc5JtSzpF6Y3/E3AjABlfDRreNHwu+3RRD2KbsZkWMxra5A0pdRHpei8M/g/FbrNx
         nWjzEs6FqJLiu/rrPcBr9DCGqFzaNawk3iC5IsT6AHv+Bbj8TAqh4UH+6ktV1tTQkvJx
         rtBIasOhHcHDfwOwAZynISNK8+Dn7o6Dlwr+tq9fjJMHOzhxLbubSD1+mY3n1rqQU/fi
         JjNhtxiYw2wcyfrdGpmvzr7ZFKzzpaisSkxu9lbFyoo/ahO+s+ptMNW0rS1JJux9mPZp
         Dy4cxiUld4a9WEI/Z5vWFxW3p0MwDQF3Yb82cJOkjSFERZgsMo3ewRq3P9MqmYNLKmBX
         kHAw==
X-Gm-Message-State: AOAM530kLbiUxUOtTZSBBoHOSg+1qtADQJChqmV0K8zvZVXQ+RW6tLZU
        R98iiPspG2vbNQfI2Dd5U/Q=
X-Google-Smtp-Source: ABdhPJxT6lW0VIQtBS9lK25r+twgledzVfItG5lYPCORBwI7x33DZMjM6G+zDK8wWLeoytLyT7Whvg==
X-Received: by 2002:a1c:e306:: with SMTP id a6mr6491325wmh.66.1609313978980;
        Tue, 29 Dec 2020 23:39:38 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:40d3:8504:24f3:bef8? (p200300ea8f06550040d3850424f3bef8.dip0.t-ipconnect.de. [2003:ea:8f06:5500:40d3:8504:24f3:bef8])
        by smtp.googlemail.com with ESMTPSA id y11sm6158689wmi.0.2020.12.29.23.39.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Dec 2020 23:39:38 -0800 (PST)
Subject: Re: Registering IRQ for MT7530 internal PHYs
To:     DENG Qingfang <dqfext@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Marc Zyngier <maz@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>
References: <20201230042208.8997-1-dqfext@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <a64312eb-8b4c-d6d4-5624-98f55e33e0b7@gmail.com>
Date:   Wed, 30 Dec 2020 08:39:34 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201230042208.8997-1-dqfext@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.12.2020 05:22, DENG Qingfang wrote:
> Hi,
> 
> I added MT7530 IRQ support and registered its internal PHYs to IRQ.
> It works but my patch used two hacks.
> 
> 1. Removed phy_drv_supports_irq check, because config_intr and
> handle_interrupt are not set for Generic PHY.
> 
I don't think that's the best option. First, did you check which
consequences this has? The check is there for a reason.
You may want to add a PHY driver for your chip. Supposedly it
supports at least PHY suspend/resume. You can use the RTL8366RB
PHY driver as template.

> 2. Allocated ds->slave_mii_bus before calling ds->ops->setup, because
> we cannot call dsa_slave_mii_bus_init which is private.
> 
> Any better ideas?
> 
> Regards,
> Qingfang
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index a67cac15a724..d59a8c50ede3 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -10,6 +10,7 @@
>  #include <linux/mfd/syscon.h>
>  #include <linux/module.h>
>  #include <linux/netdevice.h>
> +#include <linux/of_irq.h>
>  #include <linux/of_mdio.h>
>  #include <linux/of_net.h>
>  #include <linux/of_platform.h>
> @@ -1639,6 +1640,125 @@ mtk_get_tag_protocol(struct dsa_switch *ds, int port,
>  	}
>  }
>  
> +static irqreturn_t
> +mt7530_irq(int irq, void *data)
> +{
> +	struct mt7530_priv *priv = data;
> +	bool handled = false;
> +	int phy;
> +	u32 val;
> +
> +	val = mt7530_read(priv, MT7530_SYS_INT_STS);
> +	mt7530_write(priv, MT7530_SYS_INT_STS, val);
> +
> +	dev_info_ratelimited(priv->dev, "interrupt status: 0x%08x\n", val);
> +	dev_info_ratelimited(priv->dev, "interrupt enable: 0x%08x\n", mt7530_read(priv, MT7530_SYS_INT_EN));
> +
This is debug code to be removed in the final version?

> +	for (phy = 0; phy < MT7530_NUM_PHYS; phy++) {
> +		if (val & BIT(phy)) {
> +			unsigned int child_irq;
> +
> +			child_irq = irq_find_mapping(priv->irq_domain, phy);
> +			handle_nested_irq(child_irq);
> +			handled = true;
> +		}
> +	}
> +
> +	return handled ? IRQ_HANDLED : IRQ_NONE;

IRQ_RETVAL() could be used here.

> +}
> +
> +static void mt7530_irq_mask(struct irq_data *d)
> +{
> +	struct mt7530_priv *priv = irq_data_get_irq_chip_data(d);
> +
> +	priv->irq_enable &= ~BIT(d->hwirq);

Here you don't actually do something. HW doesn't support masking
interrupt generation for a port?

> +}
> +
> +static void mt7530_irq_unmask(struct irq_data *d)
> +{
> +	struct mt7530_priv *priv = irq_data_get_irq_chip_data(d);
> +
> +	priv->irq_enable |= BIT(d->hwirq);
> +}
> +
> +static void mt7530_irq_bus_lock(struct irq_data *d)
> +{
> +	struct mt7530_priv *priv = irq_data_get_irq_chip_data(d);
> +
> +	mutex_lock(&priv->reg_mutex);
> +}
> +
> +static void mt7530_irq_bus_sync_unlock(struct irq_data *d)
> +{
> +	struct mt7530_priv *priv = irq_data_get_irq_chip_data(d);
> +
> +	mt7530_write(priv, MT7530_SYS_INT_EN, priv->irq_enable);
> +	mutex_unlock(&priv->reg_mutex);
> +}
> +
> +static struct irq_chip mt7530_irq_chip = {
> +	.name = MT7530_NAME,
> +	.irq_mask = mt7530_irq_mask,
> +	.irq_unmask = mt7530_irq_unmask,
> +	.irq_bus_lock = mt7530_irq_bus_lock,
> +	.irq_bus_sync_unlock = mt7530_irq_bus_sync_unlock,
> +};
> +
> +static int
> +mt7530_irq_map(struct irq_domain *domain, unsigned int irq,
> +	       irq_hw_number_t hwirq)
> +{
> +	irq_set_chip_data(irq, domain->host_data);
> +	irq_set_chip_and_handler(irq, &mt7530_irq_chip, handle_simple_irq);
> +	irq_set_noprobe(irq);
> +
> +	return 0;
> +}
> +
> +static const struct irq_domain_ops mt7530_irq_domain_ops = {
> +	.map = mt7530_irq_map,
> +	.xlate = irq_domain_xlate_onecell,
> +};
> +
> +static void
> +mt7530_irq_init(struct mt7530_priv *priv)
> +{
> +	struct mii_bus *bus = priv->ds->slave_mii_bus;
> +	struct device *dev = priv->dev;
> +	struct device_node *np = dev->of_node;
> +	int parent_irq;
> +	int phy, ret;
> +
> +	parent_irq = of_irq_get(np, 0);
> +	if (parent_irq <= 0) {
> +		dev_err(dev, "failed to get parent IRQ: %d\n", parent_irq);
> +		return;
> +	}
> +
> +	mt7530_set(priv, MT7530_TOP_SIG_CTRL, TOP_SIG_CTRL_NORMAL);
> +	ret = devm_request_threaded_irq(dev, parent_irq, NULL, mt7530_irq,
> +					IRQF_ONESHOT, MT7530_NAME, priv);
> +	if (ret) {
> +		dev_err(dev, "failed to request IRQ: %d\n", ret);
> +		return;
> +	}
> +
> +	priv->irq_domain = irq_domain_add_linear(np, MT7530_NUM_PHYS,
> +						&mt7530_irq_domain_ops, priv);
> +	if (!priv->irq_domain) {
> +		dev_err(dev, "failed to create IRQ domain\n");
> +		return;
> +	}
> +
> +	/* IRQ for internal PHYs */
> +	for (phy = 0; phy < MT7530_NUM_PHYS; phy++) {
> +		unsigned int irq = irq_create_mapping(priv->irq_domain, phy);
> +
> +		irq_set_parent(irq, parent_irq);
> +		bus->irq[phy] = irq;
> +	}
> +}
> +
>  static int
>  mt7530_setup(struct dsa_switch *ds)
>  {
> @@ -2578,8 +2698,13 @@ static int
>  mt753x_setup(struct dsa_switch *ds)
>  {
>  	struct mt7530_priv *priv = ds->priv;
> +	int ret =  priv->info->sw_setup(ds);
>  
> -	return priv->info->sw_setup(ds);
> +	/* Setup interrupt */
> +	if (!ret)
> +		mt7530_irq_init(priv);
> +
> +	return ret;
>  }
>  
>  static int
> @@ -2780,6 +2905,9 @@ mt7530_remove(struct mdio_device *mdiodev)
>  		dev_err(priv->dev, "Failed to disable io pwr: %d\n",
>  			ret);
>  
> +	if (priv->irq_domain)
> +		irq_domain_remove(priv->irq_domain);
> +
>  	dsa_unregister_switch(priv->ds);
>  	mutex_destroy(&priv->reg_mutex);
>  }
> @@ -2788,7 +2916,7 @@ static struct mdio_driver mt7530_mdio_driver = {
>  	.probe  = mt7530_probe,
>  	.remove = mt7530_remove,
>  	.mdiodrv.driver = {
> -		.name = "mt7530",
> +		.name = MT7530_NAME,
>  		.of_match_table = mt7530_of_match,
>  	},
>  };
> diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
> index 32d8969b3ace..b1988d8085bb 100644
> --- a/drivers/net/dsa/mt7530.h
> +++ b/drivers/net/dsa/mt7530.h
> @@ -6,7 +6,10 @@
>  #ifndef __MT7530_H
>  #define __MT7530_H
>  
> +#define MT7530_NAME			"mt7530"
> +
>  #define MT7530_NUM_PORTS		7
> +#define MT7530_NUM_PHYS			5
>  #define MT7530_CPU_PORT			6
>  #define MT7530_NUM_FDB_RECORDS		2048
>  #define MT7530_ALL_MEMBERS		0xff
> @@ -380,6 +383,12 @@ enum mt7531_sgmii_force_duplex {
>  #define  SYS_CTRL_SW_RST		BIT(1)
>  #define  SYS_CTRL_REG_RST		BIT(0)
>  
> +/* Register for system interrupt */
> +#define MT7530_SYS_INT_EN		0x7008
> +
> +/* Register for system interrupt status */
> +#define MT7530_SYS_INT_STS		0x700c
> +
>  /* Register for PHY Indirect Access Control */
>  #define MT7531_PHY_IAC			0x701C
>  #define  MT7531_PHY_ACS_ST		BIT(31)
> @@ -761,6 +770,8 @@ struct mt7530_priv {
>  	struct mt7530_port	ports[MT7530_NUM_PORTS];
>  	/* protect among processes for registers access*/
>  	struct mutex reg_mutex;
> +	struct irq_domain *irq_domain;
> +	u32 irq_enable;
>  };
>  
>  struct mt7530_hw_vlan_entry {
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 80c2e646c093..cdddc27e2df7 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -2846,12 +2846,6 @@ static int phy_probe(struct device *dev)
>  
>  	phydev->drv = phydrv;
>  
> -	/* Disable the interrupt if the PHY doesn't support it
> -	 * but the interrupt is still a valid one
> -	 */
> -	 if (!phy_drv_supports_irq(phydrv) && phy_interrupt_is_valid(phydev))
> -		phydev->irq = PHY_POLL;
> -
>  	if (phydrv->flags & PHY_IS_INTERNAL)
>  		phydev->is_internal = true;
>  
> diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
> index 183003e45762..ef5db1106581 100644
> --- a/net/dsa/dsa2.c
> +++ b/net/dsa/dsa2.c
> @@ -448,19 +448,19 @@ static int dsa_switch_setup(struct dsa_switch *ds)
>  	if (err)
>  		goto unregister_devlink_ports;
>  
> +	ds->slave_mii_bus = devm_mdiobus_alloc(ds->dev);
> +	if (!ds->slave_mii_bus) {
> +		err = -ENOMEM;
> +		goto unregister_notifier;
> +	}
> +
>  	err = ds->ops->setup(ds);
>  	if (err < 0)
>  		goto unregister_notifier;
>  
>  	devlink_params_publish(ds->devlink);
>  
> -	if (!ds->slave_mii_bus && ds->ops->phy_read) {
> -		ds->slave_mii_bus = devm_mdiobus_alloc(ds->dev);
> -		if (!ds->slave_mii_bus) {
> -			err = -ENOMEM;
> -			goto unregister_notifier;
> -		}
> -
> +	if (ds->ops->phy_read) {
>  		dsa_slave_mii_bus_init(ds);
>  
>  		err = mdiobus_register(ds->slave_mii_bus);
> 

