Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5877224B71
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 15:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbgGRNUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 09:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726566AbgGRNUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 09:20:22 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05149C0619D2;
        Sat, 18 Jul 2020 06:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=u1Ta43l8ivno0FCtWUhrqwGXsKGzaaP+vzxnn7dCRs0=; b=hraSxEa8sSRapBAnEdTMHrFww
        Ws8wbtC3pEWdiPCtvVN0dWA7gC8fH8K68gMZm2aBwDTQ5MLzW6PvXrytg2JhLfYosQs/XtjMQDNL/
        om5EXahWcp7QwGUyvypqKNWgIhLEmxqjaVi+6vkHizFSWB4LCzL43ge1Hlr0AQvd4TBBqcGvoDsfe
        duVMfvA2fCgIBQp/ZnN638bEdngPfn/rKugJasNr8X8Mw1me/J/PBHwly1Y7PCdQ0HBmEvSrnSx+K
        fxva4v0RRLfMFh/UW8/WjxlHNtdT+1KCfUCT6Jrph84E3ik03Qg5Qjv3p0qjdadO2soOA0mda5ffC
        2v1aC27bw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:41078)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jwmlD-0001bu-P8; Sat, 18 Jul 2020 14:20:15 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jwml9-0002yE-BN; Sat, 18 Jul 2020 14:20:11 +0100
Date:   Sat, 18 Jul 2020 14:20:11 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     John Crispin <john@phrozen.org>
Cc:     Matthew Hagan <mnhagan88@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jonathan McDowell <noodles@earth.li>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH 2/2] dt-bindings: net: dsa: qca8k: Add PORT0_PAD_CTRL
 properties
Message-ID: <20200718132011.GQ1551@shell.armlinux.org.uk>
References: <2e1776f997441792a44cd35a16f1e69f848816ce.1594668793.git.mnhagan88@gmail.com>
 <ea0a35ed686e6dace77e25cb70a8f39fdd1ea8ad.1594668793.git.mnhagan88@gmail.com>
 <20200716150925.0f3e01b8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <ac7f5f39-9f83-64c0-d8d5-9ea059619f67@gmail.com>
 <53851852-0efe-722e-0254-8652cdfea8fc@phrozen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53851852-0efe-722e-0254-8652cdfea8fc@phrozen.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 10:44:19PM +0200, John Crispin wrote:
> in regards to the sgmii clk skew. I never understood the electrics fully I
> am afraid, but without the patch it simply does not work. my eletcric foo is
> unfortunately is not sufficient to understand the "whys" I am afraid.

Do you happen to know what frequency the clock is?  Is it 1.25GHz or
625MHz?  It sounds like it may be 1.25GHz if the edge is important.

If the clock is 1.25GHz, the "why" is because of hazards (it has
nothing to do with delays in RGMII being propagated to SGMII).

Quite simply, a flip-flop suffers from metastability if the clock and
data inputs change at about the same time.  Amongst the parametrics of
flip-flops will be a data setup time, and a data hold time, referenced
to the clock signal.

If the data changes within the setup and hold times of the clock
changing, then the output of the flip-flop is unpredictable - it can
latch a logic 1 or a logic 0, or oscillate between the two until
settling on one state.

So, if data is clocked out on the rising edge of a clock signal, and
clocked in on the rising edge of a clock signal - and the data and
clock edges arrive within the setup and hold times at the flip-flop
that is clocking the data in, there is a metastability hazard, and
the data bit that is latched is unpredictable.

One way to solve this is to clock data out on one edge, and clock data
in on the opposite edge - this is used on buses such as SPI.  Other
buses such as I2C define minimum separation between transitions between
the SDA and SCL signals.

These solutions don't work with RGMII - the RGMII TXC clocks data on
both edges.  The only solution there is to ensure a delay is introduced
between the data and clock changes seen at the receiver - which can be
done by introducing delays at the transmitter or at the receiver, or by
serpentine routing of the traces to induce delays to separate the clock
and data transitions sufficiently to avoid metastability.

If the clock is 625MHz (as with some Marvell devices for SGMII) then
both clock edges are used, and both edges are used just like RGMII.
Therefore, the same considerations as RGMII apply there to ensure that
the data setup and hold times are not violated.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
