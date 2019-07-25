Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 428B274FA6
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 15:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388554AbfGYNgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 09:36:16 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34752 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388380AbfGYNgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 09:36:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=4VXwvzkEj9NF1gRnbsRNQSHO8CIYBoFwOxJC55LwU9g=; b=OOMNvaxn2yOarMXVC7lVByXPs
        PnP9viWt6p1OTkUWe6RCXklHR1dHERQQl3DiSSpWMkLI1R27A/lfX1EpA52Oyc4ZWCKGRbEjAAE+J
        MoMSrDnBNusgkkafSqpd5rARfTxURb4zl+gIVjAmsEANW/slBvEcF7M8HHEw0hi1Q7CbFe2QzoLcp
        wSvKccHXjLGDqWjoQVDqs/7kQQfG9jmQ8ED+pF2abq5T6iEmA7syIIJTJg+6gfgJiOwxd9tZlY/Bm
        LsnCfCB7mLpGmffEV0tibvESx7/MJ5PE7X4k8KLWkVGz5SgR87WAgv6sYs2NPamuoW0WJUWE7H9Oz
        ZMPqjY+Wg==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:37040)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hqduf-0000OB-Aa; Thu, 25 Jul 2019 14:36:05 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hqdua-0005fG-ET; Thu, 25 Jul 2019 14:36:00 +0100
Date:   Thu, 25 Jul 2019 14:36:00 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Parshuram Raju Thombare <pthombar@cadence.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rafal Ciepiela <rafalc@cadence.com>,
        Piotr Sroka <piotrs@cadence.com>,
        Anil Joy Varughese <aniljoy@cadence.com>,
        Arthur Marris <arthurm@cadence.com>,
        Steven Ho <stevenh@cadence.com>,
        Milind Parab <mparab@cadence.com>
Subject: Re: [PATCH v6 0/5] net: macb: cover letter
Message-ID: <20190725133559.GI1330@shell.armlinux.org.uk>
References: <1562769391-31803-1-git-send-email-pthombar@cadence.com>
 <20190718151310.GE25635@lunn.ch>
 <CO2PR07MB246961335F7D401785377765C1C10@CO2PR07MB2469.namprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO2PR07MB246961335F7D401785377765C1C10@CO2PR07MB2469.namprd07.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 25, 2019 at 01:27:58PM +0000, Parshuram Raju Thombare wrote:
> Hi Andrew,
> 
> >One thing which was never clear is how you are testing the features you are
> >adding. Please could you describe your test setup and how each new feature
> >is tested using that hardware. I'm particularly interested in what C45 device
> >are you using? But i expect Russell would like to know more about SFP
> >modules you are using. Do you have any which require 1000BaseX,
> >2500BaseX, or provide copper 1G?
> 
> Sorry for late reply.
> Here is a little more information on our setup used for testing C45 patch with a view to
> try clarify a few points. 
> Regarding the MDIO communication channel that our controller supports - We have tested
> MDIO transfers through Clause 22, but none of our local PHY's support Clause 45 so our hardware
> team have created an example Clause 45 slave device for us to add support to the driver.
> Note our hardware has been in silicon for 20 years, with customers using their own software to support
> MDIO (both clause 22 and clause 45 functionality) and so this has been in Cadence's hardware controller
> many times. 
> The programming interface is not hugely different between the two clauses and therefore we feel the risk is low.
> 
> For other features like SGMII, USXGMII we are using kc705 and vcu118 FPGA boards.
> 10G SFP+ module from Tyco electronics is used for testing 10G USXGMII in fixed AN mode.

SFP and SFP+ modules take SGMII, 1000BASE-X, possibly 2500BASE-X and
10GBASE-R all over a single serdes lane.

USXGMII might be used from the MAC to some sort of PHY which then
converts to 10GBASE-R.

If you have a PHY present, then using phylink and trying to link the
MAC directly with the SFP cage in software is the _wrong approach_.
I've stated this several times.

I'm getting to the point of asking you not to persist with your use
of phylink with your driver - I do not believe that your hardware has
any justification for its use, and I also believe that your use of
phylink is positively hurtful to the long term maintenance of phylink
itself.

In other words, you persisting to (ab)use phylink _hurts_ our ability
to maintain it into the future.

I'm also at the point where I'm giving up reviewing your patches - you
don't seem to take the issues I raise on board at all, so I feel like
I'm completely wasting my time trying to get you to make improvements.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
