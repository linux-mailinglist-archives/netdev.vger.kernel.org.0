Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75488356055
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 02:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245516AbhDGAcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 20:32:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37182 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236581AbhDGAcT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 20:32:19 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lTw72-00FDm5-Ce; Wed, 07 Apr 2021 02:32:04 +0200
Date:   Wed, 7 Apr 2021 02:32:04 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     hauke@hauke-m.de, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, linux@armlinux.org.uk,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH RFC net 2/2] net: dsa: lantiq_gswip: Configure all
 remaining GSWIP_MII_CFG bits
Message-ID: <YGz9hMcgZ1sUkgLO@lunn.ch>
References: <20210406203508.476122-1-martin.blumenstingl@googlemail.com>
 <20210406203508.476122-3-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406203508.476122-3-martin.blumenstingl@googlemail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  	case PHY_INTERFACE_MODE_RGMII:
>  	case PHY_INTERFACE_MODE_RGMII_ID:
>  	case PHY_INTERFACE_MODE_RGMII_RXID:
>  	case PHY_INTERFACE_MODE_RGMII_TXID:
>  		miicfg |= GSWIP_MII_CFG_MODE_RGMII;
> +
> +		if (phylink_autoneg_inband(mode))
> +			miicfg |= GSWIP_MII_CFG_RGMII_IBS;

Is there any other MAC driver doing this? Are there any boards
actually enabling it? Since it is so odd, if there is nothing using
it, i would be tempted to leave this out.

    Andrew
