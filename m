Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22ECE2C2552
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 13:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387454AbgKXMGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 07:06:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729172AbgKXMGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 07:06:06 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09579C0613D6;
        Tue, 24 Nov 2020 04:06:06 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id a9so28537266lfh.2;
        Tue, 24 Nov 2020 04:06:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X1gWKsLM8WhU8BIYUm/PDJ+UEVUdceUwgZGfwp9Tdo4=;
        b=mbyD0ZxA9b9ZriZi2hg1urENNnACQ15IfL2TRhb7ZJzmJJgLI0vyIx67W6QaGyvM7O
         Pz8KBLZly6Gnn4ma0i1cx0yWJQNQ6AZhWoun7xCT/xCDt580Ii0VUNdzU152Vs8KWRGS
         0ekXa8dymW51DkW/spUp5dWtJ9ac2y4kmuq3+L2gcpXNUi4r2ohpx/zOGr6EVQgr0twd
         Ho/twtCOUFelLXuoIwrQBf7/jrJa10nWaTS0S4c7us+XoMsRq3qYCyG5pRLHyZLB6WyV
         IlqeXrKyJpKHhxvBE6yIOyrDyt3cd6JbcBCiKPGOr8bh3702auWLDraqcQo6htXO8pVJ
         SIsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X1gWKsLM8WhU8BIYUm/PDJ+UEVUdceUwgZGfwp9Tdo4=;
        b=MZVT16dj4aZxOZAwp8cR4uGWqrJVyfDnKyeU2MJzKb+BV/NKfjMvUFq+JrWXxeH4n0
         K2WNW0D4Q0NRpty+fFRmnbucBJPZ7THaSgt6SkKYJHriEzneK6WOXvjAbG75Qj+XjLjW
         QFlvHuyspuZ4T1SgchPaP0pAsQA5juGOXl0TxAqo9XPT+fJmX/uoyhoZUDB+rQ7os4zP
         horLqMxIDmHV4bhD7WlO3tL2/SeBUqgu9qkgCO938SDeKmrjAR9zy4MOLa8VteKN9uwn
         HqynhpezmUMefzuKPXkipypIViC0h0DhN2CFkNG7lyQn9ZzgvNvcwQvd8tvu5By5UccZ
         Rk9A==
X-Gm-Message-State: AOAM533qMIQy7xOU7FY2OjZpfDgE+E0t4ARvWkNK5YDycsCoIyoLD9p8
        LZrly6ohxPUMiFY/Qi/DJrfHYdU1uWuZr1z2yS0=
X-Google-Smtp-Source: ABdhPJwgdnxMDfraL0+FptbpHyQAQ3ebsJdjgdLIkFQ1dbTCVc569vD1l13vWGfyZYOauxMvXw0ZmSdD6xiblQU3Xks=
X-Received: by 2002:ac2:5e91:: with SMTP id b17mr1562721lfq.442.1606219564293;
 Tue, 24 Nov 2020 04:06:04 -0800 (PST)
MIME-Version: 1.0
References: <CGME20201123075658epcms2p5a6237314f7a72a2556545d3f96261c93@epcms2p5>
 <20201123075658epcms2p5a6237314f7a72a2556545d3f96261c93@epcms2p5> <20201123081940.GA9323@kozik-lap>
In-Reply-To: <20201123081940.GA9323@kozik-lap>
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
Date:   Tue, 24 Nov 2020 21:05:52 +0900
Message-ID: <CACwDmQDOm6PAyphMiUFizueENMdW3Bo5PvdP_VC_sfBEHc9pMQ@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: nfc: s3fwrn5: Support a UART interface
To:     "krzk@kernel.org" <krzk@kernel.org>
Cc:     Bongsu Jeon <bongsu.jeon@samsung.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nfc@lists.01.org" <linux-nfc@lists.01.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 5:55 PM krzk@kernel.org <krzk@kernel.org> wrote:
>
> On Mon, Nov 23, 2020 at 04:56:58PM +0900, Bongsu Jeon wrote:
> > Since S3FWRN82 NFC Chip, The UART interface can be used.
> > S3FWRN82 uses NCI protocol and supports I2C and UART interface.
> >
> > Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
>
> Please start sending emails properly, e.g. with git send-email, so all
> your patches in the patchset are referencing the first patch.
>
Ok. I will do that.

