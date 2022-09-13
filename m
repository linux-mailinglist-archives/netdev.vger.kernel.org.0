Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90B935B664E
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 05:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbiIMDzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 23:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiIMDzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 23:55:39 -0400
Received: from mail.nfschina.com (unknown [124.16.136.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0A31143E61;
        Mon, 12 Sep 2022 20:55:37 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 6CDFC1E80D89;
        Tue, 13 Sep 2022 11:53:31 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id m0azm_8-P2zr; Tue, 13 Sep 2022 11:53:28 +0800 (CST)
Received: from localhost.localdomain (unknown [219.141.250.2])
        (Authenticated sender: zeming@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 905631E80D80;
        Tue, 13 Sep 2022 11:53:28 +0800 (CST)
From:   Li zeming <zeming@nfschina.com>
To:     aelior@marvell.com, manishc@marvell.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li zeming <zeming@nfschina.com>
Subject: [PATCH] qed: Remove unnecessary '0' values from prod
Date:   Tue, 13 Sep 2022 11:55:30 +0800
Message-Id: <20220913035530.258266-1-zeming@nfschina.com>
X-Mailer: git-send-email 2.18.2
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The prod variable is assigned first, it does not need to be initialized.

Signed-off-by: Li zeming <zeming@nfschina.com>
---
 include/linux/qed/qed_if.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
index 6dc4943d8aec..f542d9946444 100644
--- a/include/linux/qed/qed_if.h
+++ b/include/linux/qed/qed_if.h
@@ -1423,7 +1423,7 @@ struct qed_sb_cnt_info {
 
 static inline u16 qed_sb_update_sb_idx(struct qed_sb_info *sb_info)
 {
-	u32 prod = 0;
+	u32 prod;
 	u16 rc = 0;
 
 	prod = le32_to_cpu(sb_info->sb_virt->prod_index) &
-- 
2.18.2

