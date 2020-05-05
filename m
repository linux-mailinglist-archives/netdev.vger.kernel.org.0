Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B70191C4B1A
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 02:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbgEEAjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 20:39:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41448 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726531AbgEEAjE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 May 2020 20:39:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=zMFD/1W3giR0m2xyej1RWginytW3yCvgYp5u+GbUTK0=; b=lOLjMYEhxizHLF7wVN5J544+JJ
        mC+PvqB/dA1+5/GTouEgjUhLJU4foGel9fHeaL+/mp2g7nJtMxzrcsFeO5N1eZOF8Y34TjBns7PvE
        3wq7uXywPVFwiKhKhaW4u4bu0+9FSrD9b37W7VFACaNG1QUeZArQCMWrtJgDLwnMYWOQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jVlby-000sRn-QT; Tue, 05 May 2020 02:39:02 +0200
Date:   Tue, 5 May 2020 02:39:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Subject: Re: [PATCH net-next v2 3/3] net: phy: mscc: use phy_package_shared
Message-ID: <20200505003902.GB208718@lunn.ch>
References: <20200504213136.26458-1-michael@walle.cc>
 <20200504213136.26458-4-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200504213136.26458-4-michael@walle.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 04, 2020 at 11:31:36PM +0200, Michael Walle wrote:
> Use the new phy_package_shared common storage to ease the package
> initialization and to access the global registers.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
