Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4671FDA03
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 02:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbgFRAAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 20:00:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:49538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726763AbgFRAAv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 20:00:51 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 515B820B1F;
        Thu, 18 Jun 2020 00:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592438450;
        bh=O0Ojn64QE9TAUNMg1Czyk7vrOv6xiPBYlaWVb0X35x8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gntkbq/YBvvPhhPey0eMwmZnvFqAA0xmCm33NsY2GTKj8dJSY1qe2aD0wauUxNDFa
         A3SoEyYovNwwrk0zB7RyggJLgYgL3F7NZ3BXDno9GM7tPtHMTiHCdwmXQccU6fl3Nd
         br1RA6J8hvuQNwKsAK1zy7WXq97Uw8aosdT2/WpY=
Date:   Wed, 17 Jun 2020 17:00:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <robh@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next v7 6/6] net: phy: DP83822: Add ability to
 advertise Fiber connection
Message-ID: <20200617170048.3501848a@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200617182019.6790-7-dmurphy@ti.com>
References: <20200617182019.6790-1-dmurphy@ti.com>
        <20200617182019.6790-7-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Jun 2020 13:20:19 -0500 Dan Murphy wrote:
> +static int dp83822_config_init(struct phy_device *phydev)
> +{
> +	struct dp83822_private *dp83822 = phydev->priv;
> +	int rgmii_delay;
> +	int err = 0;
> +
> +	if (phy_interface_is_rgmii(phydev)) {
> +		if (dp83822->rx_int_delay)
> +			rgmii_delay = DP83822_RX_CLK_SHIFT;
> +
> +		if (dp83822->tx_int_delay)
> +			rgmii_delay |= DP83822_TX_CLK_SHIFT;
> +
> +		if (rgmii_delay)
> +			err = phy_set_bits_mmd(phydev, DP83822_DEVADDR,
> +					       MII_DP83822_RCSR, rgmii_delay);
> +	}
> +
> +	return dp8382x_disable_wol(phydev);
> +}


drivers/net/phy/dp83822.c: In function dp83822_config_init:
drivers/net/phy/dp83822.c:282:6: warning: variable err set but not used [-Wunused-but-set-variable]
  282 |  int err = 0;
      |      ^~~
