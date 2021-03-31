Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C35A334FF8A
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 13:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235288AbhCaLf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 07:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235019AbhCaLfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 07:35:41 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7AFEC061574
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 04:35:41 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id j25so14352148pfe.2
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 04:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2sP62O9mz98ol7aSHrKyx7S+HlcJw6WNXmEff/D6CjY=;
        b=v4ixmf3WEHv7n4xykt1cmkLzr/aGoTRLnu7pUgDkfbhv3y02sNFU/jBYTixHDFWkPA
         T8CS5AFQojPRwkoIFhFNftDfWXlQ0vVP/EEU6QLFmGMb3ch9NpmhYBVh/Yz1ZK/19pG1
         asn+3nSwOKp2PNn9+cB+ar7URCA1ruyu0zaqEJdxJvnsY7j0aAYjXIgacBMQyFtoIpg/
         vzHPJdosw4tN1lbBkHwj39iQ0+ZNTgn0bG1mev9oHyOvlhGXB1eSj7cOGpRfMfydtHSI
         7dYqqvGiZ04GYErJx13nuCDd0PaSqKuKteP6aVRc9vzQv9JA+tZy7D6eeecKznWDoySi
         AHSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2sP62O9mz98ol7aSHrKyx7S+HlcJw6WNXmEff/D6CjY=;
        b=OFRGJ7RHVoZ5D0v3ITK8MKGcqKLA8FrnhcNbKxCT6EaWrZxsG99qhBlOvFhwtozwCz
         YwozKQcD7ZHS2PldQMgz8awvxsFVszbTq5zFD6ENALM6hMcOqI/14nC2wETTGKECzeDU
         Gth7riIu0CiE1xuCD7O1oxlfdEu/d8nSIvBIQ+6TD2OLsdMsNbetIX4c4xhbiYolYrl/
         BFZfNcpDF2dil4Suph18IJM4CMflAvivT0pKuK92cJ9zUNAwF6xVY19EzCO/aSu3iLsp
         DGAdi172Wr/fwL8vUDEwpjqXRop2sIdPbuDV1391HUczZTaubIgXDlK/O1Xi5kevbroo
         jDew==
X-Gm-Message-State: AOAM5327Uh5gqdyDEqCNoAsPwZXmhrk0RTBOzaIriqwP60U3XDrIItZh
        pqyRAPMVhRJ/lRMwUH5445Shy4eU7TOsK8OGUEJcsw==
X-Google-Smtp-Source: ABdhPJxAG7wCb7BLWpkd3pyvLKRQmn3H7xyeyb/xTxvQDDRTXBpW/wHwkaz4FO5G8ICf5OLJ5WzcXiN62FPpjFgP3pQ=
X-Received: by 2002:a63:62c4:: with SMTP id w187mr2775944pgb.173.1617190540916;
 Wed, 31 Mar 2021 04:35:40 -0700 (PDT)
MIME-Version: 1.0
References: <1617187150-13727-1-git-send-email-loic.poulain@linaro.org> <YGRSdQxTuxIy0Qsc@kroah.com>
In-Reply-To: <YGRSdQxTuxIy0Qsc@kroah.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Wed, 31 Mar 2021 13:35:04 +0200
Message-ID: <CAMZdPi-f4wDiFSuib5h17SaFWgORv8q7jKdh8fS_C=iihc0a_A@mail.gmail.com>
Subject: Re: [PATCH net-next v6 1/2] net: Add a WWAN subsystem
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Aleksander Morgado <aleksander@aleksander.es>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

