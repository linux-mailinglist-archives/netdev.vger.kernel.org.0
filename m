Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C59E42C788C
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 10:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgK2J4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 04:56:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbgK2J4E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 04:56:04 -0500
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C24A0C0613CF;
        Sun, 29 Nov 2020 01:55:23 -0800 (PST)
Received: by mail-lj1-x244.google.com with SMTP id j10so12154957lja.5;
        Sun, 29 Nov 2020 01:55:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6XkhWTU/zHmW4L14lFNXuMuv9qUGydEYcbZsIYX6biY=;
        b=PUmagK61jUbatp34j1flbIE+mSh9BPdrkmSUyIiAW08vjYSLakP/IfN/yloC0GqCpn
         lNHqUdLO9AV4anp+TtrUVsLfNEds4uxiaqPwJjh0Qncfd4LkNXK9PWPzHtBVsls9XkcZ
         yvJpapV8GXrplKAKDW/ikr+GsElyXPdjtoP/ZItpTLuozxhP53eDPWRI0ky6E3lE3M9w
         vf5jMYz+6/fQ0x3Ws7wqZNYMcceeIIrIdJbBjGoDRVIopwxiHnFHq4ZG0317atXWRs0i
         qeP282L7+gKtAuibqMhcj7YMFrwo6cifylownaNaExIquSYmW4cmqGtEE8CaqpbAS/iT
         cnPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6XkhWTU/zHmW4L14lFNXuMuv9qUGydEYcbZsIYX6biY=;
        b=Yaejzhcv+WoZ0/MGPwSL+MtpRvIIYOZ4A7ZjL8edN90un5iBK+ZDjiATR6g++zn8my
         9ogdLMFs1ij1AG/oB5wfEBANR+U9OqYf9isfPWYijFkpyBFF8ETj0Jd41Mi0F/r60ESf
         EB8QLER1LlNxdpk5UEc7auxA+XrUO5ZmnCSfmhJgPMFJb3asH5v+WG49Q9pYbUkXlQRJ
         pog9VqwLLaopqokTr5ucT/xvwhHV5M0AjzhRHtN4Um0IVceVlq7iiPFh1oXgx+Wc68AU
         J+CO/TdsnHbXTuQgfCj2j08tDwQlnWyH8UbK0EGeW4GATvnhF08jDuGtGdHnEglqXT5l
         tv/Q==
X-Gm-Message-State: AOAM530b6iikzwurir4DSKmPJRgMbWZn+IsZO6DmH3RQlRhwd8pS+VU2
        JKg167E/DdZbqHJPAsRbJHP4juDBHXx7/vKLkulnY2mxmWQ=
X-Google-Smtp-Source: ABdhPJx5oEDWFtFJA3/8NpP0Dm6E8ExvfD0xUvTvrvaEiEyn8BYKgX2HGqXg7qu2fQQBXLOe5yCKFyMipnAldYfjZLw=
X-Received: by 2002:a2e:9681:: with SMTP id q1mr7100900lji.2.1606643722023;
 Sun, 29 Nov 2020 01:55:22 -0800 (PST)
