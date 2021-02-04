Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBCE030E8F6
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 01:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234478AbhBDAxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 19:53:21 -0500
Received: from m12-16.163.com ([220.181.12.16]:36768 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234266AbhBDAxU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 19:53:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=hMNO2n8NEeG+F1B2PO
        O/M8BjP3yqWv44VFvbWtGSjq4=; b=l75cnHo0BJ0WkcXu9BsVHmM5uKXLS7cD/C
        OiEVuTCObm/AvtlWzyxV5/lmYoLJgs37PsmhbzTG/UadiJY6FfZ2mxevVInirv8F
        /zFcAvq604EKZtgZjh8ghZRxKUZ8T0xquzDa9ZrxAFY+PbiqBf4fFymCsF+OBzdN
        tMADId97s=
Received: from wengjianfeng.ccdomain.com (unknown [218.17.89.92])
        by smtp12 (Coremail) with SMTP id EMCowAAHDFD8RBtg9T6UaQ--.22444S2;
        Thu, 04 Feb 2021 08:51:09 +0800 (CST)
From:   samirweng1979 <samirweng1979@163.com>
To:     stf_xl@wp.pl, rdunlap@infradead.org, helmut.schaa@googlemail.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: [PATCH v2] rt2x00: remove duplicate word and fix typo in comment
Date:   Thu,  4 Feb 2021 08:51:19 +0800
Message-Id: <20210204005119.18060-1-samirweng1979@163.com>
X-Mailer: git-send-email 2.15.0.windows.1
X-CM-TRANSID: EMCowAAHDFD8RBtg9T6UaQ--.22444S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtrW3Gr48ZF1xCw1rZr4DCFg_yoWDZFg_ur
        y8urs7Z348Ja4YvF4jvFW7Zrya9r93Zr1kGwnIg39xWryYvrWkWan3AF4Sqw1jkr4jvrnx
        GF4DJF9Yv3yjqjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUYpnQUUUUUU==
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/1tbiLx0vsVUMXD4-kQAAs5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wengjianfeng <wengjianfeng@yulong.com>

remove duplicate word 'we' in comment
change 'then' to 'than' in comment

Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00crypto.c b/drivers/net/wireless/ralink/rt2x00/rt2x00crypto.c
index c861811..ad95f9e 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00crypto.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00crypto.c
@@ -179,7 +179,7 @@ void rt2x00crypto_rx_insert_iv(struct sk_buff *skb,
 	 * Make room for new data. There are 2 possibilities
 	 * either the alignment is already present between
 	 * the 802.11 header and payload. In that case we
-	 * we have to move the header less then the iv_len
+	 * have to move the header less than the iv_len
 	 * since we can use the already available l2pad bytes
 	 * for the iv data.
 	 * When the alignment must be added manually we must
-- 
1.9.1


