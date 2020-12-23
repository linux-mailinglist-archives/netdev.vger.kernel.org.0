Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9DAD2E1E3E
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 16:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728806AbgLWPeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 10:34:24 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:38742 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728768AbgLWPeX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 10:34:23 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1ks68O-00DbtA-Vv; Wed, 23 Dec 2020 16:33:04 +0100
Date:   Wed, 23 Dec 2020 16:33:04 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dinghao Liu <dinghao.liu@zju.edu.cn>
Cc:     kjlu@umn.edu, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: Fix memleak in ethoc_probe
Message-ID: <20201223153304.GD3198262@lunn.ch>
References: <20201223110615.31389-1-dinghao.liu@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201223110615.31389-1-dinghao.liu@zju.edu.cn>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 23, 2020 at 07:06:12PM +0800, Dinghao Liu wrote:
> When mdiobus_register() fails, priv->mdio allocated
> by mdiobus_alloc() has not been freed, which leads
> to memleak.
> 
> Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>

Fixes: bfa49cfc5262 ("net/ethoc: fix null dereference on error exit path")

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
