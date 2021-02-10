Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2EE9315CD2
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 03:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233728AbhBJCDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 21:03:41 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59194 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235297AbhBJCDI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 21:03:08 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l9epn-005Dvz-1n; Wed, 10 Feb 2021 03:02:27 +0100
Date:   Wed, 10 Feb 2021 03:02:27 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 4/9] net: phy: icplus: use the .soft_reset() of
 the phy-core
Message-ID: <YCM+sw5p37XGayii@lunn.ch>
References: <20210209164051.18156-1-michael@walle.cc>
 <20210209164051.18156-5-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209164051.18156-5-michael@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 05:40:46PM +0100, Michael Walle wrote:
> The PHY core already resets the PHY before .config_init() if a
> .soft_reset() op is registered. Drop the open-coded ip1xx_reset().
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
