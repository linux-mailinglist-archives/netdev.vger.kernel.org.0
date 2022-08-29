Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD8B35A4466
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 10:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbiH2IAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 04:00:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbiH2H76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 03:59:58 -0400
X-Greylist: delayed 529 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 29 Aug 2022 00:59:54 PDT
Received: from mail.tkos.co.il (guitar.tkos.co.il [84.110.109.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 820CF60F6
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 00:59:54 -0700 (PDT)
Received: from tarshish.tkos.co.il (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.tkos.co.il (Postfix) with ESMTPS id D11E3440778;
        Mon, 29 Aug 2022 10:49:53 +0300 (IDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tkos.co.il;
        s=default; t=1661759393;
        bh=XcFA8ijUBorrmnPbcq6LEg2IOM74y+CFwPD32zL+3I0=;
        h=From:To:Cc:Subject:Date:From;
        b=Fwl41v5oNdCnOdN5IN88/lCNymFqB1P/xlU9VJEuxHa3Id4PRaH9uT3fNJRgu6q8O
         LGqKavBlxW9Zx/miNIUoAf3/Txuw1bRzdxqUop26UI+EqNsOmAQxWhKf2FVb/72xIW
         yi6L27jGUxB2AutaYDh9Z/ruKFLi/xYF/zUeCVw0Gw7peAD3WRfc3wk5lXw/DdePeJ
         K/Z9pWrBO8yCc+VOc7cRulzAv+8aXjPVRf9ap3VUuFCu4f4/lBiyKum8rYoCo1F5vz
         qRT0WnjrUr3hUAAD6Edeu+zMYUJqoG7mzACflqPir/I+9+mnYSJ+wq6Vc/8qD5GsuJ
         8h1gEmUM9L75A==
From:   Baruch Siach <baruch@tkos.co.il>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@nvidia.com>
Cc:     netdev@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH iproute2] devlink: fix region-new usage message
Date:   Mon, 29 Aug 2022 10:49:13 +0300
Message-Id: <d7b189357e13804524e2e61c65817b9f9eb26a58.1661759353.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The snapshot parameter is optional.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 devlink/devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 21f26246f91b..8bb6db006b30 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -8504,7 +8504,7 @@ static void cmd_region_help(void)
 {
 	pr_err("Usage: devlink region show [ DEV/REGION ]\n");
 	pr_err("       devlink region del DEV/REGION snapshot SNAPSHOT_ID\n");
-	pr_err("       devlink region new DEV/REGION snapshot SNAPSHOT_ID\n");
+	pr_err("       devlink region new DEV/REGION [ snapshot SNAPSHOT_ID ]\n");
 	pr_err("       devlink region dump DEV/REGION [ snapshot SNAPSHOT_ID ]\n");
 	pr_err("       devlink region read DEV/REGION [ snapshot SNAPSHOT_ID ] address ADDRESS length LENGTH\n");
 }
-- 
2.35.1

