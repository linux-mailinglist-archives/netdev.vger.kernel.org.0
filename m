Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77DB3134469
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 14:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728560AbgAHN6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 08:58:05 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:58532 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727206AbgAHN6F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 08:58:05 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id DB3D44FDA4190C1CA6DA;
        Wed,  8 Jan 2020 21:58:02 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Wed, 8 Jan 2020
 21:57:55 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <kvalo@codeaurora.org>, <arend.vanspriel@broadcom.com>
CC:     <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <brcm80211-dev-list@cypress.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, yuehaibing <yuehaibing@huawei.com>
Subject: [PATCH] brcmfmac: Remove always false 'idx < 0' statement
Date:   Wed, 8 Jan 2020 21:57:48 +0800
Message-ID: <20200108135748.46096-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: yuehaibing <yuehaibing@huawei.com>

idx is declared as u32, it will never less than 0.

Signed-off-by: yuehaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
index e3dd862..8bb4f1f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -365,7 +365,7 @@ brcmf_msgbuf_get_pktid(struct device *dev, struct brcmf_msgbuf_pktids *pktids,
 	struct brcmf_msgbuf_pktid *pktid;
 	struct sk_buff *skb;
 
-	if (idx < 0 || idx >= pktids->array_size) {
+	if (idx >= pktids->array_size) {
 		brcmf_err("Invalid packet id %d (max %d)\n", idx,
 			  pktids->array_size);
 		return NULL;
-- 
2.7.4


