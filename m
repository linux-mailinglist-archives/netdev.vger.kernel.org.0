Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6511D22ED51
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 15:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728847AbgG0N3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 09:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbgG0N3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 09:29:32 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D67C061794;
        Mon, 27 Jul 2020 06:29:32 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 74so807280pfx.13;
        Mon, 27 Jul 2020 06:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1W/TJOhV1Q2x8Y1yXce+BP15tiEKyW2hSok2S/+HdkU=;
        b=kfLqCv5oeqjLUhoqhNxntBxH5Dtso7HRS8ERXDmplzxzw0pL1QTCeDn6ehQ0O3R/b5
         OJh4l/Jc4sUQP+3hIV0QA5vTBNP20Rx2upTTX2BaXSSVZxlwjqJtAAqbr24rLvIzlG3/
         DfpItpIuTUAwrLn3Hwd4qYOtO5BwwHQYg83rBJlHTLda3RpcENDrGs0I3gLR5dgzvyoA
         yOtCpbbnZs8xzTmutBo68Irl8oqLWA72U6U3Ae84bgJcKQ/NSGtDOemWR+z5V3gc3Zta
         pwIyUcTIsUxI2Wg+V8vps1+MMYeFmMuf9RBmHv43dm3+dNwnUgRbTewMntQXTeUCxSCr
         CKXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1W/TJOhV1Q2x8Y1yXce+BP15tiEKyW2hSok2S/+HdkU=;
        b=kYV8dPjfbeh4q6qaoAfHaoO04HZznL7zhjvqYKQSzKDK8xpLq43h2D3tlR0naZmGZW
         XP34SEaQrYgWwQBmDt4hoCr6INoTxRUrBw2ENAPz9Mk1piUCLB1AlRPQS8UkjkkRSV2W
         FwUqtT7VXk04RxUwJcmgTj8ssciyY3pzaxV7TBzCOmL5XTaG0ACq+2mYst91h4rDjDNH
         E2u/51/Cx3C4wcMUK0Huu8KwKZeJs5OQwazsZQhMBBC3n+e3uRZGuHI9APOE51rV17Fc
         rW0zKoql7mOkbXZXQWeT7PahmkhZGDbIk4ag4Z+T13AFCXEc1/L9RQCi9SwyEsp7shXL
         8New==
X-Gm-Message-State: AOAM530eOApZiVfBgcnQ/4DJwxqx4chVz/fa0h5b8hOhvHes96tNnIel
        1bg2XYAQzfTDzQpzGq1i/1bLAgBicPHlIXwFvlM=
X-Google-Smtp-Source: ABdhPJwhiEUrznarqE/qM4WT4ZX6Jmz84CEn4bWiJf9PqB2KXFbk4s1TrsN6w8OfJPnhtN5ES1xbhWWxNKtY28X8pt0=
X-Received: by 2002:a63:924b:: with SMTP id s11mr19224169pgn.74.1595856572131;
 Mon, 27 Jul 2020 06:29:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200727122242.32337-1-vadym.kochan@plvision.eu> <20200727122242.32337-3-vadym.kochan@plvision.eu>
In-Reply-To: <20200727122242.32337-3-vadym.kochan@plvision.eu>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 27 Jul 2020 16:29:17 +0300
Message-ID: <CAHp75VeWGUB8izyHptfsXXv4GbsDu6_4rr9EaRR9wooXywaP+g@mail.gmail.com>
Subject: Re: [net-next v4 2/6] net: marvell: prestera: Add PCI interface support
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mickey Rachamim <mickeyr@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 3:23 PM Vadym Kochan <vadym.kochan@plvision.eu> wrote:
>
> Add PCI interface driver for Prestera Switch ASICs family devices, which
> provides:
>
>     - Firmware loading mechanism
>     - Requests & events handling to/from the firmware
>     - Access to the firmware on the bus level
>
> The firmware has to be loaded each time the device is reset. The driver
> is loading it from:
>
>     /lib/firmware/marvell/prestera_fw-v{MAJOR}.{MINOR}.img
>
> The full firmware image version is located within the internal header
> and consists of 3 numbers - MAJOR.MINOR.PATCH. Additionally, driver has
> hard-coded minimum supported firmware version which it can work with:
>
>     MAJOR - reflects the support on ABI level between driver and loaded
>             firmware, this number should be the same for driver and loaded
>             firmware.
>
>     MINOR - this is the minimum supported version between driver and the
>             firmware.
>
>     PATCH - indicates only fixes, firmware ABI is not changed.
>
> Firmware image file name contains only MAJOR and MINOR numbers to make
> driver be compatible with any PATCH version.

I have to admit that memcpy_toio() / memcpy_fromio() may not be good
for this driver.
Please, consider two things:
 - they are native endianess (it's good if it's your case)
 - they are behaving interestingly when buffer is not aligned

Sorry I didn't think well about this.

...

