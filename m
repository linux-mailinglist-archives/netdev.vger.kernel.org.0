Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9A32EAD50
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 15:24:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727255AbhAEOXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 09:23:37 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50204 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726600AbhAEOXg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 09:23:36 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kwnEW-00GB5H-A9; Tue, 05 Jan 2021 15:22:48 +0100
Date:   Tue, 5 Jan 2021 15:22:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        pantelis.antoniou@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH v2] net: ethernet: fs_enet: Add missing MODULE_LICENSE
Message-ID: <X/R2OPcvQ6YcYkc0@lunn.ch>
References: <20210105091515.87509-1-mpe@ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210105091515.87509-1-mpe@ellerman.id.au>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 05, 2021 at 08:15:15PM +1100, Michael Ellerman wrote:
> Since commit 1d6cd3929360 ("modpost: turn missing MODULE_LICENSE()
> into error") the ppc32_allmodconfig build fails with:
> 
>   ERROR: modpost: missing MODULE_LICENSE() in drivers/net/ethernet/freescale/fs_enet/mii-fec.o
>   ERROR: modpost: missing MODULE_LICENSE() in drivers/net/ethernet/freescale/fs_enet/mii-bitbang.o
> 
> Add the missing MODULE_LICENSEs to fix the build. Both files include a
> copyright header indicating they are GPL v2.
> 
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
