Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2775311A90A
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 11:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728929AbfLKKip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 05:38:45 -0500
Received: from smtp21.cstnet.cn ([159.226.251.21]:40482 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727496AbfLKKip (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 05:38:45 -0500
X-Greylist: delayed 419 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Dec 2019 05:38:43 EST
Received: from localhost.localdomain (unknown [159.226.5.100])
        by APP-01 (Coremail) with SMTP id qwCowACnrrp+xfBdniUxAw--.217S3;
        Wed, 11 Dec 2019 18:31:27 +0800 (CST)
From:   Xu Wang <vulab@iscas.ac.cn>
To:     peppe.cavallaro@st.com
Cc:     alexandre.torgue@st.com, joabreu@synopsys.com, davem@davemloft.net,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] stmmac: platform: Remove unnecessary conditions
Date:   Wed, 11 Dec 2019 10:31:24 +0000
Message-Id: <1576060284-12371-1-git-send-email-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: qwCowACnrrp+xfBdniUxAw--.217S3
X-Coremail-Antispam: 1UD129KBjvdXoW7GFyrAFWDCw1UWF4DZr45Awb_yoWDAwcE93
        W29FnxGF1UJF90kw47Kr43ur92vFyDuF1rJF1DXFW3A34kXas8JFZ8uryUA3WxC342vF9r
        Gwn3KF17A3sxGjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbw8YjsxI4VW3JwAYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I
        6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
        8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0
        cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4
        A2jsIEc7CjxVAFwI0_Cr1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
        64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8Jw
        Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2Ij64vIr41l4I8I
        3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxV
        WUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAF
        wI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcI
        k0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_
        Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07je1v3UUUUU=
X-Originating-IP: [159.226.5.100]
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBAoBA102SyGETgAAsH
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove conditions where if and else branch are identical.
This issue is detected by coccinelle.

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index bedaff0..1d26691 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -229,8 +229,6 @@ static int stmmac_mtl_setup(struct platform_device *pdev,
 		plat->tx_sched_algorithm = MTL_TX_ALGORITHM_WFQ;
 	else if (of_property_read_bool(tx_node, "snps,tx-sched-dwrr"))
 		plat->tx_sched_algorithm = MTL_TX_ALGORITHM_DWRR;
-	else if (of_property_read_bool(tx_node, "snps,tx-sched-sp"))
-		plat->tx_sched_algorithm = MTL_TX_ALGORITHM_SP;
 	else
 		plat->tx_sched_algorithm = MTL_TX_ALGORITHM_SP;
 
-- 
2.7.4

