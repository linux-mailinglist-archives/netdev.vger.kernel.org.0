Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5043C14EC28
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 13:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728480AbgAaMCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 07:02:06 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40899 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728423AbgAaMCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 07:02:06 -0500
Received: by mail-wm1-f68.google.com with SMTP id t14so8364276wmi.5
        for <netdev@vger.kernel.org>; Fri, 31 Jan 2020 04:02:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mbDxoFJm2oj+qhmVC/5UqLWBu4cSJFdbmCZh1//SVQ4=;
        b=mYoMDYgfxsoqJFWW3pc1GvButWs7I+ctO4pZCarC+mZtnIJe0Gdqgy27ddJxZxcrz7
         SVx7e5lutA81dKlggkTmmmtmSVncGLDGm0cC6fKfjlA0u6DzPGaoLKOEdiEu8oIvwOUT
         +1x0QGJQD7mIOcsV4HkaPQeHYUxlekwTim81WrJ50UNbhnGtjcOSdsxF8V5n9g7ndF4C
         74zpfo3MZvg3Z8jbr0DqnZXLAoAU+CLGgVQmrV2UUQaaNtSZy204apfDLTeEZ9JAzQQw
         pEXULMN0WgEbIONtu00fIhLezf5FgM3nUMS84Vj5W2qW+vA+qYnJE4psO6bRKgt8WDHH
         9sRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mbDxoFJm2oj+qhmVC/5UqLWBu4cSJFdbmCZh1//SVQ4=;
        b=ZAmkvFtR/26E7HrgllCmpCiTdjMsIB7f7pWn6rs5OdmiIZcWcMTNqfxxQ09VBptm2p
         hkNgGP45jKxjrkbDKVLLc8ka+xoBw5QbJvxRd9hXF/4Tw6CN9QRtn+XlISzlwyTdWXqg
         fl2vV0cWnZBRaXKviZu06tEyAt3OQ8C6t1vwLHm1kdgSyT1OSAqN2u3MrBryb/Tv/VYN
         BcER/qlsNnnRW41hwP0pgGsowTWzEaryk1frV9Hn2QCIdafnlpd5G0gFNNKjF1/LqxCa
         NL4yr5eF9OumlMmkTbtlPySqMT/ONVMMygcOjTKrD60FkSy1+U/ZPyHZmdY+4MhrYDDu
         CFWg==
X-Gm-Message-State: APjAAAWURxvDQqjqBN/jkXVH94oydcuecaIDtRo8kYN9FEbjQ1RQRAkb
        P3sKU4OboRmcM0AXvAajVLQ9qW4oQEVFmB3uimCmrA==
X-Google-Smtp-Source: APXvYqyLtANt7wYq0lzcfnJ4oPim2jg3zsq8GEIuplfKm8PZP6V4fWF6UhT0UKkmPz3Joc4FOM6mQXP4R6uiWrkIJbw=
X-Received: by 2002:a05:600c:248:: with SMTP id 8mr11681147wmj.1.1580472123485;
 Fri, 31 Jan 2020 04:02:03 -0800 (PST)
MIME-Version: 1.0
References: <1580198925-50411-1-git-send-email-makarand.pawagi@nxp.com>
 <20200128110916.GA491@e121166-lin.cambridge.arm.com> <DB8PR04MB7164DDF48480956F05886DABEB070@DB8PR04MB7164.eurprd04.prod.outlook.com>
 <12531d6c569c7e14dffe8e288d9f4a0b@kernel.org>
In-Reply-To: <12531d6c569c7e14dffe8e288d9f4a0b@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 31 Jan 2020 13:01:51 +0100
Message-ID: <CAKv+Gu8uaJBmy5wDgk=uzcmC4vkEyOjW=JRvhpjfsdh-HcOCLg@mail.gmail.com>
Subject: Re: [EXT] Re: [PATCH] bus: fsl-mc: Add ACPI support for fsl-mc
To:     Marc Zyngier <maz@kernel.org>
Cc:     Makarand Pawagi <makarand.pawagi@nxp.com>,
        Calvin Johnson <calvin.johnson@nxp.com>, stuyoder@gmail.com,
        nleeder@codeaurora.org, Ioana Ciornei <ioana.ciornei@nxp.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Will Deacon <will@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Pankaj Bansal <pankaj.bansal@nxp.com>, jon@solid-run.com,
        Russell King <linux@armlinux.org.uk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Andy Wang <Andy.Wang@arm.com>, Varun Sethi <V.Sethi@nxp.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Paul Yang <Paul.Yang@arm.com>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Robin Murphy <robin.murphy@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Jan 2020 at 12:06, Marc Zyngier <maz@kernel.org> wrote:
