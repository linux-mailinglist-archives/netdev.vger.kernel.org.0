Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C05D42C3C5
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 16:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237386AbhJMOpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 10:45:50 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:40699 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233744AbhJMOpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 10:45:50 -0400
Received: (Authenticated sender: gregory.clement@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 70C2D1BF205;
        Wed, 13 Oct 2021 14:43:44 +0000 (UTC)
From:   Gregory CLEMENT <gregory.clement@bootlin.com>
To:     Marcel Ziswiler <marcel@ziswiler.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Marcel Ziswiler <marcel@ziswiler.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Frank Rowand <frowand.list@gmail.com>,
        Olof Johansson <olof@lixom.net>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        soc@kernel.org
Subject: Re: [PATCH v3 0/3] ARM: prepare and add netgear gs110emx support
In-Reply-To: <20211007205659.702842-1-marcel@ziswiler.com>
References: <20211007205659.702842-1-marcel@ziswiler.com>
Date:   Wed, 13 Oct 2021 16:43:38 +0200
Message-ID: <87ily1dlyd.fsf@BL-laptop>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Marcel Ziswiler,

> Cleanup mvebu_v7_defconfig and then add support for the Netgear
> GS110EMX which is an 8 port Gigabit switch with two additional
> Multi-Gig ports. An 88E6390X switch sits at its core connecting to two
> 88X3310P 10G PHYs while the control plane is handled by an 88F6811
> Armada 381 SoC.
>
> Changes in v3:
> - Got rid of unused 3.3 volt regulator as suggested by Andrew.
> - Got rid of partitioning comment.
> - Added switch interrupt GPIO configuration.
>
> Changes in v2:
> - Add Andrew's reviewed-by tag.
> - Add Andrew's reviewed-by tag.
> - Send previous first patch separately to netdev mailing list as
>   suggested by Andrew.
> - Fix numbering of the PHY labels as suggested by Andrew.
>
> Marcel Ziswiler (3):
>   ARM: mvebu_v7_defconfig: enable mtd physmap
>   ARM: mvebu_v7_defconfig: rebuild default configuration

Both applied on mvebu/defconfig

>   ARM: dts: mvebu: add device tree for netgear gs110emx switch

Applied on mvebu/dt

Thanks,

Gregory

>
>  arch/arm/boot/dts/Makefile                    |   1 +
>  .../boot/dts/armada-381-netgear-gs110emx.dts  | 295 ++++++++++++++++++
>  arch/arm/configs/mvebu_v7_defconfig           |  18 +-
>  3 files changed, 304 insertions(+), 10 deletions(-)
>  create mode 100644 arch/arm/boot/dts/armada-381-netgear-gs110emx.dts
>
> -- 
> 2.26.2
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

-- 
Gregory Clement, Bootlin
Embedded Linux and Kernel engineering
http://bootlin.com
