Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4EB9C2EF8
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 10:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733040AbfJAIgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 04:36:06 -0400
Received: from hermes.aosc.io ([199.195.250.187]:51942 "EHLO hermes.aosc.io"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727957AbfJAIgG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 04:36:06 -0400
X-Greylist: delayed 345 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Oct 2019 04:36:05 EDT
Received: from localhost (localhost [127.0.0.1]) (Authenticated sender: icenowy@aosc.io)
        by hermes.aosc.io (Postfix) with ESMTPSA id F21C082889;
        Tue,  1 Oct 2019 08:30:15 +0000 (UTC)
From:   Icenowy Zheng <icenowy@aosc.io>
To:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@googlegroups.com, Icenowy Zheng <icenowy@aosc.io>
Subject: [PATCH 0/3] Pine64+ specific hacks for RTL8211E Ethernet PHY
Date:   Tue,  1 Oct 2019 16:29:09 +0800
Message-Id: <20191001082912.12905-1-icenowy@aosc.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There're some Pine64+ boards known to have broken RTL8211E chips, and
a hack is given by Pine64+, which is said to be from Realtek.

This patchset adds the hack.

The hack is taken from U-Boot, and it contains magic numbers without
any document.

Icenowy Zheng (3):
  dt-bindings: add binding for RTL8211E Ethernet PHY
  net: phy: realtek: add config hack for broken RTL8211E on Pine64+
    boards
  arm64: allwinner: a64: dts: apply hack for RTL8211E on Pine64+

 .../bindings/net/realtek,rtl8211e.yaml        | 23 +++++++++++++++++++
 .../dts/allwinner/sun50i-a64-pine64-plus.dts  |  1 +
 drivers/net/phy/realtek.c                     | 14 +++++++++++
 3 files changed, 38 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/realtek,rtl8211e.yaml

-- 
2.21.0

