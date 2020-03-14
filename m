Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 739A8185825
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 02:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727714AbgCOByv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 21:54:51 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36040 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727703AbgCOByu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Mar 2020 21:54:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pTTnYgLOnVCGWTOw+byVvcEU2YGJK2NZSzlcHTlsL7o=; b=RMBvYMTxTgfkNC23+LmXLj/lla
        kelpBDacRemQJeLXHcVOlcVpRCiwSgVKEEnVW2Xvh0IhTzRK2EVbAQf1lGPbFQeMiz47yRIUVxAUM
        qCaTJFRmo2Ji1irwBlXFK0baW85fc+BDPiOWbboMU2DAUDi+oOQqqgGhTenaEatTiXAU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jDBYW-0001Z2-PY; Sat, 14 Mar 2020 19:30:40 +0100
Date:   Sat, 14 Mar 2020 19:30:40 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: mii: convert
 mii_lpa_to_ethtool_lpa_x() to linkmode variant
Message-ID: <20200314183040.GB5388@lunn.ch>
References: <20200314100916.GE25745@shell.armlinux.org.uk>
 <E1jD3jt-000664-PK@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1jD3jt-000664-PK@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 14, 2020 at 10:09:53AM +0000, Russell King wrote:
> Add a LPA to linkmode decoder for 1000BASE-X protocols; this decoder
> only provides the modify semantics similar to other such decoders.
> This replaces the unused mii_lpa_to_ethtool_lpa_x() helper.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
