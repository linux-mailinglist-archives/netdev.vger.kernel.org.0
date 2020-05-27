Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09B4B1E3DDA
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 11:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729196AbgE0Jqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 05:46:42 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:51564 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729072AbgE0Jql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 05:46:41 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from maxg@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 27 May 2020 12:46:35 +0300
Received: from mtr-vdi-031.wap.labs.mlnx. (mtr-vdi-031.wap.labs.mlnx [10.209.102.136])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 04R9kYii009430;
        Wed, 27 May 2020 12:46:35 +0300
From:   Max Gurtovoy <maxg@mellanox.com>
To:     jgg@mellanox.com, dledford@redhat.com, leon@kernel.org,
        galpress@amazon.com, dennis.dalessandro@intel.com,
        netdev@vger.kernel.org, sagi@grimberg.me,
        linux-rdma@vger.kernel.org, bvanassche@acm.org,
        santosh.shilimkar@oracle.com, tom@talpey.com
Cc:     aron.silverton@oracle.com, israelr@mellanox.com, oren@mellanox.com,
        shlomin@mellanox.com, vladimirk@mellanox.com,
        Max Gurtovoy <maxg@mellanox.com>
Subject: [PATCH 1/9] RDMA/mlx5: Remove FMR leftovers
Date:   Wed, 27 May 2020 12:46:26 +0300
Message-Id: <20200527094634.24240-2-maxg@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200527094634.24240-1-maxg@mellanox.com>
References: <20200527094634.24240-1-maxg@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gal Pressman <galpress@amazon.com>

Remove a few leftovers from FMR functionality which are no longer used.

Signed-off-by: Gal Pressman <galpress@amazon.com>
Signed-off-by: Max Gurtovoy <maxg@mellanox.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index a4e5223..211ec84 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -702,12 +702,6 @@ struct umr_common {
 	struct semaphore	sem;
 };
 
-enum {
-	MLX5_FMR_INVALID,
-	MLX5_FMR_VALID,
-	MLX5_FMR_BUSY,
-};
-
 struct mlx5_cache_ent {
 	struct list_head	head;
 	/* sync access to the cahce entry
@@ -1283,8 +1277,6 @@ int mlx5_query_mad_ifc_port(struct ib_device *ibdev, u8 port,
 			    struct ib_port_attr *props);
 int mlx5_ib_query_port(struct ib_device *ibdev, u8 port,
 		       struct ib_port_attr *props);
-int mlx5_ib_init_fmr(struct mlx5_ib_dev *dev);
-void mlx5_ib_cleanup_fmr(struct mlx5_ib_dev *dev);
 void mlx5_ib_cont_pages(struct ib_umem *umem, u64 addr,
 			unsigned long max_page_shift,
 			int *count, int *shift,
-- 
1.8.3.1

