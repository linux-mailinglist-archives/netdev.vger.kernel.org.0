Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2B167F53A
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 07:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbjA1GgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 01:36:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbjA1GgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 01:36:13 -0500
Received: from out28-172.mail.aliyun.com (out28-172.mail.aliyun.com [115.124.28.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E990C10DB;
        Fri, 27 Jan 2023 22:36:11 -0800 (PST)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.2477281|-1;BR=01201311R101ec;CH=green;DM=|CONTINUE|false|;DS=AD|ad_normal|0.45466-0.338976-0.206364;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047198;MF=frank.sae@motor-comm.com;NM=1;PH=DS;RN=14;RT=14;SR=0;TI=SMTPD_---.R2f-OMU_1674887768;
Received: from sun-VirtualBox..(mailfrom:Frank.Sae@motor-comm.com fp:SMTPD_---.R2f-OMU_1674887768)
          by smtp.aliyun-inc.com;
          Sat, 28 Jan 2023 14:36:08 +0800
From:   Frank Sae <Frank.Sae@motor-comm.com>
To:     Peter Geis <pgwipeout@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     xiaogang.fan@motor-comm.com, fei.zhang@motor-comm.com,
        hua.sun@motor-comm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Frank <Frank.Sae@motor-comm.com>
Subject: [PATCH net-next v1] net: phy: motorcomm: change the phy id of yt8521 and yt8531s to lowercase
Date:   Sat, 28 Jan 2023 14:35:58 +0800
Message-Id: <20230128063558.5850-2-Frank.Sae@motor-comm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230128063558.5850-1-Frank.Sae@motor-comm.com>
References: <20230128063558.5850-1-Frank.Sae@motor-comm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 The phy id is usually defined in lower case.

Signed-off-by: Frank Sae <Frank.Sae@motor-comm.com>
---
 drivers/net/phy/motorcomm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/motorcomm.c b/drivers/net/phy/motorcomm.c
index b6968c78c303..aa02e722c51d 100644
--- a/drivers/net/phy/motorcomm.c
+++ b/drivers/net/phy/motorcomm.c
@@ -12,8 +12,8 @@
 #include <linux/phy.h>
 
 #define PHY_ID_YT8511		0x0000010a
-#define PHY_ID_YT8521		0x0000011A
-#define PHY_ID_YT8531S		0x4F51E91A
+#define PHY_ID_YT8521		0x0000011a
+#define PHY_ID_YT8531S		0x4f51e91a
 
 /* YT8521/YT8531S Register Overview
  *	UTP Register space	|	FIBER Register space
-- 
2.34.1

