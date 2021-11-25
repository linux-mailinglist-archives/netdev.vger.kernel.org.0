Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A445645D8FB
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 12:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238288AbhKYLTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 06:19:34 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:23047 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239996AbhKYLRe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 06:17:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1637838863; x=1669374863;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Bc8QxHXVsePajHSex4lSnt3xrPHH5iD6DErJOtC05HI=;
  b=QIHnNOElVnINN9EQuMrjPNr4+f5rg8UidybA4XpiGfA76e85ig1SoWgH
   K6wEi4ih0fOh2m2VqKl0gQnXzlefF6ufBRNpN4tMY8Y/zDfxVq0kb0vbW
   7Dlk6Pt2VhcZE9CUxdrR4Vf9M2xyG5IbDL2oegPGTEgeZbshhWKq66/ZC
   bubCPzAb4zi5y8n0G7jh4mRWrYFnwQvc1ItHylmTf2BP5kz2gGljvwSiU
   pjP0lLmmabJ0H2pVEzGAq0xURmE7ZwyPEWNtOtQPCxeIn8ML8JIkobCl1
   ezliuzYx81BmPdc5dTIrtXIjR8pqq7n2zLNU2Tc3jn4ESpAk7KunQVH3M
   A==;
IronPort-SDR: 4Swfajmu4PANy8rilbtzs2ePky66Hcs6IV+15CBHARs9oLsNhxwOIJbJqU2ayeW4RhDhN6cFtL
 guwDJZTJ4bcsVGsrJFhc9IqELBu8kNJxnvQ7elQ64FWMFAtINzGmHEHmuzBIr2kOKgqwnDrahP
 n1MoVqXoiBaIN7jn7BwSCTqoDAkx6H7gaTOEQ2ORtPC57zf8fRejeeDT2D8SZiPmLlemW4ztPj
 we1aIetfb3//GF1ZUzJAsWHuIrEyzdIkc/gd7N3M5Mq6xhQzK2LD/AHUPNdqbI37iOqR9TdMLY
 UvTVeFoEDTPqhkpYEBgSw90x
X-IronPort-AV: E=Sophos;i="5.87,263,1631602800"; 
   d="scan'208";a="145134329"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Nov 2021 04:14:22 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 25 Nov 2021 04:14:22 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Thu, 25 Nov 2021 04:14:21 -0700
Date:   Thu, 25 Nov 2021 12:16:15 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <p.zabel@pengutronix.de>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v3 3/6] net: lan966x: add port module support
Message-ID: <20211125111615.4zobdjmyxtss6ngn@soft-dev3-1.localhost>
References: <20211124083915.2223065-1-horatiu.vultur@microchip.com>
 <20211124083915.2223065-4-horatiu.vultur@microchip.com>
 <YZ4SB/wX6UT3zrEV@shell.armlinux.org.uk>
 <20211124145800.my4niep3sifqpg55@soft-dev3-1.localhost>
 <YZ5UXdiNNf011skU@shell.armlinux.org.uk>
 <20211124154323.44liimrwzthsh547@soft-dev3-1.localhost>
 <YZ5ikamCVeyGFw3x@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <YZ5ikamCVeyGFw3x@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/24/2021 16:04, Russell King (Oracle) wrote:
> On Wed, Nov 24, 2021 at 04:43:23PM +0100, Horatiu Vultur wrote:
> > > > Actually, port->config.phy_mode will not get zeroed. Because right after
> > > > the memset it follows: 'config = port->config'.
> > >
> > > Ah, missed that, thanks. However, why should portmode and phy_mode be
> > > different?
> >
> > Because the serdes knows only few modes(QSGMII, SGMII, GMII) and this
> > information will come from DT. So I would like to have one variable that
> > will configure the serdes ('phy_mode') and one will configure the MAC
> > ('portmode').
> 
> I don't follow why you need this to be different.
> 
> Isn't the point of interfaces such as phy_set_mode_ext() such that we
> can achieve independence of the details of what is behind that
> interface - so, as it takes a PHY interface mode, if we're operating
> in 1000BASE-X, we pass that to phy_set_mode_ext(). It is then the
> responsibility of the Serdes PHY driver to decide that means "sgmii"
> mode for the Serdes?

I have kept the responsability in the network driver to decide which
interface should for serdes, but I can change that as you suggested.

> 
> For example, the Marvell CP110 comphy driver does this:
> 
>         if (submode == PHY_INTERFACE_MODE_1000BASEX)
>                 submode = PHY_INTERFACE_MODE_SGMII;
> 
> because the serdes phy settings for PHY_INTERFACE_MODE_1000BASEX are
> no different from PHY_INTERFACE_MODE_SGMII - and that detail is hidden
> from the network driver.

Yes, I will add a similar check in the serdes driver.

> 
> The next question this brings up is... you're setting all the different
> interface modes in phylink_config.supported_interfaces, which basically
> means you're giving permission for phylink to switch between any of
> those modes. So, what if the serdes is in QSGMII mode but phylink
> requests SGMII mode. Doesn't your driver architecture mean that if
> you're in QSGMII mode you can't use SGMII or GMII mode?
> 
> Is there some kind of restriction that you need to split this, or is
> this purely down to the way this driver has been written?

It was just the way the driver has been written.

> 
> I don't see any other driver in the kernel making this kind of split.
> 
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

-- 
/Horatiu
