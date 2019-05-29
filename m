Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 577192E8A8
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 01:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfE2XDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 19:03:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40284 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbfE2XDm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 19:03:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=g3dIPaHOm9Yirjunzdr4EeMbY8yeAgg4qL2WO6u+NKc=; b=iz5I6M7+gVI+X8TxAY6IUt4tuC
        ATumOgL3/y+VeeZx/8MuZRLlHxXe+vo3WjcGnHF43bZINAthYmqAqhmubZj9CkCTvu00NVXneJGu2
        wh/vzFhKWZidt2F9jHJk7ZX+KoLI4boppsXR68OAbzAFNv9tILi4GOKpEQFuhVedyIFA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hW7bY-0002wo-GM; Thu, 30 May 2019 01:03:32 +0200
Date:   Thu, 30 May 2019 01:03:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "lkp@01.org" <lkp@01.org>,
        kernel test robot <rong.a.chen@intel.com>
Subject: Re: [net] 9dd6d07682: kernel_BUG_at_drivers/net/phy/mdio_bus.c
Message-ID: <20190529230332.GC18059@lunn.ch>
References: <1558992127-26008-11-git-send-email-ioana.ciornei@nxp.com>
 <20190529023557.GA22325@shao2-debian>
 <VI1PR0402MB2800068E2D6880BE1930DE53E01F0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
 <20190529162527.kuunt5gxif6wvhoo@shell.armlinux.org.uk>
 <VI1PR0402MB28000F3C6A070321299AA57EE01F0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB28000F3C6A070321299AA57EE01F0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>     phydev = dsa_port_get_phy_device(dp);
>     if (!phydev)
>           return 0;
> 
> I don't see how this method is sane either.

If i remember correctly, the thinking was, you can get away without
the PHY, at least during bring up of a new switch/board. So don't
consider this a fatal error. Now that it is fatal, in the sense of an
Opps, maybe we should change this.

      Andrew
