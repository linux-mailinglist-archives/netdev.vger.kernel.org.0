Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51EC730D79F
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 11:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233883AbhBCKdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 05:33:14 -0500
Received: from m12-17.163.com ([220.181.12.17]:53410 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232865AbhBCKdL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 05:33:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=Oa9fJWAe0/0aV9P9p2
        Zg+Ft1ZwGWfRwM5fVUa4V6GlY=; b=kIStVPWZKAlsZF75zqyOXOmRwHzfoo8vBB
        nDyZL5IuOhQhwlE0h8d+XCIYYxO4d6AqBM43gJ4GdbJIM4fwxdaKAG3vlPd0q/Qn
        spZ33oE6JqEzqgBmj0QLw3MtxArMj6zOkimMeh+Rb2X2waBH8p4UTXXLZmaxwFCV
        THNcltOQU=
Received: from wengjianfeng.ccdomain.com (unknown [119.137.55.230])
        by smtp13 (Coremail) with SMTP id EcCowAAX_XTyRBpgXHrGjA--.48279S2;
        Wed, 03 Feb 2021 14:38:43 +0800 (CST)
From:   samirweng1979 <samirweng1979@163.com>
To:     stf_xl@wp.pl, helmut.schaa@googlemail.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: [PATCH] rt2x00: remove duplicate word in comment
Date:   Wed,  3 Feb 2021 14:38:50 +0800
Message-Id: <20210203063850.15844-1-samirweng1979@163.com>
X-Mailer: git-send-email 2.15.0.windows.1
X-CM-TRANSID: EcCowAAX_XTyRBpgXHrGjA--.48279S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtrW7Cw47ur13tFy7JF1DZFb_yoWDWFX_ur
        y8Wrs7Z348Jw1YvF4jvFW7Xrya9r93Zr1kGw1jgr9xWry5ZrWUWan3AF4Sqw1jkr40vrnx
        GF4DJr9Yv3yjvjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU5hSdPUUUUU==
X-Originating-IP: [119.137.55.230]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/1tbiERMusV7+2swKlgAAs3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wengjianfeng <wengjianfeng@yulong.com>

remove duplicate word 'we' in comment

Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00crypto.c b/drivers/net/wireless/ralink/rt2x00/rt2x00crypto.c
index c861811..7158152 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00crypto.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00crypto.c
@@ -179,7 +179,7 @@ void rt2x00crypto_rx_insert_iv(struct sk_buff *skb,
 	 * Make room for new data. There are 2 possibilities
 	 * either the alignment is already present between
 	 * the 802.11 header and payload. In that case we
-	 * we have to move the header less then the iv_len
+	 * have to move the header less then the iv_len
 	 * since we can use the already available l2pad bytes
 	 * for the iv data.
 	 * When the alignment must be added manually we must
-- 
1.9.1


