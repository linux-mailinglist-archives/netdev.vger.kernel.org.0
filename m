Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6260F560107
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 15:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233781AbiF2NOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 09:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233780AbiF2NOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 09:14:17 -0400
Received: from smtpbg.qq.com (unknown [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B1426541;
        Wed, 29 Jun 2022 06:14:10 -0700 (PDT)
X-QQ-mid: bizesmtp80t1656508420tyf0raqj
Received: from localhost.localdomain ( [182.148.13.66])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 29 Jun 2022 21:13:37 +0800 (CST)
X-QQ-SSF: 0100000000200060C000C00A0000000
X-QQ-FEAT: 02HFykG0jktbnPvtiDf42PmRotP77QBKZH3mQMCDt+sxKkQD1HhZLNwh/7Tnv
        F8grmefunn+Mf2aK9yLuTJeKV+vndFDoe2rV3ee5gwsMKcMIDSwoELUgzHYm5RqBerPEHHG
        4F2qLaOkXQ/XxLvK8TEI+TGSPeWsqICcdpWRZ+YKIscr2cCHyYXrbrLQLFeZ/qC3/QbSBaJ
        aBYgPRzSyxkcljMQSfX2xVXs65PeDIxV1GbBpQzkJbKE+cZzeiFf2iRf5NAU0tI+NRtk26y
        WxhEPiFAeq/o40OqO5FXgPWOCRuoZlg51CPGjPkcAr2cRlXL8c/9NDhiDDnytf1ewR6oznq
        glC6ts0
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     shenjian15@huawei.com, lipeng321@huawei.com,
        zhangjiaran@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] hisilicon/hns3/hns3vf:fix repeated words in comments
Date:   Wed, 29 Jun 2022 21:13:30 +0800
Message-Id: <20220629131330.16812-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr4
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete the redundant word 'new'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 5eaf09ea4009..26f87330173e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -979,7 +979,7 @@ static int hclgevf_update_mac_list(struct hnae3_handle *handle,
 
 	/* if the mac addr is already in the mac list, no need to add a new
 	 * one into it, just check the mac addr state, convert it to a new
-	 * new state, or just remove it, or do nothing.
+	 * state, or just remove it, or do nothing.
 	 */
 	mac_node = hclgevf_find_mac_node(list, addr);
 	if (mac_node) {
-- 
2.36.1

