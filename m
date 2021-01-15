Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78FFD2F802E
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 17:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731741AbhAOQAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 11:00:32 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:42976 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728338AbhAOQAc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 11:00:32 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l0RVu-000lty-Au; Fri, 15 Jan 2021 16:59:50 +0100
Date:   Fri, 15 Jan 2021 16:59:50 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH net-next] net: ks8851: Fix mixed module/builtin build
Message-ID: <YAG79tfQXTVWtPJX@lunn.ch>
References: <20210115134239.126152-1-marex@denx.de>
 <YAGuA8O0lr19l5lH@lunn.ch>
 <e000a5f4-53bb-a4e4-f032-3dbe394d5ea3@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e000a5f4-53bb-a4e4-f032-3dbe394d5ea3@denx.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 04:05:57PM +0100, Marek Vasut wrote:
> On 1/15/21 4:00 PM, Andrew Lunn wrote:
> > On Fri, Jan 15, 2021 at 02:42:39PM +0100, Marek Vasut wrote:
> > > When either the SPI or PAR variant is compiled as module AND the other
> > > variant is compiled as built-in, the following build error occurs:
> > > 
> > > arm-linux-gnueabi-ld: drivers/net/ethernet/micrel/ks8851_common.o: in function `ks8851_probe_common':
> > > ks8851_common.c:(.text+0x1564): undefined reference to `__this_module'
> > > 
> > > Fix this by including the ks8851_common.c in both ks8851_spi.c and
> > > ks8851_par.c. The DEBUG macro is defined in ks8851_common.c, so it
> > > does not have to be defined again.
> > 
> > DEBUG should not be defined for production code. So i would remove it
> > altogether.
> > 
> > There is kconfig'ury you can use to make them both the same. But i'm
> > not particularly good with it.
> 
> We had discussion about this module/builtin topic in ks8851 before, so I was
> hoping someone might provide a better suggestion.

Try Arnd Bergmann. He is good with this sort of thing.

    Andrew
