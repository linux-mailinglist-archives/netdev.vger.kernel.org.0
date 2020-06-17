Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6781FD756
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 23:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbgFQVdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 17:33:40 -0400
Received: from gloria.sntech.de ([185.11.138.130]:48422 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726991AbgFQVdj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 17:33:39 -0400
Received: from ip5f5aa64a.dynamic.kabel-deutschland.de ([95.90.166.74] helo=phil.sntech)
        by gloria.sntech.de with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <heiko@sntech.de>)
        id 1jlfgW-00063V-J4; Wed, 17 Jun 2020 23:33:28 +0200
From:   Heiko Stuebner <heiko@sntech.de>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     robh+dt@kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, heiko@sntech.de,
        christoph.muellner@theobroma-systems.com
Subject: [PATCH v4 0/3] add clkout support to mscc phys
Date:   Wed, 17 Jun 2020 23:33:23 +0200
Message-Id: <20200617213326.1532365-1-heiko@sntech.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The main part of this series is adding handling of the clkout
controls some of the mscc phys have and while at it Andrew
asked for some of the duplicated probe functionality to be
factored out into a common function.

changes in v4:
- fix missing variable initialization in one probe function
changes in v3:
- adapt to 5.8 merge-window results
- introduce a more generic enet-phy-property instead of
  using a vsc8531,* one - suggested by Andrew
changes in v2:
- new probe factoring patch as suggested by Andrew


Heiko Stuebner (3):
  net: phy: mscc: move shared probe code into a helper
  dt-bindings: net: ethernet-phy: add enet-phy-clock-out-frequency
  net: phy: mscc: handle the clkout control on some phy variants

 .../devicetree/bindings/net/ethernet-phy.yaml |   5 +
 drivers/net/phy/mscc/mscc.h                   |   9 +
 drivers/net/phy/mscc/mscc_main.c              | 211 ++++++++++++------
 3 files changed, 155 insertions(+), 70 deletions(-)

-- 
2.26.2

