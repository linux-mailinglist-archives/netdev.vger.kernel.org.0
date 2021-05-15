Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3647F3817DF
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 12:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235110AbhEOK5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 06:57:03 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3544 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232323AbhEOKzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 06:55:48 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fj2Jh4L9TzsR9G;
        Sat, 15 May 2021 18:51:48 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Sat, 15 May 2021 18:54:21 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>,
        Chris Snook <chris.snook@gmail.com>
Subject: [PATCH 04/34] net: atheros: atl1x: Fix wrong function name in comments
Date:   Sat, 15 May 2021 18:53:29 +0800
Message-ID: <1621076039-53986-5-git-send-email-shenyang39@huawei.com>
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

 drivers/net/ethernet/atheros/atlx/atl1.c:1020: warning: expecting prototype for atl1_setup_mem_resources(). Prototype was for atl1_setup_ring_resources() instead

Cc: Chris Snook <chris.snook@gmail.com>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
---
 drivers/net/ethernet/atheros/atlx/atl1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/atheros/atlx/atl1.c b/drivers/net/ethernet/atheros/atlx/atl1.c
index eaf96d0..c67201a 100644
--- a/drivers/net/ethernet/atheros/atlx/atl1.c
+++ b/drivers/net/ethernet/atheros/atlx/atl1.c
@@ -1011,7 +1011,7 @@ static int atl1_mii_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
 }
 
 /**
- * atl1_setup_mem_resources - allocate Tx / RX descriptor resources
+ * atl1_setup_ring_resources - allocate Tx / RX descriptor resources
  * @adapter: board private structure
  *
  * Return 0 on success, negative on failure
-- 
2.7.4

