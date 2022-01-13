Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4372548D59D
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 11:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbiAMKS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 05:18:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiAMKS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 05:18:27 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC491C06173F;
        Thu, 13 Jan 2022 02:18:26 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id k15so21072599edk.13;
        Thu, 13 Jan 2022 02:18:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kZFNHIj+SfcYq9AlTwFrsQEBDKDiEWumGsUTDrWMVPQ=;
        b=TykAfoucB+qJ/XpLbvUXBKXm1gY+YXQab5faWFHhn2HAlqCcvhWGqk0iNoiCUwN28V
         NEdleohDM/96AJjJiujjHI0Pfw8qR5C4GkRc9I4byqwukK6Oh9hiED6X1Wp2OUlIrFKb
         CHga0fkmjeJ8APaHLVFsGejfXvznsV5KhSBmqFHCejOOALHAmE/LtURrS4gsjE3S8HBn
         voU4vrEUyLb9UsDKIQHfru/vK5yM4pOAp3k2562E91i4aBi4Du692P1H88/ugWNPZttE
         SzHHbuKjC5jFECp+l9nhBa7/OfhnbCh+ojkHjtCtWZMChxLHPJ7nqLwCjuRvOZ2EAkfs
         Sz7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kZFNHIj+SfcYq9AlTwFrsQEBDKDiEWumGsUTDrWMVPQ=;
        b=75/4vGLBxWCKvBQCs+QgJ7wfDL+VazfC7njHfueUabI8wS7zUnq7/OGCOUR6mnBrrx
         7Xt+QfKPyuUYUmqj3aTWJH6ytRhPINSXaBKnUtGvyibEklKgdW0TtLwnQHYe298KZOeC
         4+qZSQOLz1Brem7TQLzLwsfygi6szn4Reel81ytw6j3BJbSCO8HV4nluCtrRJlMHPDUg
         OFviAIVtJUgDZTBWPpKoiF/wzjEXRapDC7nTqHYPwNzVQ8dFiNiGkTtbFVOL1sAALs8d
         ymMr6W9dxB+D4fu4eAxfJ2Flx8EE2e7WIy0sjYVqF6nVdLKkEdbSjXAgZGhhFjmmZFE2
         Zh5w==
X-Gm-Message-State: AOAM531uMYEGEf9qry93drQ4sCyrx9Ug5MpS948vpqjd5lNX+cO4g5ZT
        a88zb48wiczAmwlQlYM9we5VkNbfBn16LF06VOI=
X-Google-Smtp-Source: ABdhPJypD8mioCxRbg8o4TMtkdBZ3ZD7kSoBZlW5obg2B6YAds6cIdNEdM2h3neLJ5paA765/NTmIRbBsu12LOlowvw=
X-Received: by 2002:a05:6402:4c5:: with SMTP id n5mr3560532edw.122.1642069105299;
 Thu, 13 Jan 2022 02:18:25 -0800 (PST)
MIME-Version: 1.0
References: <20220113074614.407-1-josright123@gmail.com> <20220113074614.407-3-josright123@gmail.com>
In-Reply-To: <20220113074614.407-3-josright123@gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 13 Jan 2022 12:16:38 +0200
Message-ID: <CAHp75VeRx8X+5i7SG4KMKADAUj=tkbjfmFDwup5dQ64SLq4yvw@mail.gmail.com>
Subject: Re: [PATCH v11, 2/2] net: Add dm9051 driver
To:     Joseph CHAMG <josright123@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, joseph_chang@davicom.com.tw,
        netdev <netdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Leon Romanovsky <leon@kernel.org>,
        kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for update, my comments below.

On Thu, Jan 13, 2022 at 9:46 AM Joseph CHAMG <josright123@gmail.com> wrote:

Missed commit message.

...

> v1-v4
> v5
> v6
> v7
> v8
> v9
> v10

Changelog should go after the cutter '--- ' line below, it's strange
that you did it correctly only for v11 changelog and not for the rest.

...

> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: andy Shevchenko <andy.shevchenko@gmail.com>

Instead, utilize --cc parameter to `git send-email ...`

...

> Reported-by: kernel test robot <lkp@intel.com>

New driver can't be reported.

> Signed-off-by: Joseph CHAMG <josright123@gmail.com>
> ---
> v11

...

> +config DM9051
> +       tristate "DM9051 SPI support"
> +       select PHYLIB
> +       depends on SPI
> +       select CRC32

Please group dependencies first followed by selections.
Also, you missed to select corresponding regmap APIs (SPI and MDIO you
mentioned).

...

