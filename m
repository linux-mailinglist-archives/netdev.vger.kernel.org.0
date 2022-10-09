Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CAD55F89F8
	for <lists+netdev@lfdr.de>; Sun,  9 Oct 2022 09:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiJIHR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 03:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbiJIHR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 03:17:27 -0400
Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F552DAB4
        for <netdev@vger.kernel.org>; Sun,  9 Oct 2022 00:17:23 -0700 (PDT)
X-QQ-mid: bizesmtp82t1665299374t4yss6jy
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sun, 09 Oct 2022 15:09:18 +0800 (CST)
X-QQ-SSF: 01400000000000M0M000000A0000000
X-QQ-FEAT: znfcQSa1hKZmOr4I++H8gUPXGIbcrFc7pqENhWtBqgByBmmkia5k5YD2wYL61
        MuiYODINy8Pk5EytFtEO3ghw7m//IsyoPQYCixhAZ7mPCcGkHA1xdeTR8oEKoe0G+2SMNvM
        uxI5g3nqHAK0HSxl81NblNZmHUEgFF8H9P3RkFe7CE72YSDHapYUuvcgjseUXGwS7Oz6jE3
        dAlrhYnNy41MZiQBu4R/aM9pFCRtnyZXnluG90HO85luS1nbtPYf0YKALnGhpg2rMemrvNU
        BTqw9Ak4blomAFPdOzia6hzbYN1T91OYqUeq5bhLEIPpVSjenCMgFpPz1SicS1Ykamh171s
        00wM7L8w4mR6/z/tRQ/5iRkmn/5HIV3rOKvi9uIT1hW0EZPjLMfefjUMLlQLV9PQcryCZ8G
        YZTZ8DiWHDE=
X-QQ-GoodBg: 2
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org
Cc:     jiawenwu@trustnetic.com, Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next] net: ngbe: Variables need to be initialized
Date:   Sun,  9 Oct 2022 15:09:12 +0800
Message-Id: <20221009070912.55353-1-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvr:qybglogicsvr1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variables need to be initialized in ngbe_shutdown()
Fix: commit <e79e40c83b9f> ("net: ngbe: Add build support for ngbe")

Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
---
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
index 7674cb6e5700..f754e53eb852 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
@@ -46,7 +46,7 @@ static void ngbe_dev_shutdown(struct pci_dev *pdev, bool *enable_wake)
 
 static void ngbe_shutdown(struct pci_dev *pdev)
 {
-	bool wake;
+	bool wake = false;
 
 	ngbe_dev_shutdown(pdev, &wake);
 
-- 
2.37.3

