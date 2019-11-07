Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B812F2330
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 01:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727669AbfKGASP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 19:18:15 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:52928 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727228AbfKGASP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 19:18:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IozkhT/J9M58uO1+SDJz9QLkV2w6YXY1U46TKPPM7YM=; b=hDadjPePXRNBwz1wBrrXQbmdjp
        Q0NbT/RRJT5s273Edk5zURPPsb+V4Np7s3o68I1LwvsFO4VcU5ORHL6RP6F+0Tqi1qqiXq/KDrxdI
        +io+kWMPvy7LNqXpUS9yXh2bJv0ICWj9d397W+Um/VH0fDuBY1jg8kLICCAh0KTP/+qk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iSVV5-0002KF-Hf; Thu, 07 Nov 2019 01:18:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next] net: dsa: mv8e6xxx: Fix stub function parameters
Date:   Thu,  7 Nov 2019 01:18:00 +0100
Message-Id: <20191107001800.8898-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mv88e6xxx_g2_atu_stats_get() takes two parameters. Make the stub
function also take two, otherwise we get compile errors.

Fixes: c5f299d59261 ("net: dsa: mv88e6xxx: global1_atu: Add helper for get next")
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/global2.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/global2.h b/drivers/net/dsa/mv88e6xxx/global2.h
index d80ad203d126..1f42ee656816 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.h
+++ b/drivers/net/dsa/mv88e6xxx/global2.h
@@ -532,7 +532,8 @@ static inline int mv88e6xxx_g2_atu_stats_set(struct mv88e6xxx_chip *chip,
 	return -EOPNOTSUPP;
 }
 
-static inline int mv88e6xxx_g2_atu_stats_get(struct mv88e6xxx_chip *chip)
+static inline int mv88e6xxx_g2_atu_stats_get(struct mv88e6xxx_chip *chip,
+					     u16 *stats)
 {
 	return -EOPNOTSUPP;
 }
-- 
2.23.0

