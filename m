Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C99132508D
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 14:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbhBYNdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 08:33:06 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57420 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232471AbhBYNcE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 08:32:04 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lFGjY-008PSW-DE; Thu, 25 Feb 2021 14:31:12 +0100
Date:   Thu, 25 Feb 2021 14:31:12 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com, linux-imx@nxp.com, netdev@vger.kernel.org
Subject: Re: [RFC V2 net-next 1/3] net: stmmac: add clocks management for
 gmac driver
Message-ID: <YDemoDbVIfblk2u+@lunn.ch>
References: <20210225115050.23971-1-qiangqing.zhang@nxp.com>
 <20210225115050.23971-2-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210225115050.23971-2-qiangqing.zhang@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -248,9 +296,15 @@ static int stmmac_mdio_write(struct mii_bus *bus, int phyaddr, int phyreg,
>  	unsigned int mii_address = priv->hw->mii.addr;
>  	unsigned int mii_data = priv->hw->mii.data;
>  	u32 value = MII_BUSY;
> -	int data = phydata;
> +	int ret, data = phydata;
>  	u32 v;

Reverse Christmass tree.

Otherwise this looks good.

	  Andrew
