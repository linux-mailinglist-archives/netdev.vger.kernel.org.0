Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAC9911CE78
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 14:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729473AbfLLNg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 08:36:57 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:46065 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729428AbfLLNg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 08:36:57 -0500
Received: from orion.localdomain ([77.9.34.244]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1N30VJ-1hjUae0AJh-013OL2; Thu, 12 Dec 2019 14:36:45 +0100
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, jchapman@katalix.com, netdev@vger.kernel.org
Subject: [PATCH] net: l2tp: remove unneeded MODULE_VERSION() usage
Date:   Thu, 12 Dec 2019 14:36:13 +0100
Message-Id: <20191212133613.25376-1-info@metux.net>
X-Mailer: git-send-email 2.11.0
X-Provags-ID: V03:K1:6qYUVL/1QU7SOmEBdm0nTdLO073oCYRrqAiMznG4x2UbdVcYzn7
 pgsQGBHsYMDHccGq2ca7NLLAWCas6SESLnDKlJXliSGoeoVTJdRXc52sCpQG4T6wXt6mNuA
 MYnPlyfyN8xHVfLRy/znxflU2lKSKNOguk5GQTGlti/ruVG+yogyH7Kj2Nbq1DjzI51D88+
 Tse7xwcZTbopic+s5JeCw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:5Jbj/oeTWbs=:izDIY2av33ECANoVM1qixZ
 LcohtjqEiy2/hhxIYhSv7jVhAzttGtYlykjk7o4Oxzgk+ahiTSSCTo/buh32NH5AvofXw3vaH
 g0XU68ZCTw2IIzU2gBYpBfXBbuSolat71ykRxBCaSgQ6gn5VEfbBsP7XEoMQ2Q5orfvxwe1+N
 k02MwiF6PbQnmOvwnBGjcB+XPzHzsgNlLRkhyi81EtRCS5LKzgV6jaEOzyC5iH7DhPJrim6qr
 4BW7opeUHv4Fy0YwQLH7cPS9U0cWnjg9qfm9WfhWmMQek8AW6/VHR8gkN0bmVQYI/eBddNQUg
 3EfR1o4bsMEoFXyWsLvhtNarrdhkNYQ9yuQHr4ttgvBtbG/3VP4vazHnclqYeHnfIWKjXr44S
 ttgWfbrZO7ljP2EZJBhsnDdcnSkWWuDzskFw6ehbNXxAQq2ziMIuBmj9OmXN5U4hbhWsBlmms
 e6MCaRpf+nN7B1rnMk6+A7BNPenG7SF4fkcUSerbUHpXLca9AuJS+Gza7iQvnkY07VZn8qYvH
 08rN0rCr1Z/6Mjug2vKj3bkiA9OfCN4/NbdlqCE+nDr7n7QtdMY7Hlyf7CpuUtfmCJotcI316
 9xoZRztrPf2lw8WYYHg8e/3EIavUHXA9uFoxEWOu/aQcTL/Ajy1n07yIpLnYbOlv0YEg9pb+I
 /worppFg//iGyVmKFyHuOev2cAnob3LxMMu1B08PrXHKM34hGmHWHmmRtECWK4RjLYZT+AiEP
 3/iLIHDv4T/ADH5KARdTOi1mdtxyc0ycF6rqT0QD0qRPZVZPu6Vbrmnnp6rgX2TA5Cp9f3zpL
 OCVwPC0s0EfB3WGm47Zyc1xZ2sCuLiwkDS7eDskMYhTqRZty76mBqQ4LCrVF47pLhJeLU2FDl
 9vCUTiNR/o5tzBqzHk8A==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove MODULE_VERSION(), as it isn't needed at all: the only version
making sense is the kernel version.

Signed-off-by: Enrico Weigelt, metux IT consult <info@metux.net>
---
 net/l2tp/l2tp_core.c    | 1 -
 net/l2tp/l2tp_debugfs.c | 1 -
 net/l2tp/l2tp_eth.c     | 1 -
 net/l2tp/l2tp_ip.c      | 1 -
 net/l2tp/l2tp_ip6.c     | 1 -
 net/l2tp/l2tp_netlink.c | 1 -
 net/l2tp/l2tp_ppp.c     | 1 -
 7 files changed, 7 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index f82ea12bac37..29da8b28046f 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1784,4 +1784,3 @@ module_exit(l2tp_exit);
 MODULE_AUTHOR("James Chapman <jchapman@katalix.com>");
 MODULE_DESCRIPTION("L2TP core");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(L2TP_DRV_VERSION);
diff --git a/net/l2tp/l2tp_debugfs.c b/net/l2tp/l2tp_debugfs.c
index 35bb4f3bdbe0..fa84078d1809 100644
--- a/net/l2tp/l2tp_debugfs.c
+++ b/net/l2tp/l2tp_debugfs.c
@@ -345,4 +345,3 @@ module_exit(l2tp_debugfs_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("James Chapman <jchapman@katalix.com>");
 MODULE_DESCRIPTION("L2TP debugfs driver");
-MODULE_VERSION("1.0");
diff --git a/net/l2tp/l2tp_eth.c b/net/l2tp/l2tp_eth.c
index d3b520b9b2c9..d0569e993574 100644
--- a/net/l2tp/l2tp_eth.c
+++ b/net/l2tp/l2tp_eth.c
@@ -381,5 +381,4 @@ module_exit(l2tp_eth_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("James Chapman <jchapman@katalix.com>");
 MODULE_DESCRIPTION("L2TP ethernet pseudowire driver");
-MODULE_VERSION("1.0");
 MODULE_ALIAS_L2TP_PWTYPE(5);
diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
index 0d7c887a2b75..f02909157e25 100644
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -677,7 +677,6 @@ module_exit(l2tp_ip_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("James Chapman <jchapman@katalix.com>");
 MODULE_DESCRIPTION("L2TP over IP");
-MODULE_VERSION("1.0");
 
 /* Use the value of SOCK_DGRAM (2) directory, because __stringify doesn't like
  * enums
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index d148766f40d1..8fa37a30347a 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -810,7 +810,6 @@ module_exit(l2tp_ip6_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Chris Elston <celston@katalix.com>");
 MODULE_DESCRIPTION("L2TP IP encapsulation for IPv6");
-MODULE_VERSION("1.0");
 
 /* Use the value of SOCK_DGRAM (2) directory, because __stringify doesn't like
  * enums
diff --git a/net/l2tp/l2tp_netlink.c b/net/l2tp/l2tp_netlink.c
index f5a9bdc4980c..89b85371d4d3 100644
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -1032,5 +1032,4 @@ module_exit(l2tp_nl_cleanup);
 MODULE_AUTHOR("James Chapman <jchapman@katalix.com>");
 MODULE_DESCRIPTION("L2TP netlink");
 MODULE_LICENSE("GPL");
-MODULE_VERSION("1.0");
 MODULE_ALIAS_GENL_FAMILY("l2tp");
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index c54cb59593ef..4b4be64e3fe2 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -1755,6 +1755,5 @@ module_exit(pppol2tp_exit);
 MODULE_AUTHOR("James Chapman <jchapman@katalix.com>");
 MODULE_DESCRIPTION("PPP over L2TP over UDP");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(PPPOL2TP_DRV_VERSION);
 MODULE_ALIAS_NET_PF_PROTO(PF_PPPOX, PX_PROTO_OL2TP);
 MODULE_ALIAS_L2TP_PWTYPE(7);
-- 
2.11.0

