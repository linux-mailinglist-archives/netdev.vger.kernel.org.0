Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1CCA45F587
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 20:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237248AbhKZT4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 14:56:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231942AbhKZTx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 14:53:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB56BC061D63;
        Fri, 26 Nov 2021 11:34:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BD8962346;
        Fri, 26 Nov 2021 19:34:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71224C9305B;
        Fri, 26 Nov 2021 19:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637955294;
        bh=N9aA0eu5MMmJxiq8ygVUF3Cp3I6S2rsTKe45E1ABP/c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YM84d47UfTGUQhkROLjBwmu2L/B0sJIG1+2oYx4qFjAmqb2Im1hQiAgvEh1cr/uiZ
         s6NpMjHcrvM08rdO8XYQFoKek2Y/p2fNg7uEbh3UFC5WiWk1Y6CPnxOK6i2LEkWtAO
         cM/CNU9XSmVKdaLjUqTRo+n7sAR8eqWTNFJxFeooBg0JnvqXxGtP9rTsz7a4qrrKcn
         oU5prI1vrsiaxW5I+M0XfbmiaUhk0wEqOrYS6rplTl5M7GNRwr82ufA0t7loolLxKx
         AFKrp8RAFCxQO2DT9914MhNuBg3rBTn8moj3bbFJk/QryXZtjeWrUHoqykkclBwBNt
         AaMbJq7CaBR0g==
Date:   Fri, 26 Nov 2021 11:34:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Sven Schuchmann <schuchmann@schleissheimer.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: usb: lan78xx: lan78xx_phy_init(): use PHY_POLL
 instead of "0" if no IRQ is available
Message-ID: <20211126113440.5463ff74@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YaED/p7O0iYQF6bW@lunn.ch>
References: <20211126152040.29058-1-schuchmann@schleissheimer.de>
        <YaED/p7O0iYQF6bW@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Nov 2021 16:57:50 +0100 Andrew Lunn wrote:
> On Fri, Nov 26, 2021 at 04:20:40PM +0100, Sven Schuchmann wrote:
> > On most systems request for IRQ 0 will fail, phylib will print an error message
> > and fall back to polling. To fix this set the phydev->irq to PHY_POLL if no IRQ
> > is available.
> > 
> > Signed-off-by: Sven Schuchmann <schuchmann@schleissheimer.de>  
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Fixes: cc89c323a30e ("lan78xx: Use irq_domain for phy interrupt from USB Int. EP")

right?
