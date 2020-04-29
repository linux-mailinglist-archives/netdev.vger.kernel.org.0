Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A94251BE11A
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 16:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgD2OdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 10:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726511AbgD2OdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 10:33:17 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0153AC03C1AD;
        Wed, 29 Apr 2020 07:33:17 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id f3so2446317ioj.1;
        Wed, 29 Apr 2020 07:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+HxWllnBn+1zJz8WVHl3XZ5HneD7xfI7ue7Ll9hMj1k=;
        b=KfhqtV5rBOv6WOPFrGrYP/W1ymZ0aF9SZWOUKTF1n0i7rFrDefDx/4PskiRm2TV6jK
         1iMmW8zXk2FY0kRY/5LaMSFcy7yqJaueSxuZGlHeL3qWbUUQ/uUphVhRSJwTip6ls/UK
         WGzM4iEBp3oyEiYpjZPL3N2n8hr8QG+ytFiICfkyWAek8zLxBYIo4ZmjTiswe36UBI3E
         OArdRdcXNuCX3fJ3UZTi0/4tQxp7qIWFtmF4xDbTnsRh33WkGy10dUVghO7QWUcFZBYi
         Appo2aATelJJExpbw83M6RGbDQH0dKMNK/vOxpzG44na5nUeSMeA8qa7v24wKzcja9Td
         TXOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+HxWllnBn+1zJz8WVHl3XZ5HneD7xfI7ue7Ll9hMj1k=;
        b=pi7dz9M9KMXzeMzRdp6Hq7v/UUAxaISLzcKbhvfB+HxNKIVmUCzk8vWpam9xeyzSeH
         NRdgQbviEDxJxoW4VtVrgGCz0ol5mdyy3Gxw/8GVPWeO25IxHxbg7AUrCTjeXO3d8sAB
         a1Ye944Qn4X1KhcVI4+yrMFi124GehTBXvi3ztM7QGT0RzC6yqQIRi+jrQ4BY3Wo7QOi
         DILpv9Hb7XFajwxJjUoXE7EfUiBRIEdDsmsAw+0S7Yo0QV8Ca7naC5Eb9HTG8qhQ6DV1
         kX+lzx7hd427FO1oly+huevaNw5+rnHIO6Q8pgWbacsIEduc9O2jpYuQ1PYCDEDztI+q
         S94g==
X-Gm-Message-State: AGi0PuYOMGrxylgQjGMftADmW5vmbD2LQjOG+Ys5XuMHx7GRyNMgFMl3
        kvl4NLVBHUSPBxIA904xUoHof33zF9B0GMFi7pw=
X-Google-Smtp-Source: APiQypL9ZMEuyRwR1ix42kKXhDIen1mp+JUktqgLX56B4R1/wXlWDuBNoGzXc4uMoKsa1XQiVoCkhLIVE8RD84ArNA8=
X-Received: by 2002:a02:bb91:: with SMTP id g17mr29560141jan.88.1588170794879;
 Wed, 29 Apr 2020 07:33:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200428144314.24533-3-vaibhavgupta40@gmail.com> <20200428172917.GA177492@google.com>
In-Reply-To: <20200428172917.GA177492@google.com>
From:   Vaibhav Gupta <vaibhav.varodek@gmail.com>
Date:   Wed, 29 Apr 2020 20:02:11 +0530
Message-ID: <CAPBsFfDv0UWvo9KAs4zowmE=No_sk5DOq1ROLjFBDAK4STdKEA@mail.gmail.com>
Subject: Re: [Linux-kernel-mentees] [PATCH v2 2/2] realtek/8139cp: Remove
 Legacy Power Management
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Shannon Nelson <snelson@pensando.io>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Martin Habets <mhabets@solarflare.com>, netdev@vger.kernel.org,
        bjorn@helgaas.com, linux-kernel-mentees@lists.linuxfoundation.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        skhan@linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Apr 2020 at 22:59, Bjorn Helgaas <helgaas@kernel.org> wrote:
