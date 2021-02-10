Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB06831715B
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 21:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233250AbhBJU21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 15:28:27 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:33248 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233131AbhBJU2U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 15:28:20 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l9w5E-005OFt-BE; Wed, 10 Feb 2021 21:27:32 +0100
Date:   Wed, 10 Feb 2021 21:27:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 7/9] net: phy: icplus: select page before
 writing control register
Message-ID: <YCRBtK8Z+fAi2Sr9@lunn.ch>
References: <20210209164051.18156-1-michael@walle.cc>
 <20210209164051.18156-8-michael@walle.cc>
 <d5672062-c619-02a4-3bbe-dad44371331d@gmail.com>
 <20210210103059.GR1463@shell.armlinux.org.uk>
 <d35f726f82c6c743519f3d8a36037dfa@walle.cc>
 <20210210104900.GS1463@shell.armlinux.org.uk>
 <3a9716ffafc632d2963d3eee673fb0b1@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a9716ffafc632d2963d3eee673fb0b1@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I guess it boils down to: how hard should we try to get the driver
> behave correctly if the user is changing registers.

All bets are off if root starts messing with the PHY state from
userspace. Its a foot gun, don't be surprised with what happens when
you use it.

    Andrew
