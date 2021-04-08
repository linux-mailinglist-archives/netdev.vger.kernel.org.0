Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BEC635858E
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 16:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231668AbhDHODJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 10:03:09 -0400
Received: from mx.i2x.nl ([5.2.79.48]:54860 "EHLO mx.i2x.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229803AbhDHODJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 10:03:09 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd00::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by mx.i2x.nl (Postfix) with ESMTPS id 486E75FAE1;
        Thu,  8 Apr 2021 16:02:56 +0200 (CEST)
Authentication-Results: mx.i2x.nl;
        dkim=pass (2048-bit key) header.d=vdorst.com header.i=@vdorst.com header.b="GaDX8GbP";
        dkim-atps=neutral
Received: from www (unknown [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id 0413FBC4A3C;
        Thu,  8 Apr 2021 16:02:56 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com 0413FBC4A3C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1617890576;
        bh=iTjQMjGaO13j0gfO948rxz1a3FR1rjNSKNPgqaVS82o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=GaDX8GbPzXFw0HGykitrLCBztl5DCDMQISYBbXc+j5DyttDBGVa34OOw5oeWseVqK
         TTW3Yqspd0SGsPQmN86G+682rx4ZXggI8IGKGtDB6cuWO3B1vIsPOboeLF8L+wZ8iH
         JfdHXoljUplYhnvpxxcU096xNsTkuLneoK1yqdkWDShETRx9iCDf7b39TzVOSBltN4
         8waSRdvcqba2R4SNDdSnH7+G1nDe98inN0JwJqnBshKh/ro91tBPYyYxeXYJUaokIy
         GUFtCRAvoFderbLegZHbq2mU8oPUqsIdYzfmgcKr99h36HisX3W2WCDqLYZAYokLCz
         lBxpMUBh//QEg==
Received: from 48.79.2.5.in-addr.arpa (48.79.2.5.in-addr.arpa [5.2.79.48])
 by www.vdorst.com (Horde Framework) with HTTPS; Thu, 08 Apr 2021 14:02:55
 +0000
Date:   Thu, 08 Apr 2021 14:02:55 +0000
Message-ID: <20210408140255.Horde.Pl-DXtrqmiH9imsWjDqblfM@www.vdorst.com>
From:   =?utf-8?b?UmVuw6k=?= van Dorst <opensource@vdorst.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
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
        Frank Wunderlich <frank-w@public-files.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>
Subject: Re: [RFC v3 net-next 0/4] MT7530 interrupt support
In-Reply-To: <20210408123919.2528516-1-dqfext@gmail.com>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting DENG Qingfang <dqfext@gmail.com>:

> Add support for MT7530 interrupt controller.
>
> DENG Qingfang (4):
>   net: phy: add MediaTek PHY driver
>   net: dsa: mt7530: add interrupt support
>   dt-bindings: net: dsa: add MT7530 interrupt controller binding
>   staging: mt7621-dts: enable MT7530 interrupt controller
>
>  .../devicetree/bindings/net/dsa/mt7530.txt    |   5 +
>  drivers/net/dsa/Kconfig                       |   1 +
>  drivers/net/dsa/mt7530.c                      | 266 ++++++++++++++++--
>  drivers/net/dsa/mt7530.h                      |  20 +-
>  drivers/net/phy/Kconfig                       |   5 +
>  drivers/net/phy/Makefile                      |   1 +
>  drivers/net/phy/mediatek.c                    | 112 ++++++++
>  drivers/staging/mt7621-dts/mt7621.dtsi        |   3 +
>  8 files changed, 384 insertions(+), 29 deletions(-)
>  create mode 100644 drivers/net/phy/mediatek.c
>
> --
> 2.25.1

I already tested v2 which works fine.
v3 works too.

Tested on Ubiquiti ER-X-SFP (MT7621) with 1 external phy which uses irq=POLL.

See dmesg log:

[   12.045645] mt7530 mdio-bus:1f eth0 (uninitialized): PHY  
[mt7530-0:00] driver [MediaTek MT7530 PHY] (irq=24)
[   12.425643] mt7530 mdio-bus:1f eth1 (uninitialized): PHY  
[mt7530-0:01] driver [MediaTek MT7530 PHY] (irq=25)
[   12.745642] mt7530 mdio-bus:1f eth2 (uninitialized): PHY  
[mt7530-0:02] driver [MediaTek MT7530 PHY] (irq=26)
[   13.065656] mt7530 mdio-bus:1f eth3 (uninitialized): PHY  
[mt7530-0:03] driver [MediaTek MT7530 PHY] (irq=27)
[   13.445657] mt7530 mdio-bus:1f eth4 (uninitialized): PHY  
[mt7530-0:04] driver [MediaTek MT7530 PHY] (irq=28)
[   13.785656] mt7530 mdio-bus:1f eth5 (uninitialized): PHY  
[mdio-bus:07] driver [Qualcomm Atheros AR8031/AR8033] (irq=POLL)

Tested-by: René van Dorst <opensource@vdorst.com>

Greats,

René

