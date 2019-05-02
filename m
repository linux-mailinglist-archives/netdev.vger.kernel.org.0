Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6506A1137A
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 08:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbfEBGoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 02:44:10 -0400
Received: from first.geanix.com ([116.203.34.67]:34224 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725772AbfEBGoK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 02:44:10 -0400
Received: from localhost (87-49-45-205-mobile.dk.customer.tdc.net [87.49.45.205])
        by first.geanix.com (Postfix) with ESMTPSA id 9CA5B308E60;
        Thu,  2 May 2019 06:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1556779432; bh=IK0D6zczZeZdKYv2r0AW45oME3lOQxyfMlPoQHK4S6Q=;
        h=From:To:Cc:Subject:Date;
        b=figuhPYRgcYIUEYVBAFaM/n9CsIBKURD1ZLfD9Xv7aZnnkp3HvxemTAr0i7/h5neg
         s/NxRPguK7LMcXExC1HCUVpJJD4tYa576PYKGyVkED7wG8bY3/ro9uwFO4YGf/pfns
         fIldqkH+GeND3M6my/Jt3wBm6kJdRU8l4IY02HnXrpEvNwy1+GmJ/BS6Ub0KYbd3Bl
         HqkzZN6qf9Wqiz5V4jSTG/wst/7Kg03t9qpbTt8cdfj1BQpA3cHcRJtgDQuGirIdxo
         2ix6doM4+pOwxu2JSWrawBHkyzhII3YqJELF2Y9+/jUDiQ/4vzH5q24U+51NNQtVFO
         ohVK1KwKP8DdQ==
From:   Esben Haabendal <esben@geanix.com>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, YueHaibing <yuehaibing@huawei.com>,
        Yang Wei <yang.wei9@zte.com.cn>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH] net: ll_temac: Fix typo bug for 32-bit
Date:   Thu,  2 May 2019 08:43:43 +0200
Message-Id: <20190502064406.12608-1-esben@geanix.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,UNPARSEABLE_RELAY,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on b7bf6291adac
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes: d84aec42151b ("net: ll_temac: Fix support for 64-bit platforms")

Signed-off-by: Esben Haabendal <esben@geanix.com>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 1003ee14c833..ca95c726269a 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -658,7 +658,7 @@ void *ptr_from_txbd(struct cdmac_bd *bd)
 
 #else
 
-void ptr_to_txbd(void *p, struct cmdac_bd *bd)
+void ptr_to_txbd(void *p, struct cdmac_bd *bd)
 {
 	bd->app4 = (u32)p;
 }
-- 
2.21.0

