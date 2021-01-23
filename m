Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9BA3301208
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 02:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbhAWBde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 20:33:34 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55582 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725881AbhAWBdc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 20:33:32 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l37n4-002B2R-3T; Sat, 23 Jan 2021 02:32:38 +0100
Date:   Sat, 23 Jan 2021 02:32:38 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sergej Bauer <sbauer@blackbox.su>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Simon Horman <simon.horman@netronome.com>,
        Mark Einon <mark.einon@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Masahiro Yamada <masahiroy@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] lan743x: add virtual PHY for PHY-less devices
Message-ID: <YAt8trmR1FjGnCeF@lunn.ch>
References: <20210122214247.6536-1-sbauer@blackbox.su>
 <3174210.ndmClRx9B8@metabook>
 <5306ffe6-112c-83c9-826a-9bacd661691b@gmail.com>
 <4496952.bab7Homqhv@metabook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4496952.bab7Homqhv@metabook>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> it migth be helpful for developers work on userspace networking tools with
> PHY-less lan743x

(the interface even could not be brought up)
> of course, there nothing much to do without TP port but the difference is
> representative.
> 
> sbauer@metamini ~$ sudo ethtool eth7
> Settings for eth7:
> Cannot get device settings: No such device
>         Supports Wake-on: pumbag
>         Wake-on: d
>         Current message level: 0x00000137 (311)
>                                drv probe link ifdown ifup tx_queued
>         Link detected: no
> sbauer@metamini ~$ sudo ifup eth7
> sbauer@metamini ~$ sudo ethtool eth7
> Settings for eth7:
>         Supported ports: [ MII ]
>         Supported link modes:   10baseT/Full 
>                                 100baseT/Full 
>                                 1000baseT/Full 
>         Supported pause frame use: Symmetric Receive-only
>         Supports auto-negotiation: Yes
>         Supported FEC modes: Not reported
>         Advertised link modes:  10baseT/Full 
>                                 100baseT/Full 
>                                 1000baseT/Full 
>         Advertised pause frame use: Symmetric Receive-only
>         Advertised auto-negotiation: Yes
>         Advertised FEC modes: Not reported
>         Speed: 1000Mb/s
>         Duplex: Full
>         Port: MII
>         PHYAD: 0
>         Transceiver: internal
>         Auto-negotiation: on
>         Supports Wake-on: pumbag
>         Wake-on: d
>         Current message level: 0x00000137 (311)
>                                drv probe link ifdown ifup tx_queued
>         Link detected: yes
> sbauer@metamini ~$ sudo mii-tool -vv eth7
> Using SIOCGMIIPHY=0x8947
> eth7: negotiated 1000baseT-FD, link ok
>   registers for MII PHY 0: 
>     5140 512d 7431 0011 4140 4140 000d 0000
>     0000 0200 7800 0000 0000 0000 0000 2000
>     0000 0000 0000 0000 0000 0000 0000 0000
>     0000 0000 0000 0000 0000 0000 0000 0000
>   product info: vendor 1d:0c:40, model 1 rev 1
>   basic mode:   loopback, autonegotiation enabled
>   basic status: autonegotiation complete, link ok
>   capabilities: 1000baseT-FD 100baseTx-FD 10baseT-FD
>   advertising:  1000baseT-FD 100baseTx-FD 10baseT-FD
>   link partner: 1000baseT-FD 100baseTx-FD 10baseT-FD

You have not shown anything i cannot do with the ethernet interfaces i
have in my laptop. And since ethtool is pretty standardized, what
lan743x offers should be pretty much the same as any 1G Ethernet MAC
using most 1G PHYs.

      Andrew
