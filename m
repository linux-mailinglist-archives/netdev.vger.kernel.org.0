Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E716936A3B7
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 02:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhDYAkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Apr 2021 20:40:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39594 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230079AbhDYAkB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Apr 2021 20:40:01 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1laSns-000tVG-Cq; Sun, 25 Apr 2021 02:39:16 +0200
Date:   Sun, 25 Apr 2021 02:39:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Zoltan HERPAI <wigyori@uid0.hu>,
        Raylynn Knight <rayknight@me.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH 1/3 net-next v4] net: ethernet: ixp4xx: Add DT bindings
Message-ID: <YIS6NO+wGhgICmvz@lunn.ch>
References: <20210425003038.2937498-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210425003038.2937498-1-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 25, 2021 at 02:30:36AM +0200, Linus Walleij wrote:
> This adds device tree bindings for the IXP4xx ethernet
> controller with optional MDIO bridge.
> 
> Cc: Zoltan HERPAI <wigyori@uid0.hu>
> Cc: Raylynn Knight <rayknight@me.com>
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

I'm not a YAML guy, but this looks O.K. to me.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
