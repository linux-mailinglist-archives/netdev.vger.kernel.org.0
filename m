Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3094A78DE
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 20:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346948AbiBBTqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 14:46:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbiBBTqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 14:46:51 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38943C061714;
        Wed,  2 Feb 2022 11:46:51 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id b13so819495edn.0;
        Wed, 02 Feb 2022 11:46:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rnmPw/OuvT5nnEtXmJqegdwVhZuNfh1sLakxnaRWZtU=;
        b=iagGXqbnA+/6CPbz6jGozukFarqUd+V88acZVpP4hERalD6uejXfAcY73H+/dboFpw
         1Pc3X46l4+FLyndDBx97RwsGO9mOU+EAAWk59xaLe07nTyuVm/2u36KPP8Ees3MmnIFc
         FXIZIQXKYc8xcEsv6crEHugs/WbMJz07GYh81Ws/XVJ4sJEPzFWslDiJK4fGXvsMNdXU
         PgttMXxfxTMvUMuYw+FGGdZ7LePhseUv75bP/7kcH/SqMRsfeRSsMXBlfKUwjHjThlE7
         0FoGW8hpkogZ11SutO1U9iHasnHzu8IuPAP+hudUyiEKmy4mcw83q6mM45UzN8sWW1pV
         rR/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rnmPw/OuvT5nnEtXmJqegdwVhZuNfh1sLakxnaRWZtU=;
        b=FvUhGQqKYWMZFBFAdcphM7+VNNKLT7djXivn8xpJaxLjXEqc6yIJcfaz/x5WUUsbHU
         87Kf2J6v+BjMiFBAraAajhrbnlOfWD/1SGOpTwEhdVT6MC3yJoVfpWU2/b00pgp2aRor
         TY1TYmBeUeeKcfRe9LuYBFjLMdgpRqymC1RaA5HL/y8P/mo6EJjMhzbg7jRxU2xYvvjc
         HoB2IP9VNnlvOmNXqOZulQs3iI+UDYhtk+SGjG8ewoYueblgFW1PGXTFyVfX1BcVGR2e
         GyvS7xHp0OalOC6QFBMuw3T/BP6aOyygQGQOky2O7qoTc7d6G3BMBH/1A7HNZHxHKSjC
         NhUg==
X-Gm-Message-State: AOAM530/HnsI7iHqSO/5oOtFAdLiGEs3QyZkare6uFkHgX7HHPqFTZq3
        J5zpclz9RqFOZI8BtlWgtvOI+soaUP7J9YIXVXM=
X-Google-Smtp-Source: ABdhPJyXVxqNMmfb2b4TgCMxti9E2qhIYKGuf0BCS0PaAUFncuGmQK6OxuuSbLsJX1AM6ivknDuRZDLOUoSgmZZPRWs=
X-Received: by 2002:a05:6402:1705:: with SMTP id y5mr31690498edu.200.1643831209595;
 Wed, 02 Feb 2022 11:46:49 -0800 (PST)
MIME-Version: 1.0
References: <20220202181248.18344-1-josright123@gmail.com> <20220202181248.18344-3-josright123@gmail.com>
In-Reply-To: <20220202181248.18344-3-josright123@gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 2 Feb 2022 21:45:13 +0200
Message-ID: <CAHp75VeRoG3+UmPm41O0+5YmxDgDr3ESFtvMzn2c-SGpUePETw@mail.gmail.com>
Subject: Re: [PATCH v17, 2/2] net: Add dm9051 driver
To:     Joseph CHAMG <josright123@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, joseph_chang@davicom.com.tw,
        netdev <netdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Leon Romanovsky <leon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 2, 2022 at 8:13 PM Joseph CHAMG <josright123@gmail.com> wrote:
>
> Add davicom dm9051 spi ethernet driver, The driver work for the
> device platform which has the spi master

...

> +       ret = regmap_write(db->regmap_dm, DM9051_EPCR, 0x0);

0x0 --> 0


> +       if (ret)
> +               return ret;

...

> +       return regmap_write(db->regmap_dm, DM9051_EPCR, 0x0);

Ditto.

...

> +       ret = regmap_update_bits(db->regmap_dm, DM9051_FCR, 0xff, fcr);

GENMASK(7, 0) ?

...

> +static int dm9051_map_chipid(struct board_info *db)
> +{
> +       struct device *dev = &db->spidev->dev;
> +       unsigned int ret;
> +       unsigned short wid;
> +       u8 buff[6];
> +
> +       ret = regmap_bulk_read(db->regmap_dmbulk, DM9051_VIDL, buff, 6);

sizeof(buff)

> +       if (ret < 0) {
> +               netif_err(db, drv, db->ndev, "%s: error %d bulk_read reg %02x\n",
> +                         __func__, ret, DM9051_VIDL);
> +               return ret;
> +       }

> +       wid = buff[3] << 8 | buff[2];

get_unaligned_le16()

> +       if (wid != DM9051_ID) {
> +               dev_err(dev, "chipid error as %04x !\n", wid);
> +               return -ENODEV;
> +       }
> +
> +       dev_info(dev, "chip %04x found\n", wid);
> +       return 0;
> +}

...

