Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 031A641BEBA
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 07:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244255AbhI2FdX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 29 Sep 2021 01:33:23 -0400
Received: from mail1.shanghaitech.edu.cn ([119.78.254.90]:44251 "EHLO
        mail.shanghaitech.edu.cn" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S243962AbhI2FdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 01:33:22 -0400
Received: from [10.15.44.215] by mail.shanghaitech.edu.cn with MESSAGESEC ESMTP id 456895189764503;
        Wed, 29 Sep 2021 13:31:32 +0800 (CST)
Received: from DESKTOP-FOJ6ELG.localdomain (10.15.44.220) by
 smtp.shanghaitech.edu.cn (10.15.44.215) with Microsoft SMTP Server (TLS) id
 14.3.399.0; Wed, 29 Sep 2021 13:31:32 +0800
From:   Mianhan Liu <liumh1@shanghaitech.edu.cn>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Mianhan Liu <liumh1@shanghaitech.edu.cn>
Subject: [PATCH -next -v2] net/ipv4/datagram.c: remove superfluous header files from datagram.c
Date:   Wed, 29 Sep 2021 13:31:09 +0800
Message-ID: <20210929053109.23979-1-liumh1@shanghaitech.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain
X-Originating-IP: [10.15.44.220]
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

datagram.c hasn't use any macro or function declared in linux/ip.h.
Thus, these files can be removed from datagram.c safely without
affecting the compilation of the net/ipv4 module

Signed-off-by: Mianhan Liu <liumh1@shanghaitech.edu.cn>

---
 net/ipv4/datagram.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv4/datagram.c b/net/ipv4/datagram.c
index 4a8550c49..48f337ccf 100644
--- a/net/ipv4/datagram.c
+++ b/net/ipv4/datagram.c
@@ -9,7 +9,6 @@
 
 #include <linux/types.h>
 #include <linux/module.h>
-#include <linux/ip.h>
 #include <linux/in.h>
 #include <net/ip.h>
 #include <net/sock.h>
-- 
2.25.1


