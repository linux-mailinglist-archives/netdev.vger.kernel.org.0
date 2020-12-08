Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 035D92D2078
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 03:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727218AbgLHCF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 21:05:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:56914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726000AbgLHCF0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 21:05:26 -0500
Date:   Mon, 7 Dec 2020 18:04:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607393085;
        bh=KognAkCYfuOB1Nu4iQHjV0+XS82XioxE4y/7HqsoFSI=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=knwrH+dkY81EEXnXNZrcZ7/DxgrakZsW/jRIRhprkgTkBBpdy2Owu0tNqcetN6IDt
         4u/G5n9YDT8JYkLyisZRP9dKW54WjJXuJBMbbet+sMZGrhSkDdfLXEZQGFSKUETobW
         8KEb57LGEJugVUVwV7skGo6j0k5D7ttGWBptAP45kKt1XWHVmYxHnq2xLn/6ABgi3m
         P6O1pnrNTY10rqcjPklFIeE8If1XZwJIUvR+2vsCHsQaNFitbNW/pONVw1+ZQ0ZmSk
         uKCHK0i42P/oOgTxW70VHFgXU7A2tLsbntopIPou5K9TMn3ikM1OYtQoHwHL2dk3mP
         icQbKxYNw6tww==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jerome Brunet <jbrunet@baylibre.com>
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] net: stmmac: dwmac-meson8b: fix mask definition of the
 m250_sel mux
Message-ID: <20201207180444.2a48c366@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <1jo8j62c8t.fsf@starbuckisacylon.baylibre.com>
References: <20201205213207.519341-1-martin.blumenstingl@googlemail.com>
        <1jo8j62c8t.fsf@starbuckisacylon.baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 07 Dec 2020 10:31:46 +0100 Jerome Brunet wrote:
> > The m250_sel mux clock uses bit 4 in the PRG_ETH0 register. Fix this by
> > shifting the PRG_ETH0_CLK_M250_SEL_MASK accordingly as the "mask" in
> > struct clk_mux expects the mask relative to the "shift" field in the
> > same struct.
> >
> > While here, get rid of the PRG_ETH0_CLK_M250_SEL_SHIFT macro and use
> > __ffs() to determine it from the existing PRG_ETH0_CLK_M250_SEL_MASK
> > macro.
> >
> > Fixes: 566e8251625304 ("net: stmmac: add a glue driver for the Amlogic Meson 8b / GXBB DWMAC")
> > Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>  
> 
> Reviewed-by: Jerome Brunet <jbrunet@baylibre.com>

Applied, thanks!
