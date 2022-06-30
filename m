Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 021AE56141F
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 10:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233455AbiF3IEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 04:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233466AbiF3IEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 04:04:39 -0400
Received: from smtpbg.qq.com (unknown [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B9540A02;
        Thu, 30 Jun 2022 01:04:32 -0700 (PDT)
X-QQ-mid: bizesmtp75t1656576246ti3ilpgf
Received: from localhost.localdomain ( [182.148.13.66])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 30 Jun 2022 16:04:02 +0800 (CST)
X-QQ-SSF: 0100000000200070C000C00A0000000
X-QQ-FEAT: 3uawQE1sH+2IcMwGXDlgsuszRdK3oGrUVfsZw9Abpp35ifjI0BwdKZCK4TdIY
        VVbQqZwRJ1wxM27XUDyzxuKtLBC0exh3iwdsWxNnUOKET3yD3eAy9hS1JhzVTO501LuoFZD
        TPLIHRV8SBN4cmRyv4yt1OWKiVQ0noVTUjF59PDZOyYUsGKI0CPa5rXsVIOOaMqTWsiqLL6
        kFd0WZ1hnxWuzKl/6gYmx3dq6hxem+xlTLyry3n/nZ4Tuv02lGR9xhPZ7T6GNNRV4erDrF4
        /M2gtaWVe6Kkjom5m3GyvgvBRBk771l1TW+OOKKfHR7xTNgG30qMRmjaINvCWtfzbPza9/r
        dOcF3ZyYZi9GE7p1Sj+zG1bIdiH8A==
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     jdmason@kudzu.us, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] neterion/vxge: fix repeated words in comments
Date:   Thu, 30 Jun 2022 16:03:55 +0800
Message-Id: <20220630080355.53566-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr4
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete the redundant word 'frame'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/ethernet/neterion/vxge/vxge-config.c  | 2 +-
 drivers/net/ethernet/neterion/vxge/vxge-ethtool.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/neterion/vxge/vxge-config.c b/drivers/net/ethernet/neterion/vxge/vxge-config.c
index a3204a7ef750..b6ee004058e5 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-config.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-config.c
@@ -1899,7 +1899,7 @@ u32 vxge_hw_device_trace_level_get(struct __vxge_hw_device *hldev)
 }
 
 /*
- * vxge_hw_getpause_data -Pause frame frame generation and reception.
+ * vxge_hw_getpause_data -Pause frame generation and reception.
  * Returns the Pause frame generation and reception capability of the NIC.
  */
 enum vxge_hw_status vxge_hw_device_getpause_data(struct __vxge_hw_device *hldev,
diff --git a/drivers/net/ethernet/neterion/vxge/vxge-ethtool.c b/drivers/net/ethernet/neterion/vxge/vxge-ethtool.c
index 4d91026485ae..f371cfd09ea2 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-ethtool.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-ethtool.c
@@ -185,7 +185,7 @@ static int vxge_ethtool_idnic(struct net_device *dev,
 }
 
 /**
- * vxge_ethtool_getpause_data - Pause frame frame generation and reception.
+ * vxge_ethtool_getpause_data - Pause frame generation and reception.
  * @dev : device pointer.
  * @ep : pointer to the structure with pause parameters given by ethtool.
  * Description:
-- 
2.36.1

