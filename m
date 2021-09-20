Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD1194116AC
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 16:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240304AbhITOSD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 20 Sep 2021 10:18:03 -0400
Received: from mail.shanghaitech.edu.cn ([119.78.254.11]:52965 "EHLO
        mail.shanghaitech.edu.cn" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240291AbhITOR6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 10:17:58 -0400
Received: from [10.15.44.216] by mail.shanghaitech.edu.cn with MESSAGESEC ESMTP id 480405297546506;
        Mon, 20 Sep 2021 22:16:10 +0800 (CST)
Received: from DESKTOP-U066CHB.localdomain (10.15.44.220) by
 smtp.shanghaitech.edu.cn (10.15.44.216) with Microsoft SMTP Server (TLS) id
 14.3.399.0; Mon, 20 Sep 2021 22:16:09 +0800
From:   Mianhan Liu <liumh1@shanghaitech.edu.cn>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Mianhan Liu <liumh1@shanghaitech.edu.cn>
Subject: [PATCH -next] net/ipv4/syncookies.c: remove superfluous header files from syncookies.c
Date:   Mon, 20 Sep 2021 22:15:49 +0800
Message-ID: <20210920141549.29643-1-liumh1@shanghaitech.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain
X-Originating-IP: [10.15.44.220]
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syncookies.c hasn't use any macro or function declared in slab.h and random.h,
Thus, these files can be removed from syncookies.c safely without
affecting the compilation of the net module.

Signed-off-by: Mianhan Liu <liumh1@shanghaitech.edu.cn>

---
 net/ipv4/syncookies.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 33792cf55..8696dc343 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -7,8 +7,6 @@
  */
 
 #include <linux/tcp.h>
-#include <linux/slab.h>
-#include <linux/random.h>
 #include <linux/siphash.h>
 #include <linux/kernel.h>
 #include <linux/export.h>
-- 
2.25.1


