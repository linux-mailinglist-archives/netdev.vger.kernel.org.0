Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC8EC2F0339
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 20:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbhAITtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 14:49:02 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59062 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbhAITtB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 14:49:01 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kyKDi-00H9hE-U1; Sat, 09 Jan 2021 20:48:18 +0100
Date:   Sat, 9 Jan 2021 20:48:18 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Zhi Han <z.han@gmx.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] Incorrect filename in drivers/net/phy/Makefile
Message-ID: <X/oIgiad+sSejmtt@lunn.ch>
References: <20210106101712.6360-1-z.han@gmx.net>
 <0d9094e9-5562-8535-98c3-993161aea355@gmail.com>
 <20210109091738.GB25@E480.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210109091738.GB25@E480.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 09, 2021 at 10:17:38AM +0100, Zhi Han wrote:
> Thanks a lot for the .config file.
> I also tested it, with mdio-bus.o in the Makefile, glad to got that there is
> no problem of that, although I don't know the reason/trick yet.

I'm not 100% sure, but i think:

obj-$(CONFIG_MDIO_DEVICE)       += mdio-bus.o

actually refers back to

mdio-bus-y                      += mdio_bus.o mdio_device.o

	Andrew
