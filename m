Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0B4B290F8B
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 07:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411845AbgJQFnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 01:43:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60640 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393382AbgJQFnB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 01:43:01 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kTbfl-002683-KH; Sat, 17 Oct 2020 04:10:17 +0200
Date:   Sat, 17 Oct 2020 04:10:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ivan Mikhaylov <i.mikhaylov@yadro.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Po-Yu Chuang <ratbert@faraday-tech.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        openbmc@lists.ozlabs.org
Subject: Re: [PATCH 1/1] net: ftgmac100: add handling of mdio/phy nodes for
 ast2400/2500
Message-ID: <20201017021017.GH456889@lunn.ch>
References: <20201013124014.2989-1-i.mikhaylov@yadro.com>
 <20201013124014.2989-2-i.mikhaylov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201013124014.2989-2-i.mikhaylov@yadro.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +		if (priv->is_aspeed &&
> +		    phy_intf != PHY_INTERFACE_MODE_RMII &&
> +		    phy_intf != PHY_INTERFACE_MODE_RGMII &&
> +		    phy_intf != PHY_INTERFACE_MODE_RGMII_ID &&
> +		    phy_intf != PHY_INTERFACE_MODE_RGMII_RXID &&
> +		    phy_intf != PHY_INTERFACE_MODE_RGMII_TXID) {


phy_interface_mode_is_rgmii()

	Andrew
