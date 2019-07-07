Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE63613D9
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 06:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbfGGEdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 00:33:38 -0400
Received: from m12-13.163.com ([220.181.12.13]:46785 "EHLO m12-13.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbfGGEdi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Jul 2019 00:33:38 -0400
X-Greylist: delayed 906 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Jul 2019 00:33:34 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=obkgI72FnkfilFr+aG
        Iy9W7IsYqdSbTqaaEZ3FLrriA=; b=DEVuW4gyKlk83j4/+KPUpMZpfvcwWzq2jL
        1jKT8EcZagpc1Rh7oklwAYNQAYfJppkDaiDbK3pK7ZtJV9VO0nv23OoPCsg0mLCP
        3jJMl0mcxEuny1vsXSA396kC1pv+XznLfDKawI+FzhplcQQQA2Flo9xeUBBkD8Vq
        URMtsD/hU=
Received: from localhost.localdomain (unknown [125.82.14.162])
        by smtp9 (Coremail) with SMTP id DcCowACnI71WciFdP77+AA--.37123S2;
        Sun, 07 Jul 2019 12:17:27 +0800 (CST)
From:   xianfengting221@163.com
To:     wensong@linux-vs.org, horms@verge.net.au, ja@ssi.bg,
        pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hu Haowen <xianfengting221@163.com>
Subject: [PATCH] ipvs: Delete some unused space characters in Kconfig
Date:   Sun,  7 Jul 2019 12:16:49 +0800
Message-Id: <1562473009-29726-1-git-send-email-xianfengting221@163.com>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: DcCowACnI71WciFdP77+AA--.37123S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Ar18JF1Utryfur1ktr43Wrg_yoW8tFyDpr
        9I9r13KF47Ar1Ykr97uFy8Cryxua93Jw45Gr1kZ3s7Aas8JFn2y3Z5trsrKa4UArZ5ZrW3
        ZFW5Xw1j93Z0yaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UJfH8UUUUU=
X-Originating-IP: [125.82.14.162]
X-CM-SenderInfo: h0ld0wxhqj3xtqjsjii6rwjhhfrp/1tbiMhzqAFWBjw5NGAAAsE
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hu Haowen <xianfengting221@163.com>

The space characters at the end of lines are always unused and
not easy to find. This patch deleted some of them I have found
in Kconfig.

Signed-off-by: Hu Haowen <xianfengting221@163.com>
---

This is my first patch to the Linux kernel, so please forgive
me if anything went wrong.

 net/netfilter/ipvs/Kconfig | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipvs/Kconfig b/net/netfilter/ipvs/Kconfig
index f6f1a0d..54afad5 100644
--- a/net/netfilter/ipvs/Kconfig
+++ b/net/netfilter/ipvs/Kconfig
@@ -120,7 +120,7 @@ config	IP_VS_RR
 
 	  If you want to compile it in kernel, say Y. To compile it as a
 	  module, choose M here. If unsure, say N.
- 
+
 config	IP_VS_WRR
 	tristate "weighted round-robin scheduling"
 	---help---
@@ -138,7 +138,7 @@ config	IP_VS_LC
         tristate "least-connection scheduling"
 	---help---
 	  The least-connection scheduling algorithm directs network
-	  connections to the server with the least number of active 
+	  connections to the server with the least number of active
 	  connections.
 
 	  If you want to compile it in kernel, say Y. To compile it as a
@@ -193,7 +193,7 @@ config  IP_VS_LBLCR
 	tristate "locality-based least-connection with replication scheduling"
 	---help---
 	  The locality-based least-connection with replication scheduling
-	  algorithm is also for destination IP load balancing. It is 
+	  algorithm is also for destination IP load balancing. It is
 	  usually used in cache cluster. It differs from the LBLC scheduling
 	  as follows: the load balancer maintains mappings from a target
 	  to a set of server nodes that can serve the target. Requests for
@@ -250,8 +250,8 @@ config	IP_VS_SED
 	tristate "shortest expected delay scheduling"
 	---help---
 	  The shortest expected delay scheduling algorithm assigns network
-	  connections to the server with the shortest expected delay. The 
-	  expected delay that the job will experience is (Ci + 1) / Ui if 
+	  connections to the server with the shortest expected delay. The
+	  expected delay that the job will experience is (Ci + 1) / Ui if
 	  sent to the ith server, in which Ci is the number of connections
 	  on the ith server and Ui is the fixed service rate (weight)
 	  of the ith server.
-- 
2.7.4


