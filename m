Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40AD5315CB7
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 02:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235059AbhBJB6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 20:58:11 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59148 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235225AbhBJB5t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 20:57:49 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l9ekd-005Dpr-KO; Wed, 10 Feb 2021 02:57:07 +0100
Date:   Wed, 10 Feb 2021 02:57:07 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 2/9] net: phy: icplus: use PHY_ID_MATCH_EXACT()
 for IP101A/G
Message-ID: <YCM9c9L/B8iS4IKi@lunn.ch>
References: <20210209164051.18156-1-michael@walle.cc>
 <20210209164051.18156-3-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209164051.18156-3-michael@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 05:40:44PM +0100, Michael Walle wrote:
> According to the datasheet of the IP101A/G there is no revision field
> and MII_PHYSID2 always reads as 0x0c54. Use PHY_ID_MATCH_EXACT() then.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Lets hope the datasheet is correct and up to date, because this could
cause a regression if wrong.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
