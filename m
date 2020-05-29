Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E44E91E8814
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 21:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbgE2TpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 15:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726751AbgE2TpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 15:45:08 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8935BC03E969;
        Fri, 29 May 2020 12:45:08 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D27471282CC6B;
        Fri, 29 May 2020 12:45:07 -0700 (PDT)
Date:   Fri, 29 May 2020 12:45:06 -0700 (PDT)
Message-Id: <20200529.124506.499859048953015300.davem@davemloft.net>
To:     antoine.tenart@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        michael@walle.cc, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: mscc: fix PHYs using the
 vsc8574_probe
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200529094909.1254629-1-antoine.tenart@bootlin.com>
References: <20200529094909.1254629-1-antoine.tenart@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 29 May 2020 12:45:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antoine Tenart <antoine.tenart@bootlin.com>
Date: Fri, 29 May 2020 11:49:09 +0200

> PHYs using the vsc8574_probe fail to be initialized and their
> config_init return -EIO leading to errors like:
> "could not attach PHY: -5".
> 
> This is because when the conversion of the MSCC PHY driver to use the
> shared PHY package helpers was done, the base address retrieval and the
> base PHY read and write helpers in the driver were modified. In
> particular, the base address retrieval logic was moved from the
> config_init to the probe. But the vsc8574_probe was forgotten. This
> patch fixes it.
> 
> Fixes: deb04e9c0ff2 ("net: phy: mscc: use phy_package_shared")
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>

Applied, thanks.
