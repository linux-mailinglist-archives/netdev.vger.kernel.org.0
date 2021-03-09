Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5B33322DF
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 11:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbhCIKVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 05:21:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbhCIKU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 05:20:59 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0625BC061760
        for <netdev@vger.kernel.org>; Tue,  9 Mar 2021 02:20:59 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id o38so8453355pgm.9
        for <netdev@vger.kernel.org>; Tue, 09 Mar 2021 02:20:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pNSjqyK0LPyqyWQYbvZumKo7SJVV4crx1fZyzzPnaNs=;
        b=T+yUcoxevbEmJNoONa0+BBenPFuWKB7cpD1e63zw63BwE7IaMGrco3KARQiF5ASc6r
         q2sPxAUery7rTfptxjG6h3jquKPfeM2M0mep0jJUVQvqVbI3ELYUhFUjCXJuMDs+Cq//
         p0RxOgl85MzOYeD2usqDzl3nRc+5qiCMk0Xl7DjtyQusnEka//n7FdLsadc9qkepYMx+
         2NBOX/6h+ACrmWc9PO75l6Iq7lGuqnWLnnE0Mi3s+C+nXUJPgthkBNOnZdJ6s/SWu/cP
         sTKJiwl6huvrv78eNYiYB6poFZOWcKX+Pz9Js+PuTbOi9DtAfiK8aaB3wCXSMgX0cpoa
         X/Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pNSjqyK0LPyqyWQYbvZumKo7SJVV4crx1fZyzzPnaNs=;
        b=NyumgWdNQxBUmxIe7+Sw+YJ4x4aWNFkRNlt/y2sgIfQc2wTdHJ9wQZ4bUki/KjRz81
         6FcXoPyKEFHcW4VBTuktA32yfuT/EEfqJMJjW2rpS7ZoBa4eYLBD6Ls3DAG8OGy0Gcz7
         3alE2cFe18RLqw/GDxVAYGRDO8ZJx8Sdeke7ud97e+Xf2+bEeZUSoGLa+deY+SzWCJV2
         LW0DNWoiWP5U3r5AwqSMjHnATtToFsHgfuPrcBIr39wZnbKqGe67BNR0hdWY8kwwPnzg
         gKq5X+W7xAxJ7RDL7z/bJKdKEpsaOHtqAvv1SGBCeb6GExCb8w80tBaNTBSrAU/ydmc5
         +KBg==
X-Gm-Message-State: AOAM533y6AJxYim+k/TqK6ILzo5jkNvkVprimDM2detK+sBBv8SOeXzz
        FO+ljI5xAKQcc4AVPlyUxTm9aFMi7DKH50y3Y7nZWg==
X-Google-Smtp-Source: ABdhPJxi2zpk7PcFQnet3iZZhhQfYdqsYJ5OppLqfcYaWWQ4QbAI4RXP49wyGJ4MslA4plTSMWHpB1/Ue0TATKHKyPg=
X-Received: by 2002:aa7:86d9:0:b029:1ef:4f40:4bba with SMTP id
 h25-20020aa786d90000b02901ef4f404bbamr21859345pfo.54.1615285258264; Tue, 09
 Mar 2021 02:20:58 -0800 (PST)
MIME-Version: 1.0
References: <1615279336-27227-1-git-send-email-loic.poulain@linaro.org> <YEdBfHAYkTGI8sE4@kroah.com>
In-Reply-To: <YEdBfHAYkTGI8sE4@kroah.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Tue, 9 Mar 2021 11:28:49 +0100
Message-ID: <CAMZdPi9dCzH9ufSoRK_szOaVnSsySk-kC5fu2Rb+wy-6snow0Q@mail.gmail.com>
Subject: Re: [PATCH net-next v3] net: Add Qcom WWAN control driver
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        open list <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Hemant Kumar <hemantk@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

