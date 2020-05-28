Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D87801E614F
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 14:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389997AbgE1Msb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 08:48:31 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5367 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389852AbgE1MsX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 08:48:23 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 3DCB9CEF700E7D0C8469;
        Thu, 28 May 2020 20:46:48 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Thu, 28 May 2020 20:46:37 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 07/11] net: hns3; remove unused HNAE3_RESTORE_CLIENT in enum hnae3_reset_notify_type
Date:   Thu, 28 May 2020 20:45:08 +0800
Message-ID: <1590669912-21867-8-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1590669912-21867-1-git-send-email-tanhuazhong@huawei.com>
References: <1590669912-21867-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove HNAE3_RESTORE_CLIENT which is not needed now.

Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index 7506cab..0a4aac4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -145,7 +145,6 @@ enum hnae3_reset_notify_type {
 	HNAE3_DOWN_CLIENT,
 	HNAE3_INIT_CLIENT,
 	HNAE3_UNINIT_CLIENT,
-	HNAE3_RESTORE_CLIENT,
 };
 
 enum hnae3_hw_error_type {
-- 
2.7.4

