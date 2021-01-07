Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8049F2EC850
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 03:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbhAGCsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 21:48:37 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:58308 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726293AbhAGCsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 21:48:37 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=abaci-bugfix@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UKy5PJl_1609987657;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:abaci-bugfix@linux.alibaba.com fp:SMTPD_---0UKy5PJl_1609987657)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 07 Jan 2021 10:47:54 +0800
From:   Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
Subject: [PATCH] net/ipv6: warning: %u in format string (no. 2) requires 'unsigned int' but the argument type is 'signed int'.
Date:   Thu,  7 Jan 2021 10:47:34 +0800
Message-Id: <1609987654-11647-1-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The print format of this parameter does not match, because it is defined
as int type, so modify the matching format of this parameter to %d format.

Signed-off-by: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
Reported-by: Abaci <abaci@linux.alibaba.com>
---
 net/ipv6/proc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/proc.c b/net/ipv6/proc.c
index d6306aa..26c702b 100644
--- a/net/ipv6/proc.c
+++ b/net/ipv6/proc.c
@@ -169,7 +169,7 @@ static void snmp6_seq_show_icmpv6msg(struct seq_file *seq, atomic_long_t *smib)
 		val = atomic_long_read(smib + i);
 		if (!val)
 			continue;
-		snprintf(name, sizeof(name), "Icmp6%sType%u",
+		snprintf(name, sizeof(name), "Icmp6%sType%d",
 			i & 0x100 ?  "Out" : "In", i & 0xff);
 		seq_printf(seq, "%-32s\t%lu\n", name, val);
 	}
-- 
1.8.3.1

