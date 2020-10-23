Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 492FE296B8F
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 10:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S460872AbgJWI4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 04:56:19 -0400
Received: from smtp21.cstnet.cn ([159.226.251.21]:57946 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S460855AbgJWI4T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 04:56:19 -0400
Received: from ubuntu18.localdomain (unknown [124.16.141.242])
        by APP-01 (Coremail) with SMTP id qwCowADHKFaimpJf_Dx1Aw--.33307S2;
        Fri, 23 Oct 2020 16:56:02 +0800 (CST)
From:   Xu Wang <vulab@iscas.ac.cn>
To:     jdmason@kudzu.us, davem@davemloft.net, kuba@kernel.org,
        jesse.brandeburg@intel.com, christophe.jaillet@wanadoo.fr,
        gustavoars@kernel.org, bigeasy@linutronix.de
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xu Wang <vulab@iscas.ac.cn>
Subject: [PATCH] vxge: remove unnecessary cast in kfree()
Date:   Fri, 23 Oct 2020 16:55:33 +0800
Message-Id: <20201023085533.4792-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: qwCowADHKFaimpJf_Dx1Aw--.33307S2
X-Coremail-Antispam: 1UD129KBjvdXoWrtF45uFW5Kw1DtF4rtF17Awb_yoW3ZwcE9r
        42qF1rGFn8A34Skw4YyFZ3Z34S9an5XryrZFWxtFZxXFW2gFy3J34DZFZxXr98WF4xGFZx
        GrZFyFy3A34FqjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbVkFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
        Gr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
        n2kIc2xKxwCY02Avz4vE14v_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr
        0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY
        17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcV
        C0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF
        0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2Kf
        nxnUUI43ZEXa7VUjAhL5UUUUU==
X-Originating-IP: [124.16.141.242]
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCgUSA1z4jFfGsQAAsW
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove unnecessary cast in the argument to kfree.

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
---
 drivers/net/ethernet/neterion/vxge/vxge-config.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/neterion/vxge/vxge-config.c b/drivers/net/ethernet/neterion/vxge/vxge-config.c
index f5d48d7c4ce2..da48dd85770c 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-config.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-config.c
@@ -1121,7 +1121,7 @@ static void __vxge_hw_blockpool_destroy(struct __vxge_hw_blockpool *blockpool)
 
 	list_for_each_safe(p, n, &blockpool->free_entry_list) {
 		list_del(&((struct __vxge_hw_blockpool_entry *)p)->item);
-		kfree((void *)p);
+		kfree(p);
 	}
 
 	return;
-- 
2.17.1

