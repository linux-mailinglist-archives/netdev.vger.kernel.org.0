Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 822D839C47A
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 02:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbhFEAfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 20:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbhFEAfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 20:35:02 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4EF5C061766;
        Fri,  4 Jun 2021 17:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=V+hjMwL6pv5S226ZXdxW+r94VZLwnnDUg913Mua7a68=; b=n6AGsFe4s1jPWOG3sII7rVVTf
        f23QBTGnxo36zLhYzPwjfg/+kBblHjfsiRyDTS7Rawc4BIl2zJJ9OPayxRPHF30sMVi8aCUOvtFQK
        fLqKbF0z/8gt8CeMGM1Qe9NUEb9jFtnqjvvWZlqqrBNcbuSlR9EgyAyssr9XroZTAOsu4MqT8hws/
        vLp5DNNwbGMQWTak0fOOxyrsf/HbCirRs1mGPhD75l5T7ZIaHLe2H979dMI2KNMcn2UFq89/2v+GE
        ZDk13TOltm5JT41pm1IlF2fuWe2QLe6+4FK2Wq02mUsCvB8gMQpRJzonPWDnAcHz5WIgW5ReIkm1N
        K5Ok4P4WA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44722)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lpKFQ-0005OD-M6; Sat, 05 Jun 2021 01:33:08 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lpKFP-0003Vi-3E; Sat, 05 Jun 2021 01:33:07 +0100
Date:   Sat, 5 Jun 2021 01:33:07 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     Madalin Bucur <madalin.bucur@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Igal Liberman <Igal.Liberman@freescale.com>,
        Shruti Kanetkar <Shruti@freescale.com>,
        Emil Medve <Emilian.Medve@freescale.com>,
        Scott Wood <oss@buserror.net>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Camelia Alexandra Groza (OSS)" <camelia.groza@oss.nxp.com>
Subject: Re: Unsupported phy-connection-type sgmii-2500 in
 arch/powerpc/boot/dts/fsl/t1023rdb.dts
Message-ID: <20210605003306.GY30436@shell.armlinux.org.uk>
References: <20210603143453.if7hgifupx5k433b@pali>
 <YLjxX/XPDoRRIvYf@lunn.ch>
 <20210603194853.ngz4jdso3kfncnj4@pali>
 <AM6PR04MB3976B62084EC462BA02F0C4CEC3B9@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <20210604192732.GW30436@shell.armlinux.org.uk>
 <AM6PR04MB39768A569CE3CC4EC61A8769EC3B9@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <YLqLzOltcb6jan+B@lunn.ch>
 <AM6PR04MB39760B986E86BA9169DEECC5EC3B9@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <20210604233455.fwcu2chlsed2gwmu@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210604233455.fwcu2chlsed2gwmu@pali>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 05, 2021 at 01:34:55AM +0200, Pali Rohár wrote:
> But as this is really confusing what each mode means for Linux, I would
> suggest that documentation for these modes in ethernet-controller.yaml
> file (or in any other location) could be extended. I see that it is
> really hard to find exact information what these modes mean and what is
> their meaning in DTS / kernel.

We have been adding documentation to:

Documentation/networking/phy.rst

for each of the modes that have had issues. The 2500base-X entry
hasn't been updated yet, as the question whether it can have in-band
signaling is unclear (there is no well defined standard for this.)

Some vendors state that there is no in-band signalling in 2500base-X.
Others (e.g. Xilinx) make it clear that it is optional. Others don't
say either way, and when testing hardware, it appears to be functional.

So, coming up with a clear definition for this, when we have no real
method in the DT file to say "definitely do not use in-band" is a tad
difficult.

It started out as described - literally, 1000base-X multiplied by 2.5x.
There are setups where that is known to work - namely GPON SFPs that
support 2500base-X. What that means is that we know the GPON SFP
module negotiates in-band AN with 2500base-X. However, we don't know
whether the module will work if we disable in-band AN.

There is hardware out there as well which allows one to decide whether
to use in-band AN with 2500base-X or not. Xilinx is one such vendor
who explicitly documents this. Marvell on the other hand do not
prohibit in-band AN with mvneta, neither to they explicitly state it
is permitted. In at least one of their PHY documents, they suggest it
isn't supported if the MAC side is operating in 2500base-X.

Others (NXP) take the position that in-band AN is not supported at
2500base-X speeds. I think a few months ago, Vladimir persuaded me
that we should disable in-band AN for 2500base-X - I had forgotten
about the Xilinx documentation I had which shows that it's optional.
(Practically, it's optional in hardware with 1000base-X too, but then
it's not actually conforming with 802.3's definition of 1000base-X.)

The result is, essentially, a total mess. 2500base-X is not a standards
defined thing, so different vendors have gone off and done different
things.

Sometimes it's amazing that you can connect two devices together and
they will actually talk to each other!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
