Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE97436950F
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 16:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241013AbhDWOuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 10:50:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38158 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229549AbhDWOuE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 10:50:04 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lZx7P-000flm-68; Fri, 23 Apr 2021 16:49:19 +0200
Date:   Fri, 23 Apr 2021 16:49:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Zoltan HERPAI <wigyori@uid0.hu>,
        Raylynn Knight <rayknight@me.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH 1/3 net-next v3] net: ethernet: ixp4xx: Add DT bindings
Message-ID: <YILeb1OyrE0k0PyY@lunn.ch>
References: <20210423082208.2244803-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210423082208.2244803-1-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 23, 2021 at 10:22:06AM +0200, Linus Walleij wrote:
> This adds device tree bindings for the IXP4xx ethernet
> controller with optional MDIO bridge.

Hi Linus

That optional MDIO bus sentence is important here. I think it would be
good to give examples for say IXP43x, where the MDIO bus is on NPE-C,
and the phy-handles point from one Ethernet device in the device tree
to the other. It is not unknown, but it is unusual, so giving an
example is good.

Also, looking at the unmodified driver, there is the global variable
mdio_bus. This should contain the one MDIO bus for the cluster. With
the C code, it should be impossible for multiple devices to
instantiate an MDIO bus. But with device tree, is that still true?
Should there be validation that only one device has an MDIO bus in its
device tree?

       Andrew