> +static int dm9051_map_read(struct board_info *db, u8 reg, unsigned int *prb)
> +{
> +       struct net_device *ndev = db->ndev;
> +       int ret = regmap_read(db->regmap, reg, prb);
> +
> +       if (unlikely(ret))
> +               netif_err(db, drv, ndev, "%s: error %d reading reg %02x\n",
> +                         __func__, ret, reg);
> +       return ret;
> +}
> +
> +static int dm9051_map_write(struct board_info *db, u8 reg, u16 val)
> +{
> +       struct net_device *ndev = db->ndev;
> +       int ret = regmap_write(db->regmap, reg, val);
> +
> +       if (unlikely(ret))
> +               netif_err(db, drv, ndev, "%s: error %d writing reg %02x=%04x\n",
> +                         __func__, ret, reg, val);
> +       return ret;
> +}

Redefining callbacks for the sake of printing messages? Hmm... dunno
if it's a good idea here.

...

> +       ret = dm9051_map_write(db, DM9051_EPDRL, val & 0xff); /* write ctl must once 8-bit */
> +       if (ret < 0)
> +               return ret;
> +       ret = dm9051_map_write(db, DM9051_EPDRH, val >> 8); /* write ctl must once 8-bit */
> +       if (ret < 0)
> +               return ret;

Wouldn't be better to use bulk write for these?

...

> +       ret = dm9051_map_read(db, DM9051_EPDRH, &eph); /* read ctl must once 8-bit */
> +       if (ret)
> +               return ret;
> +       ret = dm9051_map_read(db, DM9051_EPDRL, &epl); /* read ctl must once 8-bit */
> +       if (ret)
> +               return ret;
> +       *val = (eph << 8) | epl;

Wouldn't be better to use bulk read for these?

...

> +static bool dm9051_regmap_volatile(struct device *dev, unsigned int reg)
> +{
> +       return true; /* true, register can not be cached */
> +}

Do you need this wrapper?

...

> +       .lock = dm9051_reg_lock_mutex,
> +       .unlock = dm9051_reg_unlock_mutex,

But this doesn't protect against interleaved accesses. Is it fine?

...

> +static int dm9051_map_updbits(struct board_info *db, unsigned int reg,
> +                             unsigned int mask, unsigned int val)
> +{
> +       unsigned int set_mask = val & mask;
> +       unsigned int readd = 0; /* clear all insided bits */
> +       int ret = 0;
> +
> +       ret = regmap_read(db->regmap, reg, &readd);
> +       if (ret < 0)
> +               return ret;
> +
> +       if ((readd & mask) != set_mask) {
> +               readd &= ~mask;
> +               readd |= set_mask;
> +
> +               ret = regmap_write(db->regmap, reg, readd);
> +               if (ret < 0)
> +                       return ret;
> +       }
> +       return ret;
> +}

NIH regmap_update_bits().


...

> +static bool dm9051_phymap_volatile(struct device *dev, unsigned int reg)
> +{
> +       return true; /* true, register can not be cached */
> +}

Do you really need this?

...

> +static int dm9051_map_phy_updbits(struct board_info *db, unsigned int reg,
> +                                 unsigned int mask, unsigned int val)
> +{
> +       unsigned int set_mask = mask & val;
> +       unsigned int readd = 0;
> +       int ret;
> +
> +       ret = ctrl_dm9051_phyread(db, reg, &readd);
> +       if (ret)
> +               return ret;
> +
> +       if ((readd & mask) != set_mask) {
> +               readd &= ~mask;
> +               readd |= set_mask;
> +               ret = ctrl_dm9051_phywrite(db, reg, readd);
> +               if (ret)
> +                       return ret;
> +       }
> +       return ret;
> +}

NIH regmap_update_bits().

...

> +       ret = dm9051_map_read(db, DM9051_EPDRL, &mval); /* must read once 8-bit */
> +       if (ret < 0)
> +               return ret;
> +       to[0] = mval;
> +       ret = dm9051_map_read(db, DM9051_EPDRH, &mval); /* must read once 8-bit */
> +       if (ret < 0)
> +               return ret;

Why not _bulk operation?

...

> +       dm9051_map_write(db, DM9051_EPDRH, data[1]); /* must write once 8-bit */
> +       dm9051_map_write(db, DM9051_EPDRL, data[0]); /* must write once 8-bit */

Ditto.

...

> +       ret = dm9051_map_read(db, DM9051_PIDH, &wpidh);
> +       if (ret < 0)
> +               return ret;
> +       ret = dm9051_map_read(db, DM9051_PIDL, &wpidl);
> +       if (ret < 0)
> +               return ret;

> +       id = (wpidh << 8) | wpidl;

Ditto.

...

> +       if (id == DM9051_ID) {
> +               dev_info(dev, "chip %04x found\n", id);
> +               return 0;
> +       }
> +
> +       dev_info(dev, "chipid error as %04x !\n", id);

Why not dev_err()?

> +       return -ENODEV;

Please, use standard pattern, i.e. check for errors first:

  if (error condition) {
    ...
    return err;
  }

...

> +       for (i = 0; i < ETH_ALEN; i++) {
> +               ret = dm9051_map_read(db, DM9051_PAR + i, &mval);
> +               if (unlikely(ret))
> +                       return ret;
> +               addr[i] = mval;
> +       }

