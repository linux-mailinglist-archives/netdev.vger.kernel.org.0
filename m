Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE682FB3AF
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 09:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731369AbhASIEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 03:04:37 -0500
Received: from smtp23.cstnet.cn ([159.226.251.23]:46470 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729939AbhASIDq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 03:03:46 -0500
Received: from localhost.localdomain (unknown [124.16.141.241])
        by APP-03 (Coremail) with SMTP id rQCowABXN_hekAZgstLTAA--.53709S2;
        Tue, 19 Jan 2021 15:55:10 +0800 (CST)
From:   Xu Wang <vulab@iscas.ac.cn>
To:     sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] octeontx2-af: debugfs: Remove unneeded semicolon
Date:   Tue, 19 Jan 2021 07:55:07 +0000
Message-Id: <20210119075507.17699-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: rQCowABXN_hekAZgstLTAA--.53709S2
X-Coremail-Antispam: 1UD129KBjvdXoW7JFyrtFWrtF1kAF47Kr17Wrg_yoWDtrcEkw
        nFgF43Aa1UGrWjyr1jyr45WrWv9a1DWF4vqr43K3yYyrW7J3y2k3ykur48Xr48Ww4FqFnx
        Ary7CF43Aw17tjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb2xYjsxI4VWkKwAYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I
        6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
        8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0
        cI8IcVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4
        A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IE
        w4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r4UJVWxJr
        1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkIecxEwVAFwVW8CwCF04k2
        0xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI
        8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41l
        IxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIx
        AIcVCF04k26cxKx2IYs7xG6Fyj6rWUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E
        87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUq6nQDUUUU
X-Originating-IP: [124.16.141.241]
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCQcFA102Z4IiQgACsk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fix semicolon.cocci warnings:
drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c:1788:3-4: Unneeded semicolon
drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c:1809:3-4: Unneeded semicolon

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index d27543c1a166..b5b5032a1aa2 100644
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
 
-- 
2.17.1

