Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5213B3558B1
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 18:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237469AbhDFQCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 12:02:50 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36116 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232350AbhDFQCq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 12:02:46 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lTo9t-00F91t-0O; Tue, 06 Apr 2021 18:02:29 +0200
Date:   Tue, 6 Apr 2021 18:02:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Chun-Kuang Hu <chunkuang.hu@kernel.org>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        linux-staging@lists.linux.dev, DTML <devicetree@vger.kernel.org>,
        netdev@vger.kernel.org, Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>
Subject: Re: [RFC net-next 1/4] net: phy: add MediaTek PHY driver
Message-ID: <YGyGFOrXwEsqCW/z@lunn.ch>
References: <20210406141819.1025864-1-dqfext@gmail.com>
 <20210406141819.1025864-2-dqfext@gmail.com>
 <CAAOTY_8snSTcguhyB9PJBWydqNaWZL3V4zXiYULVp5n48fN24w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAOTY_8snSTcguhyB9PJBWydqNaWZL3V4zXiYULVp5n48fN24w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 06, 2021 at 11:47:08PM +0800, Chun-Kuang Hu wrote:
> Hi, Qingfang:
> 
> DENG Qingfang <dqfext@gmail.com> 於 2021年4月6日 週二 下午10:19寫道：
> >
> > Add support for MediaTek PHYs found in MT7530 and MT7531 switches.
> > The initialization procedure is from the vendor driver, but due to lack
> > of documentation, the function of some register values remains unknown.
> >
> > Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> > ---
> >  drivers/net/phy/Kconfig    |   5 ++
> >  drivers/net/phy/Makefile   |   1 +
> >  drivers/net/phy/mediatek.c | 109 +++++++++++++++++++++++++++++++++++++
> >  3 files changed, 115 insertions(+)
> >  create mode 100644 drivers/net/phy/mediatek.c
> >
> > diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> > index a615b3660b05..edd858cec9ec 100644
> > --- a/drivers/net/phy/Kconfig
> > +++ b/drivers/net/phy/Kconfig
> > @@ -207,6 +207,11 @@ config MARVELL_88X2222_PHY
> >           Support for the Marvell 88X2222 Dual-port Multi-speed Ethernet
> >           Transceiver.
> >
> > +config MEDIATEK_PHY
> 
> There are many Mediatek phy drivers in [1], so use a specific name.

Those are generic PHY drivers, where as this patch is add a PHY
driver. The naming used in this patch is consistent with other PHY
drivers. So i'm happy with this patch in this respect.

PHY drivers have been around a lot longer than generic PHY drivers. So
i would actually say the generic PHY driver naming should make it
clear they are generic PHYs, not PHYs.

But lets not bike shed about this too much.

      Andrew
