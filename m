Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 045E12F17ED
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 15:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730941AbhAKOR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 09:17:57 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:33288 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727304AbhAKOR4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 09:17:56 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kyy0H-00HXVo-Ez; Mon, 11 Jan 2021 15:17:05 +0100
Date:   Mon, 11 Jan 2021 15:17:05 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marco Felsch <m.felsch@pengutronix.de>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH] net: phy: smsc: fix clk error handling
Message-ID: <X/xd4T7G99KNv/Vz@lunn.ch>
References: <20210111085932.28680-1-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111085932.28680-1-m.felsch@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 09:59:32AM +0100, Marco Felsch wrote:
> Commit bedd8d78aba3 ("net: phy: smsc: LAN8710/20: add phy refclk in
> support") added the phy clk support. The commit already checks if
> clk_get_optional() throw an error but instead of returning the error it
> ignores it.
> 
> Fixes: bedd8d78aba3 ("net: phy: smsc: LAN8710/20: add phy refclk in support")
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
