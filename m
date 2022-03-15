Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 389934DA292
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 19:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351129AbiCOSpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 14:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241627AbiCOSpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 14:45:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C10613F62;
        Tue, 15 Mar 2022 11:43:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0382461557;
        Tue, 15 Mar 2022 18:43:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3666DC340EE;
        Tue, 15 Mar 2022 18:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647369825;
        bh=Hq+DOME/poVr7Ganygw5gx4KaOP+Qu8m/oCX10TgAOY=;
        h=From:To:Cc:Subject:Date:From;
        b=UoiZbrkJjDS+k3ZifVV2ooTPTArqqpquLE966wG72AaadHU2YQYCkxtC0fAZ8wm+Z
         BefHydomdCOA/5bkUla89/z/lzxRdIXdaaAdgTxVo7HFp37zdlrDSA0+lmIPC17E3Y
         oro1j0B2NarUbfi09qHIfuldigmFxSSPbIEAV+hWYTyajvONShHdPY2ARdVWnviR5y
         gAtnTyIZiw/PzZ1wRF4VN6k25HRWVWaZ6y8lUpIBShnlYNrmwGdtfRaB/J0VSBt0y5
         yIaGmmDgAkb2voh3i8TvFELzTiv/ymndQ8lNb2IK2LH5AOdxJTvag76fqToc5yZfP8
         7pTiJLCLdAK1Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-parisc@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: mark tulip obsolete
Date:   Tue, 15 Mar 2022 11:43:42 -0700
Message-Id: <20220315184342.1064038-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's ancient, an likely completely unused at this point.
Let's mark it obsolete to prevent refactoring.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1397a6b039fb..9afe495a86ca 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -19687,7 +19687,7 @@ F:	drivers/media/tuners/tua9001*
 TULIP NETWORK DRIVERS
 L:	netdev@vger.kernel.org
 L:	linux-parisc@vger.kernel.org
-S:	Orphan
+S:	Orphan / Obsolete
 F:	drivers/net/ethernet/dec/tulip/
 
 TUN/TAP driver
-- 
2.34.1

