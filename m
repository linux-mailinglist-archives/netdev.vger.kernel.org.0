Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 172F948527D
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 13:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236582AbiAEMc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 07:32:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231857AbiAEMcz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 07:32:55 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D64C061761;
        Wed,  5 Jan 2022 04:32:54 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id bm14so161387980edb.5;
        Wed, 05 Jan 2022 04:32:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t2mRxwjJ3sQ6LACbsnguwAozobHd6VsPoNd7LZmiFH8=;
        b=Gc+xy4XeAGiqi248XRuvU7yJpAmaMiA5H8262nmKxtobB7ij3DX8Qrhws3D4rAt3zi
         mTVPx1vQcJRURCG5AffiAt6LXHFSLzO6kuL05mspsfVG7DFfPJxKkvblZJmrQ+SH+1/E
         /G5Ixyd79qvJrr2Huf26ff6m83j0b09/zvFVJAU/iHAGDHs3Te798GkSFpdlHwxD8wac
         qqxJs5DuwskCpZiVV10i8Y6PwaY0zjtwlVo+ttVSxqIsqCS9ELJq7YSFfXAyVKSh/Ot/
         8QSeqyR1JxQiYca9NEsuy9z9mBb3LktOkOKrbvGux3V8lnBlTj+SCSwjt79WkOyo7hEH
         Q8jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t2mRxwjJ3sQ6LACbsnguwAozobHd6VsPoNd7LZmiFH8=;
        b=7SG2UE0D3WIxZr0DjQp0S4Y97PfPbHs30/DH1mzJK9Tbu9IrXEFxlV3mlvmasC7ApQ
         Ren6oB1lWFtbgXtbjBWeOEjiVQYUtkqH29Au72tVeT2dESut1ICAy82WA7Ay7oDH/XL1
         kANxlqX3llE4tk98iS/+s1v55CtVWQb/85X+IVijbLwYChl0na1KnDt2VcYlNsX8CBpE
         a5CQhyMU0V961Xh9citIEYULnbpHVAQYkT5C7zr1O6K07QCYQtRyJj2z7Jm2xp+yZv8e
         sdvQM7h+kj0MMWsyE3NGfo33AYIi0fTwCsBFP409m9DToofSBQIwlEIojWzj1gOdFB3K
         /VHw==
X-Gm-Message-State: AOAM533jfclnXivHNTtOsFVhPblSEHifIxOaZUChyBNUGcaFEj3xozVf
        Hfg4b23eK8PSyBSccVWfuZw+Vs6bXyQmewiuLTSgcX56oyVmCQ==
X-Google-Smtp-Source: ABdhPJxCcTzYQ8gzNKvJSHl5U+/0RhZrs7GOUhVB7k0QWptqTCxlUgnqDLVOqTtGCaNRjudmOu5S/qocH8xDMc8XFGk=
X-Received: by 2002:a17:906:a3c6:: with SMTP id ca6mr41898560ejb.639.1641385973243;
 Wed, 05 Jan 2022 04:32:53 -0800 (PST)
MIME-Version: 1.0
References: <20220105081728.4289-1-josright123@gmail.com> <20220105081728.4289-3-josright123@gmail.com>
In-Reply-To: <20220105081728.4289-3-josright123@gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 5 Jan 2022 14:31:02 +0200
Message-ID: <CAHp75VfvfokzL2anenFKGyLE68RJfJ7ktSGhh3q7rsi5woLaxg@mail.gmail.com>
Subject: Re: [PATCH v10, 2/2] net: Add dm9051 driver
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

On Wed, Jan 5, 2022 at 10:18 AM Joseph CHAMG <josright123@gmail.com> wrote:

Missed commit message.

> v1-v4
>
> Add davicom dm9051 spi ethernet driver. The driver work for the
> device platform with spi master
>
> Test ok with raspberry pi 2 and pi 4, the spi configure used in
> my raspberry pi 4 is spi0.1, spi speed 31200000, and INT by pin 26.
>
> v5
>
> Work to eliminate the wrappers to be clear for read, swapped to
> phylib for phy connection tasks.
>
> Tested with raspberry pi 4. Test for netwroking function, CAT5
> cable unplug/plug and also ethtool detect for link state, and
> all are ok.
>
> v6
>
> remove the redundant code that phylib has support,
> adjust to be the reasonable sequence,
> fine tune comments, add comments for pause function support
>
> Tested with raspberry pi 4. Test for netwroking function, CAT5
> cable unplug/plug and also ethtool detect for link state, and
> all are ok.
>
> v7
>
> read/write registers must return error code to the callet,
> add to enable pause processing
>
> v8
>
> not parmanently set MAC by .ndo_set_mac_address
>
> correct rx function such as clear ISR,
> inblk avoid stack buffer,
> simple skb buffer process and
> easy use netif_rx_ni.
>
> simplely queue init and wake the queues,
> limit the start_xmit function use netif_stop_queue.
>
> descript that schedule delay is essential
> for tx_work and rxctrl_work
>
> eliminate ____cacheline_aligned and
> add static int msg_enable.
>
> v9
>
> use phylib, no need 'select MII' in Kconfig,
> make it clear in dm9051_xfer when using spi_sync,
> improve the registers read/write so that error code
> return as far as possible up the call stack.
>
> v10
>
> use regmap APIs for SPI and MDIO,
> modify to correcting such as include header files
> and program check styles

Changelog should go after the cutter '--- ' line below...

> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: andy Shevchenko <andy.shevchenko@gmail.com>
> Signed-off-by: Joseph CHAMG <josright123@gmail.com>
> ---

...somewhere here.

...

> +#include <linux/etherdevice.h>
> +#include <linux/ethtool.h>
> +#include <linux/interrupt.h>
> +#include <linux/iopoll.h>
> +#include <linux/mii.h>
> +#include <linux/module.h>
> +#include <linux/netdevice.h>
> +#include <linux/phy.h>
> +#include <linux/regmap.h>
> +#include <linux/skbuff.h>
> +#include <linux/spinlock.h>
> +#include <linux/spi/spi.h>

...

> +/* spi master low level code */
> +static int hw_dm9051_spi_write(void *context, u8 reg, const u8 *data, size_t count)

> +static int hw_dm9051_spi_read(void *context, u8 reg, u8 *data, size_t count)

> +static int regmap_dm9051_reg_write(void *context, const void *data, size_t len)

> +static int regmap_dm9051_reg_read(void *context, const void *reg_buf, size_t reg_size,
> +                                 void *val, size_t val_size)

> +static int regmap_dm9051_reg_update_bits(void *context, unsigned int reg,
> +                                        unsigned int mask,
> +                                        unsigned int val)

All these are implemented by regmap SPI API. Why don't you use it?

...

> +static bool dm9051_regmap_readable(struct device *dev, unsigned int reg)
> +{
> +       return true;
> +}
> +
> +static bool dm9051_regmap_writeable(struct device *dev, unsigned int reg)
> +{
> +       return true;
> +}
> +
> +static bool dm9051_regmap_volatile(struct device *dev, unsigned int reg)
> +{
> +       return true; /* optional false */
> +}
> +
> +static bool dm9051_regmap_precious(struct device *dev, unsigned int reg)
> +{
> +       return true; /* optional false */
> +}

These stubs are redundant.

...

> +static void regmap_lock_mutex(void *context)
> +{
> +       struct board_info *db = context;
> +
> +       mutex_lock(&db->regmap_mutex);
> +}
> +
> +static void regmap_unlock_mutex(void *context)
> +{
> +       struct board_info *db = context;
> +
> +       mutex_unlock(&db->regmap_mutex);
> +}

Why do you need this? Either you use lock provided by regmap, or you
disable locking for regmap and provide your own locking scheme (should
be justified in the commit message).

...

> +static struct regmap_config regconfig = {

> +       .name = "reg",

Do you need this?

> +       .reg_bits = 8,
> +       .val_bits = 8,
> +       .max_register = 0xff,
> +       .reg_stride = 1,
> +       .cache_type = REGCACHE_RBTREE,
> +       .val_format_endian = REGMAP_ENDIAN_LITTLE,

> +};

...

> +static int dm9051_map_poll(struct board_info *db)
> +{
> +       unsigned int mval;
> +       int ret;
> +
> +       ret = read_poll_timeout(regmap_read, ret, !ret || !(mval & EPCR_ERRE),
> +                               100, 10000, true, db->regmap, DM9051_EPCR, &mval);
> +       if (ret)
> +               netdev_err(db->ndev, "timeout in processing for phy/eeprom accessing\n");
> +       return ret;
> +}

regmap has a corresponding API, i.e. regmap_read_poll_timeout().

...

> +static int regmap_dm9051_phy_reg_write(void *context, unsigned int reg, unsigned int val)
> +{
> +       struct board_info *db = context;
> +       int ret;
> +
> +       regmap_write(db->regmap, DM9051_EPAR, DM9051_PHY | reg);

> +       regmap_write(db->regmap, DM9051_EPDRL, val & 0xff);
> +       regmap_write(db->regmap, DM9051_EPDRH, (val >> 8) && 0xff);

Shouldn't be this a bulk write?
Ditto for all other cases where you need to write 16-bit values in
sequential addresses.

> +       regmap_write(db->regmap, DM9051_EPCR, EPCR_EPOS | EPCR_ERPRW);
> +       ret = dm9051_map_poll(db);
> +       regmap_write(db->regmap, DM9051_EPCR, 0x0);
> +
> +       if (reg == MII_BMCR && !(val & 0x0800))
> +               mdelay(1); /* need for if activate phyxcer */
> +
> +       return ret;
> +}

...

> +static int devm_regmap_init_dm9051(struct device *dev, struct board_info *db)
> +{
> +       mutex_init(&db->regmap_mutex);
> +
> +       regconfig.lock_arg = db;
> +
> +       db->regmap = devm_regmap_init(dev, &regmap_spi, db, &regconfig);
> +       if (IS_ERR(db->regmap))
> +               return PTR_ERR(db->regmap);
> +       db->phymap = devm_regmap_init(dev, &phymap_mdio, db, &phyconfig);
> +       if (IS_ERR(db->phymap))
> +               return PTR_ERR(db->phymap);

Use corresponding regmap APIs, i.e. MDIO, SPI, etc.

> +       return 0;
> +}

...

> +{
> +       int ret;
> +       u8 rxb[1];
> +
> +       while (len--) {
> +               ret = hw_dm9051_spi_read(db, DM_SPI_MRCMD, rxb, 1);
> +               if (ret < 0)
> +                       return ret;
> +       }
> +       return ret;
> +}

I believe the regmap API provides this kind of read (bulk with no
increment addresses or so).

I stopped here, because it's enough for now. Just take your time to
see how other (recent) drivers are implemented.

-- 
With Best Regards,
Andy Shevchenko
