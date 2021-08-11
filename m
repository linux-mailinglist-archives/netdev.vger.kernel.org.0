Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA5923E947C
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 17:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbhHKPZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 11:25:05 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:38905 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232110AbhHKPZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 11:25:04 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=wenyang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0Uihn-HP_1628695472;
Received: from localhost(mailfrom:wenyang@linux.alibaba.com fp:SMTPD_---0Uihn-HP_1628695472)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 11 Aug 2021 23:24:38 +0800
From:   Wen Yang <wenyang@linux.alibaba.com>
To:     davem@davemloft.net, David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     Wen Yang <wenyang@linux.alibaba.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ipv4: fix up inetsw_array coding style
Date:   Wed, 11 Aug 2021 23:24:30 +0800
Message-Id: <20210811152431.66426-1-wenyang@linux.alibaba.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch from a mix of tabs and spaces to just tabs.

Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: David Ahern <dsahern@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 net/ipv4/af_inet.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 5464818..0f6f138 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1136,23 +1136,23 @@ static int inet_compat_ioctl(struct socket *sock, unsigned int cmd, unsigned lon
 		.prot =       &udp_prot,
 		.ops =        &inet_dgram_ops,
 		.flags =      INET_PROTOSW_PERMANENT,
-       },
+	},
 
-       {
+	{
 		.type =       SOCK_DGRAM,
 		.protocol =   IPPROTO_ICMP,
 		.prot =       &ping_prot,
 		.ops =        &inet_sockraw_ops,
 		.flags =      INET_PROTOSW_REUSE,
-       },
-
-       {
-	       .type =       SOCK_RAW,
-	       .protocol =   IPPROTO_IP,	/* wild card */
-	       .prot =       &raw_prot,
-	       .ops =        &inet_sockraw_ops,
-	       .flags =      INET_PROTOSW_REUSE,
-       }
+	},
+
+	{
+		.type =       SOCK_RAW,
+		.protocol =   IPPROTO_IP,	/* wild card */
+		.prot =       &raw_prot,
+		.ops =        &inet_sockraw_ops,
+		.flags =      INET_PROTOSW_REUSE,
+	}
 };
 
 #define INETSW_ARRAY_LEN ARRAY_SIZE(inetsw_array)
-- 
1.8.3.1

