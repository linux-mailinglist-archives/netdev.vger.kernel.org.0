Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5671461350
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 12:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242974AbhK2LL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 06:11:57 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:52874 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233362AbhK2LJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 06:09:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1638184000; x=1669720000;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=px9O/Bq5B4DL5jCTNt3L7dJdnR2fEC1xr8C2iqfLWtU=;
  b=bwCDp6gNmzMKX5vAgsJe8BqezpB+96n9TBcOrx5vb2EcNSAoZghf6eq/
   VI/19J+Zk1IHNNZHIE25MphIptaN5KrF01q5PMEP5dqFt1DgG8IPj4IIG
   iWDvGNGK3Tb/cgGywk4q9AhZqnVzdqLZoFMkDN0cRrRjIg+7rFQXvaolY
   ea6O3Hu5qokej34ZPhVX4USFs4wq3h8N2P6jMhFZ0T0kbjXj6XQ8CUUME
   A+Muda6fGIeYYVFtbQuly3UtHZE34PBVJeCtowwRhjqLO9eeyYYYW91Vj
   T2CKm0u4E9P9frvcGg1Ermr7L1cRRZKzy9vsqDmIdtjfneK8iqnzj2din
   A==;
IronPort-SDR: 80zuOpP18NibtUCEZqIRvXSBV++FIA/BG92vVkFxqNwpRKtLQypaupvoZnXrrR3vaWu3v53xUd
 Rwuu3BoD0zEoHGqPO8TzmBg5TSm8Plskqow4bo44/ev3qxCnPw0AuNr89h62laYd8+x6fIeqg3
 F6qzvlff3cGRsiGDvuqSfCFmxJoFd6VKtgku1l1dpQwoh/6V1ZK9XE3mrXZlPFQv4Ne40syZGC
 opn0CJ/I9OSAQQKNB3lq6pNf33Dj438oT5RuItm6+NDvufUk86gSqqRwgUvjKzcIR5wmAgyUyS
 a3LEb/7jL3qyBTIZIn8Nz6/J
X-IronPort-AV: E=Sophos;i="5.87,273,1631602800"; 
   d="scan'208";a="140561184"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Nov 2021 04:06:39 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Mon, 29 Nov 2021 04:06:39 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Mon, 29 Nov 2021 04:06:38 -0700
Date:   Mon, 29 Nov 2021 12:08:34 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <p.zabel@pengutronix.de>,
        <andrew@lunn.ch>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v4 3/6] net: lan966x: add port module support
Message-ID: <20211129110834.yy6wai63vaftnias@soft-dev3-1.localhost>
References: <20211126090540.3550913-1-horatiu.vultur@microchip.com>
 <20211126090540.3550913-4-horatiu.vultur@microchip.com>
 <YaC/OT0f2JKBPMOb@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <YaC/OT0f2JKBPMOb@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/26/2021 11:04, Russell King (Oracle) wrote:
> 
> On Fri, Nov 26, 2021 at 10:05:37AM +0100, Horatiu Vultur wrote:
> > This patch adds support for netdev and phylink in the switch. The
> > injection + extraction is register based. This will be replaced with DMA
> > accees.
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> 
> This looks mostly good now, thanks. There's one remaining issue:

Thanks for the help!

> 
> > +int lan966x_port_pcs_set(struct lan966x_port *port,
> > +                      struct lan966x_port_config *config)
> > +{
> > +     struct lan966x *lan966x = port->lan966x;
> > +     bool inband_aneg = false;
> > +     bool outband;
> > +     int err;
> > +
> > +     lan966x_port_link_down(port);
> 
> This looks like something the MAC layer should be doing. Phylink won't
> change the interface mode by just calling the PCS - it will do this
> sequence, known as a major reconfiguration:
> 
> mac_link_down() (if the link was previously up)
> mac_prepare()
> mac_config()
> if (pcs_config() > 0)
>   pcs_an_restart()
> mac_finish()
> 
> pcs_config() will also be called thusly:
> 
> if (pcs_config() > 0)
>   pcs_an_restart()
> 
> to change the ethtool advertising mask which changes the inband advert
> or the Autoneg bit, which has an effect only on your DEV_PCS1G_ANEG_CFG()
> register, and this may be called with the link up or down.
> 
> Also, pcs_config() is supposed to return 0 if the inband advert has not
> changed, or positive if it has (so pcs_an_restart() is called to cause
> in-band negotiation to be restarted.)
> 
> Note also that pcs_an_restart() may  also be called when ethtool
> requests negotiation restart when we're operating in 802.3z modes.
> 
> So, my question is - do you need to be so heavy weight with the call to
> lan966x_port_link_down() to take everything down when pcs_config() is
> called, and is it really in the right place through the sequence for
> a major reconfiguration?

Thanks for the detail explanation.
You are right, it doesn't look like it is needed to call
lan966x_port_link_down when pcs_config is called.
I can put the lan966x_port_link_down() inside the mac_link_down() callback.

> 
> Thanks.
> 
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

-- 
/Horatiu
