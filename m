Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 021C52FB3B7
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 09:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731347AbhASIGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 03:06:47 -0500
Received: from smtp23.cstnet.cn ([159.226.251.23]:44652 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726023AbhASIBk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 03:01:40 -0500
Received: from localhost.localdomain (unknown [124.16.141.241])
        by APP-03 (Coremail) with SMTP id rQCowABn0iiokQZg3xbUAA--.54909S2;
        Tue, 19 Jan 2021 16:00:40 +0800 (CST)
From:   Xu Wang <vulab@iscas.ac.cn>
To:     sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] octeontx2-af: rvu.c: Remove unneeded semicolon
Date:   Tue, 19 Jan 2021 08:00:37 +0000
Message-Id: <20210119080037.17931-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: rQCowABn0iiokQZg3xbUAA--.54909S2
X-Coremail-Antispam: 1UD129KBjvdXoWrKF45CF1rKFy5CF48Jw1UKFg_yoW3uFcEkr
        nFqF43Zan8KF90yw1jyrW3Ja4Fv3WkXrWvyF43K39YkFWxJw4fCr97Cr4xXrWxur40q3WD
        Ar1ak3ySy3y2vjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb2AYjsxI4VWkCwAYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I
        6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
        8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0
        cI8IcVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4
        A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IE
        w4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r4UJVWxJr
        1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkIecxEwVAFwVW8ZwCF04k2
        0xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI
        8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41l
        IxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIx
        AIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvE
        x4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jYg4fUUUUU=
X-Originating-IP: [124.16.141.241]
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBgcGA10Te7OtdwAAsY
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fix semicolon.cocci warnings:
drivers/net/ethernet/marvell/octeontx2/af/rvu.c:1326:2-3: Unneeded semicolon

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index e8fd712860a1..0b6bf9f0c6f0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -1323,7 +1323,7 @@ static int rvu_get_attach_blkaddr(struct rvu *rvu, int blktype,
 		break;
 	default:
 		return rvu_get_blkaddr(rvu, blktype, 0);
-	};
+	}
 
 	if (is_block_implemented(rvu->hw, blkaddr))
 		return blkaddr;
-- 
2.17.1

