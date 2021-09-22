Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0EC74143C8
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 10:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233921AbhIVIae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 04:30:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:59818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233920AbhIVIad (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 04:30:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FFE661209;
        Wed, 22 Sep 2021 08:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632299343;
        bh=jiouLZz/Q+SP5VeEmlrPZJs67Kq3f6zq2uFUufcpsU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u8iSEtjRQHgxCjmxzdYWpPZgmAJV5BOv6yn4BasFo3tQ7930k2QUcBO0qayA1AqKH
         huNleNfciYMVDrezWun72CGCWZmqbAKbBcVMk5ML9Jt6j/eQs5ad9/CyDS67rqKz6k
         ioUsQORt2e2b23jeyF1IoGOcu8Yfq2OSlLjMp+UX5kmk62W3rZLb9Pfbc4KCgIetIb
         nEd8Ch1iA652VjVdzMj7iMIhIpymYTQWMT12C+PQFsYc/txGGa2+ob4tf9baYjt0PY
         qIBw0LY/yjLWT1ThXv9IubRESXdFfuXZrMNhUgO+O7AOxBVZ23dfBKPNzru7+34kC3
         DXoYLmu/mud/w==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Meir Lichtinger <meirl@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: [PATCH mlx5-next v1 1/2] net/mlx5: Add uid field to UAR allocation structures
Date:   Wed, 22 Sep 2021 11:28:50 +0300
Message-Id: <07aec04b44ccb6bf96fc050cc735610aa480a40b.1632299184.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1632299184.git.leonro@nvidia.com>
References: <cover.1632299184.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Meir Lichtinger <meirl@nvidia.com>

Add uid field to mlx5_ifc_alloc_uar_in_bits and
mlx5_ifc_dealloc_uar_out_bits structs.

This field will be used by FW to manage UAR according to uid.

Signed-off-by: Meir Lichtinger <meirl@nvidia.com>
Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 52e5baad3b93..4a7e6914ed9b 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -7573,7 +7573,7 @@ struct mlx5_ifc_dealloc_uar_out_bits {
 
 struct mlx5_ifc_dealloc_uar_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -8420,7 +8420,7 @@ struct mlx5_ifc_alloc_uar_out_bits {
 
 struct mlx5_ifc_alloc_uar_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
-- 
2.31.1

