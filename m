Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49FAC20D23F
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 20:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729375AbgF2Srv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 14:47:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729360AbgF2Srq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 14:47:46 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA80C02E2C2;
        Mon, 29 Jun 2020 06:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=qWyNxceE1HxDR9dXe27zL2Runx7nsY5emtD94N5b97s=; b=YN5nfLhHtwAS5bza4algxyhr3
        6ldxxk2+Hq3tRFjkQMCxV8cQsvoEhWZt9/PN9SG8360DvtYKHX1oxrz3Ur9oAM5hhskUF4KiYfEWX
        CSFMYP7pm9SOn8nnSVcTO46vMYVSiqGsSBiLR5HvhrUTWss1B7chmVvaXYnYJ+UCY00CoUT4lW5Ej
        b4f7DRoLGKoGp1FICS/Fq59Ku4k14U9e/ndBjLuJhoCUTHXxQ4cLt0DBRd8i8K02b8A3YtRXjflsx
        6qw9FNQTxUBiG/PsY9W93rkyr36N60B6TZtbC5ly3vYr2Le3wHaFJL5kKKTQjpNvtGnHkIkl0NXY/
        JRlhlr9VA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33104)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jpuJ4-0007h0-CS; Mon, 29 Jun 2020 14:58:46 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jpuJ0-0007AW-Al; Mon, 29 Jun 2020 14:58:42 +0100
Date:   Mon, 29 Jun 2020 14:58:42 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florinel Iordache <florinel.iordache@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v3 4/7] net: phy: add backplane kr driver support
Message-ID: <20200629135842.GU1551@shell.armlinux.org.uk>
References: <1592832924-31733-1-git-send-email-florinel.iordache@nxp.com>
 <1592832924-31733-5-git-send-email-florinel.iordache@nxp.com>
 <20200622142430.GP279339@lunn.ch>
 <AM6PR04MB397677E90EFBD9749D01B061EC970@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <7b12d7f1-9e36-e3ee-7a51-d8d8628e2e6f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b12d7f1-9e36-e3ee-7a51-d8d8628e2e6f@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 12:02:05PM -0700, Florian Fainelli wrote:
> On 6/22/20 8:08 AM, Madalin Bucur (OSS) wrote:
> > Hi Andrew, the reasons behind this selection:
> > 
> > - the PCS that is controlled by the backplane driver belongs to the PHY
> > layer so the representation as a PHY device is legitimate
> 
> That argument makes sense.

It doesn't when you also are subjected to other parts of NXP arguing
that the PCS is tightly bound inside the SoC and therefore should be
effectively a library - as has been discussed in the threads about
the Lynx PCS.

> > - the PHY driver provides the state machine that is required, not using
> > this representation backplane would need to add a separate, duplicate
> > state machine
> 
> Which is entirely permissible according to the PHY library
> documentation, not that we have seen many people do it though, even less
> so when the PHY driver is providing the state machine.

It seems the PHYlib state machine is getting smaller and smaller
as we move forward; phy_state_machine() is now looking very bare
compared to what it used to look like.  I think it's not that far
off being eliminated.

> > - the limitation, that only one PHY layer entity can be managed by the
> > PHYLib, is a known limitation that always existed, is not introduced by
> > the backplane support; the unsupported scenario with a backplane connection
> > to a PHY entity that needs to be managed relates to that limitation and
> > a solution for it should not be added through the backplane support
> > - afaik, Russell and Ioana are discussing the PCS representation in the
> > context of PHYLink, this submission is using PHYLib. If we are to discuss
> > about the PCS representation, it's the problem of the simplistic "one device
> > in the PHY layer" issue that needs to be addressed to have a proper PCS
> > representation at all times.
> 
> So would not it make sense for the PCS representation to be settled and
> then add the backplane driver implementation such that there is no
> double work happening for Florinel and for reviewers and the PCS
> implementation als factors in the backplane use case and requirements?

Yes, that is my assessment; there's a lot of work going on in different
areas in QoriQ networking, and it seems people are pulling things in
quite diverse directions.

If we're not careful, we're going to end up with the Lynx PCS being
implemented one way, and backplane PCS being implemented completely
differently and preventing any hope of having a backplane PCS
connected to a conventional copper PHY.

I think folk at NXP need to stop, stand back, and look at the bigger
picture about how they want to integrate all these individual,
independent strands of development into the kernel, and come up with
a common approach that also satisfies the mainline kernel, rather
than having individual discussions with mainline kernel maintainers
on public lists.  What I'm saying is, it isn't our job to co-ordinate
between the different parts of NXP - that's fairly and squarely
NXP's problem to sort out themselves.

So, I think, further progress in public on backplane support needs to
wait until we have the general situation for PCS resolved.

Makes sense?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
