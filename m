Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEB830D15B
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 03:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232053AbhBCCSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 21:18:05 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:60509 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230087AbhBCCSA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 21:18:00 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UNj9FBx_1612318632;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0UNj9FBx_1612318632)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 03 Feb 2021 10:17:12 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, sgoutham@marvell.com, lcherian@marvell.com,
        gakula@marvell.com, jerinj@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH] octeontx2-af: remove unneeded semicolon
Date:   Wed,  3 Feb 2021 10:17:11 +0800
Message-Id: <1612318631-101349-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eliminate the following coccicheck warning:
./drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c:272:2-3:
Unneeded semicolon
./drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c:1809:3-4:
Unneeded semicolon
./drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c:1788:3-4:
Unneeded semicolon
./drivers/net/ethernet/marvell/octeontx2/af/rvu.c:1326:2-3: Unneeded
semicolon

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c         | 2 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c | 4 ++--
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c  | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index e8fd712..0b6bf9f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -1323,7 +1323,7 @@ static int rvu_get_attach_blkaddr(struct rvu *rvu, int blktype,
 		break;
 	default:
 		return rvu_get_blkaddr(rvu, blktype, 0);
-	};
+	}
 
 	if (is_block_implemented(rvu->hw, blkaddr))
 		return blkaddr;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index d27543c..b5b5032 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -1785,7 +1785,7 @@ static void rvu_dbg_npc_mcam_show_action(struct seq_file *s,
 			break;
 		default:
 			break;
-		};
+		}
 	} else {
 		switch (rule->rx_action.op) {
 		case NIX_RX_ACTIONOP_DROP:
@@ -1806,7 +1806,7 @@ static void rvu_dbg_npc_mcam_show_action(struct seq_file *s,
 			break;
 		default:
 			break;
-		};
+		}
 	}
 }
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
index 14832b6..f72c795 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -269,7 +269,7 @@ static void npc_scan_parse_result(struct npc_mcam *mcam, u8 bit_number,
 		break;
 	default:
 		return;
-	};
+	}
 	npc_set_kw_masks(mcam, type, nr_bits, kwi, offset, intf);
 }
 
-- 
1.8.3.1

