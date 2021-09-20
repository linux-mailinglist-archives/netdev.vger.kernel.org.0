Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A6A4113BF
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 13:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237221AbhITLtF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 20 Sep 2021 07:49:05 -0400
Received: from mail1.shanghaitech.edu.cn ([119.78.254.90]:33703 "EHLO
        mail.shanghaitech.edu.cn" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237077AbhITLtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 07:49:04 -0400
Received: from [10.15.44.215] by mail.shanghaitech.edu.cn with MESSAGESEC ESMTP id 456895189764503;
        Mon, 20 Sep 2021 19:32:06 +0800 (CST)
Received: from DESKTOP-U066CHB.localdomain (10.15.44.220) by
 smtp.shanghaitech.edu.cn (10.15.44.215) with Microsoft SMTP Server (TLS) id
 14.3.399.0; Mon, 20 Sep 2021 19:32:08 +0800
From:   Mianhan Liu <liumh1@shanghaitech.edu.cn>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Mianhan Liu <liumh1@shanghaitech.edu.cn>
Subject: [PATCH -next] net/ipv4/route.c: remove superfluous header files from route.c
Date:   Mon, 20 Sep 2021 19:31:37 +0800
Message-ID: <20210920113137.25121-1-liumh1@shanghaitech.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain
X-Originating-IP: [10.15.44.220]
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

route.c hasn't use any macro or function declared in uaccess.h, types.h,
string.h, sockios.h, times.h, protocol.h, arp.h and l3mdev.h. Thus, these
files can be removed from route.c safely without affecting the compilation
of the net module.

Signed-off-by: Mianhan Liu <liumh1@shanghaitech.edu.cn>

---
 net/ipv4/route.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index d6899ab5f..0b4103b1e 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -61,15 +61,11 @@
 #define pr_fmt(fmt) "IPv4: " fmt
 
 #include <linux/module.h>
-#include <linux/uaccess.h>
 #include <linux/bitops.h>
-#include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/memblock.h>
-#include <linux/string.h>
 #include <linux/socket.h>
-#include <linux/sockios.h>
 #include <linux/errno.h>
 #include <linux/in.h>
 #include <linux/inet.h>
@@ -84,20 +80,17 @@
 #include <linux/netfilter_ipv4.h>
 #include <linux/random.h>
 #include <linux/rcupdate.h>
-#include <linux/times.h>
 #include <linux/slab.h>
 #include <linux/jhash.h>
 #include <net/dst.h>
 #include <net/dst_metadata.h>
 #include <net/net_namespace.h>
-#include <net/protocol.h>
 #include <net/ip.h>
 #include <net/route.h>
 #include <net/inetpeer.h>
 #include <net/sock.h>
 #include <net/ip_fib.h>
 #include <net/nexthop.h>
-#include <net/arp.h>
 #include <net/tcp.h>
 #include <net/icmp.h>
 #include <net/xfrm.h>
@@ -109,7 +102,6 @@
 #endif
 #include <net/secure_seq.h>
 #include <net/ip_tunnels.h>
-#include <net/l3mdev.h>
 
 #include "fib_lookup.h"
 
-- 
2.25.1


