Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD49F421951
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 23:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236223AbhJDVdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 17:33:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48434 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236385AbhJDVdM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 17:33:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=mUCU6Y31WqkjejWqrL97kZMddA6zTxAATPsaPVEZdvs=; b=Y5w5M6pk7c3GGeI0MWfMQHQ7ZM
        aLUrInmpGM4Z94kvxLE7XRjKTpNP98xJGcY/45G6Od3x9J9jUjbY1N+ulCskkZ+BTT3ewrczQ51vc
        P518wEVICTF/KLqns4yulVg/Mb0NZTBu3T3SXqs7RoSemPqgth4gQke2Y+pyr/Y0wZ24=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mXVYL-009bbh-6J; Mon, 04 Oct 2021 23:31:17 +0200
Date:   Mon, 4 Oct 2021 23:31:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [RFC net-next PATCH 03/16] net: sfp: Fix typo in state machine
 debug string
Message-ID: <YVtypfZJfivfDnu7@lunn.ch>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
 <20211004191527.1610759-4-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004191527.1610759-4-sean.anderson@seco.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 04, 2021 at 03:15:14PM -0400, Sean Anderson wrote:
> The string should be "tx_disable" to match the state enum.
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
> 
>  drivers/net/phy/sfp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
> index 34e90216bd2c..ab77a9f439ef 100644
> --- a/drivers/net/phy/sfp.c
> +++ b/drivers/net/phy/sfp.c
> @@ -134,7 +134,7 @@ static const char * const sm_state_strings[] = {
>  	[SFP_S_LINK_UP] = "link_up",
>  	[SFP_S_TX_FAULT] = "tx_fault",
>  	[SFP_S_REINIT] = "reinit",
> -	[SFP_S_TX_DISABLE] = "rx_disable",
> +	[SFP_S_TX_DISABLE] = "tx_disable",
>  };

Hi Sean

This is a bug fix. Please separate it out and base it on net, not
net-next.

Fixes: 4005a7cb4f55 ("net: phy: sftp: print debug message with text, not numbers")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
