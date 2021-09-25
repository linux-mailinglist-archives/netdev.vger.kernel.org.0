Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB664182A2
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 16:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343585AbhIYOXl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 25 Sep 2021 10:23:41 -0400
Received: from mail.shanghaitech.edu.cn ([119.78.254.11]:4151 "EHLO
        mail.shanghaitech.edu.cn" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233738AbhIYOXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Sep 2021 10:23:40 -0400
Received: from [10.15.44.215] by mail.shanghaitech.edu.cn with MESSAGESEC ESMTP id 480405297546506;
        Sat, 25 Sep 2021 22:21:51 +0800 (CST)
Received: from DESKTOP-FOJ6ELG.localdomain (10.15.44.220) by
 smtp.shanghaitech.edu.cn (10.15.44.215) with Microsoft SMTP Server (TLS) id
 14.3.399.0; Sat, 25 Sep 2021 22:21:50 +0800
From:   Mianhan Liu <liumh1@shanghaitech.edu.cn>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Mianhan Liu <liumh1@shanghaitech.edu.cn>
Subject: [PATCH -next] net/ipv4/tcp_nv.c: remove superfluous header files from tcp_nv.c
Date:   Sat, 25 Sep 2021 22:21:40 +0800
Message-ID: <20210925142140.23166-1-liumh1@shanghaitech.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain
X-Originating-IP: [10.15.44.220]
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tcp_nv.c hasn't use any macro or function declared in mm.h. Thus, these files
can be removed from tcp_nv.c safely without affecting the compilation
of the net module.

Signed-off-by: Mianhan Liu <liumh1@shanghaitech.edu.cn>

---
 net/ipv4/tcp_nv.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv4/tcp_nv.c b/net/ipv4/tcp_nv.c
index 95db7a11b..ab552356b 100644
--- a/net/ipv4/tcp_nv.c
+++ b/net/ipv4/tcp_nv.c
@@ -25,7 +25,6 @@
  * 1) Add mechanism to deal with reverse congestion.
  */
 
-#include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/math64.h>
 #include <net/tcp.h>
-- 
2.25.1


