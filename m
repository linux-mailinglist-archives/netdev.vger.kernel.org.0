Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4371741B568
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 19:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242074AbhI1Rvp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 28 Sep 2021 13:51:45 -0400
Received: from mail1.shanghaitech.edu.cn ([119.78.254.90]:44026 "EHLO
        mail.shanghaitech.edu.cn" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241873AbhI1Rvo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 13:51:44 -0400
Received: from [10.15.44.215] by mail.shanghaitech.edu.cn with MESSAGESEC ESMTP id 456895189764503;
        Wed, 29 Sep 2021 01:49:55 +0800 (CST)
Received: from DESKTOP-FOJ6ELG.localdomain (10.15.44.220) by
 smtp.shanghaitech.edu.cn (10.15.44.215) with Microsoft SMTP Server (TLS) id
 14.3.399.0; Wed, 29 Sep 2021 01:49:55 +0800
From:   Mianhan Liu <liumh1@shanghaitech.edu.cn>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Mianhan Liu <liumh1@shanghaitech.edu.cn>
Subject: [PATCH -next] net/ipv4/datagram.c: remove superfluous header files from datagram.c
Date:   Wed, 29 Sep 2021 01:49:43 +0800
Message-ID: <20210928174943.8148-1-liumh1@shanghaitech.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain
X-Originating-IP: [10.15.44.220]
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

datagram.c hasn't use any macro or function declared in linux/ip.h,
and linux/module.h.
Thus, these files can be removed from datagram.c safely without
affecting the compilation of the net/ipv4 module

Signed-off-by: Mianhan Liu <liumh1@shanghaitech.edu.cn>

---
 net/ipv4/datagram.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/ipv4/datagram.c b/net/ipv4/datagram.c
index 4a8550c49..2dc5f1890 100644
--- a/net/ipv4/datagram.c
+++ b/net/ipv4/datagram.c
@@ -8,8 +8,6 @@
  */
 
 #include <linux/types.h>
-#include <linux/module.h>
-#include <linux/ip.h>
 #include <linux/in.h>
 #include <net/ip.h>
 #include <net/sock.h>
-- 
2.25.1


