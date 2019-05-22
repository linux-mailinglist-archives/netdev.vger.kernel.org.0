Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2664C26A0D
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 20:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729198AbfEVSs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 14:48:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43572 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728734AbfEVSs2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 14:48:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version
        :Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IXW8t58L643gZwkC4+zldl+Wk6Vao5m0lRXkoSJxubY=; b=zeatx2kFT9uMfegJxE2gUShfg7
        29Iv++XD0hmCFm1PRKpP2T7/kpZV49ZkZNV/baXTiiD3kOBtRw5BkqtyHNH3/J9iDtamdRu67T1zD
        0UxV+UkBQyDdoJ62r5l/oy20re5dDUYoTH851lmxqgP8mer9+HdhLvTdfZ8JTetdjls0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hTWGr-0001t0-5k; Wed, 22 May 2019 20:47:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 0/2] net: phy: T1 support
Date:   Wed, 22 May 2019 20:47:02 +0200
Message-Id: <20190522184704.7195-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T1 PHYs make use of a single twisted pair, rather than the traditional
2 pair for 100BaseT or 4 pair for 1000BaseT. This patchset adds link
modes for 100BaseT1 and 1000BaseT1, and them makes use of 100BaseT1 in
the list of PHY features used by current T1 drivers.

---

The NXP PHY TJA1100 and TJA1101 have ability bits in the extended
status register to indicate they support 100BaseT1. However i've not
been able to verify that these bits are actually part of the 802.3
standard. They are not in the 802.3 2018. So at the moment i assume
they are proprietary.

Andrew Lunn (2):
  net: phy: Add support for 100BaseT1 and 1000BaseT1
  net: phy: Make phy_basic_t1_features use base100t1.

 drivers/net/phy/phy-core.c   | 4 +++-
 drivers/net/phy/phy_device.c | 2 +-
 include/uapi/linux/ethtool.h | 2 ++
 3 files changed, 6 insertions(+), 2 deletions(-)

-- 
2.20.1

