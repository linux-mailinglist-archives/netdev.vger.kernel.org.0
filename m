Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFE8336948E
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 16:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240985AbhDWOZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 10:25:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38096 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230520AbhDWOZC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 10:25:02 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lZwjH-000fYe-T5; Fri, 23 Apr 2021 16:24:23 +0200
Date:   Fri, 23 Apr 2021 16:24:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH 2/3 net-next v3] net: ethernet: ixp4xx: Retire ancient
 phy retrieveal
Message-ID: <YILYl9ntSpWxojk7@lunn.ch>
References: <20210423082208.2244803-1-linus.walleij@linaro.org>
 <20210423082208.2244803-2-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210423082208.2244803-2-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 23, 2021 at 10:22:07AM +0200, Linus Walleij wrote:
> This driver was using a really dated way of obtaining the
> phy by printing a string and using it with phy_connect().
> Switch to using more reasonable modern interfaces.
> 
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
