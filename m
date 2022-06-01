Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05B54539E24
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 09:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343589AbiFAHYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 03:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236045AbiFAHYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 03:24:44 -0400
Received: from mail.meizu.com (edge05.meizu.com [157.122.146.251])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 882EF4EA3A;
        Wed,  1 Jun 2022 00:24:41 -0700 (PDT)
Received: from IT-EXMB-1-125.meizu.com (172.16.1.125) by mz-mail12.meizu.com
 (172.16.1.108) with Microsoft SMTP Server (TLS) id 14.3.487.0; Wed, 1 Jun
 2022 15:24:41 +0800
Received: from meizu.meizu.com (172.16.137.70) by IT-EXMB-1-125.meizu.com
 (172.16.1.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.14; Wed, 1 Jun
 2022 15:24:38 +0800
From:   Haowen Bai <baihaowen@meizu.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Haowen Bai <baihaowen@meizu.com>, <netdev@vger.kernel.org>,
        <linux-parisc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: tulip: de4x5: remove unused variable
Date:   Wed, 1 Jun 2022 15:24:36 +0800
Message-ID: <1654068277-6691-1-git-send-email-baihaowen@meizu.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.137.70]
X-ClientProxiedBy: IT-EXMB-1-126.meizu.com (172.16.1.126) To
 IT-EXMB-1-125.meizu.com (172.16.1.125)
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The variable imr is initialized but never used otherwise.

Signed-off-by: Haowen Bai <baihaowen@meizu.com>
---
 drivers/net/ethernet/dec/tulip/de4x5.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/dec/tulip/de4x5.c b/drivers/net/ethernet/dec/tulip/de4x5.c
index 71730ef4cd57..40a54827d599 100644
--- a/drivers/net/ethernet/dec/tulip/de4x5.c
+++ b/drivers/net/ethernet/dec/tulip/de4x5.c
@@ -3817,10 +3817,9 @@ de4x5_setup_intr(struct net_device *dev)
 {
     struct de4x5_private *lp = netdev_priv(dev);
     u_long iobase = dev->base_addr;
-    s32 imr, sts;
+    s32 sts;
 
     if (inl(DE4X5_OMR) & OMR_SR) {   /* Only unmask if TX/RX is enabled */
-	imr = 0;
 	UNMASK_IRQs;
 	sts = inl(DE4X5_STS);        /* Reset any pending (stale) interrupts */
 	outl(sts, DE4X5_STS);
-- 
2.7.4

