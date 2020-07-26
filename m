Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E12922DE71
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 13:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727894AbgGZLUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 07:20:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:46884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725794AbgGZLUW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jul 2020 07:20:22 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D38720663;
        Sun, 26 Jul 2020 11:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595762422;
        bh=EGEVcZJz8TEJ1iOibvqzpe04pfAUDkgdNqV/JheeLNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1IaZe0RO0K+Rg52yzV1TxAvHFDm5wFDxs+NepuDqSrdqe03sQoMErPMzqgjH5iLCe
         r5PPXdIhhp5EbCRTLoTu9gIpd7HT0LkE6nIzGujm48DYltLM0dOwH6yabS9sYG1lud
         K3ZubSdrvNg0jkb3/75E+KnN2S1trOsOOQtvDsZM=
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Mark Zhang <markz@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Ido Kalir <idok@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: [RFC PATCH iproute2-next 1/3] rdma: update uapi headers
Date:   Sun, 26 Jul 2020 14:20:09 +0300
Message-Id: <20200726112011.75905-2-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200726112011.75905-1-leon@kernel.org>
References: <20200726112011.75905-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

Update rdma_netlink.h file upto kernel commit 7c97f3aded10
("RDMA/counter: Add PID category support in auto mode")

Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Ido Kalir <idok@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/include/uapi/rdma/rdma_netlink.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rdma/include/uapi/rdma/rdma_netlink.h b/rdma/include/uapi/rdma/rdma_netlink.h
index fe127b88..5fbf395b 100644
--- a/rdma/include/uapi/rdma/rdma_netlink.h
+++ b/rdma/include/uapi/rdma/rdma_netlink.h
@@ -565,9 +565,9 @@ enum rdma_nl_counter_mode {

 /*
  * Supported criteria in counter auto mode.
- * Currently only "qp type" is supported
  */
 enum rdma_nl_counter_mask {
 	RDMA_COUNTER_MASK_QP_TYPE = 1,
+	RDMA_COUNTER_MASK_PID = 1 << 1,
 };
 #endif /* _RDMA_NETLINK_H */
--
2.26.2

