Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59CEE29F69B
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 22:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgJ2VGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 17:06:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53228 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726200AbgJ2VGo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 17:06:44 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kYF7w-004EXZ-0x; Thu, 29 Oct 2020 22:06:32 +0100
Date:   Thu, 29 Oct 2020 22:06:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukasz Stelmach <l.stelmach@samsung.com>
Cc:     jim.cromie@gmail.com, Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        =?utf-8?Q?Bart=C5=82omiej_=C5=BBolnierkiewicz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v4 3/5] net: ax88796c: ASIX AX88796C SPI Ethernet Adapter
 Driver
Message-ID: <20201029210632.GT878328@lunn.ch>
References: <20201029003131.GF933237@lunn.ch>
 <CGME20201029203142eucas1p138b7a69cf72e5ad0b1ecd8134adcbccf@eucas1p1.samsung.com>
 <dleftjimasvknv.fsf%l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dleftjimasvknv.fsf%l.stelmach@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> +static irqreturn_t ax88796c_interrupt(int irq, void *dev_instance)
> >> +{
> >> +	struct net_device *ndev = dev_instance;
> >> +	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);

Do the assignment later.

   Andrew