MIME-Version: 1.0
References: <1606476138-31992-1-git-send-email-bongsu.jeon2@gmail.com> <20201128124920.GB6313@kozik-lap>
In-Reply-To: <20201128124920.GB6313@kozik-lap>
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
Date:   Sun, 29 Nov 2020 18:55:10 +0900
Message-ID: <CACwDmQC_QrWz=vJN0u0eQAX0fGV__W8cLBF5q7goCxB7Wc2y7A@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 3/3] nfc: s3fwrn5: extract the common phy blocks
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Krzysztof Opasiak <k.opasiak@samsung.com>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 28, 2020 at 9:49 PM Krzysztof Kozlowski <krzk@kernel.org> wrote:
>
> On Fri, Nov 27, 2020 at 08:22:18PM +0900, bongsu.jeon2@gmail.com wrote:
> > From: Bongsu Jeon <bongsu.jeon@samsung.com>
> >
> > Extract the common phy blocks to reuse it.
> > The UART module will use the common blocks.
> >
> > Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
> > ---
> > Changes in v2:
> >  - remove the common function's definition in common header file.
> >  - make the common phy_common.c file to define the common function.
> >  - wrap the lines.
> >  - change the Header guard.
> >  - remove the unused common function.
> >
> >  drivers/nfc/s3fwrn5/Makefile     |   2 +-
> >  drivers/nfc/s3fwrn5/i2c.c        | 114 +++++++++++++--------------------------
> >  drivers/nfc/s3fwrn5/phy_common.c |  60 +++++++++++++++++++++
> >  drivers/nfc/s3fwrn5/phy_common.h |  31 +++++++++++
> >  4 files changed, 129 insertions(+), 78 deletions(-)
> >  create mode 100644 drivers/nfc/s3fwrn5/phy_common.c
> >  create mode 100644 drivers/nfc/s3fwrn5/phy_common.h
> >
> > diff --git a/drivers/nfc/s3fwrn5/Makefile b/drivers/nfc/s3fwrn5/Makefile
> > index d0ffa35..a5279c6 100644
> > --- a/drivers/nfc/s3fwrn5/Makefile
> > +++ b/drivers/nfc/s3fwrn5/Makefile
> > @@ -4,7 +4,7 @@
> >  #
> >
> >  s3fwrn5-objs = core.o firmware.o nci.o
> > -s3fwrn5_i2c-objs = i2c.o
> > +s3fwrn5_i2c-objs = i2c.o phy_common.o
>
> Thanks for the changes.
>
> Shouldn't this be part of s3fwrn5.ko? Otherwise you would duplicate the
> objects in two modules.
>

Okay. It could be better to avoid the duplication.
I will try to move phy_common.c to s3fwrn5.ko.

