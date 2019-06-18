Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4172B4A844
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 19:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729754AbfFRR0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 13:26:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:53126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728572AbfFRR0g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 13:26:36 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAA702147A;
        Tue, 18 Jun 2019 17:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560878795;
        bh=2D2NeSPWZPNZcduHNijpZLr6l3dgtHqKsRrKaEMfmMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y73BW3k/JsFfoo5z/g9CyVnGZlX5igufee96AF9uMOJIQ9NnWPiwtjR4z9hrEViHv
         qXPWq2+vQLeFFozUO0952wjl4fuQcL2/Nk7jOFol1qkM6bb3AUyYq4zRYiR84oZ3gQ
         LLBrW/A84Q2agHZZzEPUcMQw4HfPCdY0cbprVyyE=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH mlx5-next v4 01/17] net/mlx5: Add rts2rts_qp_counters_set_id field in hca cap
Date:   Tue, 18 Jun 2019 20:26:09 +0300
Message-Id: <20190618172625.13432-2-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190618172625.13432-1-leon@kernel.org>
References: <20190618172625.13432-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

Add rts2rts_qp_counters_set_id field in hca cap so that RTS2RTS
qp modification can be used to change the counter of a QP.

Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Majd Dibbiny <majd@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index e3c154b573a2..16348528fef6 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1028,7 +1028,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         cc_modify_allowed[0x1];
 	u8         start_pad[0x1];
 	u8         cache_line_128byte[0x1];
-	u8         reserved_at_165[0xa];
+	u8         reserved_at_165[0x4];
+	u8         rts2rts_qp_counters_set_id[0x1];
+	u8         reserved_at_16a[0x5];
 	u8         qcam_reg[0x1];
 	u8         gid_table_size[0x10];

--
2.20.1

