Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA6E3557D3
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 17:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243632AbhDFPa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 11:30:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35988 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229790AbhDFPaz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 11:30:55 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lTnf5-00F8jg-4x; Tue, 06 Apr 2021 17:30:39 +0200
Date:   Tue, 6 Apr 2021 17:30:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
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
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-staging@lists.linux.dev, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>
Subject: Re: [RFC net-next 2/4] net: dsa: mt7530: add interrupt support
Message-ID: <YGx+nyYkSY3Xu0Za@lunn.ch>
References: <20210406141819.1025864-1-dqfext@gmail.com>
 <20210406141819.1025864-3-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406141819.1025864-3-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 06, 2021 at 10:18:17PM +0800, DENG Qingfang wrote:
> Add support for MT7530 interrupt controller to handle internal PHYs.

Are the interrupts purely PHY interrupts? Or are there some switch
operation interrupts, which are currently not used?

I'm just wondering if it is correct to so closely tie interrupts and
MDIO together.

     Andrew
