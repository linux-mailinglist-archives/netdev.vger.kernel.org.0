Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE6894182B8
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 16:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245656AbhIYO3c convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 25 Sep 2021 10:29:32 -0400
Received: from mail.shanghaitech.edu.cn ([119.78.254.11]:59988 "EHLO
        mail.shanghaitech.edu.cn" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233738AbhIYO3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 10:29:32 -0400
Received: from [10.15.44.215] by mail.shanghaitech.edu.cn with MESSAGESEC ESMTP id 480405297546506;
        Sat, 25 Sep 2021 22:27:41 +0800 (CST)
Received: from DESKTOP-FOJ6ELG.localdomain (10.15.44.220) by
 smtp.shanghaitech.edu.cn (10.15.44.215) with Microsoft SMTP Server (TLS) id
 14.3.399.0; Sat, 25 Sep 2021 22:27:41 +0800
From:   Mianhan Liu <liumh1@shanghaitech.edu.cn>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Mianhan Liu <liumh1@shanghaitech.edu.cn>
Subject: [PATCH -next] net/ipv4/tcp_metrics.c: remove superfluous header files from tcp_metrics.c
Date:   Sat, 25 Sep 2021 22:27:33 +0800
Message-ID: <20210925142733.24293-1-liumh1@shanghaitech.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain
X-Originating-IP: [10.15.44.220]
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tcp_metrics.c hasn't use any macro or function declared in rcupdate.h
spinlock.h, module.h, cache.h, hash.h and vmalloc.h. Thus, these files
can be removed from tcp_metrics.c safely without affecting the compilation
of the net module.

Signed-off-by: Mianhan Liu <liumh1@shanghaitech.edu.cn>

---
 net/ipv4/tcp_metrics.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/net/ipv4/tcp_metrics.c b/net/ipv4/tcp_metrics.c
index 0588b004d..7b819530d 100644
--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -1,15 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
-#include <linux/rcupdate.h>
-#include <linux/spinlock.h>
 #include <linux/jiffies.h>
-#include <linux/module.h>
-#include <linux/cache.h>
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/tcp.h>
-#include <linux/hash.h>
 #include <linux/tcp_metrics.h>
-#include <linux/vmalloc.h>
 
 #include <net/inet_connection_sock.h>
 #include <net/net_namespace.h>
-- 
2.25.1


