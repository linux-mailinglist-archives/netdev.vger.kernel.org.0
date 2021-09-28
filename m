Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B37D841B40E
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 18:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241783AbhI1QmR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 28 Sep 2021 12:42:17 -0400
Received: from mail1.shanghaitech.edu.cn ([119.78.254.90]:43967 "EHLO
        mail.shanghaitech.edu.cn" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229523AbhI1QmQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 12:42:16 -0400
Received: from [10.15.44.215] by mail.shanghaitech.edu.cn with MESSAGESEC ESMTP id 456895189764503;
        Wed, 29 Sep 2021 00:40:25 +0800 (CST)
Received: from DESKTOP-FOJ6ELG.localdomain (10.15.44.220) by
 smtp.shanghaitech.edu.cn (10.15.44.215) with Microsoft SMTP Server (TLS) id
 14.3.399.0; Wed, 29 Sep 2021 00:40:25 +0800
From:   Mianhan Liu <liumh1@shanghaitech.edu.cn>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Mianhan Liu <liumh1@shanghaitech.edu.cn>
Subject: [PATCH -next] net/ipv4/fib_notifier.c remove superfluous header files from fib_notifier.c
Date:   Wed, 29 Sep 2021 00:40:11 +0800
Message-ID: <20210928164011.1454-1-liumh1@shanghaitech.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain
X-Originating-IP: [10.15.44.220]
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fib_notifier.chasn't use any macro or function declared in net/netns/ipv4.h.
Thus, these files can be removed from fib_notifier.c safely without
affecting the compilation of the net/ipv4 module.

Signed-off-by: Mianhan Liu <liumh1@shanghaitech.edu.cn>

---
 net/ipv4/fib_notifier.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv4/fib_notifier.c b/net/ipv4/fib_notifier.c
index 0c28bd469..0e23ade74 100644
--- a/net/ipv4/fib_notifier.c
+++ b/net/ipv4/fib_notifier.c
@@ -6,7 +6,6 @@
 #include <linux/export.h>
 #include <net/net_namespace.h>
 #include <net/fib_notifier.h>
-#include <net/netns/ipv4.h>
 #include <net/ip_fib.h>
 
 int call_fib4_notifier(struct notifier_block *nb,
-- 
2.25.1


