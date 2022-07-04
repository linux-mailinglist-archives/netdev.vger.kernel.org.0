Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC80564B42
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 03:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232810AbiGDBmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 21:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbiGDBmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 21:42:11 -0400
Received: from mail.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5C3F66378;
        Sun,  3 Jul 2022 18:42:10 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 21CDE1E80C95;
        Mon,  4 Jul 2022 09:40:17 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id rXY3C9gbhySn; Mon,  4 Jul 2022 09:40:14 +0800 (CST)
Received: from localhost.localdomain (unknown [180.167.10.98])
        (Authenticated sender: jiaming@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id D9AC61E80C90;
        Mon,  4 Jul 2022 09:40:13 +0800 (CST)
From:   Zhang Jiaming <jiaming@nfschina.com>
To:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        liqiong@nfschina.com, renyu@nfschina.com,
        Zhang Jiaming <jiaming@nfschina.com>
Subject: [PATCH] net: hns: Fix spelling mistake in comments
Date:   Mon,  4 Jul 2022 09:42:04 +0800
Message-Id: <20220704014204.8212-1-jiaming@nfschina.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a typo(waitting) in comments.
FIx it.

Signed-off-by: Zhang Jiaming <jiaming@nfschina.com>
---
 drivers/net/ethernet/hisilicon/hns_mdio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns_mdio.c b/drivers/net/ethernet/hisilicon/hns_mdio.c
index 07fdab58001d..c239c407360f 100644
--- a/drivers/net/ethernet/hisilicon/hns_mdio.c
+++ b/drivers/net/ethernet/hisilicon/hns_mdio.c
@@ -174,7 +174,7 @@ static int hns_mdio_wait_ready(struct mii_bus *bus)
 	u32 cmd_reg_value;
 	int i;
 
-	/* waitting for MDIO_COMMAND_REG 's mdio_start==0 */
+	/* waiting for MDIO_COMMAND_REG 's mdio_start==0 */
 	/* after that can do read or write*/
 	for (i = 0; i < MDIO_TIMEOUT; i++) {
 		cmd_reg_value = MDIO_GET_REG_BIT(mdio_dev,
@@ -319,7 +319,7 @@ static int hns_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
 				   MDIO_C45_READ, phy_id, devad);
 	}
 
-	/* Step 5: waitting for MDIO_COMMAND_REG 's mdio_start==0,*/
+	/* Step 5: waiting for MDIO_COMMAND_REG 's mdio_start==0,*/
 	/* check for read or write opt is finished */
 	ret = hns_mdio_wait_ready(bus);
 	if (ret) {
-- 
2.34.1