On Wed, 31 Mar 2021 at 12:44, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Mar 31, 2021 at 12:39:09PM +0200, Loic Poulain wrote:
> > This change introduces initial support for a WWAN subsystem. Given the
> > complexity and heterogeneity of existing WWAN hardwares and interfaces,
> > there is no strict definition of what a WWAN device is and how it should
> > be represented. It's often a collection of multiple devices that perform
> > the global WWAN feature (netdev, tty, chardev, etc).
> >
> > One usual way to expose modem controls and configuration is via high
> > level protocols such as the well known AT command protocol, MBIM or
> > QMI. The USB modems started to expose that as character devices, and
> > user daemons such as ModemManager learnt how to deal with them. This
> > initial version adds the concept of WWAN port, which can be created
> > by any driver to expose one of these protocols. The WWAN core takes
> > care of the generic part, including character device creation and lets
> > the driver implementing access (fops) for the selected protocol.
> >
> > Since the different components/devices do no necesserarly know about
> > each others, and can be created/removed in different orders, the
> > WWAN core ensures that all WAN ports that contribute to the whole
> > WWAN feature are grouped under the same virtual WWAN device, relying
> > on the provided parent device (e.g. mhi controller, USB device). It's
> > a 'trick' I copied from Johannes's earlier WWAN subsystem proposal.
> >
> > This initial version is purposely minimalist, it's essentially moving
> > the generic part of the previously proposed mhi_wwan_ctrl driver inside
> > a common WWAN framework, but the implementation is open and flexible
> > enough to allow extension for further drivers.
> >
> > Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> > ---
> >  v2: update copyright (2021)
> >  v3: Move driver to dedicated drivers/net/wwan directory
> >  v4: Rework to use wwan framework instead of self cdev management
> >  v5: Fix errors/typos in Kconfig
> >  v6: - Move to new wwan interface, No need dedicated call to wwan_dev_create
> >      - Cleanup code (remove legacy from mhi_uci, unused defines/vars...)
> >      - Remove useless write_lock mutex
> >      - Add mhi_wwan_wait_writable and mhi_wwan_wait_dlqueue_lock_irq helpers
> >      - Rework locking
> >      - Add MHI_WWAN_TX_FULL flag
> >      - Add support for NONBLOCK read/write
> >
> >  drivers/net/Kconfig          |   2 +
> >  drivers/net/Makefile         |   1 +
> >  drivers/net/wwan/Kconfig     |  22 +++
> >  drivers/net/wwan/Makefile    |   7 +
> >  drivers/net/wwan/wwan_core.c | 317 +++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/wwan.h         |  73 ++++++++++
> >  6 files changed, 422 insertions(+)
> >  create mode 100644 drivers/net/wwan/Kconfig
> >  create mode 100644 drivers/net/wwan/Makefile
> >  create mode 100644 drivers/net/wwan/wwan_core.c
> >  create mode 100644 include/linux/wwan.h
> >
> > diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> > index 5895905..74dc8e24 100644
> > --- a/drivers/net/Kconfig
> > +++ b/drivers/net/Kconfig
> > @@ -502,6 +502,8 @@ source "drivers/net/wan/Kconfig"
> >
> >  source "drivers/net/ieee802154/Kconfig"
> >
> > +source "drivers/net/wwan/Kconfig"
> > +
> >  config XEN_NETDEV_FRONTEND
> >       tristate "Xen network device frontend driver"
> >       depends on XEN
> > diff --git a/drivers/net/Makefile b/drivers/net/Makefile
> > index 040e20b..7ffd2d0 100644
> > --- a/drivers/net/Makefile
> > +++ b/drivers/net/Makefile
> > @@ -68,6 +68,7 @@ obj-$(CONFIG_SUNGEM_PHY) += sungem_phy.o
> >  obj-$(CONFIG_WAN) += wan/
> >  obj-$(CONFIG_WLAN) += wireless/
> >  obj-$(CONFIG_IEEE802154) += ieee802154/
> > +obj-$(CONFIG_WWAN) += wwan/
> >
> >  obj-$(CONFIG_VMXNET3) += vmxnet3/
> >  obj-$(CONFIG_XEN_NETDEV_FRONTEND) += xen-netfront.o
> > diff --git a/drivers/net/wwan/Kconfig b/drivers/net/wwan/Kconfig
> > new file mode 100644
> > index 0000000..545fe54
> > --- /dev/null
> > +++ b/drivers/net/wwan/Kconfig
> > @@ -0,0 +1,22 @@
> > +# SPDX-License-Identifier: GPL-2.0-only
> > +#
> > +# Wireless WAN device configuration
> > +#
> > +
> > +menuconfig WWAN
> > +     bool "Wireless WAN"
> > +     help
> > +       This section contains Wireless WAN driver configurations.
> > +
> > +if WWAN
> > +
> > +config WWAN_CORE
> > +     tristate "WWAN Driver Core"
> > +     help
> > +       Say Y here if you want to use the WWAN driver core. This driver
> > +       provides a common framework for WWAN drivers.
> > +
> > +       To compile this driver as a module, choose M here: the module will be
> > +       called wwan.
> > +
> > +endif # WWAN
> > diff --git a/drivers/net/wwan/Makefile b/drivers/net/wwan/Makefile
> > new file mode 100644
> > index 0000000..934590b
> > --- /dev/null
> > +++ b/drivers/net/wwan/Makefile
> > @@ -0,0 +1,7 @@
> > +# SPDX-License-Identifier: GPL-2.0
> > +#
> > +# Makefile for the Linux WWAN device drivers.
> > +#
> > +
> > +obj-$(CONFIG_WWAN_CORE) += wwan.o
> > +wwan-objs += wwan_core.o
> > diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
> > new file mode 100644
> > index 0000000..7d9e2643
> > --- /dev/null
> > +++ b/drivers/net/wwan/wwan_core.c
> > @@ -0,0 +1,317 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/* Copyright (c) 2021, Linaro Ltd <loic.poulain@linaro.org> */
> > +
> > +#include <linux/err.h>
> > +#include <linux/errno.h>
> > +#include <linux/fs.h>
> > +#include <linux/init.h>
> > +#include <linux/idr.h>
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/slab.h>
> > +#include <linux/types.h>
> > +#include <linux/wwan.h>
> > +
> > +#define WWAN_MAX_MINORS 256 /* Allow the whole available cdev range of minors */
>
> That's not the "whole range of minors" at all...

Though minor is 20-bit wide, Is 256 not the maximum number of minors
when using register_chrdev()?

>
> And what are you using this chardev for at all?  All you have is an
> open() call, but you have nothing to do with it after that.  What is it
> for?
>
> confused,

The WWAN framework acts a bit like misc or sound frameworks here, the
fops are not directly implemented by WWAN core but passed by the port
driver as parameter on WWAN port registration.There is no real benefit
of having them implemented in WWAN core since it would mostly consist
in forwarding read/write to the 'port driver' (at least for now).

Thanks,
Loic


>
> greg k-h