> > ---
> >  drivers/nfc/s3fwrn5/Kconfig  |  12 ++
> >  drivers/nfc/s3fwrn5/Makefile |   2 +
> >  drivers/nfc/s3fwrn5/uart.c   | 250 +++++++++++++++++++++++++++++++++++
> >  3 files changed, 264 insertions(+)
> >  create mode 100644 drivers/nfc/s3fwrn5/uart.c
> >
> > diff --git a/drivers/nfc/s3fwrn5/Kconfig b/drivers/nfc/s3fwrn5/Kconfig
> > index 3f8b6da58280..6f88737769e1 100644
> > --- a/drivers/nfc/s3fwrn5/Kconfig
> > +++ b/drivers/nfc/s3fwrn5/Kconfig
> > @@ -20,3 +20,15 @@ config NFC_S3FWRN5_I2C
> >         To compile this driver as a module, choose m here. The module will
> >         be called s3fwrn5_i2c.ko.
> >         Say N if unsure.
> > +
> > +config NFC_S3FWRN82_UART
> > +     tristate "Samsung S3FWRN82 UART support"
> > +     depends on NFC_NCI && SERIAL_DEV_BUS
>
> What about SERIAL_DEV_BUS as module? Shouldn't this be
> SERIAL_DEV_BUS || !SERIAL_DEV_BUS?
>

SERIAL_DEV_BUS is okay even if SERIAL_DEV_BUS is defined as module.

> > +     select NFC_S3FWRN5
> > +     help
> > +       This module adds support for a UART interface to the S3FWRN82 chip.
> > +       Select this if your platform is using the UART bus.
> > +
> > +       To compile this driver as a module, choose m here. The module will
> > +       be called s3fwrn82_uart.ko.
> > +       Say N if unsure.
> > diff --git a/drivers/nfc/s3fwrn5/Makefile b/drivers/nfc/s3fwrn5/Makefile
> > index d0ffa35f50e8..d1902102060b 100644
> > --- a/drivers/nfc/s3fwrn5/Makefile
> > +++ b/drivers/nfc/s3fwrn5/Makefile
> > @@ -5,6 +5,8 @@
> >
> >  s3fwrn5-objs = core.o firmware.o nci.o
> >  s3fwrn5_i2c-objs = i2c.o
> > +s3fwrn82_uart-objs = uart.o
> >
> >  obj-$(CONFIG_NFC_S3FWRN5) += s3fwrn5.o
> >  obj-$(CONFIG_NFC_S3FWRN5_I2C) += s3fwrn5_i2c.o
> > +obj-$(CONFIG_NFC_S3FWRN82_UART) += s3fwrn82_uart.o
> > diff --git a/drivers/nfc/s3fwrn5/uart.c b/drivers/nfc/s3fwrn5/uart.c
> > new file mode 100644
> > index 000000000000..b3c36a5b28d3
> > --- /dev/null
> > +++ b/drivers/nfc/s3fwrn5/uart.c
> > @@ -0,0 +1,250 @@
> > +// SPDX-License-Identifier: GPL-2.0+
> > +/*
> > + * UART Link Layer for S3FWRN82 NCI based Driver
> > + *
> > + * Copyright (C) 2020 Samsung Electronics
> > + * Author: Bongsu Jeon <bongsu.jeon@samsung.com>
>
> You copied a lot from existing i2c.c. Please keep also the original
> copyrights.
>

Okay. I will keep also the original copyrights.

> > + * All rights reserved.
> > + */
> > +
> > +#include <linux/device.h>
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/nfc.h>
> > +#include <linux/netdevice.h>
> > +#include <linux/of.h>
> > +#include <linux/serdev.h>
> > +#include <linux/gpio.h>
> > +#include <linux/of_gpio.h>
> > +
> > +#include "s3fwrn5.h"
> > +
> > +#define S3FWRN82_UART_DRIVER_NAME "s3fwrn82_uart"
>
> Remove the define, it is used only once.
>
> > +#define S3FWRN82_NCI_HEADER 3
> > +#define S3FWRN82_NCI_IDX 2
> > +#define S3FWRN82_EN_WAIT_TIME 20
> > +#define NCI_SKB_BUFF_LEN 258
> > +
> > +struct s3fwrn82_uart_phy {
> > +     struct serdev_device *ser_dev;
> > +     struct nci_dev *ndev;
> > +     struct sk_buff *recv_skb;
> > +
> > +     unsigned int gpio_en;
> > +     unsigned int gpio_fw_wake;
> > +
> > +     /* mutex is used to synchronize */
>
> Please do not write obvious comments. Mutex is always used to
> synchronize, what else is it for? Instead you must describe what exactly
> is protected with mutex.
>

I understand it. I will fix it.

> > +     struct mutex mutex;
> > +     enum s3fwrn5_mode mode;
> > +};
> > +
> > +static void s3fwrn82_uart_set_wake(void *phy_id, bool wake)
> > +{
> > +     struct s3fwrn82_uart_phy *phy = phy_id;
> > +
> > +     mutex_lock(&phy->mutex);
> > +     gpio_set_value(phy->gpio_fw_wake, wake);
> > +     msleep(S3FWRN82_EN_WAIT_TIME);
> > +     mutex_unlock(&phy->mutex);
> > +}
> > +
> > +static void s3fwrn82_uart_set_mode(void *phy_id, enum s3fwrn5_mode mode)
> > +{
> > +     struct s3fwrn82_uart_phy *phy = phy_id;
> > +
> > +     mutex_lock(&phy->mutex);
> > +     if (phy->mode == mode)
> > +             goto out;
> > +     phy->mode = mode;
> > +     gpio_set_value(phy->gpio_en, 1);
> > +     gpio_set_value(phy->gpio_fw_wake, 0);
> > +     if (mode == S3FWRN5_MODE_FW)
> > +             gpio_set_value(phy->gpio_fw_wake, 1);
> > +     if (mode != S3FWRN5_MODE_COLD) {
> > +             msleep(S3FWRN82_EN_WAIT_TIME);
> > +             gpio_set_value(phy->gpio_en, 0);
> > +             msleep(S3FWRN82_EN_WAIT_TIME);
> > +     }
> > +out:
> > +     mutex_unlock(&phy->mutex);
> > +}
> > +
> > +static enum s3fwrn5_mode s3fwrn82_uart_get_mode(void *phy_id)
> > +{
> > +     struct s3fwrn82_uart_phy *phy = phy_id;
> > +     enum s3fwrn5_mode mode;
> > +
> > +     mutex_lock(&phy->mutex);
> > +     mode = phy->mode;
> > +     mutex_unlock(&phy->mutex);
> > +     return mode;
> > +}
>
> All this duplicates I2C version. You need to start either reusing common
> blocks.
>

