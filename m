Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35E42301480
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 11:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbhAWKZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 05:25:42 -0500
Received: from m12-14.163.com ([220.181.12.14]:38467 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725769AbhAWKZk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 Jan 2021 05:25:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=D0k6r2pWCL9eDP5sNC
        MqI8cXd/GSdRb5LMudyN7noj4=; b=U8eoqfOdZ2Er5W0OqZFBN8s2z+dVStjtKr
        5O0t//0CjjaFzOXIjlfuKkTfco7u5NYdkRz2qG8aSzXlte4KCEzPV0DLwBFQnjQY
        IlLx4xsDd+tp2DDQ1H8kjEM49w5MaF7E57e21Kd2/ewv7X0R5sdcwlQNJGeOgi5i
        vUbwa41vw=
Received: from wengjianfeng.ccdomain.com (unknown [119.137.55.101])
        by smtp10 (Coremail) with SMTP id DsCowAB3QNzJ1AtglIvNhQ--.50233S2;
        Sat, 23 Jan 2021 15:48:26 +0800 (CST)
From:   samirweng1979 <samirweng1979@163.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: [PATCH] nfc/ftp: fix typo issue
Date:   Sat, 23 Jan 2021 15:48:35 +0800
Message-Id: <20210123074835.9448-1-samirweng1979@163.com>
X-Mailer: git-send-email 2.15.0.windows.1
X-CM-TRANSID: DsCowAB3QNzJ1AtglIvNhQ--.50233S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtrWxZF1ktF17GryrXF1rCrg_yoWxKFXEkr
        sYqr47uw4Fgr1Yyry5CFy3ZF4rtr4xWrs3G3Z0gFWayr9rAF4xZa4UCryfJr1fGa1jyFnx
        Wwn5X34rAr47WjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU5V5lUUUUUU==
X-Originating-IP: [119.137.55.101]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/1tbiEQojsV7+2iq6OgAAsZ
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wengjianfeng <wengjianfeng@yulong.com>

change 'paquet' to 'packet'

Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
---
 drivers/nfc/fdp/i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/fdp/i2c.c b/drivers/nfc/fdp/i2c.c
index ad0abb1..adaa1a7 100644
--- a/drivers/nfc/fdp/i2c.c
+++ b/drivers/nfc/fdp/i2c.c
@@ -155,7 +155,7 @@ static int fdp_nci_i2c_read(struct fdp_i2c_phy *phy, struct sk_buff **skb)
 
 		/*
 		 * LRC check failed. This may due to transmission error or
-		 * desynchronization between driver and FDP. Drop the paquet
+		 * desynchronization between driver and FDP. Drop the packet
 		 * and force resynchronization
 		 */
 		if (lrc) {
-- 
1.9.1


