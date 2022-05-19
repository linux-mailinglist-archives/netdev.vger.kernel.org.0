Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5C452DF1F
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 23:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245124AbiESVWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 17:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245098AbiESVV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 17:21:59 -0400
Received: from smtp5.emailarray.com (smtp5.emailarray.com [65.39.216.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39975ED726
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 14:21:58 -0700 (PDT)
Received: (qmail 4290 invoked by uid 89); 19 May 2022 21:21:57 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjE0NC4yOQ==) (POLARISLOCAL)  
  by smtp5.emailarray.com with SMTP; 19 May 2022 21:21:57 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, kernel-team@fb.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next v4 02/10] ptp: ocp: Remove #ifdefs around PCI IDs
Date:   Thu, 19 May 2022 14:21:45 -0700
Message-Id: <20220519212153.450437-3-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220519212153.450437-1-jonathan.lemon@gmail.com>
References: <20220519212153.450437-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These #ifdefs are not required, so remove them.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 957c0522a02f..d2cdb2a05c36 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -20,13 +20,8 @@
 #include <linux/mtd/mtd.h>
 #include <linux/nvmem-consumer.h>
 
-#ifndef PCI_VENDOR_ID_FACEBOOK
-#define PCI_VENDOR_ID_FACEBOOK 0x1d9b
-#endif
-
-#ifndef PCI_DEVICE_ID_FACEBOOK_TIMECARD
-#define PCI_DEVICE_ID_FACEBOOK_TIMECARD 0x0400
-#endif
+#define PCI_VENDOR_ID_FACEBOOK			0x1d9b
+#define PCI_DEVICE_ID_FACEBOOK_TIMECARD		0x0400
 
 static struct class timecard_class = {
 	.owner		= THIS_MODULE,
-- 
2.31.1

