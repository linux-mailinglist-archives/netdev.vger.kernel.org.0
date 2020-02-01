Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B89214F7AB
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 12:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbgBALtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 06:49:52 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:58814 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbgBALtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Feb 2020 06:49:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=HnpDr+EYlr+rwm3PugQQ1cWKXYWrIicGoMrGWJGDElk=; b=mFGne9DFt/gmDPWvq8GGbODr4
        74nkRl91SC6LnethSOBtJMY5ldDSVaTOJgrNiP5qkc9yB86oVQX/tbny09bLUK4rStaKyy5P8RsR0
        EXxE4na+G0wFzokc5ThlRXoqlXf768UOkfTqmDCGudbfGl607aU6Gy/JCiF9QqUxdZqjtWko90z+6
        5VzyMmfNrU3DSggP+As0u+Mzhv3lGLHNQ1325AvgVAIGrP1Z8SrX1BannNYfA+WxcMU/rV4HKOt+/
        FvfzQAUlYc66AKckYu/TqHvMCyaq+WrZnKowM6J9PFG+KBuSWcpRngFGnClh3i8bKnwAOdr/WBs0V
        EePQFJ2uw==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:34528)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ixrHC-000704-FV; Sat, 01 Feb 2020 11:49:26 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ixrH5-0006Mc-Oa; Sat, 01 Feb 2020 11:49:19 +0000
Date:   Sat, 1 Feb 2020 11:49:19 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@mellanox.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Robin Murphy <robin.murphy@arm.com>,
        Calvin Johnson <calvin.johnson@nxp.com>, stuyoder@gmail.com,
        nleeder@codeaurora.org, Ioana Ciornei <ioana.ciornei@nxp.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Will Deacon <will@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        Jon Nettleton <jon@solid-run.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Andy Wang <Andy.Wang@arm.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        Varun Sethi <V.Sethi@nxp.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Paul Yang <Paul.Yang@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Sudeep Holla <sudeep.holla@arm.com>
Subject: Re: [EXT] Re: [PATCH] bus: fsl-mc: Add ACPI support for fsl-mc
Message-ID: <20200201114919.GQ25745@shell.armlinux.org.uk>
References: <DB8PR04MB7164DDF48480956F05886DABEB070@DB8PR04MB7164.eurprd04.prod.outlook.com>
 <12531d6c569c7e14dffe8e288d9f4a0b@kernel.org>
 <CAKv+Gu8uaJBmy5wDgk=uzcmC4vkEyOjW=JRvhpjfsdh-HcOCLg@mail.gmail.com>
 <CABdtJHsu9R9g4mn25=9EW3jkCMhnej_rfkiRzo3OCX4cv4hpUQ@mail.gmail.com>
 <0680c2ce-cff0-d163-6bd9-1eb39be06eee@arm.com>
 <CABdtJHuLZeNd9bQZ-cmQi00WnObYPvM=BdWNw4EMpOFHjRd70w@mail.gmail.com>
 <b136adc4-be48-82df-0592-97b4ba11dd79@arm.com>
 <20200131142906.GG9639@lunn.ch>
 <20200131151500.GO25745@shell.armlinux.org.uk>
 <20200131074050.38d78ff0@cakuba.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200131074050.38d78ff0@cakuba.hsd1.ca.comcast.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 31, 2020 at 07:40:50AM -0800, Jakub Kicinski wrote:
> On Fri, 31 Jan 2020 15:15:00 +0000, Russell King - ARM Linux admin
> wrote:
> > I have some prototype implementation for driving the QSFP+ cage, but
> > I haven't yet worked out how to sensible deal with the "is it 4x 10G
> > or 1x 40G" issue you mention above, and how to interface the QSFP+
> > driver sensibly with one or four network drivers.
> 
> I'm pretty sure you know this but just FWIW - vendors who do it in FW
> write the current config down in NVM so it doesn't get affected by
> reboots and use devlink port splitting to change it.

+Jiri

I wasn't aware of devlink port splitting, so thanks for that. However,
it could do with some better documentation - there's nothing on it
afaics in the Documentation subdirectory, and "man devlink-port"
doesn't give much away either:

   devlink port split - split devlink port into more
       DEV/PORT_INDEX - specifies the devlink port to operate on.

       count COUNT
              number of ports to split to.

It's the "into more" that's not clear - presumably more ports, and
presumably each port is a network device, but this isn't explained.

I think what this is trying to say is that, if we have a QSFP+ cage
with 4 serdes lines running at 10G, and they are initially treated as
a single 40G ethernet:

	devlink port split device/1 count 4

will then give us four 10G network devices, and:

	devlink port unsplit device/1

will recombine them back to a single 40G network device.

What if someone decides to do:

	devlink port split device/1 count 2

what do we end up with?  Presumably two network devices running with
two serdes lanes each (if supported by the hardware).  At that point
can they then do:

	devlink port split device/2 count 2

and end up with one network device with two 10G serdes lanes, and two
network devices each with one 10G serdes lane, or can port splitting
only be used on the "master" device/port ?

Unfortunately, I don't think I have any network devices that support
this so I can't experiment to find out how this should work; yes, I
have a Mellanox card, but it supports a single 10G SFP+, and therefore
does not support port splitting.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
