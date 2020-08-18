Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13C924813C
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 10:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgHRI7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 04:59:03 -0400
Received: from smtp21.cstnet.cn ([159.226.251.21]:50616 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726341AbgHRI7D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 04:59:03 -0400
Received: from localhost (unknown [159.226.5.99])
        by APP-01 (Coremail) with SMTP id qwCowAD3lkRelztfI8eLAQ--.19298S2;
        Tue, 18 Aug 2020 16:54:54 +0800 (CST)
From:   Xu Wang <vulab@iscas.ac.cn>
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Xu Wang <vulab@iscas.ac.cn>
Subject: [PATCH] rpl_iptunnel: simplify the return expression of rpl_do_srh()
Date:   Tue, 18 Aug 2020 08:54:54 +0000
Message-Id: <20200818085454.12224-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: qwCowAD3lkRelztfI8eLAQ--.19298S2
X-Coremail-Antispam: 1UD129KBjvdXoWruF47GF4DJrWfXFykAFWrXwb_yoW3JFg_CF
        1vgFWxCrn3ur4FkanxCa1fAF9Fq3s2vF40g3s7KrW8t343KrZI9rnavFW5GrykWrWvkryU
        Xa40kFyIyr1fWjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbfxYjsxI4VWDJwAYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I
        6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
        8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0
        cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z2
        80aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAK
        zVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Cr1j6rxdMc
        vjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjcxG6xCI17CEII8vrVW3JVW8
        Jr1lF7I21c0EjII2zVCS5cI20VAGYxC7MxkIecxEwVAFwVW8ZwCF04k20xvY0x0EwIxGrw
        CFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE
        14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2
        IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxK
        x2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxV
        AFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0ziAR65UUUUU=
X-Originating-IP: [159.226.5.99]
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCwUMA1z4jXyoSgAAs2
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the return expression.

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
---
 net/ipv6/rpl_iptunnel.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/ipv6/rpl_iptunnel.c b/net/ipv6/rpl_iptunnel.c
index 5fdf3ebb953f..e58ad9ac987c 100644
--- a/net/ipv6/rpl_iptunnel.c
+++ b/net/ipv6/rpl_iptunnel.c
@@ -197,11 +197,7 @@ static int rpl_do_srh(struct sk_buff *skb, const struct rpl_lwt *rlwt)
 
 	tinfo = rpl_encap_lwtunnel(dst->lwtstate);
 
-	err = rpl_do_srh_inline(skb, rlwt, tinfo->srh);
-	if (err)
-		return err;
-
-	return 0;
+	return rpl_do_srh_inline(skb, rlwt, tinfo->srh);
 }
 
 static int rpl_output(struct net *net, struct sock *sk, struct sk_buff *skb)
-- 
2.17.1

