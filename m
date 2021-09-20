Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFEE94113D6
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 13:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237322AbhITL5j convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 20 Sep 2021 07:57:39 -0400
Received: from mail.shanghaitech.edu.cn ([119.78.254.11]:55823 "EHLO
        mail.shanghaitech.edu.cn" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237316AbhITL5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 07:57:36 -0400
Received: from [10.15.44.215] by mail.shanghaitech.edu.cn with MESSAGESEC ESMTP id 480405297546506;
        Mon, 20 Sep 2021 19:55:59 +0800 (CST)
Received: from DESKTOP-U066CHB.localdomain (10.15.44.220) by
 smtp.shanghaitech.edu.cn (10.15.44.215) with Microsoft SMTP Server (TLS) id
 14.3.399.0; Mon, 20 Sep 2021 19:55:59 +0800
From:   Mianhan Liu <liumh1@shanghaitech.edu.cn>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Mianhan Liu <liumh1@shanghaitech.edu.cn>
Subject: [PATCH -next] net/ipv4/tcp_minisocks.c: remove superfluous header files from tcp_minisocks.c
Date:   Mon, 20 Sep 2021 19:55:36 +0800
Message-ID: <20210920115536.28250-1-liumh1@shanghaitech.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain
X-Originating-IP: [10.15.44.220]
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tcp_minisocks.c hasn't use any macro or function declared in mm.h, module.h,
slab.h, sysctl.h, workqueue.h, static_key.h and inet_common.h. Thus, these
files can be removed from tcp_minisocks.c safely without affecting the
compilation of the net module.

Signed-off-by: Mianhan Liu <liumh1@shanghaitech.edu.cn>

---
 net/ipv4/tcp_minisocks.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 0a4f3f161..cf913a66d 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -19,14 +19,7 @@
  *		Jorge Cwik, <jorge@laser.satlink.net>
  */
 
-#include <linux/mm.h>
-#include <linux/module.h>
-#include <linux/slab.h>
-#include <linux/sysctl.h>
-#include <linux/workqueue.h>
-#include <linux/static_key.h>
 #include <net/tcp.h>
-#include <net/inet_common.h>
 #include <net/xfrm.h>
 #include <net/busy_poll.h>
 
-- 
2.25.1


