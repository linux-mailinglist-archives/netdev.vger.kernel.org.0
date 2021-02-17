Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7E231D432
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 04:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbhBQDUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 22:20:39 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45204 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229796AbhBQDUi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 22:20:38 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lCDNa-006nxv-L5; Wed, 17 Feb 2021 04:19:54 +0100
Date:   Wed, 17 Feb 2021 04:19:54 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Nathan Rossi <nathan@nathanrossi.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        Nathan Rossi <nathan.rossi@digi.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] of: of_mdio: Handle properties for non-phy mdio devices
Message-ID: <YCyLWhk5zV4Z5Crv@lunn.ch>
References: <20210215070218.1188903-1-nathan@nathanrossi.com>
 <YCvDVEvBU5wabIx7@lunn.ch>
 <55c94cf4-f660-f0f5-fb04-f51f4d175f53@gmail.com>
 <CA+aJhH3SE1s8P+srhO_-Za3E0KdHVn2_bK=Kf+-Jtbm1vJNm1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+aJhH3SE1s8P+srhO_-Za3E0KdHVn2_bK=Kf+-Jtbm1vJNm1w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > The patch does make sense though, Broadcom 53125 switches have a broken
> > turn around and are mdio_device instances, the broken behavior may not
> > show up with all MDIO controllers used to interface though. For the
> 
> Yes the reason we needed this change was to enable broken turn around,
> specifically with a Marvell 88E6390.

Ah, odd. I've never had problems with the 6390, either connected to a
Freecale FEC, or the Linux bit banging MDIO bus.

What are you using for an MDIO bus controller? Did it already support
broken turn around, or did you need to add it?

       Andrew
