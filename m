Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7A742BE85
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 13:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbhJMLDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 07:03:46 -0400
Received: from mx1.tq-group.com ([93.104.207.81]:47633 "EHLO mx1.tq-group.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231658AbhJMLDb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 07:03:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1634122888; x=1665658888;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yiLPIdqtdIwyAypswEPJAvSEqYuCP9g6YjtCjU518zk=;
  b=XQLiQFvAaJnSRgTcWqr+Z8mfHQ8pnkHBcTft2vWkUyYCP4DQRdSB/anI
   J8/ZpHQGy7uYk7hIRxPf+cyVOPJPVI2SM44cP0KqGTjzygpBi+hUbivrx
   EMAOb7h6urwjn43ktRlsYIbGmhrBaaGug5obTgxngthigWoyhrVSwB/aB
   fZabR2EaMtR6sf73r/IMyAVqs3Q3rCvXzSUkdM3wKO+RqJ/HQwIG1VdAc
   p02hMY0k78wfRjlKSCNUTwOFms2fzUY1Cn+KmRAa5IpJbINRz/fgK3aKZ
   G3rg1KXd9rHZSQZNA7Wilc7qzBDtdi3jNPETn/U33tRst6XOXsqHv7S3h
   w==;
X-IronPort-AV: E=Sophos;i="5.85,370,1624312800"; 
   d="scan'208";a="20020507"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 13 Oct 2021 13:01:26 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Wed, 13 Oct 2021 13:01:26 +0200
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Wed, 13 Oct 2021 13:01:26 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1634122886; x=1665658886;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yiLPIdqtdIwyAypswEPJAvSEqYuCP9g6YjtCjU518zk=;
  b=TmU0umnDQwHvvgjdvEJzxe4mjRMdMiEleUGywN2TR2dDh+wI4a94fuK4
   VpeuYPm1kQmDzsbUhQrU8+95BfgyY/tUX/DBeH3tPrLsGXT50tN3rEM/r
   GMlmN3hKY7shjOT7sRwiycvj9fElfQuUQu/hSjZTQaW1RoTVUO+sZ6SBR
   CFFMQvlwY45lVQNqUkyQ4YoGZBZoyk4I+ZXXB9QCjO6E/H2RHMxSub8l4
   ro6Rtlz6Q2sQQVrOR3z3rmjt4sVmH3g6cQK/MI1oK1X17la8c1SVpPqFz
   4r3K17rvAaIB9w62uyKINY1t3++ZaFRnVRDwtuom6kdHvbuXHl73bPedE
   A==;
X-IronPort-AV: E=Sophos;i="5.85,370,1624312800"; 
   d="scan'208";a="20020506"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 13 Oct 2021 13:01:26 +0200
Received: from schifferm-ubuntu4.tq-net.de (schifferm-ubuntu4.tq-net.de [10.121.48.12])
        by vtuxmail01.tq-net.de (Postfix) with ESMTPA id 4FBE1280065;
        Wed, 13 Oct 2021 13:01:26 +0200 (CEST)
Message-ID: <d46649a97945efb49fefcd30415548a76cd0a334.camel@ew.tq-group.com>
Subject: Re: [PATCH] net: phy: micrel: make *-skew-ps check more lenient
From:   Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
To:     Philippe Schenker <philippe.schenker@toradex.com>
Cc:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>
Date:   Wed, 13 Oct 2021 13:01:26 +0200
In-Reply-To: <bf2c71d5f73839bdc585c19490e40d08f26d644a.camel@toradex.com>
References: <20211012103402.21438-1-matthias.schiffer@ew.tq-group.com>
         <45137d2d365d5737f36fa398ee815695722b04e5.camel@toradex.com>
         <987224f4ca93f928c8ddb69710d3aa72b336b6dc.camel@ew.tq-group.com>
         <bf2c71d5f73839bdc585c19490e40d08f26d644a.camel@toradex.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-10-13 at 10:18 +0000, Philippe Schenker wrote:
> On Wed, 2021-10-13 at 10:46 +0200, Matthias Schiffer wrote:
> > On Wed, 2021-10-13 at 08:25 +0000, Philippe Schenker wrote:
> > > On Tue, 2021-10-12 at 12:34 +0200, Matthias Schiffer wrote:
> > > > It seems reasonable to fine-tune only some of the skew values when
> > > > using
> > > > one of the rgmii-*id PHY modes, and even when all skew values are
> > > > specified, using the correct ID PHY mode makes sense for
> > > > documentation
> > > > purposes. Such a configuration also appears in the binding docs in
> > > > Documentation/devicetree/bindings/net/micrel-ksz90x1.txt, so the
> > > > driver
> > > > should not warn about it.
> > > 
> > > I don't think your commit message is right. The rgmii-*id PHY modes
> > > are
> > > no longer just for documentation purposes on KSZ9031 PHY. They are
> > > used
> > > to set the skew-registers according to .
> > 
> > Yes, this was implemented in [1]. The commit message explicitly states
> > that fine-tuning is still possible using *-skew-ps.
> > 
> > > 
> > > The warning is there, that in case you override the skew registers
> > > of
> > > one of the modes rgmii-id, rgmii-txid, rgmii-rxid with *-skew-ps
> > > settings in DT.
> > 
> > The "rgmii" mode should not be handled differently from "rgmii-*id" in
> > my opinion. Otherwise for a device that is basically "rgmii-id", but
> > requires slight fine-tuning, you have to set the mode to the incorrect
> > value "rgmii" in the DTS to avoid this warning.
> 
> Now I have understood your argument. But then I suggest to delete the
> warning entirely as it completely changes its meaning with that patch.
> 
> Philippe

The KSZ9031 also supports MII and GMII though. I think it makes sense
to keep the warning for these cases (which is why I reworded the
warning the way I did).


> 
> > 
> > 
> > > 
> > > Therefore I also think the warning is valuable and should be kept.
> > > We
> > > may want to reword it though.
> > > 
> > > Philippe
> > 
> > [1]
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/net/phy/micrel.c?id=bcf3440c6dd78bfe5836ec0990fe36d7b4bb7d20
> > 
> > 
> > > 
> > > > 
> > > > Signed-off-by: Matthias Schiffer
> > > > <matthias.schiffer@ew.tq-group.com>
> > > > ---
> > > >  drivers/net/phy/micrel.c | 4 ++--
> > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> > > > index c330a5a9f665..03e58ebf68af 100644
> > > > --- a/drivers/net/phy/micrel.c
> > > > +++ b/drivers/net/phy/micrel.c
> > > > @@ -863,9 +863,9 @@ static int ksz9031_config_init(struct
> > > > phy_device
> > > > *phydev)
> > > >                                 MII_KSZ9031RN_TX_DATA_PAD_SKEW, 4,
> > > >                                 tx_data_skews, 4, &update);
> > > >  
> > > > -               if (update && phydev->interface !=
> > > > PHY_INTERFACE_MODE_RGMII)
> > > > +               if (update && !phy_interface_is_rgmii(phydev))
> > > >                         phydev_warn(phydev,
> > > > -                                   "*-skew-ps values should be
> > > > used
> > > > only with phy-mode = \"rgmii\"\n");
> > > > +                                   "*-skew-ps values should be
> > > > used
> > > > only with RGMII PHY modes\n");
> > > >  
> > > >                 /* Silicon Errata Sheet (DS80000691D or
> > > > DS80000692D):
> > > >                  * When the device links in the 1000BASE-T slave
> > > > mode
> > > > only,
> > > 
> > > 
> 
> 

