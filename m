Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B878963BB24
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 09:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiK2IAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 03:00:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiK2IAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 03:00:43 -0500
Received: from mail-m121145.qiye.163.com (mail-m121145.qiye.163.com [115.236.121.145])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B321D1D0F5;
        Tue, 29 Nov 2022 00:00:40 -0800 (PST)
Received: from amadeus-VLT-WX0.lan (unknown [112.48.80.27])
        by mail-m121145.qiye.163.com (Hmail) with ESMTPA id EC584800302;
        Tue, 29 Nov 2022 16:00:32 +0800 (CST)
From:   Chukun Pan <amadeus@jmu.edu.cn>
To:     Frank <Frank.Sae@motor-comm.com>
Cc:     Peter Geis <pgwipeout@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Chukun Pan <amadeus@jmu.edu.cn>
Subject: [PATCH 1/1] net: phy: motorcomm: change the phy id of yt8521 to lowercase
Date:   Tue, 29 Nov 2022 16:00:05 +0800
Message-Id: <20221129080005.24780-1-amadeus@jmu.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVkaSEpNVk4ZSUhLSBkdS01CGlUTARMWGhIXJBQOD1
        lXWRgSC1lBWUpKSVVPQ1VDS1VJTFlXWRYaDxIVHRRZQVlPS0hVSkpLSEpDVUpLS1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NU06OSo4Hz0tAhw8HRgNHkMJ
        TEhPCzdVSlVKTU1CTEtDQ0hIQk1NVTMWGhIXVRoWGh8eDgg7ERYOVR4fDlUYFUVZV1kSC1lBWUpK
        SVVPQ1VDS1VJTFlXWQgBWUFKQkJCNwY+
X-HM-Tid: 0a84c266e281b03akuuuec584800302
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The phy id is usually defined in lower case, also align the indents.

Signed-off-by: Chukun Pan <amadeus@jmu.edu.cn>
---
 drivers/net/phy/motorcomm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/motorcomm.c b/drivers/net/phy/motorcomm.c
index bd1ab5d0631f..e0aa98e890dd 100644
--- a/drivers/net/phy/motorcomm.c
+++ b/drivers/net/phy/motorcomm.c
@@ -12,7 +12,7 @@
 #include <linux/phy.h>
 
 #define PHY_ID_YT8511		0x0000010a
-#define PHY_ID_YT8521				0x0000011A
+#define PHY_ID_YT8521		0x0000011a
 
 /* YT8521 Register Overview
  *	UTP Register space	|	FIBER Register space
-- 
2.25.1