_bulk?

...

> +       if (is_valid_ether_addr(addr)) {
> +               eth_hw_addr_set(ndev, addr);
> +               return 0;
> +       }
> +
> +       eth_hw_addr_random(ndev);
> +       dev_dbg(&db->spidev->dev, "Use random MAC address\n");
> +       return 0;

Check for (kinda) error first.

...

> +       snprintf(phy_id, MII_BUS_ID_SIZE + 3, PHY_ID_FMT,
> +                db->mdiobus->id, DM9051_PHY_ID);

(1)

> +       db->phydev = phy_connect(db->ndev, phy_id, dm9051_handle_link_change,
> +                                PHY_INTERFACE_MODE_MII);

> +

This blank line is misplaced. Should be in (1).

> +       if (IS_ERR(db->phydev))
> +               return PTR_ERR(db->phydev);
> +       return 0;

return PTR_ERR_OR_ZERO(...);

> +}

...

> +               rdptr = (u8 *)skb_put(skb, rxlen - 4);

Do you need this casting?

...

> +       ret = dm9051_map_write(db, DM9051_TXPLL, len);
> +       if (ret < 0)
> +               return ret;
> +       ret = dm9051_map_write(db, DM9051_TXPLH, len >> 8);
> +       if (ret < 0)
> +               return ret;

_bulk?

...

> +       /* these registers can't write by inblk, must write one by one
> +        */

Why? regmap bulk does exactly this (if properly configured).

> +       for (i = 0; i < ETH_ALEN; i++) {
> +               result = dm9051_map_write(db, DM9051_PAR + i, ndev->dev_addr[i]);
> +               if (result < 0)
> +                       goto spi_err;
> +       }

...

> +       /* these registers can't write by inblk, must write one by one
> +        */

Ditto.

> +       for (oft = DM9051_MAR, i = 0; i < 4; i++) {
> +               result = dm9051_map_write(db, oft++, db->hash_table[i]);
> +               if (result < 0)
> +                       goto spi_err;
> +               result = dm9051_map_write(db, oft++, db->hash_table[i] >> 8);
> +               if (result < 0)
> +                       goto spi_err;
> +       }

...

> +               db->hash_table[hash_val / 16] |= (u16)1 << (hash_val % 16);

Do you need casting? Can you use 1U or BIT()?

...

> +static int devm_regmap_init_dm9051(struct spi_device *spi, struct board_info *db)
> +{
> +       regconfig.lock_arg = db; /* regmap lock/unlock essential */
> +
> +       db->regmap = devm_regmap_init_spi(db->spidev, &regconfig);

> +       if (IS_ERR(db->regmap))
> +               return PTR_ERR(db->regmap);
> +       return 0;

return PTR_ERR_OR_ZERO(...);

> +}

...

> +       db->mdiobus->phy_mask = (u32)~BIT(1);

GENMASK()

...

> +       ret = devm_mdiobus_register(&spi->dev, db->mdiobus);
> +       if (ret < 0) {

What does > 0 mean?

> +               dev_err(&spi->dev, "Could not register MDIO bus\n");

> +               return ret;
> +       }
> +       return 0;

Can it be

   return ret;

?

...

> +       if (IS_ERR(db->phymap))
> +               return PTR_ERR(db->phymap);
> +       return 0;

As above.

...

> +       db->kwr_task_kw = kthread_run(kthread_worker_fn, &db->kw, "dm9051");
> +       if (IS_ERR(db->kwr_task_kw))
> +               return PTR_ERR(db->kwr_task_kw);
> +
> +       mutex_init(&db->spi_lock);
> +       mutex_init(&db->reg_mutex);

Are you sure it's good to have thread running without initializations
of locks, etc?

...

> +static int dm9051_drv_remove(struct spi_device *spi)
> +{
> +       struct device *dev = &spi->dev;
> +       struct net_device *ndev = dev_get_drvdata(dev);
> +       struct board_info *db = to_dm9051_board(ndev);
> +
> +       phy_disconnect(db->phydev);
> +       kthread_stop(db->kwr_task_kw);
> +       return 0;
> +}

Seems like a wrong order of the resource freeing.

...

> +++ b/drivers/net/ethernet/davicom/dm9051.h

Do oyu need it to be a separate header?

...

> +#include <linux/bitfield.h>

Not sure I saw the user of this header below.

> +#include <linux/mutex.h>

> +#include <linux/netdevice.h>

...

> +struct rx_ctl_mach {
> +       u16                             status_err_counter;  /* 'Status Err' counter */
> +       u16                             large_err_counter;  /* 'Large Err' counter */
> +       u16                             DO_FIFO_RST_counter; /* 'fifo_reset' counter */

Can you rather have these comments in kernel doc?

> +};

...

> +struct board_info

Why do you need this definition in the header?

-- 
With Best Regards,
Andy Shevchenko
