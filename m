Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCF9A3332EE
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 03:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbhCJCBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 21:01:37 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48640 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231901AbhCJCBV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 21:01:21 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lJo9v-00A6PY-Rb; Wed, 10 Mar 2021 03:01:11 +0100
Date:   Wed, 10 Mar 2021 03:01:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dpaa2-mac: add support for more ethtool
 10G link modes
Message-ID: <YEgoZwVt0gu9QUMH@lunn.ch>
References: <E1lJeO1-0008Vj-Jk@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1lJeO1-0008Vj-Jk@rmk-PC.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 09, 2021 at 03:35:05PM +0000, Russell King wrote:
> Phylink documentation says:
>  * Note that the PHY may be able to transform from one connection
>  * technology to another, so, eg, don't clear 1000BaseX just
>  * because the MAC is unable to BaseX mode. This is more about
>  * clearing unsupported speeds and duplex settings. The port modes
>  * should not be cleared; phylink_set_port_modes() will help with this.
> 
> So add the missing 10G modes. This allows SFP+ modules to be used with
> the SolidRun boards.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
