Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6B242E768B
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 07:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbgL3G3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 01:29:42 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:45668 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726356AbgL3G3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 01:29:41 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=abaci-bugfix@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0UKCbjMc_1609309732;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:abaci-bugfix@linux.alibaba.com fp:SMTPD_---0UKCbjMc_1609309732)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 30 Dec 2020 14:28:59 +0800
From:   YANG LI <abaci-bugfix@linux.alibaba.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, tariqt@nvidia.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, YANG LI <abaci-bugfix@linux.alibaba.com>
Subject: [PATCH] mlx4: style: replace zero-length array with flexible-array member.
Date:   Wed, 30 Dec 2020 14:28:51 +0800
Message-Id: <1609309731-70464-1-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a regular need in the kernel to provide a way to declare
having a dynamically sized set of trailing elements in a structure.
Kernel code should always use "flexible array members"[1] for these
cases. The older style of one-element or zero-length arrays should
no longer be used[2].

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://www.kernel.org/doc/html/v5.9/process/
    deprecated.html#zero-length-and-one-element-arrays

Signed-off-by: YANG LI <abaci-bugfix@linux.alibaba.com>
Reported-by: Abaci <abaci@linux.alibaba.com>
---
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
index e8ed2319..4029a8b 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
@@ -314,7 +314,7 @@ struct mlx4_en_tx_ring {
 
 struct mlx4_en_rx_desc {
 	/* actual number of entries depends on rx ring stride */
-	struct mlx4_wqe_data_seg data[0];
+	struct mlx4_wqe_data_seg data[];
 };
 
 struct mlx4_en_rx_ring {
-- 
1.8.3.1

