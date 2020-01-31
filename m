Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7D3214EB72
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 12:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728395AbgAaLG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 06:06:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:49124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728342AbgAaLGz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 06:06:55 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD79020707;
        Fri, 31 Jan 2020 11:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580468814;
        bh=rhOWBY9a8XVKosz1BHZiYYX/9QEa7aR9m1m6Yhc5uPQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aNaAMJZWTRFZ512RsXZ2YSxJeHik233WIht4ZLh84FI5nvkblDEn2W3g+hd6737ig
         2K6BCGZNYmty0Ke7DvqlZdjfxNrDxgZtAjcOm2M9QOkdxYVjEWaHP5dfgEvuVchCVG
         M90O43IJ6pAgrjeejY/zc87QXaqGrUFFGCvpQS1o=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1ixU8S-002LRZ-U0; Fri, 31 Jan 2020 11:06:53 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 31 Jan 2020 11:06:52 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Makarand Pawagi <makarand.pawagi@nxp.com>
Cc:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-acpi@vger.kernel.org,
        linux@armlinux.org.uk, jon@solid-run.com,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Varun Sethi <V.Sethi@nxp.com>,
        Calvin Johnson <calvin.johnson@nxp.com>,
        Pankaj Bansal <pankaj.bansal@nxp.com>, guohanjun@huawei.com,
        sudeep.holla@arm.com, rjw@rjwysocki.net, lenb@kernel.org,
        stuyoder@gmail.com, tglx@linutronix.de, jason@lakedaemon.net,
        shameerali.kolothum.thodi@huawei.com, will@kernel.org,
        robin.murphy@arm.com, nleeder@codeaurora.org,
        Andy Wang <Andy.Wang@arm.com>, Paul Yang <Paul.Yang@arm.com>
Subject: Re: [EXT] Re: [PATCH] bus: fsl-mc: Add ACPI support for fsl-mc
In-Reply-To: <DB8PR04MB7164DDF48480956F05886DABEB070@DB8PR04MB7164.eurprd04.prod.outlook.com>
References: <1580198925-50411-1-git-send-email-makarand.pawagi@nxp.com>
 <20200128110916.GA491@e121166-lin.cambridge.arm.com>
 <DB8PR04MB7164DDF48480956F05886DABEB070@DB8PR04MB7164.eurprd04.prod.outlook.com>