> >
> >  obj-$(CONFIG_NFC_S3FWRN5) += s3fwrn5.o
> >  obj-$(CONFIG_NFC_S3FWRN5_I2C) += s3fwrn5_i2c.o
> > diff --git a/drivers/nfc/s3fwrn5/i2c.c b/drivers/nfc/s3fwrn5/i2c.c
> > index 9a64eea..207f970 100644
> > --- a/drivers/nfc/s3fwrn5/i2c.c
> > +++ b/drivers/nfc/s3fwrn5/i2c.c
> > @@ -16,74 +16,30 @@
> >  #include <net/nfc/nfc.h>
> >
> >  #include "s3fwrn5.h"
> > +#include "phy_common.h"
> >
> >  #define S3FWRN5_I2C_DRIVER_NAME "s3fwrn5_i2c"
> >
> > -#define S3FWRN5_EN_WAIT_TIME 20
> > -
> >  struct s3fwrn5_i2c_phy {
> > +     struct phy_common common;
> >       struct i2c_client *i2c_dev;
> > -     struct nci_dev *ndev;
> > -
> > -     int gpio_en;
> > -     int gpio_fw_wake;
> > -
> > -     struct mutex mutex;
> >
> > -     enum s3fwrn5_mode mode;
> >       unsigned int irq_skip:1;
> >  };
> >
> > -static void s3fwrn5_i2c_set_wake(void *phy_id, bool wake)
> > -{
> > -     struct s3fwrn5_i2c_phy *phy = phy_id;
> > -
> > -     mutex_lock(&phy->mutex);
> > -     gpio_set_value(phy->gpio_fw_wake, wake);
> > -     msleep(S3FWRN5_EN_WAIT_TIME);
> > -     mutex_unlock(&phy->mutex);
> > -}
> > -
> >  static void s3fwrn5_i2c_set_mode(void *phy_id, enum s3fwrn5_mode mode)
> >  {
> >       struct s3fwrn5_i2c_phy *phy = phy_id;
> >
> > -     mutex_lock(&phy->mutex);
> > +     mutex_lock(&phy->common.mutex);
> >
> > -     if (phy->mode == mode)
> > +     if (s3fwrn5_phy_power_ctrl(&phy->common, mode) == false)
> >               goto out;
> >
> > -     phy->mode = mode;
> > -
> > -     gpio_set_value(phy->gpio_en, 1);
> > -     gpio_set_value(phy->gpio_fw_wake, 0);
> > -     if (mode == S3FWRN5_MODE_FW)
> > -             gpio_set_value(phy->gpio_fw_wake, 1);
> > -
> > -     if (mode != S3FWRN5_MODE_COLD) {
> > -             msleep(S3FWRN5_EN_WAIT_TIME);
> > -             gpio_set_value(phy->gpio_en, 0);
> > -             msleep(S3FWRN5_EN_WAIT_TIME);
> > -     }
> > -
> >       phy->irq_skip = true;
> >
> >  out:
> > -     mutex_unlock(&phy->mutex);
> > -}
> > -
> > -static enum s3fwrn5_mode s3fwrn5_i2c_get_mode(void *phy_id)
> > -{
> > -     struct s3fwrn5_i2c_phy *phy = phy_id;
> > -     enum s3fwrn5_mode mode;
> > -
> > -     mutex_lock(&phy->mutex);
> > -
> > -     mode = phy->mode;
> > -
> > -     mutex_unlock(&phy->mutex);
> > -
> > -     return mode;
> > +     mutex_unlock(&phy->common.mutex);
> >  }
> >
> >  static int s3fwrn5_i2c_write(void *phy_id, struct sk_buff *skb)
> > @@ -91,7 +47,7 @@ static int s3fwrn5_i2c_write(void *phy_id, struct sk_buff *skb)
> >       struct s3fwrn5_i2c_phy *phy = phy_id;
> >       int ret;
> >
> > -     mutex_lock(&phy->mutex);
> > +     mutex_lock(&phy->common.mutex);
> >
> >       phy->irq_skip = false;
> >
> > @@ -102,7 +58,7 @@ static int s3fwrn5_i2c_write(void *phy_id, struct sk_buff *skb)
> >               ret  = i2c_master_send(phy->i2c_dev, skb->data, skb->len);
> >       }
> >
> > -     mutex_unlock(&phy->mutex);
> > +     mutex_unlock(&phy->common.mutex);
> >
> >       if (ret < 0)
> >               return ret;
> > @@ -114,9 +70,9 @@ static int s3fwrn5_i2c_write(void *phy_id, struct sk_buff *skb)
> >  }
> >
> >  static const struct s3fwrn5_phy_ops i2c_phy_ops = {
> > -     .set_wake = s3fwrn5_i2c_set_wake,
> > +     .set_wake = s3fwrn5_phy_set_wake,
> >       .set_mode = s3fwrn5_i2c_set_mode,
> > -     .get_mode = s3fwrn5_i2c_get_mode,
> > +     .get_mode = s3fwrn5_phy_get_mode,
> >       .write = s3fwrn5_i2c_write,
> >  };
> >
> > @@ -128,7 +84,7 @@ static int s3fwrn5_i2c_read(struct s3fwrn5_i2c_phy *phy)
> >       char hdr[4];
> >       int ret;
> >
> > -     hdr_size = (phy->mode == S3FWRN5_MODE_NCI) ?
> > +     hdr_size = (phy->common.mode == S3FWRN5_MODE_NCI) ?
> >               NCI_CTRL_HDR_SIZE : S3FWRN5_FW_HDR_SIZE;
> >       ret = i2c_master_recv(phy->i2c_dev, hdr, hdr_size);
> >       if (ret < 0)
> > @@ -137,7 +93,7 @@ static int s3fwrn5_i2c_read(struct s3fwrn5_i2c_phy *phy)
> >       if (ret < hdr_size)
> >               return -EBADMSG;
> >
> > -     data_len = (phy->mode == S3FWRN5_MODE_NCI) ?
> > +     data_len = (phy->common.mode == S3FWRN5_MODE_NCI) ?
> >               ((struct nci_ctrl_hdr *)hdr)->plen :
> >               ((struct s3fwrn5_fw_header *)hdr)->len;
> >
> > @@ -157,24 +113,24 @@ static int s3fwrn5_i2c_read(struct s3fwrn5_i2c_phy *phy)
> >       }
> >
> >  out:
> > -     return s3fwrn5_recv_frame(phy->ndev, skb, phy->mode);
> > +     return s3fwrn5_recv_frame(phy->common.ndev, skb, phy->common.mode);
> >  }
> >
> >  static irqreturn_t s3fwrn5_i2c_irq_thread_fn(int irq, void *phy_id)
> >  {
> >       struct s3fwrn5_i2c_phy *phy = phy_id;
> >
> > -     if (!phy || !phy->ndev) {
> > +     if (!phy || !phy->common.ndev) {
> >               WARN_ON_ONCE(1);
> >               return IRQ_NONE;
> >       }
> >
> > -     mutex_lock(&phy->mutex);
> > +     mutex_lock(&phy->common.mutex);
> >
> >       if (phy->irq_skip)
> >               goto out;
> >
> > -     switch (phy->mode) {
> > +     switch (phy->common.mode) {
> >       case S3FWRN5_MODE_NCI:
> >       case S3FWRN5_MODE_FW:
> >               s3fwrn5_i2c_read(phy);
> > @@ -184,7 +140,7 @@ static irqreturn_t s3fwrn5_i2c_irq_thread_fn(int irq, void *phy_id)
> >       }
> >
> >  out:
> > -     mutex_unlock(&phy->mutex);
> > +     mutex_unlock(&phy->common.mutex);
> >
> >       return IRQ_HANDLED;
> >  }
> > @@ -197,19 +153,21 @@ static int s3fwrn5_i2c_parse_dt(struct i2c_client *client)
> >       if (!np)
> >               return -ENODEV;
> >
> > -     phy->gpio_en = of_get_named_gpio(np, "en-gpios", 0);
> > -     if (!gpio_is_valid(phy->gpio_en)) {
> > +     phy->common.gpio_en = of_get_named_gpio(np, "en-gpios", 0);
> > +     if (!gpio_is_valid(phy->common.gpio_en)) {
> >               /* Support also deprecated property */
> > -             phy->gpio_en = of_get_named_gpio(np, "s3fwrn5,en-gpios", 0);
> > -             if (!gpio_is_valid(phy->gpio_en))
> > +             phy->common.gpio_en =
> > +                             of_get_named_gpio(np, "s3fwrn5,en-gpios", 0);
>
> This is not a proper wrapping. Wrapping happens on function arguments.
>
> > +             if (!gpio_is_valid(phy->common.gpio_en))
> >                       return -ENODEV;
> >       }
> >
> > -     phy->gpio_fw_wake = of_get_named_gpio(np, "wake-gpios", 0);
> > -     if (!gpio_is_valid(phy->gpio_fw_wake)) {
> > +     phy->common.gpio_fw_wake = of_get_named_gpio(np, "wake-gpios", 0);
> > +     if (!gpio_is_valid(phy->common.gpio_fw_wake)) {
> >               /* Support also deprecated property */
> > -             phy->gpio_fw_wake = of_get_named_gpio(np, "s3fwrn5,fw-gpios", 0);
> > -             if (!gpio_is_valid(phy->gpio_fw_wake))
> > +             phy->common.gpio_fw_wake =
> > +                             of_get_named_gpio(np, "s3fwrn5,fw-gpios", 0);
> > +             if (!gpio_is_valid(phy->common.gpio_fw_wake))
>
> The same.
>

Even though I wrapped this as below, Second line("s3fwrn5,fw-gpios" )
was over 80 columns.
Is it okay as below?
phy->gpio_fw_wake =of_get_named_gpio(np,

"s3fwrn5,fw-gpios",
                                                                     0);


> >                       return -ENODEV;
> >       }
> >
> > @@ -226,8 +184,8 @@ static int s3fwrn5_i2c_probe(struct i2c_client *client,
> >       if (!phy)
> >               return -ENOMEM;
> >
> > -     mutex_init(&phy->mutex);
> > -     phy->mode = S3FWRN5_MODE_COLD;
> > +     mutex_init(&phy->common.mutex);
> > +     phy->common.mode = S3FWRN5_MODE_COLD;
> >       phy->irq_skip = true;
> >
> >       phy->i2c_dev = client;
> > @@ -237,17 +195,19 @@ static int s3fwrn5_i2c_probe(struct i2c_client *client,
> >       if (ret < 0)
> >               return ret;
> >
> > -     ret = devm_gpio_request_one(&phy->i2c_dev->dev, phy->gpio_en,
> > -             GPIOF_OUT_INIT_HIGH, "s3fwrn5_en");
> > +     ret = devm_gpio_request_one(&phy->i2c_dev->dev, phy->common.gpio_en,
> > +                                 GPIOF_OUT_INIT_HIGH, "s3fwrn5_en");
> >       if (ret < 0)
> >               return ret;
> >
> > -     ret = devm_gpio_request_one(&phy->i2c_dev->dev, phy->gpio_fw_wake,
> > -             GPIOF_OUT_INIT_LOW, "s3fwrn5_fw_wake");
> > +     ret = devm_gpio_request_one(&phy->i2c_dev->dev,
> > +                                 phy->common.gpio_fw_wake,
> > +                                 GPIOF_OUT_INIT_LOW, "s3fwrn5_fw_wake");
> >       if (ret < 0)
> >               return ret;
> >
> > -     ret = s3fwrn5_probe(&phy->ndev, phy, &phy->i2c_dev->dev, &i2c_phy_ops);
> > +     ret = s3fwrn5_probe(&phy->common.ndev, phy, &phy->i2c_dev->dev,
> > +                         &i2c_phy_ops);
> >       if (ret < 0)
> >               return ret;
> >
> > @@ -255,7 +215,7 @@ static int s3fwrn5_i2c_probe(struct i2c_client *client,
> >               s3fwrn5_i2c_irq_thread_fn, IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
> >               S3FWRN5_I2C_DRIVER_NAME, phy);
> >       if (ret)
> > -             s3fwrn5_remove(phy->ndev);
> > +             s3fwrn5_remove(phy->common.ndev);
> >
> >       return ret;
> >  }
> > @@ -264,7 +224,7 @@ static int s3fwrn5_i2c_remove(struct i2c_client *client)
> >  {
> >       struct s3fwrn5_i2c_phy *phy = i2c_get_clientdata(client);
> >
> > -     s3fwrn5_remove(phy->ndev);
> > +     s3fwrn5_remove(phy->common.ndev);
> >
> >       return 0;
> >  }
> > diff --git a/drivers/nfc/s3fwrn5/phy_common.c b/drivers/nfc/s3fwrn5/phy_common.c
> > new file mode 100644
> > index 0000000..e333764
> > --- /dev/null
> > +++ b/drivers/nfc/s3fwrn5/phy_common.c
> > @@ -0,0 +1,60 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> > +/*
> > + * Link Layer for Samsung S3FWRN5 NCI based Driver
> > + *
> > + * Copyright (C) 2015 Samsung Electrnoics
> > + * Robert Baldyga <r.baldyga@samsung.com>
> > + * Copyright (C) 2020 Samsung Electrnoics
> > + * Bongsu Jeon <bongsu.jeon@samsung.com>
> > + */
> > +
> > +#include <linux/gpio.h>
> > +#include <linux/delay.h>
>
> You need also mutex.h (it seems original code did not have it but since
> you move things around it's a new code basically).
>
> > +
> > +#include "s3fwrn5.h"
> > +#include "phy_common.h"
> > +
> > +void s3fwrn5_phy_set_wake(void *phy_id, bool wake)
> > +{
> > +     struct phy_common *phy = phy_id;
> > +
> > +     mutex_lock(&phy->mutex);
> > +     gpio_set_value(phy->gpio_fw_wake, wake);
> > +     msleep(S3FWRN5_EN_WAIT_TIME);
> > +     mutex_unlock(&phy->mutex);
> > +}
> > +
> > +bool s3fwrn5_phy_power_ctrl(struct phy_common *phy, enum s3fwrn5_mode mode)
> > +{
> > +     if (phy->mode == mode)
> > +             return false;
> > +
> > +     phy->mode = mode;
> > +
> > +     gpio_set_value(phy->gpio_en, 1);
> > +     gpio_set_value(phy->gpio_fw_wake, 0);
> > +     if (mode == S3FWRN5_MODE_FW)
> > +             gpio_set_value(phy->gpio_fw_wake, 1);
> > +
> > +     if (mode != S3FWRN5_MODE_COLD) {
> > +             msleep(S3FWRN5_EN_WAIT_TIME);
> > +             gpio_set_value(phy->gpio_en, 0);
> > +             msleep(S3FWRN5_EN_WAIT_TIME);
> > +     }
> > +
> > +     return true;
> > +}
> > +
> > +enum s3fwrn5_mode s3fwrn5_phy_get_mode(void *phy_id)
> > +{
> > +     struct phy_common *phy = phy_id;
> > +     enum s3fwrn5_mode mode;
> > +
> > +     mutex_lock(&phy->mutex);
> > +
> > +     mode = phy->mode;
> > +
> > +     mutex_unlock(&phy->mutex);
> > +
> > +     return mode;
> > +}
> > diff --git a/drivers/nfc/s3fwrn5/phy_common.h b/drivers/nfc/s3fwrn5/phy_common.h
> > new file mode 100644
> > index 0000000..b920f7f
> > --- /dev/null
> > +++ b/drivers/nfc/s3fwrn5/phy_common.h
> > @@ -0,0 +1,31 @@
> > +/* SPDX-License-Identifier: GPL-2.0-or-later
> > + *
> > + * Link Layer for Samsung S3FWRN5 NCI based Driver
> > + *
> > + * Copyright (C) 2015 Samsung Electrnoics
> > + * Robert Baldyga <r.baldyga@samsung.com>
> > + * Copyright (C) 2020 Samsung Electrnoics
> > + * Bongsu Jeon <bongsu.jeon@samsung.com>
> > + */
> > +
> > +#ifndef __NFC_S3FWRN5_PHY_COMMON_H
> > +#define __NFC_S3FWRN5_PHY_COMMON_H
> > +
> > +#define S3FWRN5_EN_WAIT_TIME 20
> > +
> > +struct phy_common {
> > +     struct nci_dev *ndev;
>
> You need a header for nci_dev type.
>
> > +
> > +     int gpio_en;
> > +     int gpio_fw_wake;
> > +
> > +     struct mutex mutex;
>
> You need a header include for mutex.
>
> > +
> > +     enum s3fwrn5_mode mode;
>
> Indeed now it won't work - you use an enum without its declaration. The
> s3fwrn5_mode enum looks more like a property of the phy and after this
> patch would be used only once in i2c.c and once in core.c.
>

Yes.  phy_common.h doesn't include nci_dev and mutex and s3fwrn5_mode
declaration.
So,  i2c.c and phy_common.c include "s3fwrn5.h" first and then "
( mutex and nci_dev would be included from nci_core.h and 3fwrn5_mode
would be included  from s3fwrn5.h).

> How is it going to be used in your new driver - I cannot check because
> you did not post it. You should post this refactoring with new users of
> the API, so we could see bigger picture.
>

Okay. Then, I will add the UART driver.
So, I will resend the patches as below.
1. [PATCH net-next 1/4] dt-bindings: net: nfc: s3fwrn5: Support a UART interface
2. [PATCH net-next 2/4] nfc: s3fwrn5: reduce the EN_WAIT_TIME (*
because of Jakub's request )
3. [PATCH net-next 3/4] nfc: s3fwrn5: extract the common phy blocks
4. [PATCH net-next 4/4] net: nfc: s3fwrn5: Support a UART interface

> Your original idea - with the s3fwrn5.h include here - looks more
> logical than moving the enum s3fwrn5_mode here.
>

Do you mean that it would be better to include the s3fwrn5.h in phy_common.h?

> Best regards,
> Krzysztof
