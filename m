Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8D72A829F
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 16:49:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731315AbgKEPtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 10:49:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731133AbgKEPtj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 10:49:39 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65091C0613CF;
        Thu,  5 Nov 2020 07:49:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=qEnlfxKf6HytKLFOxZiI2nMmQQBkZmroWP4YwPxehjk=; b=xYu0g69dh2tsGaTk698clYo9m
        gTIox8LMPPwctLdOcYsU+5EN4EKs8SOTgPCd50X4Go8Ks75q5VYWiVMcvMT3Ka5kvc35AjlkSVkTt
        v5+b66GmOEtFtuIYDm8l6GZdo1Fc3Ym+vYqD9Yt7NKvn7Q7gMG1lw6amdyH1zt6bV4KNjY+w6X5e4
        A1f6CNuEfDI7CX8DmYhz44crEgpGYx1ev0QlJcL8/7yvIJ1aMVnclm/617eDOjqLMAIGsNojbjYUZ
        0yVw73EOAnG3F5Fbh/LiG5/1y+rPVfDT2HZ7m4g1IcCwgyCfTFv+CwkL72eX0Ca3ig6mw9xsvnFnV
        deYSjti2w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55416)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kahVV-0004k5-Ou; Thu, 05 Nov 2020 15:49:01 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kahVQ-0004uV-V4; Thu, 05 Nov 2020 15:48:56 +0000
Date:   Thu, 5 Nov 2020 15:48:56 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Nicolas Ferre <nicolas.ferre@microchip.com>
Cc:     Parshuram Thombare <pthombar@cadence.com>, kuba@kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Claudiu.Beznea@microchip.com, Santiago.Esteban@microchip.com,
        andrew@lunn.ch, davem@davemloft.net, linux-kernel@vger.kernel.org,
        harini.katakam@xilinx.com, michal.simek@xilinx.com
Subject: Re: [PATCH] net: macb: fix NULL dereference due to no pcs_config
 method
Message-ID: <20201105154856.GN1551@shell.armlinux.org.uk>
References: <1604587039-5646-1-git-send-email-pthombar@cadence.com>
 <6873cf12-456b-c121-037b-d2c5a6138cb3@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6873cf12-456b-c121-037b-d2c5a6138cb3@microchip.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 05, 2020 at 04:22:18PM +0100, Nicolas Ferre wrote:
> On 05/11/2020 at 15:37, Parshuram Thombare wrote:
> > This patch fixes NULL pointer dereference due to NULL pcs_config
> > in pcs_ops.
> > 
> > Fixes: e4e143e26ce8 ("net: macb: add support for high speed interface")
> 
> What is this tag? In linux-next? As patch is not yet in Linus' tree, you
> cannot refer to it like this.
> 
> > Reported-by: Nicolas Ferre <Nicolas.Ferre@microchip.com>
> > Link: https://lkml.org/lkml/2020/11/4/482
> 
> You might need to change this to a "lore" link:
> https://lore.kernel.org/netdev/2db854c7-9ffb-328a-f346-f68982723d29@microchip.com/
> 
> > Signed-off-by: Parshuram Thombare <pthombar@cadence.com>
> 
> This fix looks a bit weird to me. What about proposing a patch to Russell
> like the chunk that you already identified in function
> phylink_major_config()?

No thanks. macb is currently the only case where a stub implementation
for pcs_config() is required, which only occurs because the only
appropriate protocol supported there is SGMII and not 1000base-X as
well.

> > ---
> >   drivers/net/ethernet/cadence/macb_main.c | 17 +++++++++++++++--
> >   1 file changed, 15 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> > index b7bc160..130a5af 100644
> > --- a/drivers/net/ethernet/cadence/macb_main.c
> > +++ b/drivers/net/ethernet/cadence/macb_main.c
> > @@ -633,6 +633,15 @@ static void macb_pcs_an_restart(struct phylink_pcs *pcs)
> >          /* Not supported */
> >   }
> > 
> > +static int macb_pcs_config(struct phylink_pcs *pcs,
> > +                          unsigned int mode,
> > +                          phy_interface_t interface,
> > +                          const unsigned long *advertising,
> > +                          bool permit_pause_to_mac)
> > +{
> > +       return 0;
> > +}
> 
> Russell, is the requirement for this void function intended?

In response to v3 of the patch on 21st October, I said, and I quote:

  I think all that needs to happen is a pcs_ops for the non-10GBASE-R
  mode which moves macb_mac_pcs_get_state() and macb_mac_an_restart()
  to it, and implements a stub pcs_config(). So it should be simple
  to do.

Obviously, my advice was not followed, I didn't spot the lack of it
in v4 (sorry), and the result is the NULL pointer oops.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
