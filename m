Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4383436FA18
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 14:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232019AbhD3MZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 08:25:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47616 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230208AbhD3MZR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Apr 2021 08:25:17 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lcSBs-001oHb-52; Fri, 30 Apr 2021 14:24:16 +0200
Date:   Fri, 30 Apr 2021 14:24:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     David Miller <davem@davemloft.net>, f.fainelli@gmail.com,
        hkallweit1@gmail.com, kuba@kernel.org, Landen.Chao@mediatek.com,
        matthias.bgg@gmail.com, linux@armlinux.org.uk,
        sean.wang@mediatek.com, vivien.didelot@gmail.com,
        olteanv@gmail.com, robh+dt@kernel.org, linus.walleij@linaro.org,
        gregkh@linuxfoundation.org, sergio.paracuellos@gmail.com,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-staging@lists.linux.dev, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, weijie.gao@mediatek.com,
        gch981213@gmail.com, opensource@vdorst.com,
        frank-w@public-files.de, tglx@linutronix.de, maz@kernel.org
Subject: Re: [PATCH net-next 0/4] MT7530 interrupt support
Message-ID: <YIv28APpOP9tnuO+@lunn.ch>
References: <20210429062130.29403-1-dqfext@gmail.com>
 <20210429.170815.956010543291313915.davem@davemloft.net>
 <20210430023839.246447-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210430023839.246447-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 30, 2021 at 10:38:39AM +0800, DENG Qingfang wrote:
> On Thu, Apr 29, 2021 at 05:08:15PM -0700, David Miller wrote:
> > 
> > Please fix this:
> > 
> > error: the following would cause module name conflict:
> >   drivers/net/phy/mediatek.ko
> >   drivers/usb/musb/mediatek.ko
> 
> So I still have to rename the PHY driver..
> Andrew, what is your suggestion? Is mediatek_phy.c okay?

mediatek_phy.c gets you into trouble with the generic PHY drivers.
Most Ethernet PHY drivers have the model number in the file name. Does
the PHY have its own name/numbering, or is it always considered part
of the switch?  If the PHY has an identity of its own, use
that. Otherwise maybe mediatek75xx.c?

      Andrew
