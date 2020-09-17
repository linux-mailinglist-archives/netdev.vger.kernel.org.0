Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64A526DCA1
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 15:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbgIQNR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 09:17:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40610 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726959AbgIQNQi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 09:16:38 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kItlt-00F597-Aw; Thu, 17 Sep 2020 15:16:21 +0200
Date:   Thu, 17 Sep 2020 15:16:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, hkallweit1@gmail.com, kuba@kernel.org,
        davem@davemloft.net
Subject: Re: [PATCH net 2/2] net: phy: Do not warn in phy_stop() on PHY_DOWN
Message-ID: <20200917131621.GM3526428@lunn.ch>
References: <20200917034310.2360488-1-f.fainelli@gmail.com>
 <20200917034310.2360488-3-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917034310.2360488-3-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 16, 2020 at 08:43:10PM -0700, Florian Fainelli wrote:
> When phy_is_started() was added to catch incorrect PHY states,
> phy_stop() would not be qualified against PHY_DOWN. It is possible to
> reach that state when the PHY driver has been unbound and the network
> device is then brought down.
> 
> Fixes: 2b3e88ea6528 ("net: phy: improve phy state checking")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
