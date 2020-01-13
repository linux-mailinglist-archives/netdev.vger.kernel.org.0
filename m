Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29FD913922B
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 14:29:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727331AbgAMN27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 08:28:59 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34464 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726277AbgAMN27 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 08:28:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=FpkFxp1qPW3+9QSftzRJBfOZwYtUKjyOro9/uICM4TU=; b=xR4qc2NafemcdaBW43Lk3uKOJX
        NYHT2l9SoSz77eDcruXc1TKSgKMFLgPXvi4br3v8B4oZOoxuuzgDuFIBc/7dD4BLOOo1+Ln13+3J/
        PdY/nYb1cRZ1S908oN8pU6M0FQCEm5ZjPiItq51vHU7GNKh6BivSSYTbYa+iN0AJQGsI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1iqzlz-0003sw-QO; Mon, 13 Jan 2020 14:28:51 +0100
Date:   Mon, 13 Jan 2020 14:28:51 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        David Bauer <mail@david-bauer.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Philipp Zabel <p.zabel@pengutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mdio_bus: Simplify reset handling and extend to non-DT
 systems
Message-ID: <20200113132851.GC11788@lunn.ch>
References: <20200113130529.15372-1-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200113130529.15372-1-geert+renesas@glider.be>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 13, 2020 at 02:05:29PM +0100, Geert Uytterhoeven wrote:
> Convert mdiobus_register_reset() from open-coded DT-only optional reset
> handling to reset_control_get_optional_exclusive().  This not only
> simplifies the code, but also adds support for lookup-based resets on
> non-DT systems.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> Only tested on systems without PHY resets, with and without
> CONFIG_RESET_CONTROLLER=y.

David, please could you test this.

But it Looks O.K. to me.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
