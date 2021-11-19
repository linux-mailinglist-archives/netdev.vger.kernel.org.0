Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE4F456BD7
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 09:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234464AbhKSIuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 03:50:23 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:17487 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbhKSIuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 03:50:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1637311639; x=1668847639;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5kcHApZk+ywaaFYN2hC9iqX8vhCmRFBvCWl222E/+FI=;
  b=F10xWAt7SU83JX9A0d+8kdbKs1OkhOCYUCR9ZT2komF7tsOSElvIzcTJ
   CM7O2eCwL7AaJPWjfMC12AvJ+RxNIFGFj/D5IJM4xZT04zZIYvFaObIEe
   UnR9K+5w4n2zQG7H5Gm5PIlm34LGpw/fwLdKP0eWUADkDVs56yTeH3CfH
   o9O4oBCATrgmbsscmjTIL0FrUyBU0NzLfnU1ck2VkSfFZpnftxuRZiw21
   s3SD03ZThFo2E58JVOyBxG5utVG9n2qi7XxeLcsyz1aQVZU25/CxYvnly
   4U+Sb6AAZ/er2Gd0+RV25pQVRkdDw5LPteFvj3RjqEN5/N+411Eov0SB0
   A==;
IronPort-SDR: 4ew9yvnm78cp96fbZS5lwNOtBh72D/9gAnM5hCZ64EeOSVb3JocUndm2rmeYaG6OZTl4pL4HQY
 XEuVaWx2FYiCbZ/8Hj2RGpXrNmbOBgc9a2ZvVz/+KA51LR+W1+auHxTEiC5W3aW9rFKbc2Esma
 oftKYTAMR/1OTSrEx4EUcxg4HKNNCTkl5AAna1fxJxpn1w+vMBS3ee9cx3SqtYZSn3qOatcXW8
 /PV2Z+Up4sZrtEhrYQDShMi3pHSvVloXSfVb1UTOlz0ithpRcIbVWueC/JQ4dBKSMJWRCeGWlx
 ZnRAX0eOZCGAxOHJ7fsyHiW8
X-IronPort-AV: E=Sophos;i="5.87,246,1631602800"; 
   d="scan'208";a="139692921"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Nov 2021 01:47:18 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 19 Nov 2021 01:47:17 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Fri, 19 Nov 2021 01:47:17 -0700
Date:   Fri, 19 Nov 2021 09:49:05 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Sean Anderson <sean.anderson@seco.com>
CC:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <p.zabel@pengutronix.de>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 3/5] net: lan966x: add port module support
Message-ID: <20211119084905.u2orewcwuge6oani@soft-dev3-1.localhost>
References: <20211117091858.1971414-1-horatiu.vultur@microchip.com>
 <20211117091858.1971414-4-horatiu.vultur@microchip.com>
 <YZTRUfvPPu5qf7mE@shell.armlinux.org.uk>
 <20211118095703.owsb2nen5hb5vjz2@soft-dev3-1.localhost>
 <YZYj9fwCeWdIZJOt@shell.armlinux.org.uk>
 <20211118125928.tav7k5xlbnhrgp3o@soft-dev3-1.localhost>
 <YZZVn6jve4BvSqyX@shell.armlinux.org.uk>
 <e973b8e6-f8ca-eec9-f5ac-9ae401deea81@seco.com>
 <YZZ7KwKw8i6EPcFL@shell.armlinux.org.uk>
 <5768b2bb-b417-0ea8-5d80-3e8872ee9ad3@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <5768b2bb-b417-0ea8-5d80-3e8872ee9ad3@seco.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sean,

The 11/18/2021 11:18, Sean Anderson wrote:
> 
> On 11/18/21 11:11 AM, Russell King (Oracle) wrote:
> > On Thu, Nov 18, 2021 at 10:36:58AM -0500, Sean Anderson wrote:
> > > Hi Russell,
> > > 
> > > On 11/18/21 8:31 AM, Russell King (Oracle) wrote:
> > > > On Thu, Nov 18, 2021 at 01:59:28PM +0100, Horatiu Vultur wrote:
> > > > > The 11/18/2021 09:59, Russell King (Oracle) wrote:
> > > > > > Another approach would be to split phylink_mii_c22_pcs_decode_state()
> > > > > > so that the appropriate decode function is selected depending on the
> > > > > > interface state, which may be a better idea.
> > > > >
> > > > > I have tried to look for phylink_mii_c22_pcs_decode_state() and I
> > > > > have found it only here [1], and seems that it depends on [2]. But not
> > > > > much activity happened to these series since October.
> > > > > Do you think they will still get in?
> > > >
> > > > I don't see any reason the first two patches should not be sent. I'm
> > > > carrying the second one locally because I use it in some changes I've
> > > > made to the mv88e6xxx code - as I mentioned in the patchwork entry you
> > > > linked to. See:
> > > >
> > > >   http://git.armlinux.org.uk/cgit/linux-arm.git/log/?h=net-queue
> > > >
> > > >   "net: phylink: Add helpers for c22 registers without MDIO"
> > > >
> > > > Although I notice I committed it to my tree with the wrong author. :(
> > > >
> > > > Sean, please can you submit the mdiodev patch and this patch for
> > > > net-next as they have general utility? Thanks.
> > > 
> > > The mdiodev patch is already in the tree as 0ebecb2644c8 ("net: mdio:
> > > Add helper functions for accessing MDIO devices"). The c22 patch is
> > > submitted as [1].
> > > 
> > > --Sean
> > > 
> > > [1] https://lore.kernel.org/netdev/20211022160959.3350916-1-sean.anderson@seco.com/
> > 
> > Patchwork says its deferrred:
> > 
> > https://patchwork.kernel.org/project/netdevbpf/patch/20211022160959.3350916-1-sean.anderson@seco.com/
> > 
> > However, it does apply to current net-next, but Jakub did ask for
> > it to be resubmitted.
> 
> Well, he suggested that I would have to resubmit it. But I ordered the
> patches such that they would apply cleanly in what I thought was the
> most likely scenario (which indeed come to pass). So I didn't think it
> was necessary to resend.
> 
> > Given that patches are being quickly applied to net-next, I suggest
> > resubmission may be just what's neeeded!
> 
> Resent.

Thanks for resubmission the patch!
Unfortunately, your patch introduced a new warning, so it got in
the state "Changes Required". So I think you will need to send a new
version.

[1] https://patchwork.kernel.org/project/netdevbpf/patch/20211118161430.2547168-1-sean.anderson@seco.com/

> 
> --Sean

-- 
/Horatiu
