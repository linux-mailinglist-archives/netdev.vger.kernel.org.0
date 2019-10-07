Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6ED0CE104
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 13:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727730AbfJGL61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 07:58:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:56838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727561AbfJGL61 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 07:58:27 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64C5B206C2;
        Mon,  7 Oct 2019 11:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570449507;
        bh=FUHoCM9U2W2uQk6HDXmkiydK6wbVQVxkxHd0kP8tvgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ICe01VEye1+YWHpPH4uI9k6yTF3WFowpIOvFdMcCaZpFc/hafKjD2/IwC0dV2MUXN
         mr/JNmov5ZAMpnP9BT43wKUqgPNkblnid2Mp1lnDqT+nPVA6QrIJEQSn+4Q3qqnXUi
         QiiN7gVUO0BZVADtVbtIJDdeB/kS11MzK2eQlCVg=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yamin Friedman <yaminf@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH mlx5-next v1 1/3] net/mlx5: Expose optimal performance scatter entries capability
Date:   Mon,  7 Oct 2019 14:58:17 +0300
Message-Id: <20191007115819.9211-2-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191007115819.9211-1-leon@kernel.org>
References: <20191007115819.9211-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yamin Friedman <yaminf@mellanox.com>

Expose maximum scatter entries per RDMA READ for optimal performance.

Signed-off-by: Yamin Friedman <yaminf@mellanox.com>
Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 138c50d5a353..c0bfb1d90dd2 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1153,7 +1153,7 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         log_max_srq[0x5];
 	u8         reserved_at_b0[0x10];

-	u8         reserved_at_c0[0x8];
+	u8         max_sgl_for_optimized_performance[0x8];
 	u8         log_max_cq_sz[0x8];
 	u8         reserved_at_d0[0xb];
 	u8         log_max_cq[0x5];
--
2.20.1

