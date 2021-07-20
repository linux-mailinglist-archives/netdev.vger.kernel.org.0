Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC813CFBD6
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 16:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239031AbhGTNfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 09:35:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36304 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239126AbhGTNcr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 09:32:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=H/ZSBjInAi13UtQwysE1XGWP1x1Z2LWyhWVDwlfUhQ4=; b=1g
        QzmAfqTWm5Y4pgEztIhcBInugL8LFRLZ+hgt4A1LWL8PGnfxPcif9vWqkdeQEn8hzHdXjbGd2YX2r
        hBokjL0CI1uz+fqpjRNhyz87aA3viInW5FdbnQPf/6zbiOw65D5cf5AxlYTV+oRTGEiv/iEeBqtxv
        Y11RkqUcqBO2QoE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m5qUu-00E3xa-EZ; Tue, 20 Jul 2021 16:13:24 +0200
Date:   Tue, 20 Jul 2021 16:13:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: dpaa2-mac: add support for more ethtool
 10G link modes
Message-ID: <YPbaBBvdKksRhbfy@lunn.ch>
References: <E1m5mVT-00032g-Km@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E1m5mVT-00032g-Km@rmk-PC.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 20, 2021 at 10:57:43AM +0100, Russell King wrote:
> Phylink documentation says:
>   Note that the PHY may be able to transform from one connection
>   technology to another, so, eg, don't clear 1000BaseX just
>   because the MAC is unable to BaseX mode. This is more about
>   clearing unsupported speeds and duplex settings. The port modes
>   should not be cleared; phylink_set_port_modes() will help with this.
> 
> So add the missing 10G modes.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> Acked-by: Marek Behún <kabel@kernel.org>
> Acked-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
