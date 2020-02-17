Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7963161643
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 16:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728696AbgBQPfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 10:35:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:42880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727976AbgBQPfE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Feb 2020 10:35:04 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 380E020718;
        Mon, 17 Feb 2020 15:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581953703;
        bh=8efhOOieeB7D17j3jQ31Byut/zxDybXrDad5pZgzM6g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GUBKrAqfG8eSWxLQWWL2Hm7nfXDbOjgbkjFFHnQy6utvXaBluk+63gdAGLNnTeb30
         H6BGDGTl6RRv71CiGYfZQM6e2IQ6OJd6B6ojZFHMj8nAM7Y+I5YMylksMDqdvFABaM
         7usA1EvhAx1vDJlpGyn37JrX8xFPvBnuoK+EtALk=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j3iQH-005xOP-JS; Mon, 17 Feb 2020 15:35:01 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 17 Feb 2020 15:35:01 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc:     Pankaj Bansal <pankaj.bansal@nxp.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        Calvin Johnson <calvin.johnson@nxp.com>, stuyoder@gmail.com,
        nleeder@codeaurora.org, Ioana Ciornei <ioana.ciornei@nxp.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Will Deacon <will@kernel.org>, jon@solid-run.com,
        Russell King <linux@armlinux.org.uk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Andy Wang <Andy.Wang@arm.com>, Varun Sethi <V.Sethi@nxp.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Paul Yang <Paul.Yang@arm.com>, netdev@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [EXT] Re: [PATCH] bus: fsl-mc: Add ACPI support for fsl-mc
In-Reply-To: <20200217152518.GA18376@e121166-lin.cambridge.arm.com>
References: <DB8PR04MB7164DDF48480956F05886DABEB070@DB8PR04MB7164.eurprd04.prod.outlook.com>
 <12531d6c569c7e14dffe8e288d9f4a0b@kernel.org>
 <CAKv+Gu8uaJBmy5wDgk=uzcmC4vkEyOjW=JRvhpjfsdh-HcOCLg@mail.gmail.com>
 <VI1PR0401MB249622CFA9B213632F1DE955F1150@VI1PR0401MB2496.eurprd04.prod.outlook.com>
 <7349fa0e6d62a3e0d0e540f2e17646e0@kernel.org>
 <VI1PR0401MB2496373E0C6D1097F22B3026F1150@VI1PR0401MB2496.eurprd04.prod.outlook.com>
 <20200214161957.GA27513@e121166-lin.cambridge.arm.com>
 <VI1PR0401MB2496800C88A3A2CF912959E6F1150@VI1PR0401MB2496.eurprd04.prod.outlook.com>
 <20200214174949.GA30484@e121166-lin.cambridge.arm.com>
 <VI1PR0401MB2496308C27B7DAA7A5396970F1160@VI1PR0401MB2496.eurprd04.prod.outlook.com>
 <20200217152518.GA18376@e121166-lin.cambridge.arm.com>
Message-ID: <384eb5378ee2b240d6ab7d89aef2d5c7@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: lorenzo.pieralisi@arm.com, pankaj.bansal@nxp.com, ard.biesheuvel@linaro.org, makarand.pawagi@nxp.com, calvin.johnson@nxp.com, stuyoder@gmail.com, nleeder@codeaurora.org, ioana.ciornei@nxp.com, cristian.sovaiala@nxp.com, guohanjun@huawei.com, will@kernel.org, jon@solid-run.com, linux@armlinux.org.uk, linux-acpi@vger.kernel.org, lenb@kernel.org, jason@lakedaemon.net, Andy.Wang@arm.com, V.Sethi@nxp.com, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org, laurentiu.tudor@nxp.com, Paul.Yang@arm.com, netdev@vger.kernel.org, rjw@rjwysocki.net, linux-kernel@vger.kernel.org, shameerali.kolothum.thodi@huawei.com, sudeep.holla@arm.com, robin.murphy@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-02-17 15:25, Lorenzo Pieralisi wrote:
> On Mon, Feb 17, 2020 at 12:35:12PM +0000, Pankaj Bansal wrote:

Hi Lorenzo,

[...]

>> > Side note: can you explain to me please how the MSI allocation flow
>> > and kernel data structures/drivers are modeled in DT ? I had a quick
>> > look at:
>> >
>> > drivers/irqchip/irq-gic-v3-its-fsl-mc-msi.c
>> >
>> > and to start with, does that code imply that we create a
>> > DOMAIN_BUS_FSL_MC_MSI on ALL DT systems with an ITS device node ?
>> 
>> Yes. It's being done for all DT systems having ITS node.
> 
> This does not seem correct to me, I will let Marc comment on
> the matter.

Unfortunately, there isn't a very good way to avoid that ATM,
other than defering the registration of the irqdomain until
we know that a particular bus (for example a PCIe RC) is registered.

I started working on that at some point, and ended up nowhere because
no bus (PCI, FSL, or anything else) really give us the right information
when it is actually required (when a device starts claiming interrupts).

I *think* we could try a defer it until a bus root is found, and that
this bus has a topological link to an ITS. probably invasive though,
as you would need a set of "MSI providers" for each available irqchip
node.

In short, messy. But I'd be happy to revive this and have a look again.

         M.
-- 
Jazz is not dead. It just smells funny...
