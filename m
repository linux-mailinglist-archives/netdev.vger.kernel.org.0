Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C351F24EDAC
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 16:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbgHWOg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 10:36:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40512 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725887AbgHWOgY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Aug 2020 10:36:24 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k9r6A-00BN8J-45; Sun, 23 Aug 2020 16:35:54 +0200
Date:   Sun, 23 Aug 2020 16:35:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dinghao Liu <dinghao.liu@zju.edu.cn>
Cc:     kjlu@umn.edu, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Caesar Wang <wxt@rock-chips.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: arc_emac: Fix memleak in arc_mdio_probe
Message-ID: <20200823143554.GE2588906@lunn.ch>
References: <20200823085650.912-1-dinghao.liu@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200823085650.912-1-dinghao.liu@zju.edu.cn>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 23, 2020 at 04:56:47PM +0800, Dinghao Liu wrote:
> When devm_gpiod_get_optional() fails, bus should be
> freed just like when of_mdiobus_register() fails.
> 
> Fixes: 1bddd96cba03d ("net: arc_emac: support the phy reset for emac driver")
> Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
