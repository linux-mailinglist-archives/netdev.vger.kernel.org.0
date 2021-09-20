Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91C304113A9
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 13:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234985AbhITLlT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 20 Sep 2021 07:41:19 -0400
Received: from mail1.shanghaitech.edu.cn ([119.78.254.90]:32744 "EHLO
        mail.shanghaitech.edu.cn" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232528AbhITLlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 07:41:19 -0400
X-Greylist: delayed 456 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Sep 2021 07:41:18 EDT
Received: from [10.15.44.215] by mail.shanghaitech.edu.cn with MESSAGESEC ESMTP id 456895297546506;
        Mon, 20 Sep 2021 19:34:42 +0800 (CST)
Received: from DESKTOP-U066CHB.localdomain (10.15.44.220) by
 smtp.shanghaitech.edu.cn (10.15.44.215) with Microsoft SMTP Server (TLS) id
 14.3.399.0; Mon, 20 Sep 2021 19:34:40 +0800
From:   Mianhan Liu <liumh1@shanghaitech.edu.cn>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Mianhan Liu <liumh1@shanghaitech.edu.cn>
Subject: [PATCH -next] net/ipv4/tcp_fastopen.c: remove superfluous header files from tcp_fastopen.c
Date:   Mon, 20 Sep 2021 19:34:16 +0800
Message-ID: <20210920113416.26545-1-liumh1@shanghaitech.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain
X-Originating-IP: [10.15.44.220]
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tcp_fastopen.c hasn't use any macro or function declared in crypto.h, err.h,
init.h, list.h, rculist.h and inetpeer.h. Thus, these files can be removed
from tcp_fastopen.c safely without affecting the compilation of the net module.

Signed-off-by: Mianhan Liu <liumh1@shanghaitech.edu.cn>

---
 net/ipv4/tcp_fastopen.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index 59412d635..fdbcf2a6d 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -1,13 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
-#include <linux/crypto.h>
-#include <linux/err.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/list.h>
 #include <linux/tcp.h>
 #include <linux/rcupdate.h>
-#include <linux/rculist.h>
-#include <net/inetpeer.h>
 #include <net/tcp.h>
 
 void tcp_fastopen_init_key_once(struct net *net)
-- 
2.25.1


