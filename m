Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 700CA253443
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 18:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbgHZQDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 12:03:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53116 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726990AbgHZQCi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Aug 2020 12:02:38 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kAxsY-00Bxyy-Vd; Wed, 26 Aug 2020 18:02:26 +0200
Date:   Wed, 26 Aug 2020 18:02:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukasz Stelmach <l.stelmach@samsung.com>
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, m.szyprowski@samsung.com,
        b.zolnierkie@samsung.com
Subject: Re: [PATCH 1/3] net: ax88796c: ASIX AX88796C SPI Ethernet Adapter
 Driver
Message-ID: <20200826160226.GU2403519@lunn.ch>
References: <20200825184413.GA2693@kozik-lap>
 <CGME20200826145929eucas1p1367c260edb8fa003869de1da527039c0@eucas1p1.samsung.com>
 <dleftja6yhv4g2.fsf%l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dleftja6yhv4g2.fsf%l.stelmach@samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> +module_param(comp, int, 0);
> >> +MODULE_PARM_DESC(comp, "0=Non-Compression Mode, 1=Compression Mode");
> >> +
> >> +module_param(ps_level, int, 0);
> >> +MODULE_PARM_DESC(ps_level,
> >> +	"Power Saving Level (0:disable 1:level 1 2:level 2)");
> >> +
> >> +module_param(msg_enable, int, 0);
> >> +MODULE_PARM_DESC(msg_enable, "Message mask (see linux/netdevice.h for bitmap)");
> >> +
> >> +static char *macaddr;
> >> +module_param(macaddr, charp, 0);
> >> +MODULE_PARM_DESC(macaddr, "MAC address");
> >
> > I think MAC address as param is not accepted in mainline...
> >
> 
> $ git grep MODULE_PARM_DESC\(macaddr -- drivers/net | wc -l
> 6

Yes, they exist. But still it is considered back practice, don't do
it, use device tree for MAC addresses. 

    Andrew
