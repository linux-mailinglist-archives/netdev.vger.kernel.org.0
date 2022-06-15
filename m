Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F75254BEEA
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 02:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241268AbiFOAxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 20:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240947AbiFOAxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 20:53:23 -0400
Received: from out30-57.freemail.mail.aliyun.com (out30-57.freemail.mail.aliyun.com [115.124.30.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD4844757;
        Tue, 14 Jun 2022 17:53:21 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0VGQ6.5y_1655254397;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0VGQ6.5y_1655254397)
          by smtp.aliyun-inc.com;
          Wed, 15 Jun 2022 08:53:18 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     amitkarwar@gmail.com
Cc:     ganapathi017@gmail.com, sharvari.harisangam@nxp.com,
        huxinming820@gmail.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] wireless: clean up one inconsistent indenting
Date:   Wed, 15 Jun 2022 08:53:16 +0800
Message-Id: <20220615005316.9596-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eliminate the follow smatch warning:
drivers/net/wireless/marvell/mwifiex/pcie.c:3364 mwifiex_unregister_dev() warn: inconsistent indenting

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 20352039a5c3..f7f9277602a5 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -3361,7 +3361,7 @@ static void mwifiex_unregister_dev(struct mwifiex_adapter *adapter)
 	} else {
 		mwifiex_dbg(adapter, INFO,
 			    "%s(): calling free_irq()\n", __func__);
-	       free_irq(card->dev->irq, &card->share_irq_ctx);
+		free_irq(card->dev->irq, &card->share_irq_ctx);
 
 		if (card->msi_enable)
 			pci_disable_msi(pdev);
-- 
2.20.1.7.g153144c

