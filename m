Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1227C23572D
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 15:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728376AbgHBNoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 09:44:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38856 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726578AbgHBNoP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Aug 2020 09:44:15 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k2EHS-007vVE-8B; Sun, 02 Aug 2020 15:44:02 +0200
Date:   Sun, 2 Aug 2020 15:44:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Bartosz Golaszewski <brgl@bgdev.pl>, g@lunn.ch
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [net-next PATCH] net: phy: mdio-mvusb: select MDIO_DEVRES in
 Kconfig
Message-ID: <20200802134402.GB1862409@lunn.ch>
References: <20200802074953.1529-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200802074953.1529-1-brgl@bgdev.pl>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 02, 2020 at 09:49:53AM +0200, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> 
> PHYLIB is not selected by the mvusb driver but it uses mdio devres
> helpers. Explicitly select MDIO_DEVRES in this driver's Kconfig entry.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: 1814cff26739 ("net: phy: add a Kconfig option for mdio_devres")
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
