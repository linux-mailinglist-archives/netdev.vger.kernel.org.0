Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41F551C4B2C
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 02:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgEEAzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 20:55:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41476 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726421AbgEEAzT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 May 2020 20:55:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ATaDU5Uh3wWYX3CbqGQu7PdKooMxCE1g0tP+0PVJxf0=; b=Zua0yh1YEBTJIH/JiKi/sPr3ZZ
        idmI8vu4/tECTebEWckIYSGutDHQF6FMpeKXxtcmi2f0luCHJuSTlcYdLw6j8dbI02fVymg11yb1l
        tx7Vbp6uJpAcpuiXKz0lMmmXu1JROjnhGN7rt8uSYOwEhy3sg19zBZsAs1Vh2dcjghbg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jVlrf-000sVW-QS; Tue, 05 May 2020 02:55:15 +0200
Date:   Tue, 5 May 2020 02:55:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Subject: Re: [PATCH net-next v2 1/3] net: phy: add concept of shared storage
 for PHYs
Message-ID: <20200505005515.GC208718@lunn.ch>
References: <20200504213136.26458-1-michael@walle.cc>
 <20200504213136.26458-2-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200504213136.26458-2-michael@walle.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 04, 2020 at 11:31:34PM +0200, Michael Walle wrote:
> There are packages which contain multiple PHY devices, eg. a quad PHY
> transceiver. Provide functions to allocate and free shared storage.
> 
> Usually, a quad PHY contains global registers, which don't belong to any
> PHY. Provide convenience functions to access these registers.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
