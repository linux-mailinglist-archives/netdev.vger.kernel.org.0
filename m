Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9354C18CB3B
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 11:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbgCTKJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 06:09:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47032 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726527AbgCTKJ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 06:09:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=tAYPRm4IJac7W+8neIju/63yEbVYeH5eneKaf19WKEM=; b=tjLnoMEycQl+PY5k8MsaF3UQsc
        aoBPNM4AZBRZNU2l9gOyf1s5nFJrRVwyOw1LQm4LXg0TBd9isvzD9/GFIkN+xbNrK41G5DA3B54v0
        cBLHoqyHH2oNZMW72xBRqbI2DoM3xZoE0Bn7FscrLQR4Q0tQFSzgcp2eRxCKXY6OR4y0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jFEaj-0004lE-EH; Fri, 20 Mar 2020 11:09:25 +0100
Date:   Fri, 20 Mar 2020 11:09:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, f.fainelli@gmail.com,
        hkallweit1@gmail.com, antoine.tenart@bootlin.com
Subject: Re: [PATCH net-next 1/4] net: phy: mscc: rename enum
 rgmii_rx_clock_delay to rgmii_clock_delay
Message-ID: <20200320100925.GB16662@lunn.ch>
References: <20200319211649.10136-1-olteanv@gmail.com>
 <20200319211649.10136-2-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319211649.10136-2-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 19, 2020 at 11:16:46PM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> There is nothing RX-specific about these clock skew values. So remove
> "RX" from the name in preparation for the next patch where TX delays are
> also going to be configured.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/phy/mscc/mscc.h      | 18 +++++++++---------
>  drivers/net/phy/mscc/mscc_main.c |  2 +-
>  2 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
> index 29ccb2c9c095..56feb14838f3 100644
> --- a/drivers/net/phy/mscc/mscc.h
> +++ b/drivers/net/phy/mscc/mscc.h
> @@ -12,15 +12,15 @@
>  #include "mscc_macsec.h"
>  #endif
>  
> -enum rgmii_rx_clock_delay {
> -	RGMII_RX_CLK_DELAY_0_2_NS = 0,
> -	RGMII_RX_CLK_DELAY_0_8_NS = 1,
> -	RGMII_RX_CLK_DELAY_1_1_NS = 2,
> -	RGMII_RX_CLK_DELAY_1_7_NS = 3,
> -	RGMII_RX_CLK_DELAY_2_0_NS = 4,
> -	RGMII_RX_CLK_DELAY_2_3_NS = 5,
> -	RGMII_RX_CLK_DELAY_2_6_NS = 6,
> -	RGMII_RX_CLK_DELAY_3_4_NS = 7
> +enum rgmii_clock_delay {
> +	RGMII_CLK_DELAY_0_2_NS = 0,
> +	RGMII_CLK_DELAY_0_8_NS = 1,
> +	RGMII_CLK_DELAY_1_1_NS = 2,
> +	RGMII_CLK_DELAY_1_7_NS = 3,
> +	RGMII_CLK_DELAY_2_0_NS = 4,
> +	RGMII_CLK_DELAY_2_3_NS = 5,
> +	RGMII_CLK_DELAY_2_6_NS = 6,
> +	RGMII_CLK_DELAY_3_4_NS = 7
>  };

Can this be shared?

https://www.spinics.net/lists/netdev/msg638747.html

Looks to be the same values?

Can some of the implementation be consolidated?

    Andrew