>
> On Tue, Apr 28, 2020 at 08:13:14PM +0530, Vaibhav Gupta wrote:
> > Upgrade power management from legacy to generic using dev_pm_ops.
> >
> > Add "__maybe_unused" attribute to resume() and susend() callbacks
> > definition to suppress compiler warnings.
> >
> > Generic callback requires an argument of type "struct device*". Hence,
> > convert it to "struct net_device*" using "dev_get_drv_data()" to use
> > it in the callback.
> >
> > Most of the cleaning part is to remove pci_save_state(),
> > pci_set_power_state(), etc power management function calls.
> >
> > Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
> > ---
> >  drivers/net/ethernet/realtek/8139cp.c | 25 +++++++------------------
> >  1 file changed, 7 insertions(+), 18 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
> > index 60d342f82fb3..4f2fb1393966 100644
> > --- a/drivers/net/ethernet/realtek/8139cp.c
> > +++ b/drivers/net/ethernet/realtek/8139cp.c
> > @@ -2054,10 +2054,9 @@ static void cp_remove_one (struct pci_dev *pdev)
> >       free_netdev(dev);
> >  }
> >
> > -#ifdef CONFIG_PM
> > -static int cp_suspend (struct pci_dev *pdev, pm_message_t state)
> > +static int __maybe_unused cp_suspend(struct device *device)
> >  {
> > -     struct net_device *dev = pci_get_drvdata(pdev);
> > +     struct net_device *dev = dev_get_drvdata(device);
> >       struct cp_private *cp = netdev_priv(dev);
> >       unsigned long flags;
> >
> > @@ -2075,16 +2074,12 @@ static int cp_suspend (struct pci_dev *pdev, pm_message_t state)
> >
> >       spin_unlock_irqrestore (&cp->lock, flags);
> >
> > -     pci_save_state(pdev);
> > -     pci_enable_wake(pdev, pci_choose_state(pdev, state), cp->wol_enabled);
>
> This one is a little more interesting because it relies on the driver
> state (cp->wol_enabled).  IIUC, the corresponding pci_enable_wake() in
> the generic path is in pci_prepare_to_sleep() (called from
> pci_pm_suspend_noirq()).
>
> But of course the generic path doesn't look at cp->wol_enabled.  It
> looks at device_may_wakeup(), but I don't know whether there's a
> connection between that and cp->wol_enabled.
I have tested it by just compiling it. I will try to dig a bit more deep into
this and check if it is affecting something (on the basis of code).
The final test has to done with hardware.

-- Vaibhav Gupta
>
> > -     pci_set_power_state(pdev, pci_choose_state(pdev, state));
> > -
> >       return 0;
> >  }
> >
> > -static int cp_resume (struct pci_dev *pdev)
> > +static int __maybe_unused cp_resume(struct device *device)
> >  {
> > -     struct net_device *dev = pci_get_drvdata (pdev);
> > +     struct net_device *dev = dev_get_drvdata(device);
> >       struct cp_private *cp = netdev_priv(dev);
> >       unsigned long flags;
> >
> > @@ -2093,10 +2088,6 @@ static int cp_resume (struct pci_dev *pdev)
> >
> >       netif_device_attach (dev);
> >
> > -     pci_set_power_state(pdev, PCI_D0);
> > -     pci_restore_state(pdev);
> > -     pci_enable_wake(pdev, PCI_D0, 0);
> > -
> >       /* FIXME: sh*t may happen if the Rx ring buffer is depleted */
> >       cp_init_rings_index (cp);
> >       cp_init_hw (cp);
> > @@ -2111,7 +2102,6 @@ static int cp_resume (struct pci_dev *pdev)
> >
> >       return 0;
> >  }
> > -#endif /* CONFIG_PM */
> >
> >  static const struct pci_device_id cp_pci_tbl[] = {
> >          { PCI_DEVICE(PCI_VENDOR_ID_REALTEK,     PCI_DEVICE_ID_REALTEK_8139), },
> > @@ -2120,15 +2110,14 @@ static const struct pci_device_id cp_pci_tbl[] = {
> >  };
> >  MODULE_DEVICE_TABLE(pci, cp_pci_tbl);
> >
> > +static SIMPLE_DEV_PM_OPS(cp_pm_ops, cp_suspend, cp_resume);
> > +
> >  static struct pci_driver cp_driver = {
> >       .name         = DRV_NAME,
> >       .id_table     = cp_pci_tbl,
> >       .probe        = cp_init_one,
> >       .remove       = cp_remove_one,
> > -#ifdef CONFIG_PM
> > -     .resume       = cp_resume,
> > -     .suspend      = cp_suspend,
> > -#endif
> > +     .driver.pm    = &cp_pm_ops,
> >  };
> >
> >  module_pci_driver(cp_driver);
> > --
> > 2.26.2
> >
