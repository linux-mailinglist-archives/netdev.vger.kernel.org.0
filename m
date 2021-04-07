Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 897C3357855
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 01:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbhDGXOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 19:14:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39214 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229460AbhDGXOX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 19:14:23 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lUHN6-00FOxH-WC; Thu, 08 Apr 2021 01:14:04 +0200
Date:   Thu, 8 Apr 2021 01:14:04 +0200
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
Subject: Re: [RFC v2 net-next 1/4] net: phy: add MediaTek PHY driver
Message-ID: <YG48vMG/V55xS1pt@lunn.ch>
References: <20210407045038.1436843-1-dqfext@gmail.com>
 <20210407045038.1436843-2-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210407045038.1436843-2-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 07, 2021 at 12:50:35PM +0800, DENG Qingfang wrote:
> Add support for MediaTek PHYs found in MT7530 and MT7531 switches.
> The initialization procedure is from the vendor driver, but due to lack
> of documentation, the function of some register values remains unknown.
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
