Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A85B134A17
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 19:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730087AbgAHSGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 13:06:07 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:45047 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728971AbgAHSGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 13:06:06 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from yishaih@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 8 Jan 2020 20:06:05 +0200
Received: from vnc17.mtl.labs.mlnx (vnc17.mtl.labs.mlnx [10.7.2.17])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 008I64YB030018;
        Wed, 8 Jan 2020 20:06:04 +0200
Received: from vnc17.mtl.labs.mlnx (vnc17.mtl.labs.mlnx [127.0.0.1])
        by vnc17.mtl.labs.mlnx (8.13.8/8.13.8) with ESMTP id 008I64I4022318;
        Wed, 8 Jan 2020 20:06:04 +0200
Received: (from yishaih@localhost)
        by vnc17.mtl.labs.mlnx (8.13.8/8.13.8/Submit) id 008I64rF022317;
        Wed, 8 Jan 2020 20:06:04 +0200
From:   Yishai Hadas <yishaih@mellanox.com>
To:     linux-rdma@vger.kernel.org, jgg@mellanox.com, dledford@redhat.com
Cc:     saeedm@mellanox.com, yishaih@mellanox.com, maorg@mellanox.com,
        michaelgur@mellanox.com, netdev@vger.kernel.org
Subject: [PATCH rdma-next 01/10] net/mlx5: Expose relaxed ordering bits
Date:   Wed,  8 Jan 2020 20:05:31 +0200
Message-Id: <1578506740-22188-2-git-send-email-yishaih@mellanox.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <1578506740-22188-1-git-send-email-yishaih@mellanox.com>
References: <1578506740-22188-1-git-send-email-yishaih@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Guralnik <michaelgur@mellanox.com>

Expose relaxed ordering bits in HCA capability and mkey context structs.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Michael Guralnik <michaelgur@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 5d54fcc..8edcca4 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1160,7 +1160,8 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         log_max_cq[0x5];
 
 	u8         log_max_eq_sz[0x8];
-	u8         reserved_at_e8[0x2];
+	u8         relaxed_ordering_write[0x1];
+	u8         relaxed_ordering_read[0x1];
 	u8         log_max_mkey[0x6];
 	u8         reserved_at_f0[0x8];
 	u8         dump_fill_mkey[0x1];
@@ -3271,7 +3272,9 @@ struct mlx5_ifc_mkc_bits {
 
 	u8         translations_octword_size[0x20];
 
-	u8         reserved_at_1c0[0x1b];
+	u8         reserved_at_1c0[0x19];
+	u8         relaxed_ordering_read[0x1];
+	u8         reserved_at_1d9[0x1];
 	u8         log_page_size[0x5];
 
 	u8         reserved_at_1e0[0x20];
-- 
1.8.3.1

