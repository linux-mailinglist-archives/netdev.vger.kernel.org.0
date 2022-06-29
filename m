Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EED555F9C6
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 09:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232480AbiF2Hzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 03:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232488AbiF2Hz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 03:55:28 -0400
Received: from mail.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 93D7A10FC6;
        Wed, 29 Jun 2022 00:55:22 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 08A6C1E80D50;
        Wed, 29 Jun 2022 15:54:11 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 9eJqlagEV4Pq; Wed, 29 Jun 2022 15:54:08 +0800 (CST)
Received: from localhost.localdomain (unknown [180.167.10.98])
        (Authenticated sender: jiaming@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id BF5AC1E80D11;
        Wed, 29 Jun 2022 15:54:07 +0800 (CST)
From:   Zhang Jiaming <jiaming@nfschina.com>
To:     rajur@chelsio.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        liqiong@nfschina.com, renyu@nfschina.com,
        Zhang Jiaming <jiaming@nfschina.com>
Subject: [PATCH] cxgb4: clip_tbl: Fix spelling mistake
Date:   Wed, 29 Jun 2022 15:55:16 +0800
Message-Id: <20220629075516.28896-1-jiaming@nfschina.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change 'wont' to 'won't'.

Signed-off-by: Zhang Jiaming <jiaming@nfschina.com>
---
 drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c b/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c
index 163efab27e9b..5060d3998889 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c
@@ -120,7 +120,7 @@ int cxgb4_clip_get(const struct net_device *dev, const u32 *lip, u8 v6)
 				write_unlock_bh(&ctbl->lock);
 				dev_err(adap->pdev_dev,
 					"CLIP FW cmd failed with error %d, "
-					"Connections using %pI6c wont be "
+					"Connections using %pI6c won't be "
 					"offloaded",
 					ret, ce->addr6.sin6_addr.s6_addr);
 				return ret;
@@ -133,7 +133,7 @@ int cxgb4_clip_get(const struct net_device *dev, const u32 *lip, u8 v6)
 	} else {
 		write_unlock_bh(&ctbl->lock);
 		dev_info(adap->pdev_dev, "CLIP table overflow, "
-			 "Connections using %pI6c wont be offloaded",
+			 "Connections using %pI6c won't be offloaded",
 			 (void *)lip);
 		return -ENOMEM;
 	}
-- 
2.34.1

