Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA87348AF9
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 09:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbhCYIBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 04:01:11 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14470 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbhCYIAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 04:00:51 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F5ctN1vfjzwPrq;
        Thu, 25 Mar 2021 15:58:36 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Thu, 25 Mar 2021 16:00:30 +0800
From:   Daode Huang <huangdaode@huawei.com>
To:     <csully@google.com>, <sagis@google.com>, <jonolson@google.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <awogbemila@google.com>,
        <yangchun@google.com>, <kuozhao@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 2/2] net: gve: remove duplicated allowed
Date:   Thu, 25 Mar 2021 15:56:32 +0800
Message-ID: <1616658992-135804-3-git-send-email-huangdaode@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1616658992-135804-1-git-send-email-huangdaode@huawei.com>
References: <1616658992-135804-1-git-send-email-huangdaode@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fix the WARNING of Possible repeated word: 'allowed'

Signed-off-by: Daode Huang <huangdaode@huawei.com>
---
 drivers/net/ethernet/google/gve/gve_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
index e40e052..5fb05cf 100644
--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -388,7 +388,7 @@ static int gve_set_channels(struct net_device *netdev,
 
 	gve_get_channels(netdev, &old_settings);
 
-	/* Changing combined is not allowed allowed */
+	/* Changing combined is not allowed */
 	if (cmd->combined_count != old_settings.combined_count)
 		return -EINVAL;
 
-- 
2.8.1

