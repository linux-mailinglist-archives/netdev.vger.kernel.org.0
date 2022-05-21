Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B23F52FB4D
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 13:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242548AbiEULNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 07:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354887AbiEULMt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 07:12:49 -0400
Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E8357152;
        Sat, 21 May 2022 04:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=4GFEDHze4ivp/IarEmNbKeDJ6RHcXD17KTQnkvWrp5Y=;
  b=pBonOWM5+/0HHmoLLoRj4A7kbpaMsVsa4JewS9TkpdXwp9HkA5HPla5k
   wajtpeTcZwL9dKCRWtEPVMdL6UbThIKZHju3XBvsnlriS7nC+fWCyASw6
   ow4T4gBSsPSnBMhq5ewlAsab/FV23DoX+J7yop9KjT7KYsxqkp6dJjA5y
   0=;
Authentication-Results: mail3-relais-sop.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Julia.Lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.91,242,1647298800"; 
   d="scan'208";a="14727972"
Received: from i80.paris.inria.fr (HELO i80.paris.inria.fr.) ([128.93.90.48])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2022 13:12:03 +0200
From:   Julia Lawall <Julia.Lawall@inria.fr>
To:     Taras Chornyi <tchornyi@marvell.com>
Cc:     kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: marvell: prestera: fix typo in comment
Date:   Sat, 21 May 2022 13:11:16 +0200
Message-Id: <20220521111145.81697-66-Julia.Lawall@inria.fr>
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
 drivers/net/ethernet/marvell/prestera/prestera_rxtx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c b/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
index e452cdeaf703..dc3e3ddc60bf 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
@@ -102,7 +102,7 @@ struct prestera_sdma {
 	struct net_device napi_dev;
 	u32 map_addr;
 	u64 dma_mask;
-	/* protect SDMA with concurrrent access from multiple CPUs */
+	/* protect SDMA with concurrent access from multiple CPUs */
 	spinlock_t tx_lock;
 };
 

