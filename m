Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 564642F18B1
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 15:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730875AbhAKOuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 09:50:14 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:33414 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730168AbhAKOuO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 09:50:14 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kyyVh-00HXzC-1N; Mon, 11 Jan 2021 15:49:33 +0100
Date:   Mon, 11 Jan 2021 15:49:33 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH net-next] net: ks8851: Select PHYLIB and MICREL_PHY in
 Kconfig
Message-ID: <X/xlfe5oxi4zwOeo@lunn.ch>
References: <20210111125046.36326-1-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111125046.36326-1-marex@denx.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 01:50:46PM +0100, Marek Vasut wrote:
> The PHYLIB must be selected to provide mdiobus_*() functions, and the
> MICREL_PHY is necessary too, as that is the only possible PHY attached
> to the KS8851 (it is the internal PHY).
> 
> Fixes: ef3631220d2b ("net: ks8851: Register MDIO bus and the internal PHY")
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: Lukas Wunner <lukas@wunner.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
