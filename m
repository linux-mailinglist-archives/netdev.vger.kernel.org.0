Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93F05265489
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725788AbgIJV5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:57:36 -0400
Received: from mx1.tq-group.com ([62.157.118.193]:52545 "EHLO mx1.tq-group.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730509AbgIJLyx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 07:54:53 -0400
IronPort-SDR: qmGo45Gn6bwDTD6Dlghqutth8A+di0R73quSNJvEy94RpBBjqfzk181pJ1UDJHWAqcoB3jKJ55
 uhqk1uHZjKDSYTTPdM6ZbL0US067Uc5fOaKZ///nftrTg4uYdU4yDYqGp5q0r6K8BBM+Mdw/Tn
 bqWGFAye6XycxMP0J7cMfIqaianxh3VyFfaL5cMKF2Xu7gVN/tLfhUBS2nBdGNWUMfYnKPcv8g
 zktbTVIgo+fWVhRH7AhCcqFUOqNzP0sn6S0XNqY8lJX23WKrMQ1b6QiBOin7aKcEg+V8mzWYEg
 Ejk=
X-IronPort-AV: E=Sophos;i="5.76,413,1592863200"; 
   d="scan'208";a="13811661"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 10 Sep 2020 13:44:41 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Thu, 10 Sep 2020 13:44:41 +0200
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Thu, 10 Sep 2020 13:44:41 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1599738281; x=1631274281;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=guBQNj8i4p+VCsWsOT5JEcCOGWIz1qZirVz9jwa1rAQ=;
  b=abEOzB/CUc6AhKzz4Vyjb4xDFczTNJhPIt9CwyC/dRDhfQ/lAwdphXYh
   pGXv0C0F/uh5FL+yQ0+7NUSGXUlqePq0BmDWO6nzuug/dRymQzqUtPxAQ
   CO3Rz8MLzDHaIhhxivitrKfhY6GhvTKLbVJouC5Q0wc2fN8ltOlRYeVNi
   i3CZ+HtuenXMm0dhSDsgTdgWczZY7DBcY00teJIspVYEqynOcL8+KABj0
   NXmZJliwm8ZNJzWK0xOXtq4EzcdFy1LxmEsViz1w61YZ2/DJrNnhgSAhx
   Dq7QITfODMu3veWsqiFhezsa2FnbkfGFMD9Uod7bWM3BAMe1ICK3rB49/
   A==;
IronPort-SDR: Xk3X+8C+7k4uLYEdEqikUx5nfi/kIIjd9tlE6BB/UnNXkSNYdDYL9POMPrpYqv/zmAxxgequ3s
 bTrwWHMIJRgurVbed7Xe2r9nkDgzzbwI2vlvH2fS0tjt7lEXWRogYY2oCVwXPxU3/z42Fm5YEp
 wfNc9c107ig3r+s9xGfC+CvnjJcyXLNI02xHddoyW3sYKDQmcqJInHiHrBUqFcajC3IP+9zI8f
 wzPiYXGSEqzg1UPzjuliCK0fZ/1MhJNO6hbGdHNljZ94FIv1ds9C3sUoqMpt4wi4S+zuoHhncw
 VuA=
X-IronPort-AV: E=Sophos;i="5.76,413,1592863200"; 
   d="scan'208";a="13811660"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 10 Sep 2020 13:44:41 +0200
Received: from schifferm-ubuntu4.tq-net.de (schifferm-ubuntu4.tq-net.de [10.117.49.22])
        by vtuxmail01.tq-net.de (Postfix) with ESMTPA id 7C573280070;
        Thu, 10 Sep 2020 13:44:41 +0200 (CEST)
Message-ID: <15adf9f23f9b6419b0e8f4585dd82f3fcdad9697.camel@ew.tq-group.com>
Subject: Re: [PATCH v4 09/11] net: dsa: microchip: Add Microchip KSZ8863 SMI
 based driver support
From:   Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de, andrew@lunn.ch
Date:   Thu, 10 Sep 2020 13:44:39 +0200
In-Reply-To: <20200803054442.20089-10-m.grzeschik@pengutronix.de>
References: <20200803054442.20089-1-m.grzeschik@pengutronix.de>
         <20200803054442.20089-10-m.grzeschik@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-08-03 at 07:44 +0200, Michael Grzeschik wrote:
> Add KSZ88X3 driver support. We add support for the KXZ88X3 three port
> switches using the Microchip SMI Interface. They are supported using
> the
> MDIO-Bitbang Interface.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> 
> ---
> v1 -> v2:  - this code was part of previuos patch
> v2 -> v3:  - this code was part of previuos patch
> v3 -> v4:  - moved this glue code so separate patch
>            - fixed locking in regmap and mdio_read/mdio_write
> 
>  drivers/net/dsa/microchip/Kconfig       |   9 ++
>  drivers/net/dsa/microchip/Makefile      |   1 +
>  drivers/net/dsa/microchip/ksz8863_smi.c | 204
> ++++++++++++++++++++++++
>  3 files changed, 214 insertions(+)
>  create mode 100644 drivers/net/dsa/microchip/ksz8863_smi.c
> 
> diff --git a/drivers/net/dsa/microchip/Kconfig
> b/drivers/net/dsa/microchip/Kconfig
> index 4ec6a47b7f7284f..c5819bd4121cc7c 100644
> --- a/drivers/net/dsa/microchip/Kconfig
> +++ b/drivers/net/dsa/microchip/Kconfig
> @@ -40,3 +40,12 @@ config NET_DSA_MICROCHIP_KSZ8795_SPI
>  
>  	  It is required to use the KSZ8795 switch driver as the only
> access
>  	  is through SPI.
> +
> +config NET_DSA_MICROCHIP_KSZ8863_SMI
> +	tristate "KSZ series SMI connected switch driver"
> +	depends on NET_DSA_MICROCHIP_KSZ8795

Please also update the label or help text for the
NET_DSA_MICROCHIP_KSZ8795 symbol to include the KSZ88X3, so it's clear
which of the KSZ DSA drivers is the correct one for these switches.



> +	select MDIO_BITBANG
> +	default y
> +	help
> +	  Select to enable support for registering switches configured
> through
> +	  Microchip SMI. It Supports the KSZ8863 and KSZ8873 Switch.
> diff --git a/drivers/net/dsa/microchip/Makefile
> b/drivers/net/dsa/microchip/Makefile
> index 929caa81e782ed2..2a03b21a3386f5d 100644
> --- a/drivers/net/dsa/microchip/Makefile
> +++ b/drivers/net/dsa/microchip/Makefile
> @@ -5,3 +5,4 @@ obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ9477_I2C)	+=
> ksz9477_i2c.o
>  obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ9477_SPI)	+= ksz9477_spi.o
>  obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ8795)		+= ksz8795.o
>  obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ8795_SPI)	+= ksz8795_spi.o
> +obj-$(CONFIG_NET_DSA_MICROCHIP_KSZ8863_SMI)	+= ksz8863_smi.o
> diff --git a/drivers/net/dsa/microchip/ksz8863_smi.c
> b/drivers/net/dsa/microchip/ksz8863_smi.c
> new file mode 100644
> index 000000000000000..fd493441d725284
> --- /dev/null
> +++ b/drivers/net/dsa/microchip/ksz8863_smi.c
> @@ -0,0 +1,204 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Microchip KSZ8863 series register access through SMI
> + *
> + * Copyright (C) 2019 Pengutronix, Michael Grzeschik <
> kernel@pengutronix.de>
> + */
> +
> +#include "ksz8.h"
> +#include "ksz_common.h"
> +
> +/* Serial Management Interface (SMI) uses the following frame
> format:
> + *
> + *       preamble|start|Read/Write|  PHY   |  REG  |TA|   Data
> bits      | Idle
> + *               |frame| OP code  |address
> |address|  |                  |
> + * read | 32x1´s | 01  |    00    | 1xRRR  | RRRRR |Z0|
> 00000000DDDDDDDD |  Z
> + * write| 32x1´s | 01  |    00    | 0xRRR  | RRRRR |10|
> xxxxxxxxDDDDDDDD |  Z
> + *
> + */
> +
> +static int ksz8863_mdio_read(void *ctx, const void *reg_buf, size_t
> reg_len,
> +			     void *val_buf, size_t val_len)
> +{
> +	struct ksz_device *dev = (struct ksz_device *)ctx;
> +	struct ksz8 *ksz8 = dev->priv;
> +	struct mdio_device *mdev = ksz8->priv;
> +	u8 reg = *(u8 *)reg_buf;
> +	u8 *val = val_buf;
> +	int ret = 0;
> +	int i;
> +
> +	mutex_lock_nested(&mdev->bus->mdio_lock, MDIO_MUTEX_NESTED);
> +	for (i = 0; i < val_len; i++) {
> +		int tmp = reg + i;
> +
> +		ret = __mdiobus_read(mdev->bus, ((tmp & 0xE0) >> 5) |
> +				     BIT(4), tmp);
> +		if (ret < 0)
> +			goto out;
> +
> +		val[i] = ret;
> +	}
> +	ret = 0;
> +
> + out:
> +	mutex_unlock(&mdev->bus->mdio_lock);
> +
> +	return ret;
> +}
> +
> +static int ksz8863_mdio_write(void *ctx, const void *data, size_t
> count)
> +{
> +	struct ksz_device *dev = (struct ksz_device *)ctx;
> +	struct ksz8 *ksz8 = dev->priv;
> +	struct mdio_device *mdev = ksz8->priv;
> +	u8 *val = (u8 *)(data + 4);
> +	u32 reg = *(u32 *)data;
> +	int ret = 0;
> +	int i;
> +
> +	mutex_lock_nested(&mdev->bus->mdio_lock, MDIO_MUTEX_NESTED);
> +	for (i = 0; i < (count - 4); i++) {
> +		int tmp = reg + i;
> +
> +		ret = __mdiobus_write(mdev->bus, ((tmp & 0xE0) >> 5),
> +				      tmp, val[i]);
> +		if (ret < 0)
> +			goto out;
> +	}
> +
> + out:
> +	mutex_unlock(&mdev->bus->mdio_lock);
> +
> +	return ret;
> +}
> +
> +static const struct regmap_bus regmap_smi[] = {
> +	{
> +		.read = ksz8863_mdio_read,
> +		.write = ksz8863_mdio_write,
> +		.max_raw_read = 1,
> +		.max_raw_write = 1,
> +	},
> +	{
> +		.read = ksz8863_mdio_read,
> +		.write = ksz8863_mdio_write,
> +		.val_format_endian_default = REGMAP_ENDIAN_BIG,
> +		.max_raw_read = 2,
> +		.max_raw_write = 2,
> +	},
> +	{
> +		.read = ksz8863_mdio_read,
> +		.write = ksz8863_mdio_write,
> +		.val_format_endian_default = REGMAP_ENDIAN_BIG,
> +		.max_raw_read = 4,
> +		.max_raw_write = 4,
> +	}
> +};
> +
> +static const struct regmap_config ksz8863_regmap_config[] = {
> +	{
> +		.name = "#8",
> +		.reg_bits = 8,
> +		.pad_bits = 24,
> +		.val_bits = 8,
> +		.cache_type = REGCACHE_NONE,
> +		.use_single_read = 1,
> +		.lock = ksz_regmap_lock,
> +		.unlock = ksz_regmap_unlock,
> +	},
> +	{
> +		.name = "#16",
> +		.reg_bits = 8,
> +		.pad_bits = 24,
> +		.val_bits = 16,
> +		.cache_type = REGCACHE_NONE,
> +		.use_single_read = 1,
> +		.lock = ksz_regmap_lock,
> +		.unlock = ksz_regmap_unlock,
> +	},
> +	{
> +		.name = "#32",
> +		.reg_bits = 8,
> +		.pad_bits = 24,
> +		.val_bits = 32,
> +		.cache_type = REGCACHE_NONE,
> +		.use_single_read = 1,
> +		.lock = ksz_regmap_lock,
> +		.unlock = ksz_regmap_unlock,
> +	}
> +};
> +
> +static int ksz8863_smi_probe(struct mdio_device *mdiodev)
> +{
> +	struct regmap_config rc;
> +	struct ksz_device *dev;
> +	struct ksz8 *ksz8;
> +	int ret;
> +	int i;
> +
> +	ksz8 = devm_kzalloc(&mdiodev->dev, sizeof(struct ksz8),
> GFP_KERNEL);
> +	ksz8->priv = mdiodev;
> +
> +	dev = ksz_switch_alloc(&mdiodev->dev, ksz8);
> +	if (!dev)
> +		return -EINVAL;
> +
> +	for (i = 0; i < ARRAY_SIZE(ksz8863_regmap_config); i++) {
> +		rc = ksz8863_regmap_config[i];
> +		rc.lock_arg = &dev->regmap_mutex;
> +		dev->regmap[i] = devm_regmap_init(&mdiodev->dev,
> +						  &regmap_smi[i], dev,
> +						  &rc);
> +		if (IS_ERR(dev->regmap[i])) {
> +			ret = PTR_ERR(dev->regmap[i]);
> +			dev_err(&mdiodev->dev,
> +				"Failed to initialize regmap%i: %d\n",
> +				ksz8863_regmap_config[i].val_bits,
> ret);
> +			return ret;
> +		}
> +	}
> +
> +	if (mdiodev->dev.platform_data)
> +		dev->pdata = mdiodev->dev.platform_data;
> +
> +	ret = ksz8_switch_register(dev);
> +
> +	/* Main DSA driver may not be started yet. */
> +	if (ret)
> +		return ret;
> +
> +	dev_set_drvdata(&mdiodev->dev, dev);
> +
> +	return 0;
> +}
> +
> +static void ksz8863_smi_remove(struct mdio_device *mdiodev)
> +{
> +	struct ksz_device *dev = dev_get_drvdata(&mdiodev->dev);
> +
> +	if (dev)
> +		ksz_switch_remove(dev);
> +}
> +
> +static const struct of_device_id ksz8863_dt_ids[] = {
> +	{ .compatible = "microchip,ksz8863" },
> +	{ .compatible = "microchip,ksz8873" },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, ksz8863_dt_ids);
> +
> +static struct mdio_driver ksz8863_driver = {
> +	.probe	= ksz8863_smi_probe,
> +	.remove	= ksz8863_smi_remove,
> +	.mdiodrv.driver = {
> +		.name	= "ksz8863-switch",
> +		.of_match_table = ksz8863_dt_ids,
> +	},
> +};
> +
> +mdio_module_driver(ksz8863_driver);
> +
> +MODULE_AUTHOR("Michael Grzeschik <m.grzeschik@pengutronix.de>");
> +MODULE_DESCRIPTION("Microchip KSZ8863 SMI Switch driver");
> +MODULE_LICENSE("GPL v2");

