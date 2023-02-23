Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0136A05FB
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 11:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233646AbjBWKWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 05:22:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233751AbjBWKWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 05:22:13 -0500
X-Greylist: delayed 421 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 23 Feb 2023 02:22:11 PST
Received: from mx.mylinuxtime.de (mx.mylinuxtime.de [195.201.174.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 608CC4ECDA
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 02:22:11 -0800 (PST)
Received: from leda.eworm.de (unknown [194.36.25.21])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mx.mylinuxtime.de (Postfix) with ESMTPSA id 4EB29201082;
        Thu, 23 Feb 2023 11:15:09 +0100 (CET)
Received: by leda.eworm.de (Postfix, from userid 1000)
        id F172A181487; Thu, 23 Feb 2023 11:15:08 +0100 (CET)
From:   Christian Hesse <list@eworm.de>
To:     netdev@vger.kernel.org
Cc:     Christian Hesse <mail@eworm.de>
Subject: [PATCH 1/1] tc: add missing separator
Date:   Thu, 23 Feb 2023 11:15:03 +0100
Message-Id: <20230223101503.52222-1-list@eworm.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christian Hesse <mail@eworm.de>

This is missing a separator, that was removed in commit
010a8388aea11e767ba3a2506728b9ad9760df0e. Let's add it back.

Signed-off-by: Christian Hesse <mail@eworm.de>
---
 tc/tc_class.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tc/tc_class.c b/tc/tc_class.c
index c1feb009..096fa2ec 100644
--- a/tc/tc_class.c
+++ b/tc/tc_class.c
@@ -356,7 +356,7 @@ int print_class(struct nlmsghdr *n, void *arg)
 		print_string(PRINT_ANY, "parent", "parent %s ", abuf);
 	}
 	if (t->tcm_info)
-		print_0xhex(PRINT_ANY, "leaf", "leaf %x", t->tcm_info>>16);
+		print_0xhex(PRINT_ANY, "leaf", "leaf %x: ", t->tcm_info>>16);
 
 	q = get_qdisc_kind(RTA_DATA(tb[TCA_KIND]));
 	if (tb[TCA_OPTIONS]) {
-- 
2.39.2

