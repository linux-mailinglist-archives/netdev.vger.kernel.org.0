Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4809F382611
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 10:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235612AbhEQIAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 04:00:51 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3710 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235386AbhEQIAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 04:00:12 -0400
Received: from dggems705-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FkBK66T9cz16QJx;
        Mon, 17 May 2021 15:56:10 +0800 (CST)
Received: from dggema704-chm.china.huawei.com (10.3.20.68) by
 dggems705-chm.china.huawei.com (10.3.19.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 17 May 2021 15:58:55 +0800
Received: from localhost.localdomain (10.67.165.2) by
 dggema704-chm.china.huawei.com (10.3.20.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 17 May 2021 15:58:54 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>, Jon Mason <jdmason@kudzu.us>
Subject: [PATCH v2 15/24] net: neterion: Fix wrong function name in comments
Date:   Mon, 17 May 2021 12:45:26 +0800
Message-ID: <20210517044535.21473-16-shenyang39@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210517044535.21473-1-shenyang39@huawei.com>
References: <20210517044535.21473-1-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.2]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggema704-chm.china.huawei.com (10.3.20.68)
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
index 9cfcd5500462..27a65ab3d501 100644
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
2.17.1