Okay. I will do refactoring on i2c.c and uart.c to make common blocks.
 is it okay to separate a patch for it?

> > +
> > +static int s3fwrn82_uart_write(void *phy_id, struct sk_buff *out)
> > +{
> > +     struct s3fwrn82_uart_phy *phy = phy_id;
> > +     int err;
> > +
> > +     err = serdev_device_write(phy->ser_dev,
> > +                               out->data, out->len,
> > +                               MAX_SCHEDULE_TIMEOUT);
> > +     if (err < 0)
> > +             return err;
> > +
> > +     return 0;
> > +}
> > +
> > +static const struct s3fwrn5_phy_ops uart_phy_ops = {
> > +     .set_wake = s3fwrn82_uart_set_wake,
> > +     .set_mode = s3fwrn82_uart_set_mode,
> > +     .get_mode = s3fwrn82_uart_get_mode,
> > +     .write = s3fwrn82_uart_write,
> > +};
> > +
> > +static int s3fwrn82_uart_read(struct serdev_device *serdev,
> > +                           const unsigned char *data,
> > +                           size_t count)
> > +{
> > +     struct s3fwrn82_uart_phy *phy = serdev_device_get_drvdata(serdev);
> > +     size_t i;
> > +
> > +     for (i = 0; i < count; i++) {
> > +             skb_put_u8(phy->recv_skb, *data++);
> > +
> > +             if (phy->recv_skb->len < S3FWRN82_NCI_HEADER)
> > +                     continue;
> > +
> > +             if ((phy->recv_skb->len - S3FWRN82_NCI_HEADER)
> > +                             < phy->recv_skb->data[S3FWRN82_NCI_IDX])
> > +                     continue;
> > +
> > +             s3fwrn5_recv_frame(phy->ndev, phy->recv_skb, phy->mode);
> > +             phy->recv_skb = alloc_skb(NCI_SKB_BUFF_LEN, GFP_KERNEL);
> > +             if (!phy->recv_skb)
> > +                     return 0;
> > +     }
> > +
> > +     return i;
> > +}
> > +
> > +static struct serdev_device_ops s3fwrn82_serdev_ops = {
>
> const
>
> > +     .receive_buf = s3fwrn82_uart_read,
> > +     .write_wakeup = serdev_device_write_wakeup,
> > +};
> > +
> > +static const struct of_device_id s3fwrn82_uart_of_match[] = {
> > +     { .compatible = "samsung,s3fwrn82-uart", },
> > +     {},
> > +};
> > +MODULE_DEVICE_TABLE(of, s3fwrn82_uart_of_match);
> > +
> > +static int s3fwrn82_uart_parse_dt(struct serdev_device *serdev)
> > +{
> > +     struct s3fwrn82_uart_phy *phy = serdev_device_get_drvdata(serdev);
> > +     struct device_node *np = serdev->dev.of_node;
> > +
> > +     if (!np)
> > +             return -ENODEV;
> > +
> > +     phy->gpio_en = of_get_named_gpio(np, "en-gpios", 0);
> > +     if (!gpio_is_valid(phy->gpio_en))
> > +             return -ENODEV;
> > +
> > +     phy->gpio_fw_wake = of_get_named_gpio(np, "wake-gpios", 0);
>
> You should not cast it it unsigned int. I'll fix the s3fwrn5 from which
> you copied this apparently.
>

Okay. I will fix it.

> > +     if (!gpio_is_valid(phy->gpio_fw_wake))
> > +             return -ENODEV;
> > +
> > +     return 0;
> > +}
> > +
> > +static int s3fwrn82_uart_probe(struct serdev_device *serdev)
> > +{
> > +     struct s3fwrn82_uart_phy *phy;
> > +     int ret = -ENOMEM;
> > +
> > +     phy = devm_kzalloc(&serdev->dev, sizeof(*phy), GFP_KERNEL);
> > +     if (!phy)
> > +             goto err_exit;
> > +
> > +     phy->recv_skb = alloc_skb(NCI_SKB_BUFF_LEN, GFP_KERNEL);
> > +     if (!phy->recv_skb)
> > +             goto err_free;
> > +
> > +     mutex_init(&phy->mutex);
> > +     phy->mode = S3FWRN5_MODE_COLD;
> > +
> > +     phy->ser_dev = serdev;
> > +     serdev_device_set_drvdata(serdev, phy);
> > +     serdev_device_set_client_ops(serdev, &s3fwrn82_serdev_ops);
> > +     ret = serdev_device_open(serdev);
> > +     if (ret) {
> > +             dev_err(&serdev->dev, "Unable to open device\n");
> > +             goto err_skb;
> > +     }
> > +
> > +     ret = serdev_device_set_baudrate(serdev, 115200);
>
> Why baudrate is fixed?
>

RN82 NFC chip only supports 115200 baudrate for UART.

> > +     if (ret != 115200) {
> > +             ret = -EINVAL;
> > +             goto err_serdev;
> > +     }
> > +
> > +     serdev_device_set_flow_control(serdev, false);
> > +
> > +     ret = s3fwrn82_uart_parse_dt(serdev);
> > +     if (ret < 0)
> > +             goto err_serdev;
> > +
> > +     ret = devm_gpio_request_one(&phy->ser_dev->dev,
> > +                                 phy->gpio_en,
> > +                                 GPIOF_OUT_INIT_HIGH,
> > +                                 "s3fwrn82_en");
>
> This is weirdly wrapped.
>

Did you ask about devem_gpio_request_one function's parenthesis and parameters?
If it is right, I changed it after i ran the checkpatch.pl --strict and
i saw message like the alignment should match open parenthesis.

> > +     if (ret < 0)
> > +             goto err_serdev;
> > +
> > +     ret = devm_gpio_request_one(&phy->ser_dev->dev,
> > +                                 phy->gpio_fw_wake,
> > +                                 GPIOF_OUT_INIT_LOW,
> > +                                 "s3fwrn82_fw_wake");
> > +     if (ret < 0)
> > +             goto err_serdev;
> > +
> > +     ret = s3fwrn5_probe(&phy->ndev, phy, &phy->ser_dev->dev, &uart_phy_ops);
> > +     if (ret < 0)
> > +             goto err_serdev;
> > +
> > +     return ret;
> > +
> > +err_serdev:
> > +     serdev_device_close(serdev);
> > +err_skb:
> > +     kfree_skb(phy->recv_skb);
> > +err_free:
> > +     kfree(phy);
>
> Eee.... why? Did you test this code?
>

I didn't test this code. i just added this code as defense code.
If the error happens, then allocated memory and device will be free
according to the fail case.

> > +err_exit:
> > +     return ret;
> > +}
> > +
> > +static void s3fwrn82_uart_remove(struct serdev_device *serdev)
> > +{
> > +     struct s3fwrn82_uart_phy *phy = serdev_device_get_drvdata(serdev);
> > +
> > +     s3fwrn5_remove(phy->ndev);
> > +     serdev_device_close(serdev);
> > +     kfree_skb(phy->recv_skb);
> > +     kfree(phy);
>
> This does not look like tested...
>

I tested this code using unbind of the serial device.
It worked and I saw the debugging log that i added for checking the
code to be sure.

> Best regards,
> Krzysztof
