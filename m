Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02F2514EF35
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 16:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729274AbgAaPJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 10:09:50 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:60146 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729071AbgAaPJu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 10:09:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2diiy8c4y3CQgdL4Lzi01JXwoWYa5nYVCP1kWDev+KA=; b=VtV9rSnhaU0/x3uU0Ks1rPZwoy
        udAyQG7ZDC0OTihQpPDz/WkVWXMvNN/aqQsxdfKqkoW3c4SQ2yZdFcgUxpNGOvWeOW6fiDxhTMgbr
        MAw/DzHa16yTES2h6C2kEpkRtp3LtWyVvPX3tDO5U2vDa7SjwSyPDdFS82it+CbcDj1w=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ixXvF-0007n7-4E; Fri, 31 Jan 2020 16:09:29 +0100
Date:   Fri, 31 Jan 2020 16:09:29 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Will Deacon <will@kernel.org>
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
Message-ID: <20200131150929.GB13902@lunn.ch>
References: <20200128110916.GA491@e121166-lin.cambridge.arm.com>
 <DB8PR04MB7164DDF48480956F05886DABEB070@DB8PR04MB7164.eurprd04.prod.outlook.com>
 <12531d6c569c7e14dffe8e288d9f4a0b@kernel.org>
 <CAKv+Gu8uaJBmy5wDgk=uzcmC4vkEyOjW=JRvhpjfsdh-HcOCLg@mail.gmail.com>
 <CABdtJHsu9R9g4mn25=9EW3jkCMhnej_rfkiRzo3OCX4cv4hpUQ@mail.gmail.com>
 <0680c2ce-cff0-d163-6bd9-1eb39be06eee@arm.com>
 <CABdtJHuLZeNd9bQZ-cmQi00WnObYPvM=BdWNw4EMpOFHjRd70w@mail.gmail.com>
 <b136adc4-be48-82df-0592-97b4ba11dd79@arm.com>
 <20200131142906.GG9639@lunn.ch>
 <20200131144737.GA4948@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200131144737.GA4948@willie-the-truck>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Devicetree to the rescue!

Yes, exactly. We have good, standardised descriptions for most of this
in device tree. And phylink can handle SFP and SFP+. Nobody has worked
on QSFP yet, since phylink has mostly been pushed by the embedded
world and 40G is not yet popular in the embedded world.

> Entertaining the use of ACPI without any firmware abstraction for this
> hardware really feels like a square peg / round hole situation, so I'm
> assuming somebody's telling you that you need it "FOAR ENTAPRYZE". Who
> is it and can you tell them to bog off?

The issues here is that SFPs are appearing in more and more server
systems, replacing plain old copper Ethernet. If the boxes use off the
shelf Mellanox or Intel PCIe cards, it is not an issue. But silicon
vendors are integrating this into the SoC in the ARM way of doing
things, memory mapped, spread over a number of controllers, not a
single PCIe device.

Maybe we need hybrid systems. Plain, old, simple, boring things like
CPUs, serial ports, SATA, PCIe busses are described in ACPI. Complex
interesting things are in DT. The hard thing is the interface between
the two. DT having a phandle to an ACPI object, e.g a GPIO, interrupt
or an i2c bus.

   Andrew
