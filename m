Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38F04207156
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 12:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390444AbgFXKkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 06:40:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:60076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388197AbgFXKkV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 06:40:21 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3FF820644;
        Wed, 24 Jun 2020 10:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592995221;
        bh=/LuP1CKMXdtgZUDTYAu2VlJFVHifJlNcs9/SpCpdqzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=clENcuFgJfi9vdrHOfJH/jfZsNMmZQehsIINg2HVTZLkZDZ6BU1wqiBqpcer3Ln93
         Icads1/WfK0CYfp0xx/B/5fNnCDcEeH8r6OuxKiWZwXXBFYsWX0b2Rfb7u12NBRIi8
         JZ2ok6HSoU0ynHnG4JA30veEd217MVg0pd2UAhDY=
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Maor Gottlieb <maorg@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: [PATCH iproute2-next v1 1/4] rdma: update uapi headers
Date:   Wed, 24 Jun 2020 13:40:09 +0300
Message-Id: <20200624104012.1450880-2-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200624104012.1450880-1-leon@kernel.org>
References: <20200624104012.1450880-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

Update rdma_netlink.h file upto kernel commit ba1f4991cc55
("RDMA: Add support to dump resource tracker in RAW format")

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/include/uapi/rdma/rdma_netlink.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/rdma/include/uapi/rdma/rdma_netlink.h b/rdma/include/uapi/rdma/rdma_netlink.h
index ae5a77a1..fe127b88 100644
--- a/rdma/include/uapi/rdma/rdma_netlink.h
+++ b/rdma/include/uapi/rdma/rdma_netlink.h
@@ -287,6 +287,12 @@ enum rdma_nldev_command {
 
 	RDMA_NLDEV_CMD_STAT_DEL,
 
+	RDMA_NLDEV_CMD_RES_QP_GET_RAW, /* can dump */
+
+	RDMA_NLDEV_CMD_RES_CQ_GET_RAW, /* can dump */
+
+	RDMA_NLDEV_CMD_RES_MR_GET_RAW, /* can dump */
+
 	RDMA_NLDEV_NUM_OPS
 };
 
@@ -525,6 +531,8 @@ enum rdma_nldev_attr {
 	 */
 	RDMA_NLDEV_ATTR_DEV_DIM,                /* u8 */
 
+	RDMA_NLDEV_ATTR_RES_RAW,                /* binary */
+
 	/*
 	 * Always the end
 	 */
-- 
2.26.2

