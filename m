Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7C8715EFC0
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 18:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390003AbgBNRuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 12:50:00 -0500
Received: from foss.arm.com ([217.140.110.172]:42128 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388732AbgBNRt6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 12:49:58 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5B8E1328;
        Fri, 14 Feb 2020 09:49:57 -0800 (PST)
Received: from e121166-lin.cambridge.arm.com (e121166-lin.cambridge.arm.com [10.1.196.255])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 157803F68E;
        Fri, 14 Feb 2020 09:49:53 -0800 (PST)
Date:   Fri, 14 Feb 2020 17:49:49 +0000
From:   Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To:     Pankaj Bansal <pankaj.bansal@nxp.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        Calvin Johnson <calvin.johnson@nxp.com>,
        "stuyoder@gmail.com" <stuyoder@gmail.com>,
        "nleeder@codeaurora.org" <nleeder@codeaurora.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Will Deacon <will@kernel.org>,
        "jon@solid-run.com" <jon@solid-run.com>,
        Russell King <linux@armlinux.org.uk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Andy Wang <Andy.Wang@arm.com>, Varun Sethi <V.Sethi@nxp.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Paul Yang <Paul.Yang@arm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [EXT] Re: [PATCH] bus: fsl-mc: Add ACPI support for fsl-mc
Message-ID: <20200214174949.GA30484@e121166-lin.cambridge.arm.com>
References: <1580198925-50411-1-git-send-email-makarand.pawagi@nxp.com>
 <20200128110916.GA491@e121166-lin.cambridge.arm.com>
 <DB8PR04MB7164DDF48480956F05886DABEB070@DB8PR04MB7164.eurprd04.prod.outlook.com>
 <12531d6c569c7e14dffe8e288d9f4a0b@kernel.org>
 <CAKv+Gu8uaJBmy5wDgk=uzcmC4vkEyOjW=JRvhpjfsdh-HcOCLg@mail.gmail.com>
 <VI1PR0401MB249622CFA9B213632F1DE955F1150@VI1PR0401MB2496.eurprd04.prod.outlook.com>
 <7349fa0e6d62a3e0d0e540f2e17646e0@kernel.org>
 <VI1PR0401MB2496373E0C6D1097F22B3026F1150@VI1PR0401MB2496.eurprd04.prod.outlook.com>
 <20200214161957.GA27513@e121166-lin.cambridge.arm.com>
 <VI1PR0401MB2496800C88A3A2CF912959E6F1150@VI1PR0401MB2496.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0401MB2496800C88A3A2CF912959E6F1150@VI1PR0401MB2496.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 14, 2020 at 04:35:10PM +0000, Pankaj Bansal wrote:

[...]

> > -----Original Message-----
> > From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> > Sent: Friday, February 14, 2020 9:50 PM
> > To: Pankaj Bansal <pankaj.bansal@nxp.com>
> > Cc: Marc Zyngier <maz@kernel.org>; Ard Biesheuvel
> > <ard.biesheuvel@linaro.org>; Makarand Pawagi <makarand.pawagi@nxp.com>;
> > Calvin Johnson <calvin.johnson@nxp.com>; stuyoder@gmail.com;
> > nleeder@codeaurora.org; Ioana Ciornei <ioana.ciornei@nxp.com>; Cristi
> > Sovaiala <cristian.sovaiala@nxp.com>; Hanjun Guo <guohanjun@huawei.com>;
> > Will Deacon <will@kernel.org>; jon@solid-run.com; Russell King
> > <linux@armlinux.org.uk>; ACPI Devel Maling List <linux-acpi@vger.kernel.org>;
> > Len Brown <lenb@kernel.org>; Jason Cooper <jason@lakedaemon.net>; Andy
> > Wang <Andy.Wang@arm.com>; Varun Sethi <V.Sethi@nxp.com>; Thomas
> > Gleixner <tglx@linutronix.de>; linux-arm-kernel <linux-arm-
> > kernel@lists.infradead.org>; Laurentiu Tudor <laurentiu.tudor@nxp.com>; Paul
> > Yang <Paul.Yang@arm.com>; netdev@vger.kernel.org; Rafael J. Wysocki
> > <rjw@rjwysocki.net>; Linux Kernel Mailing List <linux-kernel@vger.kernel.org>;
> > Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>;
> > Sudeep Holla <sudeep.holla@arm.com>; Robin Murphy
> > <robin.murphy@arm.com>
> > Subject: Re: [EXT] Re: [PATCH] bus: fsl-mc: Add ACPI support for fsl-mc
Side note: would you mind removing the email headers (as above) in your
replies please ?

> > On Fri, Feb 14, 2020 at 03:58:14PM +0000, Pankaj Bansal wrote:
> > 
> > [...]
> > 
> > > > Why should the device know about its own ID? That's a bus/interconnect
> > thing.
> > > > And nothing should be passed *to* IORT. IORT is the source.
> > >
> > > IORT is translation between Input IDs <-> Output IDs. The Input ID is still
> > expected to be passed to parse IORT table.
> > 
> > Named components use an array of single mappings (as in entries with single
> > mapping flag set) - Input ID is irrelevant.
> > 
> > Not sure what your named component is though and what you want to do with
> > it, the fact that IORT allows mapping for named components do not necessarily
> > mean that it can describe what your system really is, on that you need to
> > elaborate for us to be able to help.
> 
> Details about MC bus can be read from here:
> https://elixir.bootlin.com/linux/latest/source/Documentation/networking/device_drivers/freescale/dpaa2/overview.rst#L324
> 
> As stated above, in Linux MC is a bus (just like PCI bus, AMBA bus etc)
> There can be multiple devices attached to this bus. Moreover, we can dynamically create/destroy these devices.
> Now, we want to represent this BUS (not individual devices connected to bus) in IORT table.
> The only possible way right now we see is that we describe it as Named components having a pool of ID mappings.
> As and when devices are created and attached to bus, we sift through this pool to correctly determine the output ID for the device.
> Now the input ID that we provide, can come from device itself.
> Then we can use the Platform MSI framework for MC bus devices.

So are you asking me if that's OK ? Or there is something you can't
describe with IORT ?

Side note: can you explain to me please how the MSI allocation flow
and kernel data structures/drivers are modeled in DT ? I had a quick
look at:

drivers/irqchip/irq-gic-v3-its-fsl-mc-msi.c

and to start with, does that code imply that we create a
DOMAIN_BUS_FSL_MC_MSI on ALL DT systems with an ITS device node ?

I *think* you have a specific API to allocate MSIs for MC devices:

fsl_mc_msi_domain_alloc_irqs()

which hook into the IRQ domain created in the file above that handles
the cascading to an ITS domain, correct ?

Thanks,
Lorenzo
