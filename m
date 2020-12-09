Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F085C2D3787
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 01:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730656AbgLIAXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 19:23:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:48042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730326AbgLIAXO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 19:23:14 -0500
Date:   Tue, 8 Dec 2020 16:22:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607473353;
        bh=7aLIiUxTStX+LYo0g8eo7ffWgLa3KFjWTVyCfcZ57Dc=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=KxtEfx890KXGSsLxTVjROYHRwY0kk7yJrKsUG4p6A7hOjPCzvenyFZM2PBPRXiZ/n
         w60WBokUBoYRzmBjubCtMRfSfvxsxV6HIC7Idw7yNr54SKmRL577K0lj+W9JIC7eP8
         1wm5oSejwgMbnuUh2GNzAH0JaGYtCdrwxrRDQy3BRn6pyFZdoRjKY20GfFfm6wQc32
         5YQmntdD4cuajzapgkvHFtIX4iKpcV4b76sChcWwEtlmQXGFlAxKRNQOkFSA4jXLvy
         GxCWC9kgkqURWoitYmtwQ3nLx3kxH4YsudaIhpIR5Z5AtAVO9SnTorB+Rltmn9d0+i
         eXhrdp6m98zPw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>, davem@davemloft.net,
        robh+dt@kernel.org, nicolas.ferre@microchip.com,
        linux@armlinux.org.uk, paul.walmsley@sifive.com,
        palmer@dabbelt.com, yash.shah@sifive.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org
Subject: Re: [PATCH v2 3/8] net: macb: add function to disable all macb
 clocks
Message-ID: <20201208162226.7ca7f49f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201208184856.GM2475764@lunn.ch>
References: <1607343333-26552-1-git-send-email-claudiu.beznea@microchip.com>
        <1607343333-26552-4-git-send-email-claudiu.beznea@microchip.com>
        <20201208184856.GM2475764@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Dec 2020 19:48:56 +0100 Andrew Lunn wrote:
> > -err_disable_rxclk:
> > -	clk_disable_unprepare(*rx_clk);
> > -
> > -err_disable_txclk:
> > -	clk_disable_unprepare(*tx_clk);
> > -
> > -err_disable_hclk:
> > -	clk_disable_unprepare(*hclk);
> > -
> > -err_disable_pclk:
> > -	clk_disable_unprepare(*pclk);
> > +err_disable_clks:
> > +	macb_clks_disable(*pclk, *hclk, *tx_clk, *rx_clk, NULL);  
> 
> Personal taste, but i would of not changed this.

+1 FWIW
