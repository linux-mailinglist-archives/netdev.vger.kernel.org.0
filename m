Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BEA02E7AD4
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 17:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbgL3QBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 11:01:16 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:44684 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726161AbgL3QBQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Dec 2020 11:01:16 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kudtq-00F3Ja-Pm; Wed, 30 Dec 2020 17:00:34 +0100
Date:   Wed, 30 Dec 2020 17:00:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH 2/2] net: ks8851: Register MDIO bus and the internal PHY
Message-ID: <X+ykIqQhtjkuDQk9@lunn.ch>
References: <20201230125358.1023502-1-marex@denx.de>
 <20201230125358.1023502-2-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201230125358.1023502-2-marex@denx.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int ks8851_mdio_read(struct mii_bus *bus, int phy_id, int reg)
> +{
> +	struct ks8851_net *ks = bus->priv;
> +
> +	if (phy_id != 0)
> +		return 0xffffffff;
> +

Please check for C45 and return -EOPNOTSUPP.

       Andrew
