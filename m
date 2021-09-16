Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C5740D18F
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 04:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233903AbhIPCI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 22:08:57 -0400
Received: from smtp23.cstnet.cn ([159.226.251.23]:48582 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233745AbhIPCIz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 22:08:55 -0400
Received: from localhost.localdomain (unknown [124.16.138.128])
        by APP-03 (Coremail) with SMTP id rQCowADX3XnOpkJhmWOVAA--.28482S2;
        Thu, 16 Sep 2021 10:07:10 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: [PATCH] netlink: Remove extra brackets of nla_for_each_attr()
Date:   Thu, 16 Sep 2021 02:07:08 +0000
Message-Id: <1631758028-3805500-1-git-send-email-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: rQCowADX3XnOpkJhmWOVAA--.28482S2
X-Coremail-Antispam: 1UD129KBjvdXoW7JrWDXFyfXw18uF1UZFW7CFg_yoWxtrbEyw
        s7ZrWvg3yrAFyakr18JFWkWF1Fkwn5JFyS9Fn3tw4fX348Jr13X395GrZxtFyfC397AFy3
        J3WIqry7J3y3ujkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb4kFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
        Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr
        1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
        7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r
        1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY02Avz4vE14v_
        Gr1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxV
        WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI
        7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
        1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8
        JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfU5vtCUU
        UUU
X-Originating-IP: [124.16.138.128]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's obvious that '&(rem)' has unneeded brackets.
Therefore it's better to remove them.

Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
---
 include/net/netlink.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 1ceec51..5822e0d 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -1920,7 +1920,7 @@ static inline int nla_total_size_64bit(int payload)
 #define nla_for_each_attr(pos, head, len, rem) \
 	for (pos = head, rem = len; \
 	     nla_ok(pos, rem); \
-	     pos = nla_next(pos, &(rem)))
+	     pos = nla_next(pos, &rem))
 
 /**
  * nla_for_each_nested - iterate over nested attributes
-- 
2.7.4

