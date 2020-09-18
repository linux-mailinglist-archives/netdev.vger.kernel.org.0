Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C59826F5F9
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 08:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbgIRGhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 02:37:23 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:52522 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725886AbgIRGhX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 02:37:23 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id BE7F1F49D28F5FB5C44C;
        Fri, 18 Sep 2020 14:37:17 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Fri, 18 Sep 2020
 14:37:07 +0800
From:   Lu Wei <luwei32@huawei.com>
To:     <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>
Subject: [PATCH] net: hns: kerneldoc fixes
Date:   Fri, 18 Sep 2020 14:36:46 +0800
Message-ID: <20200918063646.102600-1-luwei32@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix some parameter description mistakes.

Signed-off-by: Lu Wei <luwei32@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c
index ed3829ae4ef1..a769273b36f7 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c
@@ -334,7 +334,7 @@ static void hns_dsaf_xge_srst_by_port_acpi(struct dsaf_device *dsaf_dev,
  * bit6-11 for ppe0-5
  * bit12-17 for roce0-5
  * bit18-19 for com/dfx
- * @enable: false - request reset , true - drop reset
+ * @dereset: false - request reset , true - drop reset
  */
 static void
 hns_dsaf_srst_chns(struct dsaf_device *dsaf_dev, u32 msk, bool dereset)
@@ -357,7 +357,7 @@ hns_dsaf_srst_chns(struct dsaf_device *dsaf_dev, u32 msk, bool dereset)
  * bit6-11 for ppe0-5
  * bit12-17 for roce0-5
  * bit18-19 for com/dfx
- * @enable: false - request reset , true - drop reset
+ * @dereset: false - request reset , true - drop reset
  */
 static void
 hns_dsaf_srst_chns_acpi(struct dsaf_device *dsaf_dev, u32 msk, bool dereset)
-- 
2.17.1

