Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2EB627A187
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 17:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbgI0PIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 11:08:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58036 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726255AbgI0PIV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Sep 2020 11:08:21 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kMYHi-00GPDv-5r; Sun, 27 Sep 2020 17:08:18 +0200
Date:   Sun, 27 Sep 2020 17:08:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH] mdio: fix mdio-thunder.c dependency & build error
Message-ID: <20200927150818.GF3889809@lunn.ch>
References: <5aecbd3f-a489-0738-8249-5e08a6f2766f@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5aecbd3f-a489-0738-8249-5e08a6f2766f@infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 26, 2020 at 09:33:43PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix build error by selecting MDIO_DEVRES for MDIO_THUNDER.
> Fixes this build error:
> 
> ld: drivers/net/phy/mdio-thunder.o: in function `thunder_mdiobus_pci_probe':
> drivers/net/phy/mdio-thunder.c:78: undefined reference to `devm_mdiobus_alloc_size'
> 
> Fixes: 379d7ac7ca31 ("phy: mdio-thunder: Add driver for Cavium Thunder SoC MDIO buses.")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
