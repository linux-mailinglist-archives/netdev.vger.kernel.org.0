Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C97C14F098
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 17:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbgAaQ21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 11:28:27 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:60336 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726168AbgAaQ20 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 11:28:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Gg4n82nFEGI/sYDjX2Y3BWaIREh/CzsvHXg7cg78LlE=; b=Hq9oGDGlX1a78c8stzsviEv0m2
        m0svDk0afLBmXZGKqTYlsfWvPQ/IycHZo0b/bDYaiSgedtESdLv44Indo9DsaMBB5nZM/cYzZYsBV
        6c2P9bbDgP+TtLAalb/PLFFE27rrwtGHfubSdlBidZEmaa1vNOErEq1/QWUdbVswwJok=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ixZ9S-0008EI-Sv; Fri, 31 Jan 2020 17:28:14 +0100
Date:   Fri, 31 Jan 2020 17:28:14 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Calvin Johnson <calvin.johnson@nxp.com>
Cc:     linux.cj@gmail.com, Jon Nettleton <jon@solid-run.com>,
        linux@armlinux.org.uk, Makarand Pawagi <makarand.pawagi@nxp.com>,
        cristian.sovaiala@nxp.com, laurentiu.tudor@nxp.com,
        ioana.ciornei@nxp.com, V.Sethi@nxp.com, pankaj.bansal@nxp.com,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v1 1/7] mdio_bus: Introduce fwnode MDIO helpers
Message-ID: <20200131162814.GB17185@lunn.ch>
References: <20200131153440.20870-1-calvin.johnson@nxp.com>
 <20200131153440.20870-2-calvin.johnson@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200131153440.20870-2-calvin.johnson@nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 31, 2020 at 09:04:34PM +0530, Calvin Johnson wrote:
> From: Marcin Wojtas <mw@semihalf.com>
> 
> This patch introduces fwnode helper for registering MDIO
> bus, as well as one for finding the PHY, basing on its
> firmware node pointer. Comparing to existing OF equivalent,
> fwnode_mdiobus_register() does not support:
>  * deprecated bindings (device whitelist, nor the PHY ID embedded
>    in the compatible string)
>  * MDIO bus auto scanning
> 
> Signed-off-by: Marcin Wojtas <mw@semihalf.com>
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>

Hi Calvin

This appears to but a cut and paste, follow by an intelligent
s/of/fwnode/g.

Did you make any attempt to consolidate the two implementations?  It
seems like there should be some level of abstraction that hides away
the difference between DT properties, and DT properties stuffed into
ACPI tables?

     Andrew

