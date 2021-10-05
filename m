Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39897421EAA
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 08:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232792AbhJEGGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 02:06:04 -0400
Received: from mout.perfora.net ([74.208.4.197]:47955 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232429AbhJEGFx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 02:05:53 -0400
Received: from toolbox.soleil.gust ([63.147.84.106]) by mrelay.perfora.net
 (mreueus002 [74.208.5.2]) with ESMTPSA (Nemesis) id 0M3i1X-1mokrY1IIb-00rHkS;
 Tue, 05 Oct 2021 08:03:45 +0200
From:   Marcel Ziswiler <marcel@ziswiler.com>
To:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Marcel Ziswiler <marcel@ziswiler.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Olof Johansson <olof@lixom.net>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, soc@kernel.org
Subject: [PATCH v1 0/4] ARM: prepare and add netgear gs110emx support
Date:   Tue,  5 Oct 2021 08:03:30 +0200
Message-Id: <20211005060334.203818-1-marcel@ziswiler.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:PHZoUWbg+wewrRDzZRFpkPO+la0hiffCSnS48JQgyvbfQBxdxal
 p+9TtNNMHp6vTPS36lRHMte5osoJBw7cEr1nEdexu0OX0tNpeD6ibRG9wpuBBgsqeWfPegL
 MaLNPyzVvZWN62Bkio9WP8W7UC2dkVa2lVjoJb1SGXRCw6EDoZhTmVajRsiqlzUfMx3MIbx
 Wp4tj2rNCuMDsevU7xfkA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:TCXgmKTrsOg=:HkEzz4khVLTBJfI+EmcSJC
 F+3Qrah5ofmBt0yP04evSgdAMrpyM8V92TSqYpLAwgZSiDoB1+TcuZIle0Ru2fPvv5CAtP86D
 lVxEALw7xkq+Krc2Mad6iB77RQq3XWSK9V/VhS81535F1B5NeSZYQzKhDhjRcdfJcFuLhsR2/
 UwShkj7SFm5NQ40TQQ6m9zMOBgESjwnoCqi0N2LRRMIy7uOh6vkSCenMZAQo3OC9Co7st0Jk4
 hZk8LSqV8eHciMyZLFEdWGBC+or5SnT5yY0GV6jjFdnWmxetB27Ckvp5FCaI6Ts0PxlXiM/hw
 +pjxYYS7ii1E2NSrNS8SgkUdI9vteezup2Zymc4X4YU8z7WiYsHtyq1XMMi/HgZ1qjX72xoUh
 U3lFkmUjZVqqeJf9z+GeE1YptiC+3/RhQsVfQLc3cSgz/ASqmQBnWt5g1P4ROcQ5JbSUn+jMQ
 KplXkfwF52lfBP1B3QrDIgt28Vs0lofsXVrWn4yHPhPqP1pL7/LOO85p0K+7jqLiCJkzeAUr3
 PRs1mgcvgjxwEw85o8HkfhnsRKUpz5yuSgIJ2DMn+0Y7kFgetLbiEyFI4xWl1QlIbznjpxoMp
 t/wJC8HUgKS/9OrSz1q24iJNQ21L5goMV3l30P78pTGmlPoS/DLhJfrHMBRv6OJS8xK2uLCPM
 2ows0/TnholAQAGpXRjZudYGBFAulan4TgwHprS1Es2YJqPCdfPEOpyPzpaJVu2D/HqKOgA6q
 bNsfjuv7yuEeT8AaEK9Ea9SFc9ic3FyvlRAkqg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Cleanup mvebu_v7_defconfig and then add support for the Netgear
GS110EMX which is an 8 port Gigabit switch with two additional
Multi-Gig ports. An 88E6390X switch sits at its core connecting to two
88X3310P 10G PHYs while the control plane is handled by an 88F6811
Armada 381 SoC.


Marcel Ziswiler (4):
  dt-bindings: net: dsa: marvell: fix compatible in example
  ARM: mvebu_v7_defconfig: enable mtd physmap
  ARM: mvebu_v7_defconfig: rebuild default configuration
  ARM: dts: mvebu: add device tree for netgear gs110emx switch

 .../devicetree/bindings/net/dsa/marvell.txt   |   2 +-
 arch/arm/boot/dts/Makefile                    |   1 +
 .../boot/dts/armada-381-netgear-gs110emx.dts  | 293 ++++++++++++++++++
 arch/arm/configs/mvebu_v7_defconfig           |  18 +-
 4 files changed, 303 insertions(+), 11 deletions(-)
 create mode 100644 arch/arm/boot/dts/armada-381-netgear-gs110emx.dts

-- 
2.26.2

