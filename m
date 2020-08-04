Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E79F23B704
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 10:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729985AbgHDItU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 04:49:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:51948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726233AbgHDItU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Aug 2020 04:49:20 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 748E12075D;
        Tue,  4 Aug 2020 08:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596530960;
        bh=iPTzB/0FNkkPyFs1J2zI+iatblLznCorgEfaNkNxKPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DbX+0jUStqGvXt1X0RWH9aTfloGVNhN+PXkc7u0zS9q8nt9PX3zaviJ//0yLjaUbM
         j1DGV7kHR2Dh0LpMsEEGVeytGfVpO/XoprKG5KdFn+jD9avrpjUeMNlhmnhnrfZDgj
         eHjPkY+45kSG0wkwXiFpnC4t9wdmPeVbkJzbPdk0=
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Mark Zhang <markz@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Ido Kalir <idok@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: [PATCH iproute2-next 1/3] rdma: update uapi headers
Date:   Tue,  4 Aug 2020 11:49:07 +0300
Message-Id: <20200804084909.604846-2-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200804084909.604846-1-leon@kernel.org>
References: <20200804084909.604846-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

Update rdma_netlink.h file upto kernel commit 76251e15ea73
("RDMA/counter: Add PID category support in auto mode")

Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Ido Kalir <idok@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/include/uapi/rdma/rdma_netlink.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/rdma/include/uapi/rdma/rdma_netlink.h b/rdma/include/uapi/rdma/rdma_netlink.h
index fe127b88..4aef76ae 100644
--- a/rdma/include/uapi/rdma/rdma_netlink.h
+++ b/rdma/include/uapi/rdma/rdma_netlink.h
@@ -287,11 +287,11 @@ enum rdma_nldev_command {
 
 	RDMA_NLDEV_CMD_STAT_DEL,
 
-	RDMA_NLDEV_CMD_RES_QP_GET_RAW, /* can dump */
+	RDMA_NLDEV_CMD_RES_QP_GET_RAW,
 
-	RDMA_NLDEV_CMD_RES_CQ_GET_RAW, /* can dump */
+	RDMA_NLDEV_CMD_RES_CQ_GET_RAW,
 
-	RDMA_NLDEV_CMD_RES_MR_GET_RAW, /* can dump */
+	RDMA_NLDEV_CMD_RES_MR_GET_RAW,
 
 	RDMA_NLDEV_NUM_OPS
 };
@@ -531,7 +531,7 @@ enum rdma_nldev_attr {
 	 */
 	RDMA_NLDEV_ATTR_DEV_DIM,                /* u8 */
 
-	RDMA_NLDEV_ATTR_RES_RAW,                /* binary */
+	RDMA_NLDEV_ATTR_RES_RAW,	/* binary */
 
 	/*
 	 * Always the end
@@ -569,5 +569,6 @@ enum rdma_nl_counter_mode {
  */
 enum rdma_nl_counter_mask {
 	RDMA_COUNTER_MASK_QP_TYPE = 1,
+	RDMA_COUNTER_MASK_PID = 1 << 1,
 };
 #endif /* _RDMA_NETLINK_H */
-- 
2.26.2

