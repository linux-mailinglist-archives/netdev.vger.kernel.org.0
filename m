Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3E93886C0
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 07:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239373AbhESFj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 01:39:28 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4673 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242987AbhESFgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 01:36:03 -0400
Received: from dggems701-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FlM1g0bY3z1BP5g;
        Wed, 19 May 2021 13:31:51 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 13:34:36 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 19 May 2021 13:34:36 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hui Tang <tanghui20@huawei.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Subject: [PATCH 09/20] net: ibm: remove leading spaces before tabs
Date:   Wed, 19 May 2021 13:30:42 +0800
Message-ID: <1621402253-27200-10-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621402253-27200-1-git-send-email-tanghui20@huawei.com>
References: <1621402253-27200-1-git-send-email-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggemi760-chm.china.huawei.com (10.1.198.146)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a few leading spaces before tabs and remove it by running the
following commard:

	$ find . -name '*.c' | xargs sed -r -i 's/^[ ]+\t/\t/'
	$ find . -name '*.h' | xargs sed -r -i 's/^[ ]+\t/\t/'
Cc: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/net/ethernet/ibm/emac/emac.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/emac/emac.h b/drivers/net/ethernet/ibm/emac/emac.h
index aa9f651..09d3ac3 100644
--- a/drivers/net/ethernet/ibm/emac/emac.h
+++ b/drivers/net/ethernet/ibm/emac/emac.h
@@ -77,7 +77,7 @@ struct emac_regs {
 		struct {
 			u32 rsvd1;
 			u32 revid;
- 			u32 rsvd2[2];
+			u32 rsvd2[2];
 			u32 iaht1;	/* Reset, R     */
 			u32 iaht2;	/* Reset, R     */
 			u32 iaht3;	/* Reset, R     */
-- 
2.8.1

