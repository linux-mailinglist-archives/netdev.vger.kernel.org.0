Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9082B5694
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 03:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727624AbgKQCKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 21:10:05 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59206 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbgKQCKE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 21:10:04 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1keqRQ-007SBo-IQ; Tue, 17 Nov 2020 03:09:56 +0100
Date:   Tue, 17 Nov 2020 03:09:56 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Roelof Berg <rberg@berg-solutions.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v1] lan743x: replace devicetree phy parse code
 with library function
Message-ID: <20201117020956.GF1752213@lunn.ch>
References: <20201116170155.26967-1-TheSven73@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201116170155.26967-1-TheSven73@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 16, 2020 at 12:01:55PM -0500, Sven Van Asbroeck wrote:
> From: Sven Van Asbroeck <thesven73@gmail.com>
> 
> The code in this driver which parses the devicetree to determine
> the phy/fixed link setup, can be replaced by a single library
> function: of_phy_get_and_connect().
> 
> Behaviour is identical, except that the library function will
> complain when 'phy-connection-type' is omitted, instead of
> blindly using PHY_INTERFACE_MODE_NA, which would result in an
> invalid phy configuration.
> 
> The library function no longer brings out the exact phy_mode,
> but the driver doesn't need this, because phy_interface_is_rgmii()
> queries the phydev directly. Remove 'phy_mode' from the private
> adapter struct.
> 
> While we're here, log info about the attached phy on connect,
> this is useful because the phy type and connection method is now
> fully configurable via the devicetree.
> 
> Tested on a lan7430 chip with built-in phy. Verified that adding
> fixed-link/phy-connection-type in the devicetree results in a
> fixed-link setup. Used ethtool to verify that the devicetree
> settings are used.
> 
> Tested-by: Sven Van Asbroeck <thesven73@gmail.com> # lan7430
> Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
