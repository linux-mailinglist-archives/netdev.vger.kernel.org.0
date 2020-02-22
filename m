Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F21601691A7
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 20:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgBVTwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 14:52:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57972 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726730AbgBVTwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Feb 2020 14:52:38 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1j5apD-00062w-Q3; Sat, 22 Feb 2020 19:52:31 +0000
From:   Colin King <colin.king@canonical.com>
To:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Huazhong Tan <tanhuazhong@huawei.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: hns3: remove redundant initialization of pointer 'client'
Date:   Sat, 22 Feb 2020 19:52:31 +0000
Message-Id: <20200222195231.200089-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The pointer 'client' is being initialized with a value that is never
read, it is being updated later on. The initialization is redundant
and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 51399dbed77a..a121af513704 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -9076,7 +9076,7 @@ static int hclge_init_nic_client_instance(struct hnae3_ae_dev *ae_dev,
 static int hclge_init_roce_client_instance(struct hnae3_ae_dev *ae_dev,
 					   struct hclge_vport *vport)
 {
-	struct hnae3_client *client = vport->roce.client;
+	struct hnae3_client *client;
 	struct hclge_dev *hdev = ae_dev->priv;
 	int rst_cnt;
 	int ret;
-- 
2.25.0

