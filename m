Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB3F265060
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgIJUPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:15:21 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:57070 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731087AbgIJO7W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 10:59:22 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 88890C7CF8D387270F67;
        Thu, 10 Sep 2020 22:59:18 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Thu, 10 Sep 2020
 22:59:10 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <snelson@pensando.io>,
        <colin.king@canonical.com>, <maz@kernel.org>, <luobin9@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 5/6] net: hns: Fix a kernel-doc warning in hinic_hw_api_cmd.c
Date:   Thu, 10 Sep 2020 22:56:19 +0800
Message-ID: <20200910145620.27470-6-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200910145620.27470-1-wanghai38@huawei.com>
References: <20200910145620.27470-1-wanghai38@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

drivers/net/ethernet/huawei/hinic/hinic_hw_api_cmd.c:382: warning: Excess function parameter 'size' description in 'api_cmd'

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_hw_api_cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_api_cmd.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_api_cmd.c
index 29e88e25a4a4..4e4029d5c8e1 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_api_cmd.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_api_cmd.c
@@ -373,7 +373,7 @@ static int wait_for_api_cmd_completion(struct hinic_api_cmd_chain *chain)
  * @chain: chain for the command
  * @dest: destination node on the card that will receive the command
  * @cmd: command data
- * @size: the command size
+ * @cmd_size: the command size
  *
  * Return 0 - Success, negative - Failure
  **/
-- 
2.17.1

