Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 976FF411602
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 15:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239618AbhITNn5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 20 Sep 2021 09:43:57 -0400
Received: from mail1.shanghaitech.edu.cn ([119.78.254.90]:31900 "EHLO
        mail.shanghaitech.edu.cn" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232644AbhITNnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 09:43:55 -0400
Received: from [10.15.44.216] by mail.shanghaitech.edu.cn with MESSAGESEC ESMTP id 456895189764503;
        Mon, 20 Sep 2021 21:42:07 +0800 (CST)
Received: from DESKTOP-U066CHB.localdomain (10.15.44.220) by
 smtp.shanghaitech.edu.cn (10.15.44.216) with Microsoft SMTP Server (TLS) id
 14.3.399.0; Mon, 20 Sep 2021 21:42:09 +0800
From:   Mianhan Liu <liumh1@shanghaitech.edu.cn>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Mianhan Liu <liumh1@shanghaitech.edu.cn>
Subject: [PATCH -next] net/ipv4/sysctl_net_ipv4.c: remove superfluous header files from sysctl_net_ipv4.c
Date:   Mon, 20 Sep 2021 21:42:00 +0800
Message-ID: <20210920134200.31481-1-liumh1@shanghaitech.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain
X-Originating-IP: [10.15.44.220]
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sysctl_net_ipv4.c hasn't use any macro or function declared in mm.h, module.h,
igmp.h, inetdevice.h, swap.h, slab.h, nsproxy.h, snmp.h, route.h and inet_frag.h. 
Thus, these files can be removed from sysctl_net_ipv4.c safely without affecting
the compilation of the net module.

Signed-off-by: Mianhan Liu <liumh1@shanghaitech.edu.cn>

---
 net/ipv4/sysctl_net_ipv4.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 6f1e64d49..f8e39d00b 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -6,25 +6,15 @@
  * Added /proc/sys/net/ipv4 directory entry (empty =) ). [MS]
  */
 
-#include <linux/mm.h>
-#include <linux/module.h>
 #include <linux/sysctl.h>
-#include <linux/igmp.h>
-#include <linux/inetdevice.h>
 #include <linux/seqlock.h>
 #include <linux/init.h>
-#include <linux/slab.h>
-#include <linux/nsproxy.h>
-#include <linux/swap.h>
-#include <net/snmp.h>
 #include <net/icmp.h>
 #include <net/ip.h>
 #include <net/ip_fib.h>
-#include <net/route.h>
 #include <net/tcp.h>
 #include <net/udp.h>
 #include <net/cipso_ipv4.h>
-#include <net/inet_frag.h>
 #include <net/ping.h>
 #include <net/protocol.h>
 #include <net/netevent.h>
-- 
2.25.1


