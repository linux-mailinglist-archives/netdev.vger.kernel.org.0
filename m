Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6CF21D9F5
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 17:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730037AbgGMPSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 11:18:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60990 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729027AbgGMPSc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 11:18:32 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jv0Do-004sjD-MW; Mon, 13 Jul 2020 17:18:24 +0200
Date:   Mon, 13 Jul 2020 17:18:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] net: phy: fix mdio-mscc-miim build
Message-ID: <20200713151824.GF1078057@lunn.ch>
References: <20200713151207.29451-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713151207.29451-1-brgl@bgdev.pl>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 05:12:07PM +0200, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> 
> PHYLIB is not selected by mdio-mscc-miim but it uses mdio devres helpers.
> Explicitly select MDIO_DEVRES in this driver's Kconfig entry.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: 1814cff26739 ("net: phy: add a Kconfig option for mdio_devres")
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
