Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 180A52DF075
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 17:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgLSQ0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Dec 2020 11:26:47 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34138 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726878AbgLSQ0r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Dec 2020 11:26:47 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kqf3R-00CrP1-KC; Sat, 19 Dec 2020 17:26:01 +0100
Date:   Sat, 19 Dec 2020 17:26:01 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Greg Ungerer <gerg@kernel.org>,
        Rene van Dorst <opensource@vdorst.com>,
        John Crispin <john@phrozen.org>
Subject: Re: [RFC PATCH net-next] net: dsa: mt7530: rename MT7621 compatible
Message-ID: <20201219162601.GE3008889@lunn.ch>
References: <20201219162153.23126-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201219162153.23126-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -2688,7 +2688,7 @@ static const struct mt753x_info mt753x_table[] = {
>  };
>  
>  static const struct of_device_id mt7530_of_match[] = {
> -	{ .compatible = "mediatek,mt7621", .data = &mt753x_table[ID_MT7621], },
> +	{ .compatible = "mediatek,mt7621-gsw", .data = &mt753x_table[ID_MT7621], },
>  	{ .compatible = "mediatek,mt7530", .data = &mt753x_table[ID_MT7530], },
>  	{ .compatible = "mediatek,mt7531", .data = &mt753x_table[ID_MT7531], },
>  	{ /* sentinel */ },

This will break backwards compatibility with existing DT blobs. You
need to keep the old "mediatek,mt7621", but please add a comment that
it is deprecated.

   Andrew
