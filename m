Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 152EB3EEE90
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 16:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240111AbhHQOdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 10:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbhHQOdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 10:33:15 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87974C061764;
        Tue, 17 Aug 2021 07:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=t/NXf9hT3CA3cgqqrDKe+AlO6SB+5k2V3RXFtkOYbQ4=; b=tFa5ruuG7pDnJXirBSeaSbbB7
        ISPMhWeZ2GDmjqUZ7mw4NRIux3pX9q43H0ZOG2oEXJn1vikWjfB4xnDd0xB+31N+aApZr3i1UYmVg
        0CAydK3XxfF8DLg7eUhIJU4f2tRFGL+758MyGAROypwKGm/TZublfeeGzqOBxCl13Lp7q/3OCdk6i
        xdByCkAR63aNNFTIAKN1BxekIVOVKRAqWomqMERsPsDdvqeANbCON7Z35y4CrTnBuP7CcbuGWofc6
        7+YAvPALTkSJ+522WUi6Vijxqi/ftUIe+TpWq7GGh6LajOCaWKxwt2k2ohn1AKv5g315+1IcBDjTC
        D2aKHxBXg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47404)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mG08i-0001VN-04; Tue, 17 Aug 2021 15:32:28 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mG08g-0000Yp-RP; Tue, 17 Aug 2021 15:32:26 +0100
Date:   Tue, 17 Aug 2021 15:32:26 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jie Luo <luoj@codeaurora.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, hkallweit1@gmail.com,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, sricharan@codeaurora.org
Subject: Re: [PATCH] net: phy: add qca8081 ethernet phy driver
Message-ID: <20210817143226.GL22278@shell.armlinux.org.uk>
References: <20210816113440.22290-1-luoj@codeaurora.org>
 <YRpuhIcwN2IsaHzy@lunn.ch>
 <6856a839-0fa0-1240-47cd-ae8536294bcd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6856a839-0fa0-1240-47cd-ae8536294bcd@codeaurora.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 17, 2021 at 09:10:44PM +0800, Jie Luo wrote:
> 
> On 8/16/2021 9:56 PM, Andrew Lunn wrote:
> > On Mon, Aug 16, 2021 at 07:34:40PM +0800, Luo Jie wrote:
> > > qca8081 is industry’s lowest cost and power 1-port 2.5G/1G Ethernet PHY
> > > chip, which implements SGMII/SGMII+ for interface to SoC.
> > Hi Luo
> > 
> > No Marketing claims in the commit message please. Even if it is
> > correct now, it will soon be wrong with newer generations of
> > devices.
> > 
> > And what is SGMII+? Please reference a document. Is it actually
> > 2500BaseX?
> 
> Hi Andrew,
> 
> thanks for the comments, will remove the claims in the next patch.
> 
> SGMII+ is for 2500BaseX, which is same as SGMII, but the clock frequency of
> SGMII+ is 2.5 times SGMII.

Bah. Sounds like more industry wide misunderstanding of what SGMII
vs 1000Base-X is to me... or just plain abuse of the term "SGMII"!

I think you'll find that "SGMII+" is nothing but a term Qualcomm use
to refer to 2500BASE-X without the 16-bit in-band control word to
the host.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
