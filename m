Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB2A84A5148
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 22:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351171AbiAaVSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 16:18:05 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60080 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243070AbiAaVSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 16:18:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85C656154B
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 21:18:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0EFAC340E8;
        Mon, 31 Jan 2022 21:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643663881;
        bh=zOb4dyXxHOXdGppQPilNWBTbPYiR9esbAaqNh1GJ1j8=;
        h=From:To:Cc:Subject:Date:From;
        b=U+1DbB8Y48+uNoCJUKma3x+Ex/AYqFr0tHqu8e6XuAeagbr6uHlBIMx0Ig0IObNdg
         JgQC1rqAtExR0C3xbF4Sp7NC65XAqkM+4Z01y05f+ZxWvZtrt1zsCwowEbx7RM0bzI
         LvWIvO3iDg2tcUTnK3d4YMGuQeiDyae3JxkjpaPlTbt+4FzLExRH96G2ontoHt+uWV
         m7bMcQckg8l8wV+AT9oCdT28DEH3FIJKk04gN0nSk+mAY1tZ5qh8Z4LB5J8GZNaZn2
         2d3zWw4Edmy/e2JN0+9Hmcf+kP2zjCaqye+bpyjqf1UTJzRBXdYRIpY5tzWTo7QXlW
         LbN4euBsgzfKw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net] ethernet: smc911x: fix indentation in get/set EEPROM
Date:   Mon, 31 Jan 2022 13:17:30 -0800
Message-Id: <20220131211730.3940875-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Build bot produced a smatch indentation warning,
the code looks correct but it mixes spaces and tabs.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/smsc/smc911x.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/smsc/smc911x.c b/drivers/net/ethernet/smsc/smc911x.c
index dd6f69ced4ee..fc9cef9dcefc 100644
--- a/drivers/net/ethernet/smsc/smc911x.c
+++ b/drivers/net/ethernet/smsc/smc911x.c
@@ -1648,7 +1648,7 @@ static int smc911x_ethtool_geteeprom(struct net_device *dev,
 			return ret;
 		if ((ret=smc911x_ethtool_read_eeprom_byte(dev, &eebuf[i]))!=0)
 			return ret;
-		}
+	}
 	memcpy(data, eebuf+eeprom->offset, eeprom->len);
 	return 0;
 }
@@ -1667,11 +1667,11 @@ static int smc911x_ethtool_seteeprom(struct net_device *dev,
 			return ret;
 		/* write byte */
 		if ((ret=smc911x_ethtool_write_eeprom_byte(dev, *data))!=0)
-			 return ret;
+			return ret;
 		if ((ret=smc911x_ethtool_write_eeprom_cmd(dev, E2P_CMD_EPC_CMD_WRITE_, i ))!=0)
 			return ret;
-		}
-	 return 0;
+	}
+	return 0;
 }
 
 static int smc911x_ethtool_geteeprom_len(struct net_device *dev)
-- 
2.34.1

