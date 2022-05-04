Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5083251B164
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 23:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239371AbiEDVz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 17:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239194AbiEDVz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 17:55:56 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8480250473;
        Wed,  4 May 2022 14:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Uq3d86EBuDumrXHdLcJBfX1DsrAwWu6TJD73LdoFmjY=; b=3Ufz56wnHh0oXmLcrolMCgczXO
        UZarBYl2S5BbN5w9rQW78rzW0/j7kRcv85ekOSTRfRASvfVDZcMglSlGHt9udylMQ9Fzv5IT/mfZf
        gvuHaxNruEFRoK28OBkRlgWqg9+b+pyBAYc12VIXatMGdYlFFFS0sNjflIka6rMcPbS0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nmMuq-001Gfo-Nb; Wed, 04 May 2022 23:52:12 +0200
Date:   Wed, 4 May 2022 23:52:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, claudiu.beznea@microchip.com,
        netdev@vger.kernel.org, o.rempel@pengutronix.de,
        linux@armlinux.org.uk, Fabio Estevam <festevam@denx.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH net v2 2/2] net: phy: micrel: Pass .probe for KS8737
Message-ID: <YnL1jLQ5A6/RraYm@lunn.ch>
References: <20220504143104.1286960-1-festevam@gmail.com>
 <20220504143104.1286960-2-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220504143104.1286960-2-festevam@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 04, 2022 at 11:31:04AM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <festevam@denx.de>
> 
> Since commit f1131b9c23fb ("net: phy: micrel: use
> kszphy_suspend()/kszphy_resume for irq aware devices") the kszphy_suspend/
> resume hooks are used.
> 
> These functions require the probe function to be called so that
> priv can be allocated.
> 
> Otherwise, a NULL pointer dereference happens inside
> kszphy_config_reset().
> 
> Cc: stable@vger.kernel.org
> Fixes: f1131b9c23fb ("net: phy: micrel: use kszphy_suspend()/kszphy_resume for irq aware devices")
> Reported-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Fabio Estevam <festevam@denx.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
