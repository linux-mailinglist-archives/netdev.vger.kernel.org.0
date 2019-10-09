Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E686D113C
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 16:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731494AbfJIO3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 10:29:18 -0400
Received: from mail.loongson.cn ([114.242.206.163]:40192 "EHLO
        mail.loongson.cn" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731133AbfJIO3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 10:29:18 -0400
Received: from linux.loongson.cn (unknown [10.20.41.27])
        by mail (Coremail) with SMTP id QMiowPAxycSw7p1dSqQMAA--.37S2;
        Wed, 09 Oct 2019 22:29:04 +0800 (CST)
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
To:     davem@davemloft.net, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: stmmac: Remove break after a return
Date:   Wed,  9 Oct 2019 22:29:00 +0800
Message-Id: <1570631340-5467-1-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
X-CM-TRANSID: QMiowPAxycSw7p1dSqQMAA--.37S2
X-Coremail-Antispam: 1UD129KBjvdXoWrtF4rKr4xAF1kCr4kKr45KFg_yoWkCFX_Cr
        y0qr4fXa90kF1jyw12yayUXryj9FnrXFs3GFsIqF93u3y2qwn5tasxurZYyr1a9ay8AFnr
        GFn3tFy7A34kKjkaLaAFLSUrUUUUbb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb4AYjsxI4VWDJwAYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I
        6I8E6xAIw20EY4v20xvaj40_JFC_Wr1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
        8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0
        cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4
        A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IE
        w4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26F4j6r4UJw
        Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7xvr2IYc2Ij64vIr40E4x8a
        64kEw24l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67
        AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIY
        rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
        v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVW3JVWrJr1lIxAIcVC2z280aVAFwI0_Jr0_
        Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU8PDG5
        UUUUU==
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since break is not useful after a return, remove it.

Fixes: 3b57de958e2a ("net: stmmac: Support devicetree configs for mcast and ucast filter entries")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
index 3d69da1..d0356fb 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
@@ -130,7 +130,6 @@ static void dwmac1000_set_mchash(void __iomem *ioaddr, u32 *mcfilterbits,
 		writel(mcfilterbits[0], ioaddr + GMAC_HASH_LOW);
 		writel(mcfilterbits[1], ioaddr + GMAC_HASH_HIGH);
 		return;
-		break;
 	case 7:
 		numhashregs = 4;
 		break;
@@ -140,7 +139,6 @@ static void dwmac1000_set_mchash(void __iomem *ioaddr, u32 *mcfilterbits,
 	default:
 		pr_debug("STMMAC: err in setting multicast filter\n");
 		return;
-		break;
 	}
 	for (regs = 0; regs < numhashregs; regs++)
 		writel(mcfilterbits[regs],
-- 
2.1.0


