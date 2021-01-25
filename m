Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED3BF3033ED
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 06:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727425AbhAZFJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:09:06 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57888 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728665AbhAYNTV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 08:19:21 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l41lL-002X9J-MK; Mon, 25 Jan 2021 14:18:35 +0100
Date:   Mon, 25 Jan 2021 14:18:35 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Marek Vasut <marex@denx.de>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [5.8 regression] net: ks8851: fix link error
Message-ID: <YA7FK3Q+KOedxW4o@lunn.ch>
References: <20210125121937.3900988-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125121937.3900988-1-arnd@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 01:19:20PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> An object file cannot be built for both loadable module and built-in
> use at the same time:
> 
> arm-linux-gnueabi-ld: drivers/net/ethernet/micrel/ks8851_common.o: in function `ks8851_probe_common':
> ks8851_common.c:(.text+0xf80): undefined reference to `__this_module'
> 
> Change the ks8851_common code to be a standalone module instead,
> and use Makefile logic to ensure this is built-in if at least one
> of its two users is.
> 
> Fixes: 797047f875b5 ("net: ks8851: Implement Parallel bus operations")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
