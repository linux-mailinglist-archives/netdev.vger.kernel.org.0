Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF10126C5C
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 20:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729793AbfLSTDS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 14:03:18 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:38316 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727335AbfLSTDR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 14:03:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Mfm7DMY8WWFlPUqQr1sVZLi8OKj883uDVX3lL5NhuA8=; b=rRjm7uJoO5fJBjErsGFPJ73aw
        mG90zjt80pLVX2HK04S/eCaR3UYGUELSaOVNSPwrzzWOw7MxlBwVJb/G4Zmm94imGRl9q8cpOKdqi
        pJpZpoyXaZZocv940b0J4XiS6fWzGdkZuxgcy3Oza2Dwdr0aePFgV3xvMHxKbgdAJ92lDLcEcqXCr
        QsGvywNRaZbLwyRyKZjcYGu7bV7ozTBUsFbv1/AT/mCm8oQ0/NAnh9N7yqQ56Yc/2V9HCvVWXgKgN
        GuKGcH3S253umER+0piOLnuK960Slb3pphVbI3fTLMW9TBYJWeFvq2y3p37Rz3iU7MWAtZlYwa4D8
        4Q4ygcE1Q==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:51056)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ii14p-0004Gj-Sm; Thu, 19 Dec 2019 19:03:12 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ii14m-0005bF-HE; Thu, 19 Dec 2019 19:03:08 +0000
Date:   Thu, 19 Dec 2019 19:03:08 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Madalin Bucur <madalin.bucur@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
Message-ID: <20191219190308.GE25745@shell.armlinux.org.uk>
References: <1576768881-24971-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1576768881-24971-2-git-send-email-madalin.bucur@oss.nxp.com>
 <20191219172834.GC25745@shell.armlinux.org.uk>
 <VI1PR04MB5567FA3170CF45F877870E8CEC520@VI1PR04MB5567.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR04MB5567FA3170CF45F877870E8CEC520@VI1PR04MB5567.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 06:32:51PM +0000, Madalin Bucur wrote:
> > -----Original Message-----
> > From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> > Sent: Thursday, December 19, 2019 7:29 PM
> > To: Madalin Bucur <madalin.bucur@nxp.com>
> > Cc: davem@davemloft.net; netdev@vger.kernel.org; andrew@lunn.ch;
> > f.fainelli@gmail.com; hkallweit1@gmail.com; shawnguo@kernel.org;
> > devicetree@vger.kernel.org
> > Subject: Re: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
> > 
> > On Thu, Dec 19, 2019 at 05:21:16PM +0200, Madalin Bucur wrote:
> > > From: Madalin Bucur <madalin.bucur@nxp.com>
> > >
> > > Add explicit entries for XFI, SFI to make sure the device
> > > tree entries for phy-connection-type "xfi" or "sfi" are
> > > properly parsed and differentiated against the existing
> > > backplane 10GBASE-KR mode.
> > 
> > 10GBASE-KR is actually used for XFI and SFI (due to a slight mistake on
> > my part, it should've been just 10GBASE-R).
> > 
> > Please explain exactly what the difference is between XFI, SFI and
> > 10GBASE-R. I have not been able to find definitive definitions for
> > XFI and SFI anywhere, and they appear to be precisely identical to
> > 10GBASE-R. It seems that it's just a terminology thing, with
> > different groups wanting to "own" what is essentially exactly the
> > same interface type.
> 
> Hi Russell,
> 
> 10GBase-R could be used as a common nominator but just as well 10G and
> remove the rest while we're at it. There are/may be differences in
> features, differences in the way the HW is configured (the most
> important aspect) and one should be able to determine what interface
> type is in use to properly configure the HW. SFI does not have the CDR
> function in the PMD, relying on the PMA signal conditioning vs the XFI
> that requires this in the PMD. We kept the xgmii compatible for so long
> without much issues until someone started cleaning up the PHY supported
> modes. Since we're doing that, let's be rigorous. The 10GBase-KR is
> important too, we have some backplane code in preparation and having it
> there could pave the way for a simpler integration.

The problem we currently have is:

$ grep '10gbase-kr' arch/*/boot/dts -r

virtually none of those are actually backplane. For the mcbin matches,
these are either to a 88x3310 PHY for the doubleshot, which dynamically
operates between XFI, 5GBASE-R, 2500BASE-X, or SGMII according to the
datasheet.

If we add something else, then the problem becomes what to do about
that lot - one of the problems is, it seems we're going to be breaking
DT compatibility by redefining 10gbase-kr to be correct.

It's interesting to hear what the difference is between XFI and SFI,
but it's weird that PHYs such as 88x3310 have no configuration of their
fiber interface to enable or disable the CDR, yet it supports fiber
interfaces, and explicitly shows applications involving "XFI/SFI".
There's no mention of the CDR in the datasheet either.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
