Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB15C2C3411
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 23:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388899AbgKXWdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 17:33:11 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48390 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728844AbgKXWdL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 17:33:11 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1khgrs-008h2D-6H; Tue, 24 Nov 2020 23:33:00 +0100
Date:   Tue, 24 Nov 2020 23:33:00 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?utf-8?Q?=C5=81ukasz?= Stelmach <l.stelmach@samsung.com>
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
Subject: Re: [PATCH v7 3/3] net: ax88796c: ASIX AX88796C SPI Ethernet Adapter
 Driver
Message-ID: <20201124223300.GJ2036992@lunn.ch>
References: <20201124120330.32445-1-l.stelmach@samsung.com>
 <CGME20201124120337eucas1p268c7e3147ea36e62d40d252278c5dcb7@eucas1p2.samsung.com>
 <20201124120330.32445-4-l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201124120330.32445-4-l.stelmach@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 24, 2020 at 01:03:30PM +0100, Łukasz Stelmach wrote:
> ASIX AX88796[1] is a versatile ethernet adapter chip, that can be
> connected to a CPU with a 8/16-bit bus or with an SPI. This driver
> supports SPI connection.
> 
> The driver has been ported from the vendor kernel for ARTIK5[2]
> boards. Several changes were made to adapt it to the current kernel
> which include:
> 
> + updated DT configuration,
> + clock configuration moved to DT,
> + new timer, ethtool and gpio APIs,
> + dev_* instead of pr_* and custom printk() wrappers,
> + removed awkward vendor power managemtn.
> + introduced ethtool tunable to control SPI compression
> 
> [1] https://www.asix.com.tw/products.php?op=pItemdetail&PItemID=104;65;86&PLine=65
> [2] https://git.tizen.org/cgit/profile/common/platform/kernel/linux-3.10-artik/
> 
> The other ax88796 driver is for NE2000 compatible AX88796L chip. These
> chips are not compatible. Hence, two separate drivers are required.
> 
> Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
