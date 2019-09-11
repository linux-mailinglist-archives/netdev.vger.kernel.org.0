Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ECD0AFE51
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 16:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbfIKOIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 10:08:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57973 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbfIKOIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 10:08:21 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1i83I9-0007EX-Ae; Wed, 11 Sep 2019 14:08:17 +0000
From:   Colin King <colin.king@canonical.com>
To:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Huazhong Tan <tanhuazhong@huawei.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: hns3: fix spelling mistake "undeflow" -> "underflow"
Date:   Wed, 11 Sep 2019 15:08:16 +0100
Message-Id: <20190911140817.20173-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a .msg literal string. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
index 58c6231aaa00..87dece0e745d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c
@@ -98,7 +98,7 @@ static const struct hclge_hw_error hclge_igu_egu_tnl_int[] = {
 	  .reset_level = HNAE3_GLOBAL_RESET },
 	{ .int_msk = BIT(1), .msg = "rx_stp_fifo_overflow",
 	  .reset_level = HNAE3_GLOBAL_RESET },
-	{ .int_msk = BIT(2), .msg = "rx_stp_fifo_undeflow",
+	{ .int_msk = BIT(2), .msg = "rx_stp_fifo_underflow",
 	  .reset_level = HNAE3_GLOBAL_RESET },
 	{ .int_msk = BIT(3), .msg = "tx_buf_overflow",
 	  .reset_level = HNAE3_GLOBAL_RESET },
-- 
2.20.1