> +static int dm9051_map_etherdev_par(struct net_device *ndev, struct board_info *db)
> +{
> +       u8 addr[ETH_ALEN];
> +       int ret;
> +
> +       ret = regmap_bulk_read(db->regmap_dmbulk, DM9051_PAR, addr, ETH_ALEN);

sizeof(addr)

> +       if (ret < 0)
> +               return ret;
> +
> +       if (!is_valid_ether_addr(addr)) {
> +               eth_hw_addr_random(ndev);

> +               ret = regmap_bulk_write(db->regmap_dmbulk, DM9051_PAR, ndev->dev_addr, ETH_ALEN);

Ditto.

> +               if (ret < 0)
> +                       return ret;
> +
> +               dev_dbg(&db->spidev->dev, "Use random MAC address\n");
> +               return 0;
> +       }
> +
> +       eth_hw_addr_set(ndev, addr);
> +       return 0;
> +}

...

> +       db->mdiobus->phy_mask = (u32)~GENMASK(1, 1);

For a single bit it might be better to use BIT(1)

...

> +       ret = devm_mdiobus_register(&spi->dev, db->mdiobus);
> +       if (ret)
> +               dev_err(&spi->dev, "Could not register MDIO bus\n");
> +

> +       return 0;

return ret; ?

...

> +       snprintf(phy_id, MII_BUS_ID_SIZE + 3, PHY_ID_FMT,

sizeof(phy_id) + 3

> +                db->mdiobus->id, DM9051_PHY_ADDR);

...

> +       if (IS_ERR(db->phydev))
> +               return PTR_ERR(db->phydev);
> +       return 0;

return PTR_ERR_OR_ZERO();

...

> +               if ((rxbyte & 0xff) != DM9051_PKT_RDY)

GENMASK(7, 0) ?

> +                       break; /* exhaust-empty */

...

> +               ret = regmap_write(db->regmap_dm, DM9051_ISR, 0xff); /* to stop mrcmd */


Ditto.

> +               if (ret)
> +                       return ret;

...

> +               ret = regmap_write(db->regmap_dm, DM9051_ISR, 0xff); /* to stop mrcmd */

Ditto.

Perhaps it needs its own definition after all?

> +               if (ret)
> +                       return ret;

...

> +spi_err:

out_unlock:

> +       mutex_unlock(&db->spi_lockm);
> +
> +       return IRQ_HANDLED;

...

> +       result = regmap_bulk_write(db->regmap_dmbulk, DM9051_MAR, db->rctl.hash_table, 8);

Is hash_table an array? Then sizeof() or ARRAY_SIZE() should work.

> +       if (result < 0) {
> +               netif_err(db, drv, ndev, "%s: error %d bulk writing reg %02x, len %d\n",
> +                         __func__, result, DM9051_MAR, 8);

Ditto.

> +               goto spi_err;
> +       }

...

> +spi_err:

out_unlock:

You need to describe what will be done if one goes to the label.

> +       mutex_unlock(&db->spi_lockm);

...

> +       /* The whole dm9051 chip registers could not be accessed within 1 ms
> +        * after above GPR power on control
> +        */
> +       mdelay(1);

Why atomic?

...

> +       ret = request_threaded_irq(spi->irq, NULL, dm9051_rx_threaded_irq,
> +                                  IRQF_TRIGGER_LOW | IRQF_ONESHOT,

Why do you ignore IRQ flags from DT?

> +                                  ndev->name, db);

...

> +       /* the multicast address in Hash Table : 64 bits */
> +       netdev_for_each_mc_addr(ha, ndev) {
> +               hash_val = ether_crc_le(ETH_ALEN, ha->addr) & 0x3f;

GENMASK() ?

> +               rxctrl.hash_table[hash_val / 16] |= 1U << (hash_val % 16);

BIT() ?

> +       }

...

> +       /* schedule work to do the actual set of the data if needed */

> +       if (memcmp(&db->rctl, &rxctrl, sizeof(rxctrl))) {
> +               memcpy(&db->rctl, &rxctrl, sizeof(rxctrl));

Hmm... This is interesting...

> +               schedule_work(&db->rxctrl_work);
> +       }

...

> +       ret = regmap_bulk_write(db->regmap_dmbulk, DM9051_PAR, ndev->dev_addr, ETH_ALEN);

sizeof() ?

...

> +       int ret = 0;

Redundant assignment.

...

> +       ret = devm_register_netdev(dev, ndev);
> +       if (ret) {

> +               dev_err(dev, "failed to register network device\n");
> +               phy_disconnect(db->phydev);
> +               return ret;

phy_disconnect();
return dev_err_probe();

> +       }

...

> +err_stopthread:
> +       return ret;

Useless. Return in-place.

...

> +static struct spi_driver dm9051_driver = {
> +       .driver = {
> +               .name = DRVNAME_9051,
> +               .of_match_table = dm9051_match_table,
> +       },
> +       .probe = dm9051_probe,
> +       .remove = dm9051_drv_remove,
> +       .id_table = dm9051_id_table,
> +};

> +

Redundant blank line.

> +module_spi_driver(dm9051_driver);

...

+ bits.h

> +#include <linux/netdevice.h>

> +#include <linux/mii.h>

How is that header being used in this header?

> +#include <linux/types.h>

...

> +#define INTCR_POL_LOW          BIT(0)
> +#define INTCR_POL_HIGH         (0 << 0)

In this case, be consistent:

#define INTCR_POL_LOW          (1 << 0)
#define INTCR_POL_HIGH         (0 << 0)

-- 
With Best Regards,
Andy Shevchenko
