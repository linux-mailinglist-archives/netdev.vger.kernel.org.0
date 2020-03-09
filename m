Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54BEE17E52F
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 17:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727232AbgCIQ7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 12:59:00 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58598 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727101AbgCIQ7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 12:59:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 70C381590E20A;
        Mon,  9 Mar 2020 09:58:59 -0700 (PDT)
Date:   Mon, 09 Mar 2020 09:58:56 -0700 (PDT)
Message-Id: <20200309.095856.857594823719355569.davem@davemloft.net>
To:     o.rempel@pengutronix.de
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, marex@denx.de, david@protonic.nl
Subject: Re: [PATCH v2 2/2] net: phy: tja11xx: add delayed registration of
 TJA1102 PHY1
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200309074044.21399-3-o.rempel@pengutronix.de>
References: <20200309074044.21399-1-o.rempel@pengutronix.de>
        <20200309074044.21399-3-o.rempel@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Mar 2020 09:58:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>
Date: Mon,  9 Mar 2020 08:40:44 +0100

> +
> +static void tja1102_p1_register(struct work_struct *work)
> +{
> +	struct tja11xx_priv *priv = container_of(work, struct tja11xx_priv,
> +						 phy_register_work);
> +
> +	struct phy_device *phydev_phy0 = priv->phydev;
> +        struct mii_bus *bus = phydev_phy0->mdio.bus;
> +	struct device *dev = &phydev_phy0->mdio.dev;

Please fix the indentation of the 'bus' variable declaration.