>
> On 2020-01-31 10:35, Makarand Pawagi wrote:
> >> -----Original Message-----
> >> From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> >> Sent: Tuesday, January 28, 2020 4:39 PM
> >> To: Makarand Pawagi <makarand.pawagi@nxp.com>
> >> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; linux-arm-
> >> kernel@lists.infradead.org; linux-acpi@vger.kernel.org;
> >> linux@armlinux.org.uk;
> >> jon@solid-run.com; Cristi Sovaiala <cristian.sovaiala@nxp.com>;
> >> Laurentiu
> >> Tudor <laurentiu.tudor@nxp.com>; Ioana Ciornei
> >> <ioana.ciornei@nxp.com>;
> >> Varun Sethi <V.Sethi@nxp.com>; Calvin Johnson
> >> <calvin.johnson@nxp.com>;
> >> Pankaj Bansal <pankaj.bansal@nxp.com>; guohanjun@huawei.com;
> >> sudeep.holla@arm.com; rjw@rjwysocki.net; lenb@kernel.org;
> >> stuyoder@gmail.com; tglx@linutronix.de; jason@lakedaemon.net;
> >> maz@kernel.org; shameerali.kolothum.thodi@huawei.com; will@kernel.org;
> >> robin.murphy@arm.com; nleeder@codeaurora.org
> >> Subject: [EXT] Re: [PATCH] bus: fsl-mc: Add ACPI support for fsl-mc
> >>
> >> Caution: EXT Email
> >>
> >> On Tue, Jan 28, 2020 at 01:38:45PM +0530, Makarand Pawagi wrote:
> >> > ACPI support is added in the fsl-mc driver. Driver will parse MC DSDT
> >> > table to extract memory and other resorces.
> >> >
> >> > Interrupt (GIC ITS) information will be extracted from MADT table by
> >> > drivers/irqchip/irq-gic-v3-its-fsl-mc-msi.c.
> >> >
> >> > IORT table will be parsed to configure DMA.
> >> >
> >> > Signed-off-by: Makarand Pawagi <makarand.pawagi@nxp.com>
> >> > ---
> >> >  drivers/acpi/arm64/iort.c                   | 53 +++++++++++++++++++++
> >> >  drivers/bus/fsl-mc/dprc-driver.c            |  3 +-
> >> >  drivers/bus/fsl-mc/fsl-mc-bus.c             | 48 +++++++++++++------
> >> >  drivers/bus/fsl-mc/fsl-mc-msi.c             | 10 +++-
> >> >  drivers/bus/fsl-mc/fsl-mc-private.h         |  4 +-
> >> >  drivers/irqchip/irq-gic-v3-its-fsl-mc-msi.c | 71
> >> ++++++++++++++++++++++++++++-
> >> >  include/linux/acpi_iort.h                   |  5 ++
> >> >  7 files changed, 174 insertions(+), 20 deletions(-)
> >> >
> >> > diff --git a/drivers/acpi/arm64/iort.c b/drivers/acpi/arm64/iort.c
> >> > index 33f7198..beb9cd5 100644
> >> > --- a/drivers/acpi/arm64/iort.c
> >> > +++ b/drivers/acpi/arm64/iort.c
> >> > @@ -15,6 +15,7 @@
> >> >  #include <linux/kernel.h>
> >> >  #include <linux/list.h>
> >> >  #include <linux/pci.h>
> >> > +#include <linux/fsl/mc.h>
> >> >  #include <linux/platform_device.h>
> >> >  #include <linux/slab.h>
> >> >
> >> > @@ -622,6 +623,29 @@ static int iort_dev_find_its_id(struct device
> >> > *dev, u32 req_id,  }
> >> >
> >> >  /**
> >> > + * iort_get_fsl_mc_device_domain() - Find MSI domain related to a
> >> > +device
> >> > + * @dev: The device.
> >> > + * @mc_icid: ICID for the fsl_mc device.
> >> > + *
> >> > + * Returns: the MSI domain for this device, NULL otherwise  */ struct
> >> > +irq_domain *iort_get_fsl_mc_device_domain(struct device *dev,
> >> > +                                                     u32 mc_icid) {
> >> > +     struct fwnode_handle *handle;
> >> > +     int its_id;
> >> > +
> >> > +     if (iort_dev_find_its_id(dev, mc_icid, 0, &its_id))
> >> > +             return NULL;
> >> > +
> >> > +     handle = iort_find_domain_token(its_id);
> >> > +     if (!handle)
> >> > +             return NULL;
> >> > +
> >> > +     return irq_find_matching_fwnode(handle, DOMAIN_BUS_FSL_MC_MSI);
> >> > +}
> >>
> >> NAK
> >>
> >> I am not willing to take platform specific code in the generic IORT
> >> layer.
> >>
> >> ACPI on ARM64 works on platforms that comply with SBSA/SBBR
> >> guidelines:
> >>
> >>
> >> https://developer.arm.com/architectures/platform-design/server-systems
> >>
> >> Deviating from those requires butchering ACPI specifications (ie IORT)
> >> and
> >> related kernel code which goes totally against what ACPI is meant for
> >> on ARM64
> >> systems, so there is no upstream pathway for this code I am afraid.
> >>
> > Reason of adding this platform specific function in the generic IORT
> > layer is
> > That iort_get_device_domain() only deals with PCI bus
> > (DOMAIN_BUS_PCI_MSI).
> >
> > fsl-mc objects when probed, need to find irq_domain which is associated
> > with
> > the fsl-mc bus (DOMAIN_BUS_FSL_MC_MSI). It will not be possible to do
> > that
> > if we do not add this function because there are no other suitable APIs
> > exported
> > by IORT layer to do the job.
>
> I think we all understood the patch. What both Lorenzo and myself are
> saying is
> that we do not want non-PCI support in IORT.
>

IORT supports platform devices (aka named components) as well, and
there is some support for platform MSIs in the GIC layer.

So it may be possible to hide your exotic bus from the OS entirely,
and make the firmware instantiate a DSDT with device objects and
associated IORT nodes that describe whatever lives on that bus as
named components.

That way, you will not have to change the OS at all, so your hardware
will not only be supported in linux v5.7+, it will also be supported
by OSes that commercial distro vendors are shipping today. *That* is
the whole point of using ACPI.

If you are going to bother and modify the OS, you lose this advantage,
and ACPI gives you no benefit over DT at all.
