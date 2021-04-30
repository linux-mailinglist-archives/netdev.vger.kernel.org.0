Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25AB436FB4A
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 15:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232255AbhD3NO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 09:14:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47812 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230020AbhD3NO5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Apr 2021 09:14:57 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lcSxy-001obc-OV; Fri, 30 Apr 2021 15:13:58 +0200
Date:   Fri, 30 Apr 2021 15:13:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        David Miller <davem@davemloft.net>, f.fainelli@gmail.com,
        hkallweit1@gmail.com, kuba@kernel.org, Landen.Chao@mediatek.com,
        matthias.bgg@gmail.com, linux@armlinux.org.uk,
        sean.wang@mediatek.com, vivien.didelot@gmail.com,
        olteanv@gmail.com, robh+dt@kernel.org, linus.walleij@linaro.org,
        gregkh@linuxfoundation.org, sergio.paracuellos@gmail.com,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-staging@lists.linux.dev, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, weijie.gao@mediatek.com,
        gch981213@gmail.com, opensource@vdorst.com, tglx@linutronix.de,
        maz@kernel.org
Subject: Re: Re: Re: [PATCH net-next 0/4] MT7530 interrupt support
Message-ID: <YIwCliT5NZT713WD@lunn.ch>
References: <20210429062130.29403-1-dqfext@gmail.com>
 <20210429.170815.956010543291313915.davem@davemloft.net>
 <20210430023839.246447-1-dqfext@gmail.com>
 <YIv28APpOP9tnuO+@lunn.ch>
 <trinity-843c99ce-952a-434e-95e4-4ece3ba6b9bd-1619786236765@3c-app-gmx-bap03>
 <YIv7w8Wy81fmU5A+@lunn.ch>
 <trinity-611ff023-c337-4148-a215-98fd5604eac2-1619787382934@3c-app-gmx-bap03>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <trinity-611ff023-c337-4148-a215-98fd5604eac2-1619787382934@3c-app-gmx-bap03>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 30, 2021 at 02:56:22PM +0200, Frank Wunderlich wrote:
> Hi
> 
> which ethernet-phy drivers do you mean?

drivers/net/phy.

> i found only combined phy-drivers with ethernet-handling (marvell,xilinx,mscc,ti) having the "phy-" prefix too
> 
> as i see something like this in drivers/phy/intel/
> 
> phy-intel-keembay-emmc.c
> phy-intel-keembay-usb.c
> 
> maybe this in drivers/phy/mediatek/
> 
> phy-mediatek-mt753x.c
> 
> ? maybe with additional -eth, but this seems redundant, as mt753x is an ethernet-switch
> 
> or like the other mtk-phys
> 
> phy-mtk-eth-mt7531.c (like phy-mtk-mipi-dsi.c,phy-mtk-hdmi.c,phy-mtk-hdmi-mt8173.c)

These are all examples of generic PHY drivers, not PHY drivers.

There is a lot of confusion between PHY drivers and generic PHY
drivers :-(

	Andrew
