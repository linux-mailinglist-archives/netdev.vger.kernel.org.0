Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 499F63953BA
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 03:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbhEaBsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 21:48:30 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:3292 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbhEaBs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 21:48:29 -0400
Received: from dggeme760-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4FtdM54F3Gz1BGgZ;
        Mon, 31 May 2021 09:42:09 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeme760-chm.china.huawei.com (10.3.19.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 31 May 2021 09:46:48 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <krzysztof.kozlowski@canonical.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] nfc: hci: Fix spelling mistakes
Date:   Mon, 31 May 2021 10:00:19 +0800
Message-ID: <20210531020019.2919799-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix some spelling mistakes in comments:
occured  ==> occurred
negociate  ==> negotiate

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 net/nfc/hci/command.c   | 2 +-
 net/nfc/hci/core.c      | 2 +-
 net/nfc/hci/llc_shdlc.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/nfc/hci/command.c b/net/nfc/hci/command.c
index e02b9befce0b..3a89bd9b89fc 100644
--- a/net/nfc/hci/command.c
+++ b/net/nfc/hci/command.c
@@ -34,7 +34,7 @@ static int nfc_hci_execute_cmd_async(struct nfc_hci_dev *hdev, u8 pipe, u8 cmd,
  * HCI command execution completion callback.
  * err will be a standard linux error (may be converted from HCI response)
  * skb contains the response data and must be disposed, or may be NULL if
- * an error occured
+ * an error occurred
  */
 static void nfc_hci_execute_cb(void *context, struct sk_buff *skb, int err)
 {
diff --git a/net/nfc/hci/core.c b/net/nfc/hci/core.c
index 43811b5219b5..3481941be70b 100644
--- a/net/nfc/hci/core.c
+++ b/net/nfc/hci/core.c
@@ -705,7 +705,7 @@ static void hci_transceive_cb(void *context, struct sk_buff *skb, int err)
 		/*
 		 * TODO: Check RF Error indicator to make sure data is valid.
 		 * It seems that HCI cmd can complete without error, but data
-		 * can be invalid if an RF error occured? Ignore for now.
+		 * can be invalid if an RF error occurred? Ignore for now.
 		 */
 		if (err == 0)
 			skb_trim(skb, skb->len - 1); /* RF Err ind */
diff --git a/net/nfc/hci/llc_shdlc.c b/net/nfc/hci/llc_shdlc.c
index c0c8fea3a186..1e3a90049da9 100644
--- a/net/nfc/hci/llc_shdlc.c
+++ b/net/nfc/hci/llc_shdlc.c
@@ -406,7 +406,7 @@ static void llc_shdlc_rcv_u_frame(struct llc_shdlc *shdlc,
 		case SHDLC_NEGOTIATING:
 		case SHDLC_CONNECTING:
 			/*
-			 * We sent RSET, but chip wants to negociate or we
+			 * We sent RSET, but chip wants to negotiate or we
 			 * got RSET before we managed to send out our.
 			 */
 			if (skb->len > 0)
-- 
2.25.1

