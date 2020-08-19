Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C92524A342
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 17:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728781AbgHSPi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 11:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbgHSPiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 11:38:21 -0400
Received: from mail.nic.cz (lists.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B642C061757
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 08:38:21 -0700 (PDT)
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:8982:ed8c:62b1:c0c8])
        by mail.nic.cz (Postfix) with ESMTP id 47244140A8D;
        Wed, 19 Aug 2020 17:38:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1597851497; bh=Nz0gsJ6ra4WThxAweXAum/S9Pdoy/C8Vdv8pbq0cAek=;
        h=From:To:Date;
        b=YdZovzTZwr6Sykh/KVkVCc0gAQNoCm0muS8oL1Vr9gC4n/HmRtZDDhLTfdieyMjkD
         XgGwmfFTIRe6CRSGyhDijVAc/QJkEv64RrGhNIo4QZquhFP0UapZ4856Yw+ufjnsX1
         HlV7emU1hsu6olboPkdvetKXEwcuXDZf0aqkcq5U=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH net-next 0/3] net: dsa: mv88e6xxx: Add Amethyst 88E6393X
Date:   Wed, 19 Aug 2020 17:38:13 +0200
Message-Id: <20200819153816.30834-1-marek.behun@nic.cz>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Spam-Status: No, score=0.00
X-Spamd-Bar: /
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

this adds support for one Marvell switch from the Amethyst family,
88E6393X.

USXGMII mode is not supported, nor SERDES stats nor SERDES register dumps.

Tested on Marvell CN9130 Customer Reference Board.

Marek

Marek Behún (3):
  net: phy: add interface mode PHY_INTERFACE_MODE_5GBASER.
  net: dsa: mv88e6xxx: return error instead of lane in .serdes_get_lane
  net: dsa: mv88e6xxx: add support for 88E6393X from Amethyst family

 drivers/net/dsa/mv88e6xxx/chip.c   | 130 +++++++++++++++---
 drivers/net/dsa/mv88e6xxx/chip.h   |   6 +-
 drivers/net/dsa/mv88e6xxx/port.c   |  87 ++++++++++--
 drivers/net/dsa/mv88e6xxx/port.h   |   9 ++
 drivers/net/dsa/mv88e6xxx/serdes.c | 204 +++++++++++++++++++++++------
 drivers/net/dsa/mv88e6xxx/serdes.h |  24 ++--
 include/linux/phy.h                |   3 +
 7 files changed, 389 insertions(+), 74 deletions(-)

-- 
2.26.2