On Tue, 9 Mar 2021 at 10:35, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Mar 09, 2021 at 09:42:16AM +0100, Loic Poulain wrote:
> > The MHI WWWAN control driver allows MHI Qcom based modems to expose
> > different modem control protocols/ports to userspace, so that userspace
> > modem tools or daemon (e.g. ModemManager) can control WWAN config
> > and state (APN config, SMS, provider selection...). A Qcom based
> > modem can expose one or several of the following protocols:
> > - AT: Well known AT commands interactive protocol (microcom, minicom...)
> > - MBIM: Mobile Broadband Interface Model (libmbim, mbimcli)
> > - QMI: Qcom MSM/Modem Interface (libqmi, qmicli)
> > - QCDM: Qcom Modem diagnostic interface (libqcdm)
> > - FIREHOSE: XML-based protocol for Modem firmware management
> >         (qmi-firmware-update)
> >
> > The different interfaces are exposed as character devices, in the same
> > way as for USB modem variants (known as modem 'ports').
> >
> > Note that this patch is mostly a rework of the earlier MHI UCI
> > tentative that was a generic interface for accessing MHI bus from
> > userspace. As suggested, this new version is WWAN specific and is
> > dedicated to only expose channels used for controlling a modem, and
> > for which related opensource user support exist. Other MHI channels
> > not fitting the requirements will request either to be plugged to
> > the right Linux subsystem (when available) or to be discussed as a
> > new MHI driver (e.g AI accelerator, WiFi debug channels, etc...).
> >
> > This change introduces a new drivers/net/wwan directory, aiming to
> > be the common place for WWAN drivers.
> >
> > Co-developed-by: Hemant Kumar <hemantk@codeaurora.org>
> > Signed-off-by: Hemant Kumar <hemantk@codeaurora.org>
> > Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> > ---
> >  v2: update copyright (2021)
> >  v3: Move driver to dedicated drivers/net/wwan directory
> >
> >  drivers/net/Kconfig              |   2 +
> >  drivers/net/Makefile             |   1 +
> >  drivers/net/wwan/Kconfig         |  26 ++
> >  drivers/net/wwan/Makefile        |   6 +
> >  drivers/net/wwan/mhi_wwan_ctrl.c | 559 +++++++++++++++++++++++++++++++++++++++
> >  5 files changed, 594 insertions(+)
> >  create mode 100644 drivers/net/wwan/Kconfig
> >  create mode 100644 drivers/net/wwan/Makefile
> >  create mode 100644 drivers/net/wwan/mhi_wwan_ctrl.c
> >
> > diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> > index 1ebb4b9..28b18f2 100644
> > --- a/drivers/net/Kconfig
> > +++ b/drivers/net/Kconfig
> > @@ -501,6 +501,8 @@ source "drivers/net/wan/Kconfig"
> >
> >  source "drivers/net/ieee802154/Kconfig"
> >
> > +source "drivers/net/wwan/Kconfig"
> > +
> >  config XEN_NETDEV_FRONTEND
> >       tristate "Xen network device frontend driver"
> >       depends on XEN
> > diff --git a/drivers/net/Makefile b/drivers/net/Makefile
> > index f4990ff..5da6424 100644
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
> > index 0000000..643aa10
> > --- /dev/null
> > +++ b/drivers/net/wwan/Kconfig
> > @@ -0,0 +1,26 @@
> > +# SPDX-License-Identifier: GPL-2.0-only
> > +#
> > +# Wireless WAN device configuration
> > +#
> > +
> > +menuconfig WWAN
> > +       bool "Wireless WAN"
> > +       help
> > +         This section contains Wireless WAN driver configurations.
> > +
> > +if WWAN
> > +
> > +config MHI_WWAN_CTRL
> > +     tristate "MHI WWAN control driver for QCOM based PCIe modems"
> > +     depends on MHI_BUS
> > +     help
> > +       MHI WWAN CTRL allow QCOM based PCIe modems to expose different modem
> > +       control protocols/ports to userspace, including AT, MBIM, QMI, DIAG
> > +       and FIREHOSE. These protocols can be accessed directly from userspace
> > +       (e.g. AT commands) or via libraries/tools (e.g. libmbim, libqmi,
> > +       libqcdm...).
> > +
> > +       To compile this driver as a module, choose M here: the module will be
> > +       called mhi_wwan_ctrl.
> > +
> > +endif # WWAN
> > diff --git a/drivers/net/wwan/Makefile b/drivers/net/wwan/Makefile
> > new file mode 100644
> > index 0000000..994a80b
> > --- /dev/null
> > +++ b/drivers/net/wwan/Makefile
> > @@ -0,0 +1,6 @@
> > +# SPDX-License-Identifier: GPL-2.0
> > +#
> > +# Makefile for the Linux WWAN device drivers.
> > +#
> > +
> > +obj-$(CONFIG_MHI_WWAN_CTRL) += mhi_wwan_ctrl.o
> > diff --git a/drivers/net/wwan/mhi_wwan_ctrl.c b/drivers/net/wwan/mhi_wwan_ctrl.c
> > new file mode 100644
> > index 0000000..3904cd0
> > --- /dev/null
> > +++ b/drivers/net/wwan/mhi_wwan_ctrl.c
> > @@ -0,0 +1,559 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/* Copyright (c) 2018-2021, The Linux Foundation. All rights reserved.*/
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/mhi.h>
> > +#include <linux/mod_devicetable.h>
> > +#include <linux/module.h>
> > +#include <linux/poll.h>
> > +
> > +#define MHI_WWAN_CTRL_DRIVER_NAME "mhi_wwan_ctrl"
>
> So a driver name is the same as the class that is being created?
>
> That feels wrong, shouldn't the "class" be wwan?

The driver does not aim to be THE wwan implementation, given the
heterogeneity of WWAN interfaces, so 'wwan' is probably too generic
for this bus/vendor specific driver. But since we create a new wwan
subdir, maybe we should create a minimal wwan_sysfs.c, that would
initially just offer a common class for all WWAN devices (wwan or
wwan-ports), as a first step to if not standardize, at least group
such devices under the same hat. Otherwise, we can just use the misc
class... Any thoughts?

>
> > +#define MHI_WWAN_CTRL_MAX_MINORS 128
>
> Why so many?

Right, it's not valid anymore, I'm going to change that.

Thanks,
Loic
