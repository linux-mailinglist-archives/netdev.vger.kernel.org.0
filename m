Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFCA418BA5D
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 16:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbgCSPG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 11:06:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45260 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727183AbgCSPG6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 11:06:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3DvunhSyQHRaZjV0LfeT42iyChJCmq7DqlZQEUaWdsQ=; b=x3fTtLuLlRb9DLpuvaPKjFsJoc
        XWlwaygWgiip9x2pm14+Z1Th5c1SYXvEJtwWKm0OObboetH2GTsaoOq2C3dPi7aEYRA0gI9eWKenP
        +vxS6u92FvxLT0vv/5n39v4RW4fF1XR162VfJp17UY0OaGJOzRb1F2lWtesBBQd+A2MA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jEwl2-0007G5-Np; Thu, 19 Mar 2020 16:06:52 +0100
Date:   Thu, 19 Mar 2020 16:06:52 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [RFC net-next 2/5] net: phylink: add separate pcs operations
 structure
Message-ID: <20200319150652.GA27807@lunn.ch>
References: <20200317144944.GP25745@shell.armlinux.org.uk>
 <E1jEDaN-0008JH-MY@rmk-PC.armlinux.org.uk>
 <20200317163802.GZ24270@lunn.ch>
 <20200317165422.GU25745@shell.armlinux.org.uk>
 <20200319121418.GJ5827@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319121418.GJ5827@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Oh, I forgot to mention on the library point - that's what has already
> been created in:
> 
> "net: phylink: pcs: add 802.3 clause 45 helpers"
> "net: phylink: pcs: add 802.3 clause 22 helpers"
> 
> which add library implementations for the pcs_get_state(), pcs_config()
> and pcs_an_restart() methods.
> 
> What remains is vendor specific - for pcs_link_up(), there is no
> standard, since it requires fiddling with vendor specific registers to
> program, e.g. the speed in SGMII mode when in-band is not being used.
> The selection between different PCS is also vendor specific.
> 
> It would have been nice to use these helpers for Marvell DSA switches
> too, but the complexities of DSA taking a multi-layered approach rather
> than a library approach, plus the use of paging makes it very
> difficult.
> 
> So, basically on the library point, "already considered and
> implemented".

Hi Russell

The 6390X family of switches has two PCSs, one for 1000BaseX/SGMII and
a second one for 10GBaseR. So at some point there is going to be a
mux, but maybe it will be internal to mv88e6xxx and not shareable. Or
internal to DSA, and shareable between DSA drivers. We will see.

     Andrew
