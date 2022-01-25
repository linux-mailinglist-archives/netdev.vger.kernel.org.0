Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EABB149B712
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 16:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349175AbiAYPAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 10:00:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1580814AbiAYOwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 09:52:35 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33793C061401;
        Tue, 25 Jan 2022 06:52:34 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id u18so49343789edt.6;
        Tue, 25 Jan 2022 06:52:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+kGacvdzzCD6QPq8PV1iVn7D6O+2KzgMqS70OsbrFYQ=;
        b=Yu7pLJMLfgzlzf9ovzBXVxyYr/qzb+CvjSdDzhO42TEjdsuuJoEasVu17KFNUY+Z9/
         ++83IAn3Gao+GtQQN8+4YjMbC8gHgSr+M2HQNZRokWwrDutGSEh4vfszqzqaJ2y8X6oP
         Zq949DML/m7S2eqeiNtThdqEGFw/iGA7sJmS3TKcmoW2CjbdDQdWtlYJwU9qImp8AGJ4
         l1znaDsNSoXNwUSJjpe4HEFc4mVRWvdN0oyw6dGovLYyreYf6RaCftxe//j75hNQ1kID
         ksjyQHrUznDS2YOR9jU4eSl7kMsDe1FF5NfAnSE3iIz7XdzNiZzCgusNI+z/IUu4snlb
         zbsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+kGacvdzzCD6QPq8PV1iVn7D6O+2KzgMqS70OsbrFYQ=;
        b=JlRrrmRO9T+8uBv8AuyBpJeUtvlJnb5GInzmP45GTt+DMOfLC3hBbmsV/Pn0ynb9xB
         M+OKX4Qbs8Iq3xkyYBMzQFg80yH4WhbxNQ8QqjEKbBovvydcltMOxColtK4IBqc+8dvP
         5xHnmClrm7OnSmhh2lUKrOP8EgnkMnCrfcJ7Fc5IF0pp8DSMPuB9J5pvUzU4sFKMl8rQ
         aiZVpu8+BRwmioqRam/E1ZY3YATkYY2KRZM2hgMDqph3YTYp4mYVXQ/SlB7UocMofZma
         uZpmBvsrEyXrNkiN07mqvRqoBBauVrT06Vh8ym2d+gkTzk7zuT28uocSvLLpDZa5KVMh
         4+jg==
X-Gm-Message-State: AOAM530kw4357Axx+FzqDvekrKA9ZpAPQmxwsIEHQrua9xFUeWeRJxOo
        uVO3xdHtFtwhCczfK9oZLYzZ0Dcq3Y3S2fm4IhU=
X-Google-Smtp-Source: ABdhPJxNcdIZR214oE7LafSn66ibQhAT6BqnKIutmDO1RoylpDHkgokt7k3YXTz+7+x0/44BmJdUjIZVfU11PrtXqPg=
X-Received: by 2002:a05:6402:35d5:: with SMTP id z21mr13592745edc.29.1643122352627;
 Tue, 25 Jan 2022 06:52:32 -0800 (PST)
MIME-Version: 1.0
References: <20220125085837.10357-1-josright123@gmail.com> <20220125085837.10357-3-josright123@gmail.com>
In-Reply-To: <20220125085837.10357-3-josright123@gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 25 Jan 2022 16:50:53 +0200
Message-ID: <CAHp75VfrP7ZkeYGu_7XL98veJNDNmjnkL_cieS+53WNOM7KVHQ@mail.gmail.com>
Subject: Re: [PATCH v13, 2/2] net: Add dm9051 driver
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

On Tue, Jan 25, 2022 at 10:59 AM Joseph CHAMG <josright123@gmail.com> wrote:
>
> Add davicom dm9051 spi ethernet driver. The driver work for the
> device platform with spi master

This is better, but please use a grammar period as well.

> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: andy Shevchenko <andy.shevchenko@gmail.com>

Andy

And you may utilize --cc parameter to git send-email or move this Cc
block behind the cutter '--- ' line.

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

types.h is missing

...

> +/**
> + * struct rx_ctl_mach - rx activities record

> + *

In all similar cases remove this blank line.

> + * @status_err_counter: rx status error counter
> + * @large_err_counter: rx get large packet length error counter
> + * @fifo_rst_counter: reset operation counter
> + *
> + * To keep track for the driver operation statistics
> + */

...

> +/**
> + * struct dm9051_rxhdr - rx packet data header
> + *
> + * @rxpktready: lead byte is 0x01 tell a valid packet
> + * @rxstatus: status bits for the received packet
> + * @rxlen: packet length
> + *

> + * The rx packet enter into the fifo memory is start with these four

The Rx packed, entered into the FIFO memory, starts with

> + * bytes which is the rx header, follow this header is the ethernet

Rx header, followed by the ethernet

> + * packet data and end with a appended 4-byte CRC data.

ends
an appended


> + * Both rx packet and CRC data are for check purpose and finally are
> + * dropped by this driver
> + */

...

> + * @kw_rxctrl: kernel thread worke structure for rx control

worker?

...

> +       int ret = regmap_read_poll_timeout(db->regmap_dm, DM9051_NSR, mval,
> +                                          mval & (NSR_TX2END | NSR_TX1END), 1, 20);
> +
> +       if (ret)

Please, split the assignment and get it closer to its user, so

  int ret;

  ret = ...
  if (ret)

This applies to all similar cases.

Actually all comments are against the entire code even if it's given
only for one occurrence of the similar code block.

> +               netdev_err(db->ndev, "timeout in checking for tx ends\n");
> +       return ret;
> +}

...

> +       ret = regmap_bulk_read(db->regmap_dmbulk, DM9051_EPDRL, to, 2);
> +       if (ret < 0)
> +               return ret;
> +       return ret;

  return regmap_...(...);

Same for other similar places.

...

> +       /* this is a 2 bytes data written via regmap_bulk_write
> +        */

Useless comments.

...

> +static int dm9051_mdiobus_read(struct mii_bus *mdiobus, int phy_id, int reg)
> +{
> +       struct board_info *db = mdiobus->priv;

> +       unsigned int val = 0;

You can  do

  val = 0xffff;

here...

> +       int ret;
> +
> +       if (phy_id == DM9051_PHY_ID) {
> +               ret = ctrl_dm9051_phyread(db, reg, &val);
> +               if (ret)
> +                       return ret;

> +               return val;
> +       }
> +       return 0xffff;

...and

  }
  return val;

here.

> +}


> +       while (count--) {

If the count is guaranteed to be greater than 0, it would be better to use

  do {
    ...
  } while (--count);

> +               ret = regmap_read(db->regmap_dm, reg, &rb);
> +               if (ret) {
> +                       netif_err(db, drv, ndev, "%s: error %d dumping read reg %02x\n",
> +                                 __func__, ret, reg);
> +                       break;
> +               }
> +       }
> +       return ret;
> +}

...

> +#ifndef _DM9051_H_
> +#define _DM9051_H_
> +
> +#include <linux/bitfield.h>

There is no user of this header, but missing bits.h and one that
provides netdev_priv().

...

> +#define DRVNAME_9051           "dm9051"

Why is this in the header?


--
With Best Regards,
Andy Shevchenko
