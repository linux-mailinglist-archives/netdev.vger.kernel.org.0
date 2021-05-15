Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 500F03817F8
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 12:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235048AbhEOK6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 06:58:16 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3542 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232137AbhEOKz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 06:55:56 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fj2Jn5g1CzsRHh;
        Sat, 15 May 2021 18:51:53 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Sat, 15 May 2021 18:54:25 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>, Jon Mason <jdmason@kudzu.us>
Subject: [PATCH 15/34] net: neterion: Fix wrong function name in comments
Date:   Sat, 15 May 2021 18:53:40 +0800
Message-ID: <1621076039-53986-16-git-send-email-shenyang39@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621076039-53986-1-git-send-email-shenyang39@huawei.com>
References: <1621076039-53986-1-git-send-email-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/ethernet/neterion/s2io.c:2759: warning: expecting prototype for s2io_poll(). Prototype was for s2io_poll_msix() instead
 drivers/net/ethernet/neterion/s2io.c:5304: warning: expecting prototype for s2io_ethtol_get_link_ksettings(). Prototype was for s2io_ethtool_get_link_ksettings() instead

Cc: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
---
 drivers/net/ethernet/neterion/s2io.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
index 9cfcd55..27a65ab3 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -2743,7 +2743,7 @@ static int s2io_chk_rx_buffers(struct s2io_nic *nic, struct ring_info *ring)
 }
 
 /**
- * s2io_poll - Rx interrupt handler for NAPI support
+ * s2io_poll_msix - Rx interrupt handler for NAPI support
  * @napi : pointer to the napi structure.
  * @budget : The number of packets that were budgeted to be processed
  * during  one pass through the 'Poll" function.
@@ -5288,7 +5288,7 @@ s2io_ethtool_set_link_ksettings(struct net_device *dev,
 }
 
 /**
- * s2io_ethtol_get_link_ksettings - Return link specific information.
+ * s2io_ethtool_get_link_ksettings - Return link specific information.
  * @dev: pointer to netdev
  * @cmd : pointer to the structure with parameters given by ethtool
  * to return link information.
-- 
2.7.4

