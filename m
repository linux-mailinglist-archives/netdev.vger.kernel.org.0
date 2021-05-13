Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0017B37F624
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 13:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232898AbhEMLBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 07:01:42 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:58892 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232226AbhEMLBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 07:01:33 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UYkXWdp_1620903615;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UYkXWdp_1620903615)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 13 May 2021 19:00:21 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     saeedm@nvidia.com
Cc:     leon@kernel.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] net/mlx5: Fix duplicate included vhca_event.h
Date:   Thu, 13 May 2021 19:00:14 +0800
Message-Id: <1620903614-65524-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clean up the following includecheck warning:

./drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c: vhca_event.h is
included more than once.

No functional change.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
index ef5f892..500c71f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
@@ -6,7 +6,6 @@
 #include "sf.h"
 #include "mlx5_ifc_vhca_event.h"
 #include "ecpf.h"
-#include "vhca_event.h"
 #include "mlx5_core.h"
 #include "eswitch.h"
 
-- 
1.8.3.1

