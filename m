Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 620072996B5
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 20:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1792929AbgJZTVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 15:21:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45482 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504798AbgJZTVF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 15:21:05 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kX838-003f1h-8p; Mon, 26 Oct 2020 20:20:58 +0100
Date:   Mon, 26 Oct 2020 20:20:58 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mdio: use inline functions for to_mdio_device() etc
Message-ID: <20201026192058.GP752111@lunn.ch>
References: <20201026165113.3723159-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201026165113.3723159-1-arnd@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 26, 2020 at 05:51:09PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>

..

> Redefine the macros in linux/mdio.h as inline functions to avoid this
> problem.
> 
> Fixes: a9049e0c513c ("mdio: Add support for mdio drivers.")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Hi Arnd

It is nice to have the additional type checking.

Since you added a Fixes: tag, do you want this in stable?
netdev puts into the Subject line the tree it is intended for:

[PATCH net v1]

or

[PATCH net-next v1]

Anyway:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
