Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC63240194F
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 11:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241537AbhIFJxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 05:53:14 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:34504 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241296AbhIFJxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 05:53:13 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UnPs1D5_1630921922;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UnPs1D5_1630921922)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 06 Sep 2021 17:52:07 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     yisen.zhuang@huawei.com
Cc:     salil.mehta@huawei.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        chongjiapeng <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] net: hns3: make hclgevf_cmd_caps_bit_map0 and hclge_cmd_caps_bit_map0 static
Date:   Mon,  6 Sep 2021 17:51:59 +0800
Message-Id: <1630921919-36549-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: chongjiapeng <jiapeng.chong@linux.alibaba.com>

This symbols is not used outside of hclge_cmd.c and hclgevf_cmd.c, so marks
it static.

Fix the following sparse warning:

drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c:345:35:
warning: symbol 'hclgevf_cmd_caps_bit_map0' was not declared. Should it
be static?

drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c:365:33: warning:
symbol 'hclge_cmd_caps_bit_map0' was not declared. Should it be static?

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: chongjiapeng <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c   | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index 474c6d1..ac9b695 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -362,7 +362,7 @@ static void hclge_set_default_capability(struct hclge_dev *hdev)
 	}
 }
 
-const struct hclge_caps_bit_map hclge_cmd_caps_bit_map0[] = {
+static const struct hclge_caps_bit_map hclge_cmd_caps_bit_map0[] = {
 	{HCLGE_CAP_UDP_GSO_B, HNAE3_DEV_SUPPORT_UDP_GSO_B},
 	{HCLGE_CAP_PTP_B, HNAE3_DEV_SUPPORT_PTP_B},
 	{HCLGE_CAP_INT_QL_B, HNAE3_DEV_SUPPORT_INT_QL_B},
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
index 59772b0..f89bfb3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
@@ -342,7 +342,7 @@ static void hclgevf_set_default_capability(struct hclgevf_dev *hdev)
 	set_bit(HNAE3_DEV_SUPPORT_FEC_B, ae_dev->caps);
 }
 
-const struct hclgevf_caps_bit_map hclgevf_cmd_caps_bit_map0[] = {
+static const struct hclgevf_caps_bit_map hclgevf_cmd_caps_bit_map0[] = {
 	{HCLGEVF_CAP_UDP_GSO_B, HNAE3_DEV_SUPPORT_UDP_GSO_B},
 	{HCLGEVF_CAP_INT_QL_B, HNAE3_DEV_SUPPORT_INT_QL_B},
 	{HCLGEVF_CAP_TQP_TXRX_INDEP_B, HNAE3_DEV_SUPPORT_TQP_TXRX_INDEP_B},
-- 
1.8.3.1

