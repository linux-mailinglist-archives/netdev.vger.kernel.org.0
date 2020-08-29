Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE112566D4
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 12:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbgH2Kgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Aug 2020 06:36:54 -0400
Received: from regular1.263xmail.com ([211.150.70.206]:56630 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726912AbgH2Kgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Aug 2020 06:36:52 -0400
Received: from localhost (unknown [192.168.167.70])
        by regular1.263xmail.com (Postfix) with ESMTP id 818FB39E;
        Sat, 29 Aug 2020 18:36:43 +0800 (CST)
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ADDR-CHECKED4: 1
X-ANTISPAM-LEVEL: 2
X-SKE-CHECKED: 1
X-ABS-CHECKED: 1
Received: from localhost.localdomain (unknown [14.18.236.70])
        by smtp.263.net (postfix) whith ESMTP id P24394T139658713364224S1598697398926370_;
        Sat, 29 Aug 2020 18:36:42 +0800 (CST)
X-IP-DOMAINF: 1
X-UNIQUE-TAG: <7f4d4f1dd4748de78646b41ba5878f0b>
X-RL-SENDER: yili@winhong.com
X-SENDER: yili@winhong.com
X-LOGIN-NAME: yili@winhong.com
X-FST-TO: linux-kernel@vger.kernel.org
X-SENDER-IP: 14.18.236.70
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
X-System-Flag: 0
From:   Yi Li <yili@winhong.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     yilikernel@gmail.com, yili@winhong.com, kuba@kernel.org,
        davem@davemloft.net, GR-everest-linux-l2@marvell.com,
        skalluru@marvell.com, aelior@marvell.com
Subject: [PATCH] bnx2x: correct a  mistake when show error code
Date:   Sat, 29 Aug 2020 18:36:37 +0800
Message-Id: <20200829103637.1730050-1-yili@winhong.com>
X-Mailer: git-send-email 2.25.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

use rc for error code.

Signed-off-by: Yi Li <yili@winhong.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
index 1426c691c7c4..0346771396ce 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
@@ -13562,9 +13560,8 @@ static int bnx2x_ext_phy_common_init(struct bnx2x *bp, u32 shmem_base_path[],
 	}
 
 	if (rc)
-		netdev_err(bp->dev,  "Warning: PHY was not initialized,"
-				      " Port %d\n",
-			 0);
+		netdev_err(bp->dev, "Warning: PHY was not initialized, Port %d\n",
+			   rc);
 	return rc;
 }
 
-- 
2.25.3



