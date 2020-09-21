Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B09CF271B0B
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 08:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgIUGrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 02:47:13 -0400
Received: from smtp21.cstnet.cn ([159.226.251.21]:36484 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726149AbgIUGrN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 02:47:13 -0400
X-Greylist: delayed 482 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Sep 2020 02:47:12 EDT
Received: from localhost (unknown [159.226.5.99])
        by APP-01 (Coremail) with SMTP id qwCowABHXfCBSmhfvpqtAA--.58445S2;
        Mon, 21 Sep 2020 14:38:58 +0800 (CST)
From:   Xu Wang <vulab@iscas.ac.cn>
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Xu Wang <vulab@iscas.ac.cn>
Subject: [PATCH] ipv6: route: convert comma to semicolon
Date:   Mon, 21 Sep 2020 06:38:56 +0000
Message-Id: <20200921063856.26285-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: qwCowABHXfCBSmhfvpqtAA--.58445S2
X-Coremail-Antispam: 1UD129KBjvdXoWrGrWfXF15ZF4UXrykuFyUJrb_yoWxXwc_JF
        yDGrZ5uryYqrn29F4jyFs5JF9rt348AF4Ig3WSgrWkt348Xr1xArn3Wr9rC39Igryj9Fy5
        uryDXFZFkayfKjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbzxFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
        Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
        0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
        jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWxJVW8Jr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCF04k20xvY0x0EwIxG
        rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4
        vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IY
        x2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26c
        xKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
        67AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VU1fgA7UUUUU==
X-Originating-IP: [159.226.5.99]
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCwUGA1z4jc0QlQAAsq
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace a comma between expression statements by a semicolon.

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
---
 net/ipv6/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 5e7e25e2523a..fb075d9545b9 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -4202,7 +4202,7 @@ static struct fib6_info *rt6_add_route_info(struct net *net,
 		.fc_nlinfo.nl_net = net,
 	};
 
-	cfg.fc_table = l3mdev_fib_table(dev) ? : RT6_TABLE_INFO,
+	cfg.fc_table = l3mdev_fib_table(dev) ? : RT6_TABLE_INFO;
 	cfg.fc_dst = *prefix;
 	cfg.fc_gateway = *gwaddr;
 
-- 
2.17.1

