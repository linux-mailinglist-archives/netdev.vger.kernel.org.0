Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 409A558A07D
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 20:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239986AbiHDS04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 14:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiHDS0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 14:26:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF495C37A
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 11:26:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9242461617
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 18:26:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3818C433C1;
        Thu,  4 Aug 2022 18:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659637613;
        bh=qy1zylQnpARgl92009Dgeg7HY4pqgJePFFgEoPjJXUw=;
        h=From:To:Cc:Subject:Date:From;
        b=Uor6uGP2UxeTsmd+Z4guIwIBIdyt3TEjsJIki1k2NjCRAS3TO3EN35nz+2w7TAC0I
         MVIiAt/RwjVY+VrBoA9iv99naSL8n8AJef7wn5GL3gAvXGEETK6kaCjTzlZz78rivQ
         Hp55ySXRl3K2HKy8JHGGW2KR4RWXyH41naZe/mTuPmkeipeERGoONXn+WXJvauTU84
         pGAcxK6nJNeMsFymCjAGgumXW4dzP0I/hyUehYLl1J6W6FkNEpcobZVKsNbdtwEG2o
         sMrM/W+aOgS/h+kR4FExmO4NNQ1/eVnS3MB5n7oO4rX0Cn9DdER7WegJofM6yFllv6
         QTPXvi2R3CxCA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        Ingo Saitz <ingo@hannover.ccc.de>, jiawenwu@trustnetic.com
Subject: [PATCH net] eth: fix the help in Wangxun's Kconfig
Date:   Thu,  4 Aug 2022 11:26:41 -0700
Message-Id: <20220804182641.1442000-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The text was copy&pasted from Intel, adjust it to say Wangxun.

Reported-by: Ingo Saitz <ingo@hannover.ccc.de>
Fixes: 3ce7547e5b71 ("net: txgbe: Add build support for txgbe")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: jiawenwu@trustnetic.com
---
 drivers/net/ethernet/wangxun/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/Kconfig b/drivers/net/ethernet/wangxun/Kconfig
index baa1f0a5cc37..b4a4fa0a58f8 100644
--- a/drivers/net/ethernet/wangxun/Kconfig
+++ b/drivers/net/ethernet/wangxun/Kconfig
@@ -7,12 +7,12 @@ config NET_VENDOR_WANGXUN
 	bool "Wangxun devices"
 	default y
 	help
-	  If you have a network (Ethernet) card belonging to this class, say Y.
+	  If you have a network (Ethernet) card from Wangxun(R), say Y.
 
 	  Note that the answer to this question doesn't directly affect the
 	  kernel: saying N will just cause the configurator to skip all
-	  the questions about Intel cards. If you say Y, you will be asked for
-	  your specific card in the following questions.
+	  the questions about Wangxun(R) cards. If you say Y, you will
+	  be asked for your specific card in the following questions.
 
 if NET_VENDOR_WANGXUN
 
-- 
2.37.1

