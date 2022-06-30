Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18A44561A9A
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 14:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234794AbiF3MpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 08:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234637AbiF3MpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 08:45:08 -0400
Received: from mail.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 529451408D;
        Thu, 30 Jun 2022 05:45:07 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 226B81E80D11;
        Thu, 30 Jun 2022 20:43:45 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id kX_5eovNYxIc; Thu, 30 Jun 2022 20:43:42 +0800 (CST)
Received: from localhost.localdomain (unknown [219.141.250.2])
        (Authenticated sender: kunyu@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 869E61E80CB6;
        Thu, 30 Jun 2022 20:43:42 +0800 (CST)
From:   Li kunyu <kunyu@nfschina.com>
To:     pabeni@redhat.com
Cc:     edumazet@google.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, rajur@chelsio.com,
        Li kunyu <kunyu@nfschina.com>
Subject: [PATCH v2] cxgb4: Fix typo in string
Date:   Thu, 30 Jun 2022 20:44:52 +0800
Message-Id: <20220630124452.5018-1-kunyu@nfschina.com>
X-Mailer: git-send-email 2.18.2
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the repeated ',' from string

Signed-off-by: Li kunyu <kunyu@nfschina.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.c
index 4a872f328fea..7d5204834ee2 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.c
@@ -85,7 +85,7 @@ static void cxgb4_dcb_cleanup_apps(struct net_device *dev)
 
 		if (err) {
 			dev_err(adap->pdev_dev,
-				"Failed DCB Clear %s Application Priority: sel=%d, prot=%d, , err=%d\n",
+				"Failed DCB Clear %s Application Priority: sel=%d, prot=%d, err=%d\n",
 				dcb_ver_array[dcb->dcb_version], app.selector,
 				app.protocol, -err);
 			break;
-- 
2.18.2

