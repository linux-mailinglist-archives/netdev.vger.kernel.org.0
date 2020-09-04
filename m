Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8936D25DB1A
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 16:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730777AbgIDONO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 10:13:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43074 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730757AbgIDOND (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 10:13:03 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kEBpB-00DCNS-G7; Fri, 04 Sep 2020 15:32:17 +0200
Date:   Fri, 4 Sep 2020 15:32:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Mickey Rachamim <mickeyr@marvell.com>
Subject: Re: [PATCH net v6 1/6] net: marvell: prestera: Add driver for
 Prestera family ASIC devices
Message-ID: <20200904133217.GJ3112546@lunn.ch>
References: <20200902150442.2779-1-vadym.kochan@plvision.eu>
 <20200902150442.2779-2-vadym.kochan@plvision.eu>
 <CA+FuTSfMRhEZ5c2CWaN_F3ASDgvV7eQ4q6zVuY-FvgLqsqYecw@mail.gmail.com>
 <20200904093252.GA10654@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200904093252.GA10654@plvision.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +static int prestera_is_valid_mac_addr(struct prestera_port *port, u8 *addr)
> > > +{
> > > +       if (!is_valid_ether_addr(addr))
> > > +               return -EADDRNOTAVAIL;
> > > +
> > > +       if (memcmp(port->sw->base_mac, addr, ETH_ALEN - 1))
> > 
> > Why ETH_ALEN - 1?
> > 
> This is the restriction of the port mac address, it must have base mac
> address part at first 5 bytes.

You probably want to put a comment here about that.

And this is particularly user unfriendly. Is this a hardware issue? Or
firmware? Is this likely to change in the future?

	  Andrew
