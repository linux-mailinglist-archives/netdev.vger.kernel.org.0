Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55F242CC54D
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 19:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbgLBSgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 13:36:13 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34666 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbgLBSgN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 13:36:13 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kkWyR-009uDz-FR; Wed, 02 Dec 2020 19:35:31 +0100
Date:   Wed, 2 Dec 2020 19:35:31 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Grant Edwards <grant.b.edwards@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: net: macb: fail when there's no PHY
Message-ID: <20201202183531.GJ2324545@lunn.ch>
References: <20170921195905.GA29873@grante>
 <66c0a032-4d20-69f1-deb4-6c65af6ec740@gmail.com>
 <CAK=1mW6Gti0QpUjirB6PfMCiQvnDjkbb56pVKkQmpCSkRU6wtA@mail.gmail.com>
 <6a9c1d4a-ed73-3074-f9fa-158c697c7bfe@gmail.com>
 <X8fb4zGoxcS6gFsc@grante>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X8fb4zGoxcS6gFsc@grante>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> When using the SIOC[SG]MIIREG ioctl() call, how does one control
> whether the fake fixed-link bus is accessed or the real macb-mdio bus
> is accessed?

As far as i remember, that ioctl is based on the interface name. So it
will access the MDIO bus of the PHY that is attached to the MAC.

I guess you have user space drivers using the IOCTL to access devices
on the real bus? A switch? Can you swap to a DSA driver?

> How does the macb driver decide which bus/id combination to use as
> "the phy" that controls the link duplex/speed settting the the MAC?

phy-handle points to a PHY.

	   Andrew
