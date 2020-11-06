Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7C872A90D6
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 08:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726588AbgKFH5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 02:57:10 -0500
Received: from m176115.mail.qiye.163.com ([59.111.176.115]:36879 "EHLO
        m176115.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726248AbgKFH5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 02:57:09 -0500
Received: from vivo-HP-ProDesk-680-G4-PCI-MT.vivo.xyz (unknown [58.251.74.231])
        by m176115.mail.qiye.163.com (Hmail) with ESMTPA id 39E20667127;
        Fri,  6 Nov 2020 15:50:31 +0800 (CST)
From:   Wang Qing <wangqing@vivo.com>
To:     Oliver Neukum <oliver@neukum.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>
Subject: [PATCH] net: usb: fix spelling typo in cdc_ncm.c
Date:   Fri,  6 Nov 2020 15:50:25 +0800
Message-Id: <1604649025-22559-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZT01NSktLGRpOH0tIVkpNS09NT0JLSEpMS0hVEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKQ1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Mz46Ehw4CD8uKx05Dj4LAkIJ
        ITZPFBhVSlVKTUtPTU9CS0hJS0NMVTMWGhIXVQwaFRwKEhUcOw0SDRRVGBQWRVlXWRILWUFZTkNV
        SU5KVUxPVUlISllXWQgBWUFKTUpLNwY+
X-HM-Tid: 0a759c89178e9373kuws39e20667127
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Actually, withing should be within.

Signed-off-by: Wang Qing <wangqing@vivo.com>
---
 drivers/net/usb/cdc_ncm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index e04f588..746353c
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1317,7 +1317,7 @@ cdc_ncm_fill_tx_frame(struct usbnet *dev, struct sk_buff *skb, __le32 sign)
 			break;
 		}
 
-		/* calculate frame number withing this NDP */
+		/* calculate frame number within this NDP */
 		if (ctx->is_ndp16) {
 			ndplen = le16_to_cpu(ndp.ndp16->wLength);
 			index = (ndplen - sizeof(struct usb_cdc_ncm_ndp16)) / sizeof(struct usb_cdc_ncm_dpe16) - 1;
-- 
2.7.4

