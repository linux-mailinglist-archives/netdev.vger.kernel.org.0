Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8A9452FB43
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 13:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242513AbiEULNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 07:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242683AbiEULMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 07:12:06 -0400
Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E7E528E33;
        Sat, 21 May 2022 04:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=8fYJyg30jVrQqFQpOJmI0wxHHBVbkdTQBhJk6eEiDi8=;
  b=FWvKDSai1Ov/mxDSznsYrLA0RAMr9D2+KBw28LYTDtjjqk/dK2YTB2sE
   bPJ1RseFvavr4t9f6c8JaaLSMie1WhhogxLDit21HMRkxECJlvdRTuzfp
   o7+YfbObhZoPvZQVZp5SeKGwx6qz/Shlp/cNRrklQeEe3tt4b2iSzvRh3
   o=;
Authentication-Results: mail3-relais-sop.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Julia.Lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.91,242,1647298800"; 
   d="scan'208";a="14727916"
Received: from i80.paris.inria.fr (HELO i80.paris.inria.fr.) ([128.93.90.48])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2022 13:11:55 +0200
From:   Julia Lawall <Julia.Lawall@inria.fr>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     kernel-janitors@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net/mlx5: fix typo in comment
Date:   Sat, 21 May 2022 13:10:31 +0200
Message-Id: <20220521111145.81697-21-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Spelling mistake (triple letters) in comment.
Detected with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

---
 drivers/net/ethernet/mellanox/mlx5/core/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index fbd4dd76a19f..c9b4e50a593e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1769,7 +1769,7 @@ static int mlx5_try_fast_unload(struct mlx5_core_dev *dev)
 	}
 
 	/* Panic tear down fw command will stop the PCI bus communication
-	 * with the HCA, so the health polll is no longer needed.
+	 * with the HCA, so the health poll is no longer needed.
 	 */
 	mlx5_drain_health_wq(dev);
 	mlx5_stop_health_poll(dev, false);

