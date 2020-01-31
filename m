Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD2F14EB6D
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 12:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728416AbgAaLGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 06:06:20 -0500
Received: from foss.arm.com ([217.140.110.172]:34304 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728268AbgAaLGT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 06:06:19 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D0A7231B;
        Fri, 31 Jan 2020 03:06:18 -0800 (PST)
Received: from e121166-lin.cambridge.arm.com (e121166-lin.cambridge.arm.com [10.1.196.255])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 976083F67D;
        Fri, 31 Jan 2020 03:06:15 -0800 (PST)
Date:   Fri, 31 Jan 2020 11:06:10 +0000
From:   Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To:     Makarand Pawagi <makarand.pawagi@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "jon@solid-run.com" <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Varun Sethi <V.Sethi@nxp.com>,
        Calvin Johnson <calvin.johnson@nxp.com>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        "guohanjun@huawei.com" <guohanjun@huawei.com>,
        "sudeep.holla@arm.com" <sudeep.holla@arm.com>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "stuyoder@gmail.com" <stuyoder@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "maz@kernel.org" <maz@kernel.org>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "will@kernel.org" <will@kernel.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "nleeder@codeaurora.org" <nleeder@codeaurora.org>,
        Andy Wang <Andy.Wang@arm.com>, Paul Yang <Paul.Yang@arm.com>
Subject: Re: [EXT] Re: [PATCH] bus: fsl-mc: Add ACPI support for fsl-mc
Message-ID: <20200131110610.GA32701@e121166-lin.cambridge.arm.com>
References: <1580198925-50411-1-git-send-email-makarand.pawagi@nxp.com>
 <20200128110916.GA491@e121166-lin.cambridge.arm.com>
 <DB8PR04MB7164DDF48480956F05886DABEB070@DB8PR04MB7164.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB8PR04MB7164DDF48480956F05886DABEB070@DB8PR04MB7164.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 31, 2020 at 10:35:48AM +0000, Makarand Pawagi wrote:
> > -----Original Message-----
> > From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> > Sent: Tuesday, January 28, 2020 4:39 PM
> > To: Makarand Pawagi <makarand.pawagi@nxp.com>
> > Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; linux-arm-
> > kernel@lists.infradead.org; linux-acpi@vger.kernel.org; linux@armlinux.org.uk;
> > jon@solid-run.com; Cristi Sovaiala <cristian.sovaiala@nxp.com>; Laurentiu
> > Tudor <laurentiu.tudor@nxp.com>; Ioana Ciornei <ioana.ciornei@nxp.com>;
> > Varun Sethi <V.Sethi@nxp.com>; Calvin Johnson <calvin.johnson@nxp.com>;
> > Pankaj Bansal <pankaj.bansal@nxp.com>; guohanjun@huawei.com;
> > sudeep.holla@arm.com; rjw@rjwysocki.net; lenb@kernel.org;
> > stuyoder@gmail.com; tglx@linutronix.de; jason@lakedaemon.net;
> > maz@kernel.org; shameerali.kolothum.thodi@huawei.com; will@kernel.org;
> > robin.murphy@arm.com; nleeder@codeaurora.org
> > Subject: [EXT] Re: [PATCH] bus: fsl-mc: Add ACPI support for fsl-mc
> > 
> > Caution: EXT Email
> > 
> > On Tue, Jan 28, 2020 at 01:38:45PM +0530, Makarand Pawagi wrote:
> > > ACPI support is added in the fsl-mc driver. Driver will parse MC DSDT
> > > table to extract memory and other resorces.
> > >
> > > Interrupt (GIC ITS) information will be extracted from MADT table by
> > > drivers/irqchip/irq-gic-v3-its-fsl-mc-msi.c.
> > >
> > > IORT table will be parsed to configure DMA.
> > >
> > > Signed-off-by: Makarand Pawagi <makarand.pawagi@nxp.com>
> > > ---
> > >  drivers/acpi/arm64/iort.c                   | 53 +++++++++++++++++++++
> > >  drivers/bus/fsl-mc/dprc-driver.c            |  3 +-
> > >  drivers/bus/fsl-mc/fsl-mc-bus.c             | 48 +++++++++++++------
> > >  drivers/bus/fsl-mc/fsl-mc-msi.c             | 10 +++-
> > >  drivers/bus/fsl-mc/fsl-mc-private.h         |  4 +-
> > >  drivers/irqchip/irq-gic-v3-its-fsl-mc-msi.c | 71
> > ++++++++++++++++++++++++++++-
> > >  include/linux/acpi_iort.h                   |  5 ++
> > >  7 files changed, 174 insertions(+), 20 deletions(-)
> > >
> > > diff --git a/drivers/acpi/arm64/iort.c b/drivers/acpi/arm64/iort.c
> > > index 33f7198..beb9cd5 100644
> > > --- a/drivers/acpi/arm64/iort.c
> > > +++ b/drivers/acpi/arm64/iort.c
> > > @@ -15,6 +15,7 @@
> > >  #include <linux/kernel.h>
> > >  #include <linux/list.h>
> > >  #include <linux/pci.h>
> > > +#include <linux/fsl/mc.h>
> > >  #include <linux/platform_device.h>
> > >  #include <linux/slab.h>
> > >
> > > @@ -622,6 +623,29 @@ static int iort_dev_find_its_id(struct device
> > > *dev, u32 req_id,  }
> > >
> > >  /**
> > > + * iort_get_fsl_mc_device_domain() - Find MSI domain related to a
> > > +device
> > > + * @dev: The device.
> > > + * @mc_icid: ICID for the fsl_mc device.
> > > + *
> > > + * Returns: the MSI domain for this device, NULL otherwise  */ struct
> > > +irq_domain *iort_get_fsl_mc_device_domain(struct device *dev,
> > > +                                                     u32 mc_icid) {
> > > +     struct fwnode_handle *handle;
> > > +     int its_id;
> > > +
> > > +     if (iort_dev_find_its_id(dev, mc_icid, 0, &its_id))
> > > +             return NULL;
> > > +
> > > +     handle = iort_find_domain_token(its_id);
> > > +     if (!handle)
> > > +             return NULL;
> > > +
> > > +     return irq_find_matching_fwnode(handle, DOMAIN_BUS_FSL_MC_MSI);
> > > +}
> > 
> > NAK
> > 
> > I am not willing to take platform specific code in the generic IORT layer.
> > 
> > ACPI on ARM64 works on platforms that comply with SBSA/SBBR guidelines:
> > 
> > 
> > https://developer.arm.com/architectures/platform-design/server-systems
> >
> > Deviating from those requires butchering ACPI specifications (ie IORT) and
> > related kernel code which goes totally against what ACPI is meant for on ARM64
> > systems, so there is no upstream pathway for this code I am afraid.
> > 
> Reason of adding this platform specific function in the generic IORT
> layer is That iort_get_device_domain() only deals with PCI bus
> (DOMAIN_BUS_PCI_MSI).
> 
> fsl-mc objects when probed, need to find irq_domain which is
> associated with the fsl-mc bus (DOMAIN_BUS_FSL_MC_MSI). It will not be
> possible to do that if we do not add this function because there are
> no other suitable APIs exported by IORT layer to do the job.

And that's by design.

I don't know what the FSL bus is and I don't want to know, what
I am telling you is that the ACPI code in the mainline is sufficient
to support SBSA compliant HW and that's what we support with ACPI
on ARM64.

We won't hack the kernel (and ACPI tables) up to boot with ACPI on
non-compliant platforms, I don't know how I can be any clearer than
that.

All is needed to configure the (platform dev/PCI->IOMMU->ITS) chain is
in the ACPI/IORT specifications and again, that's by design, adding
DSDT objects and hacking the kernel to make it work "like DT" won't
cut it, you are solving the wrong problem here, boot this platform
with a device tree, it is a problem that has been solved a long time
ago and it is supported in the mainline kernel.

Thanks,
Lorenzo
