Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDCC0443A63
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 01:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbhKCAaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 20:30:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44248 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229804AbhKCAaP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 20:30:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=TOx+tLGxVuHGdt7/IA8a5LYgGnGV+ES3Sguz6hIKwEs=; b=gxQ2AV+dHEkZ8dgo5D2vUdaZes
        ub5xPiUZXwhBQMzEEfC4yjTc/4tX7cFj7XK3n411iYeJggapt5FedkZC+5vGLzTqR5FbO+DSh10Ed
        8M4HQ9k+pdIfPYkLlk/haNvWr4eQPY9PMxgkWjgLBmGruKfEl294kLOf385StXWUsoik=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mi47n-00CS64-5x; Wed, 03 Nov 2021 01:27:31 +0100
Date:   Wed, 3 Nov 2021 01:27:31 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org, Vignesh Raghavendra <vigneshr@ti.com>
Subject: Re: [RFC PATCH] net: phy/mdio: enable mmd indirect access through
 phy_mii_ioctl()
Message-ID: <YYHXcyCOPiUkk8Tz@lunn.ch>
References: <YYBBHsFEwGdPJw3b@lunn.ch>
 <YYBF3IZoSN6/O6AL@shell.armlinux.org.uk>
 <YYCLJnY52MoYfxD8@lunn.ch>
 <YYExmHYW49jOjfOt@shell.armlinux.org.uk>
 <bc9df441-49bf-5c8a-891c-cc3f0db00aba@ti.com>
 <YYF4ZQHqc1jJsE/+@shell.armlinux.org.uk>
 <e18f17bd-9e77-d3ef-cc1e-30adccb7cdd5@ti.com>
 <828e2d69-be15-fe69-48d8-9cfc29c4e76e@ti.com>
 <YYGxvomL/0tiPzvV@lunn.ch>
 <8d24c421-064c-9fee-577a-cbbf089cdf33@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d24c421-064c-9fee-577a-cbbf089cdf33@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > What i find interesting is that you and the other resent requester are
> > using the same user space tool. If you implement C45 over C22 in that
> > tool, you get your solution, and it will work for older kernels as
> > well. Also, given the diverse implementations of this IOTCL, it
> > probably works for more drivers than just those using phy_mii_ioctl().
> 
> Do you mean change uapi, like
>  add mdio_phy_id_is_c45_over_c22() and
>  flag #define MDIO_PHY_ID_C45_OVER_C22 0x4000?

No, i mean user space implements C45 over C22. Make phytool write
MII_MMD_CTRL and MII_MMD_DATA to perform a C45 over C22.

	     Andrew