Message-ID: <12531d6c569c7e14dffe8e288d9f4a0b@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.8
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: makarand.pawagi@nxp.com, lorenzo.pieralisi@arm.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-acpi@vger.kernel.org, linux@armlinux.org.uk, jon@solid-run.com, cristian.sovaiala@nxp.com, laurentiu.tudor@nxp.com, ioana.ciornei@nxp.com, V.Sethi@nxp.com, calvin.johnson@nxp.com, pankaj.bansal@nxp.com, guohanjun@huawei.com, sudeep.holla@arm.com, rjw@rjwysocki.net, lenb@kernel.org, stuyoder@gmail.com, tglx@linutronix.de, jason@lakedaemon.net, shameerali.kolothum.thodi@huawei.com, will@kernel.org, robin.murphy@arm.com, nleeder@codeaurora.org, Andy.Wang@arm.com, Paul.Yang@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-01-31 10:35, Makarand Pawagi wrote:
>> -----Original Message-----
>> From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
>> Sent: Tuesday, January 28, 2020 4:39 PM
>> To: Makarand Pawagi <makarand.pawagi@nxp.com>
>> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; linux-arm-
>> kernel@lists.infradead.org; linux-acpi@vger.kernel.org; 
>> linux@armlinux.org.uk;
>> jon@solid-run.com; Cristi Sovaiala <cristian.sovaiala@nxp.com>; 
>> Laurentiu
>> Tudor <laurentiu.tudor@nxp.com>; Ioana Ciornei 
>> <ioana.ciornei@nxp.com>;
>> Varun Sethi <V.Sethi@nxp.com>; Calvin Johnson 
>> <calvin.johnson@nxp.com>;
>> Pankaj Bansal <pankaj.bansal@nxp.com>; guohanjun@huawei.com;
>> sudeep.holla@arm.com; rjw@rjwysocki.net; lenb@kernel.org;
>> stuyoder@gmail.com; tglx@linutronix.de; jason@lakedaemon.net;
>> maz@kernel.org; shameerali.kolothum.thodi@huawei.com; will@kernel.org;
>> robin.murphy@arm.com; nleeder@codeaurora.org
>> Subject: [EXT] Re: [PATCH] bus: fsl-mc: Add ACPI support for fsl-mc
>> 
>> Caution: EXT Email
>> 
>> On Tue, Jan 28, 2020 at 01:38:45PM +0530, Makarand Pawagi wrote:
>> > ACPI support is added in the fsl-mc driver. Driver will parse MC DSDT
>> > table to extract memory and other resorces.
>> >
>> > Interrupt (GIC ITS) information will be extracted from MADT table by
>> > drivers/irqchip/irq-gic-v3-its-fsl-mc-msi.c.
>> >
>> > IORT table will be parsed to configure DMA.
>> >
>> > Signed-off-by: Makarand Pawagi <makarand.pawagi@nxp.com>
>> > ---
>> >  drivers/acpi/arm64/iort.c                   | 53 +++++++++++++++++++++
>> >  drivers/bus/fsl-mc/dprc-driver.c            |  3 +-
>> >  drivers/bus/fsl-mc/fsl-mc-bus.c             | 48 +++++++++++++------
>> >  drivers/bus/fsl-mc/fsl-mc-msi.c             | 10 +++-
>> >  drivers/bus/fsl-mc/fsl-mc-private.h         |  4 +-
>> >  drivers/irqchip/irq-gic-v3-its-fsl-mc-msi.c | 71
>> ++++++++++++++++++++++++++++-
>> >  include/linux/acpi_iort.h                   |  5 ++
>> >  7 files changed, 174 insertions(+), 20 deletions(-)
>> >
>> > diff --git a/drivers/acpi/arm64/iort.c b/drivers/acpi/arm64/iort.c
>> > index 33f7198..beb9cd5 100644
>> > --- a/drivers/acpi/arm64/iort.c
>> > +++ b/drivers/acpi/arm64/iort.c
>> > @@ -15,6 +15,7 @@
>> >  #include <linux/kernel.h>
>> >  #include <linux/list.h>
>> >  #include <linux/pci.h>
>> > +#include <linux/fsl/mc.h>
>> >  #include <linux/platform_device.h>
>> >  #include <linux/slab.h>
>> >
>> > @@ -622,6 +623,29 @@ static int iort_dev_find_its_id(struct device
>> > *dev, u32 req_id,  }
>> >
>> >  /**
>> > + * iort_get_fsl_mc_device_domain() - Find MSI domain related to a
>> > +device
>> > + * @dev: The device.
>> > + * @mc_icid: ICID for the fsl_mc device.
>> > + *
>> > + * Returns: the MSI domain for this device, NULL otherwise  */ struct
>> > +irq_domain *iort_get_fsl_mc_device_domain(struct device *dev,
>> > +                                                     u32 mc_icid) {
>> > +     struct fwnode_handle *handle;
>> > +     int its_id;
>> > +
>> > +     if (iort_dev_find_its_id(dev, mc_icid, 0, &its_id))
>> > +             return NULL;
>> > +
>> > +     handle = iort_find_domain_token(its_id);
>> > +     if (!handle)
>> > +             return NULL;
>> > +
>> > +     return irq_find_matching_fwnode(handle, DOMAIN_BUS_FSL_MC_MSI);
>> > +}
>> 
>> NAK
>> 
>> I am not willing to take platform specific code in the generic IORT 
>> layer.
>> 
>> ACPI on ARM64 works on platforms that comply with SBSA/SBBR 
>> guidelines:
>> 
>> 
>> https://developer.arm.com/architectures/platform-design/server-systems
>> 
>> Deviating from those requires butchering ACPI specifications (ie IORT) 
>> and
>> related kernel code which goes totally against what ACPI is meant for 
>> on ARM64
>> systems, so there is no upstream pathway for this code I am afraid.
>> 
> Reason of adding this platform specific function in the generic IORT 
> layer is
> That iort_get_device_domain() only deals with PCI bus 
> (DOMAIN_BUS_PCI_MSI).
> 
> fsl-mc objects when probed, need to find irq_domain which is associated 
> with
> the fsl-mc bus (DOMAIN_BUS_FSL_MC_MSI). It will not be possible to do 
> that
> if we do not add this function because there are no other suitable APIs 
> exported
> by IORT layer to do the job.

I think we all understood the patch. What both Lorenzo and myself are 
saying is
that we do not want non-PCI support in IORT.

You have decided to have exotic hardware, and sidestep all the 
standardization
efforts. This is your right. But you can't have your cake and eat it.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
