Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0480925D93C
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 15:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730358AbgIDNEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 09:04:38 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:59646 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729297AbgIDNEg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 09:04:36 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 5661F5AA6CE11C5F8329;
        Fri,  4 Sep 2020 21:04:34 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Fri, 4 Sep 2020
 21:04:30 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <gustavo@embeddedor.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] NFC: digital: Remove two unused macroes
Date:   Fri, 4 Sep 2020 21:01:57 +0800
Message-ID: <20200904130157.17812-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DIGITAL_NFC_DEP_REQ_RES_TAILROOM is never used after it was introduced.
DIGITAL_NFC_DEP_REQ_RES_HEADROOM is no more used after below
commit e8e7f4217564 ("NFC: digital: Remove useless call to skb_reserve()")
Remove them.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 net/nfc/digital_dep.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/nfc/digital_dep.c b/net/nfc/digital_dep.c
index 304b1a9bb18a..5971fb6f51cc 100644
--- a/net/nfc/digital_dep.c
+++ b/net/nfc/digital_dep.c
@@ -38,9 +38,6 @@
 
 #define DIGITAL_GB_BIT	0x02
 
-#define DIGITAL_NFC_DEP_REQ_RES_HEADROOM	2 /* SoD: [SB (NFC-A)] + LEN */
-#define DIGITAL_NFC_DEP_REQ_RES_TAILROOM	2 /* EoD: 2-byte CRC */
-
 #define DIGITAL_NFC_DEP_PFB_TYPE(pfb) ((pfb) & 0xE0)
 
 #define DIGITAL_NFC_DEP_PFB_TIMEOUT_BIT 0x10
-- 
2.17.1

