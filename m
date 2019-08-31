Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73088A4313
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 09:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbfHaH37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 03:29:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50224 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbfHaH37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 03:29:59 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1i3xpW-0000PW-R9; Sat, 31 Aug 2019 07:29:50 +0000
From:   Colin King <colin.king@canonical.com>
To:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        Zhongzhu Liu <liuzhongzhu@huawei.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net: hns3: remove redundant assignment to pointer reg_info
Date:   Sat, 31 Aug 2019 08:29:49 +0100
Message-Id: <20190831072949.7505-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Pointer reg_info is being initialized with a value that is never read and
is being re-assigned a little later on. The assignment is redundant
and hence can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 1debe37fe735..1c6b501fb7ca 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -279,7 +279,7 @@ static void hclge_dbg_dump_dcb(struct hclge_dev *hdev, const char *cmd_buf)
 
 static void hclge_dbg_dump_reg_cmd(struct hclge_dev *hdev, const char *cmd_buf)
 {
-	struct hclge_dbg_reg_type_info *reg_info = &hclge_dbg_reg_info[0];
+	struct hclge_dbg_reg_type_info *reg_info;
 	bool has_dump = false;
 	int i;
 
-- 
2.20.1

