Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0BA14EEB7
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 15:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729020AbgAaOrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 09:47:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:53886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728827AbgAaOrq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 09:47:46 -0500
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5E3C206D5;
        Fri, 31 Jan 2020 14:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580482066;
        bh=Pa0QAne+ikfRhcST4dhxQhcKQvjaN3EVPx5vMgOXzVo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D3UmqQ/pBjmnWl1PtBaM6XfZQzl+sLU+f2jy7YCYWNZLtIrbEIrys0/0Ss5/Xc0lt
         raWKCH990ysM7rxkXTHv8SnUgWPyGF598DtDtLi+tCyQAYtjlGKnr4B2Eg5USJNfqG
         DokwLpRCs+Dw9Nz5XRQL4vnFqRCVD2pGmTcn3Qy8=
Date:   Fri, 31 Jan 2020 14:47:38 +0000
From:   Will Deacon <will@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Jon Nettleton <jon@solid-run.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Marc Zyngier <maz@kernel.org>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        Calvin Johnson <calvin.johnson@nxp.com>, stuyoder@gmail.com,
        nleeder@codeaurora.org, Ioana Ciornei <ioana.ciornei@nxp.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
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
        Sudeep Holla <sudeep.holla@arm.com>
Subject: Re: [EXT] Re: [PATCH] bus: fsl-mc: Add ACPI support for fsl-mc
Message-ID: <20200131144737.GA4948@willie-the-truck>
References: <1580198925-50411-1-git-send-email-makarand.pawagi@nxp.com>
 <20200128110916.GA491@e121166-lin.cambridge.arm.com>
 <DB8PR04MB7164DDF48480956F05886DABEB070@DB8PR04MB7164.eurprd04.prod.outlook.com>
 <12531d6c569c7e14dffe8e288d9f4a0b@kernel.org>
 <CAKv+Gu8uaJBmy5wDgk=uzcmC4vkEyOjW=JRvhpjfsdh-HcOCLg@mail.gmail.com>
 <CABdtJHsu9R9g4mn25=9EW3jkCMhnej_rfkiRzo3OCX4cv4hpUQ@mail.gmail.com>
 <0680c2ce-cff0-d163-6bd9-1eb39be06eee@arm.com>
 <CABdtJHuLZeNd9bQZ-cmQi00WnObYPvM=BdWNw4EMpOFHjRd70w@mail.gmail.com>
 <b136adc4-be48-82df-0592-97b4ba11dd79@arm.com>
 <20200131142906.GG9639@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200131142906.GG9639@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 31, 2020 at 03:29:06PM +0100, Andrew Lunn wrote:
> > > But by design SFP, SFP+, and QSFP cages are not fixed function network
> > > adapters.  They are physical and logical devices that can adapt to
> > > what is plugged into them.  How the devices are exposed should be
> > > irrelevant to this conversation it is about the underlying
> > > connectivity.
> > 
> > Apologies - I was under the impression that SFP and friends were a
> > physical-layer thing and that a MAC in the SoC would still be fixed such
> > that its DMA and interrupt configuration could be statically described
> > regardless of what transceiver was plugged in (even if some configurations
> > might not use every interrupt/stream ID/etc.) If that isn't the case I shall
> > go and educate myself further.
> 
> It gets interesting with QSFP cages. The Q is quad, there are 4 SERDES
> lanes. You can use them for 1x 40G link, or you can split them into 4x
> 10G links. So you either need one MAC or 4 MACs connecting to the
> cage, and this can change on the fly when a modules is ejected and
> replaced with another module. There are only one set of control pins
> for i2c, loss of signal, TX disable, module inserted. So where the
> interrupt/stream ID/etc are mapped needs some flexibility.
> 
> There is also to some degree a conflict with hiding all this inside
> firmware. This is complex stuff. It is much better to have one core
> implementing in Linux plus some per hardware driver support, than
> having X firmware blobs, generally closed source, each with there own
> bugs which nobody can fix.

Devicetree to the rescue!

Entertaining the use of ACPI without any firmware abstraction for this
hardware really feels like a square peg / round hole situation, so I'm
assuming somebody's telling you that you need it "FOAR ENTAPRYZE". Who
is it and can you tell them to bog off?

Will
