Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E27B4A8895
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 17:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352221AbiBCQb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 11:31:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352217AbiBCQbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 11:31:19 -0500
Received: from mail.sf-mail.de (mail.sf-mail.de [IPv6:2a01:4f8:1c17:6fae:616d:6c69:616d:6c69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF1BC06173D
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 08:31:18 -0800 (PST)
Received: (qmail 17231 invoked from network); 3 Feb 2022 16:22:54 -0000
Received: from p200300cf070ba5000c0051fffe8bdde4.dip0.t-ipconnect.de ([2003:cf:70b:a500:c00:51ff:fe8b:dde4]:41726 HELO eto.sf-tec.de) (auth=eike@sf-mail.de)
        by mail.sf-mail.de (Qsmtpd 0.38dev) with (TLS_AES_256_GCM_SHA384 encrypted) ESMTPSA
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 17:22:54 +0100
From:   Rolf Eike Beer <eike-kernel@sf-tec.de>
To:     netdev@vger.kernel.org
Subject: [PATCH 1/3] sunhme: remove unused tx_dump_ring()
Date:   Thu, 03 Feb 2022 17:21:33 +0100
Message-ID: <12947229.uLZWGnKmhe@eto.sf-tec.de>
In-Reply-To: <4686583.GXAFRqVoOG@eto.sf-tec.de>
References: <4686583.GXAFRqVoOG@eto.sf-tec.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I can't find a reference to it in the entire git history.

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
---
 drivers/net/ethernet/sun/sunhme.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index ad9029ae6848..22abfe58f728 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -135,25 +135,9 @@ static __inline__ void tx_dump_log(void)
 		this = (this + 1) & (TX_LOG_LEN - 1);
 	}
 }
-static __inline__ void tx_dump_ring(struct happy_meal *hp)
-{
-	struct hmeal_init_block *hb = hp->happy_block;
-	struct happy_meal_txd *tp = &hb->happy_meal_txd[0];
-	int i;
-
-	for (i = 0; i < TX_RING_SIZE; i+=4) {
-		printk("TXD[%d..%d]: [%08x:%08x] [%08x:%08x] [%08x:%08x] [%08x:%08x]\n",
-		       i, i + 4,
-		       le32_to_cpu(tp[i].tx_flags), le32_to_cpu(tp[i].tx_addr),
-		       le32_to_cpu(tp[i + 1].tx_flags), le32_to_cpu(tp[i + 1].tx_addr),
-		       le32_to_cpu(tp[i + 2].tx_flags), le32_to_cpu(tp[i + 2].tx_addr),
-		       le32_to_cpu(tp[i + 3].tx_flags), le32_to_cpu(tp[i + 3].tx_addr));
-	}
-}
 #else
 #define tx_add_log(hp, a, s)		do { } while(0)
 #define tx_dump_log()			do { } while(0)
-#define tx_dump_ring(hp)		do { } while(0)
 #endif
 
 #ifdef HMEDEBUG
-- 
2.31.1