> +struct prestera_ldr_regs {
> +       u32 ldr_ready;
> +       u32 pad1;
> +
> +       u32 ldr_img_size;
> +       u32 ldr_ctl_flags;
> +
> +       u32 ldr_buf_offs;
> +       u32 ldr_buf_size;
> +
> +       u32 ldr_buf_rd;
> +       u32 pad2;
> +       u32 ldr_buf_wr;
> +
> +       u32 ldr_status;

> +} __packed __aligned(4);

Do these attributes change the struct anyhow?

...

> +static int prestera_fw_wait_reg32(struct prestera_fw *fw, u32 reg, u32 cmp,
> +                                 unsigned int waitms)
> +{
> +       u8 __iomem *addr = PRESTERA_FW_REG_ADDR(fw, reg);
> +       u32 val;
> +
> +       return readl_poll_timeout(addr, val, cmp == val, 1000 * 10, waitms * 1000);

Hmm... If waitms (better to spell it fully like wait_timeout or so)
less than 10?
And all those magic numbers in each of readl_poll_timeout() calls.

Also consider to use predefined constants like NSEC_PER_SEC.

> +}

...

> +       err = readl_poll_timeout(addr, val, val & mask, 1000 * 10, waitus);
> +       if (err) {
> +               dev_err(fw->dev.dev, "Timeout to load FW img [state=%d]",
> +                       prestera_ldr_read(fw, PRESTERA_LDR_STATUS_REG));
> +               return err;
> +       }
> +
> +       return 0;

  if (err)
    dev_err();

  return err;

...

> +static int prestera_pci_probe(struct pci_dev *pdev,
> +                             const struct pci_device_id *id)
> +{
> +       const char *driver_name = pdev->driver->name;
> +       struct prestera_fw *fw;
> +       int err;
> +
> +       err = pcim_enable_device(pdev);
> +       if (err)
> +               return err;
> +
> +       err = pcim_iomap_regions(pdev, BIT(PRESTERA_PCI_BAR_FW) |
> +                                BIT(PRESTERA_PCI_BAR_PP),
> +                                pci_name(pdev));
> +       if (err)
> +               return err;
> +
> +       if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(30))) {

> +               pci_err(pdev, "fail to set DMA mask\n");

pci_err() is more for PCI core and Co. I think dev_err() and other
dev_*() are good enough here.

> +               goto err_dma_mask;
> +       }
> +
> +       pci_set_master(pdev);
> +
> +       fw = devm_kzalloc(&pdev->dev, sizeof(*fw), GFP_KERNEL);
> +       if (!fw) {
> +               err = -ENOMEM;
> +               goto err_pci_dev_alloc;
> +       }
> +
> +       fw->dev.ctl_regs = pcim_iomap_table(pdev)[PRESTERA_PCI_BAR_FW];
> +       fw->dev.pp_regs = pcim_iomap_table(pdev)[PRESTERA_PCI_BAR_PP];

> +       fw->dev.dev = &pdev->dev;
> +       fw->pci_dev = pdev;

Seems like the second one is redundant. You may always derive struct
pci_dev from struct dev if needed.

> +       pci_set_drvdata(pdev, fw);
> +
> +       err = prestera_fw_init(fw);
> +       if (err)
> +               goto err_prestera_fw_init;
> +
> +       dev_info(fw->dev.dev, "Switch FW is ready\n");
> +
> +       fw->wq = alloc_workqueue("prestera_fw_wq", WQ_HIGHPRI, 1);
> +       if (!fw->wq)
> +               goto err_wq_alloc;
> +
> +       INIT_WORK(&fw->evt_work, prestera_fw_evt_work_fn);
> +
> +       err = pci_alloc_irq_vectors(pdev, 1, 1, PCI_IRQ_MSI);
> +       if (err < 0) {
> +               pci_err(pdev, "MSI IRQ init failed\n");
> +               goto err_irq_alloc;
> +       }
> +
> +       err = request_irq(pci_irq_vector(pdev, 0), prestera_pci_irq_handler,
> +                         0, driver_name, fw);
> +       if (err) {
> +               pci_err(pdev, "fail to request IRQ\n");
> +               goto err_request_irq;
> +       }
> +
> +       err = prestera_device_register(&fw->dev);
> +       if (err)
> +               goto err_prestera_dev_register;
> +
> +       return 0;
> +
> +err_prestera_dev_register:
> +       free_irq(pci_irq_vector(pdev, 0), fw);
> +err_request_irq:
> +       pci_free_irq_vectors(pdev);
> +err_irq_alloc:
> +       destroy_workqueue(fw->wq);
> +err_wq_alloc:
> +       prestera_fw_uninit(fw);

> +err_prestera_fw_init:
> +err_pci_dev_alloc:
> +err_dma_mask:

All three are useless.

> +       return err;
> +}

...

> +static struct pci_driver prestera_pci_driver = {
> +       .name     = "Prestera DX",
> +       .id_table = prestera_pci_devices,
> +       .probe    = prestera_pci_probe,
> +       .remove   = prestera_pci_remove,
> +};

> +

Redundant blank line.

> +module_pci_driver(prestera_pci_driver);
-- 
With Best Regards,
Andy Shevchenko
