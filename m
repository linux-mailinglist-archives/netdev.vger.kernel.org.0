Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94DB4358A12
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 18:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232440AbhDHQsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 12:48:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40830 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231480AbhDHQsV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 12:48:21 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lUXoz-00FYhk-05; Thu, 08 Apr 2021 18:47:57 +0200
Date:   Thu, 8 Apr 2021 18:47:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
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
        linux-staging@lists.linux.dev,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>
Subject: Re: [RFC v3 net-next 0/4] MT7530 interrupt support
Message-ID: <YG8zvFKOdnzaJqLa@lunn.ch>
References: <20210408123919.2528516-1-dqfext@gmail.com>
 <20210408140255.Horde.Pl-DXtrqmiH9imsWjDqblfM@www.vdorst.com>
 <CALW65jZujSCk16RX_xgcg+NGrc9yyFQOQ9Y-z3qz-Qv1TvUQLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALW65jZujSCk16RX_xgcg+NGrc9yyFQOQ9Y-z3qz-Qv1TvUQLg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 08, 2021 at 11:00:08PM +0800, DENG Qingfang wrote:
> Hi René,
> 
> On Thu, Apr 8, 2021 at 10:02 PM René van Dorst <opensource@vdorst.com> wrote:
> >
> > Tested on Ubiquiti ER-X-SFP (MT7621) with 1 external phy which uses irq=POLL.
> >
> 
> I wonder if the external PHY's IRQ can be registered in the devicetree.
> Change MT7530_NUM_PHYS to 6, and add the following to ER-X-SFP dts PHY node:

I don't know this platform. What is the PHYs interrupt pin connected
to? A SoC GPIO? There is a generic mechanism to describe PHY
interrupts in DT. That should be used, if it is a GPIO.

	   Andrew
