Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD0925EBCD
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 01:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728853AbgIEXux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 19:50:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:58478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728103AbgIEXuu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Sep 2020 19:50:50 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2411B2072D;
        Sat,  5 Sep 2020 23:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599349849;
        bh=h0R4sF+5A4qwm1j7RZDzVqY8zeUBVfqPznj/PjB+chg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WcGkCr4t1aHtiLM2bweaw/TvLg1ZWv+tDICD8sUu3E2m4RaqIarx2DnPeOjVa1urZ
         lDJcH+vYwCyDVzHZGwXi0NtftkjtgUuddnMa3y6xealnrlMs0fMdi7/EV6k9GQJLBm
         81nAsgH8dEH01nbQBQpGx5PtLOpiXs1toeaMOg5Y=
Date:   Sat, 5 Sep 2020 16:50:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Landen Chao <landen.chao@mediatek.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <frank-w@public-files.de>,
        <opensource@vdorst.com>, <dqfext@gmail.com>
Subject: Re: [PATCH net-next v3 4/6] net: dsa: mt7530: Add the support of
 MT7531 switch
Message-ID: <20200905165047.32f94ae5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <63041b5c2c346b874e92761b3b3d6553106dde98.1599228079.git.landen.chao@mediatek.com>
References: <cover.1599228079.git.landen.chao@mediatek.com>
        <63041b5c2c346b874e92761b3b3d6553106dde98.1599228079.git.landen.chao@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Sep 2020 22:21:59 +0800 Landen Chao wrote:
> +static int
> +mt7531_cpu_port_config(struct dsa_switch *ds, int port)
> +{
> +	struct mt7530_priv *priv = ds->priv;
> +	phy_interface_t interface;
> +	int speed;
> +
> +	switch (port) {
> +	case 5:
> +		if (mt7531_is_rgmii_port(priv, port))
> +			interface = PHY_INTERFACE_MODE_RGMII;
> +		else
> +			interface = PHY_INTERFACE_MODE_2500BASEX;
> +
> +		priv->p5_interface = interface;
> +		break;
> +	case 6:
> +		interface = PHY_INTERFACE_MODE_2500BASEX;
> +
> +		mt7531_pad_setup(ds, interface);
> +
> +		priv->p6_interface = interface;
> +		break;
> +	};

stray semicolon
