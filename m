Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD7A33558C3
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 18:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346182AbhDFQFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 12:05:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36142 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233361AbhDFQFj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 12:05:39 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lToCh-00F94W-A1; Tue, 06 Apr 2021 18:05:23 +0200
Date:   Tue, 6 Apr 2021 18:05:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Chun-Kuang Hu <chunkuang.hu@kernel.org>,
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
        netdev <netdev@vger.kernel.org>,
        Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>
Subject: Re: [RFC net-next 1/4] net: phy: add MediaTek PHY driver
Message-ID: <YGyGwzyFKSNBQj2U@lunn.ch>
References: <20210406141819.1025864-1-dqfext@gmail.com>
 <20210406141819.1025864-2-dqfext@gmail.com>
 <CAAOTY_8snSTcguhyB9PJBWydqNaWZL3V4zXiYULVp5n48fN24w@mail.gmail.com>
 <CALW65jbbQSFbgjsMkKCyFWnbkLOenM_+2q6K7BQG5bc4-R0CpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALW65jbbQSFbgjsMkKCyFWnbkLOenM_+2q6K7BQG5bc4-R0CpA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 06, 2021 at 11:57:14PM +0800, DENG Qingfang wrote:
> On Tue, Apr 6, 2021 at 11:47 PM Chun-Kuang Hu <chunkuang.hu@kernel.org> wrote:
> >
> > Hi, Qingfang:
> >
> > DENG Qingfang <dqfext@gmail.com> 於 2021年4月6日 週二 下午10:19寫道：
> > > --- a/drivers/net/phy/Kconfig
> > > +++ b/drivers/net/phy/Kconfig
> > > @@ -207,6 +207,11 @@ config MARVELL_88X2222_PHY
> > >           Support for the Marvell 88X2222 Dual-port Multi-speed Ethernet
> > >           Transceiver.
> > >
> > > +config MEDIATEK_PHY
> >
> > There are many Mediatek phy drivers in [1], so use a specific name.
> 
> So "MEDIATEK_MT7530_PHY" should be okay?

No. MEDIATEK_PHY is consistent with other PHY drivers. Please leave it
as it is. And with time, we expect other devices will be supported by
this driver, so having MT7530 in the name would be confusing.

   Andrew
