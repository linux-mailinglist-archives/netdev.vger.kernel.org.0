Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B98574113DE
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 13:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237322AbhITMAu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 20 Sep 2021 08:00:50 -0400
Received: from mail1.shanghaitech.edu.cn ([119.78.254.90]:34565 "EHLO
        mail.shanghaitech.edu.cn" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232033AbhITMAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 08:00:49 -0400
Received: from [10.15.44.215] by mail.shanghaitech.edu.cn with MESSAGESEC ESMTP id 456898266535065;
        Mon, 20 Sep 2021 19:58:37 +0800 (CST)
Received: from DESKTOP-U066CHB.localdomain (10.15.44.220) by
 smtp.shanghaitech.edu.cn (10.15.44.215) with Microsoft SMTP Server (TLS) id
 14.3.399.0; Mon, 20 Sep 2021 19:58:39 +0800
From:   Mianhan Liu <liumh1@shanghaitech.edu.cn>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Mianhan Liu <liumh1@shanghaitech.edu.cn>
Subject: [PATCH] net/ipv4/xfrm4_tunnel.c: remove superfluous header files from xfrm4_tunnel.c
Date:   Mon, 20 Sep 2021 19:58:31 +0800
Message-ID: <20210920115831.29802-1-liumh1@shanghaitech.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain
X-Originating-IP: [10.15.44.220]
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xfrm4_tunnel.c hasn't use any macro or function declared in mutex.h and ip.h
Thus, these files can be removed from xfrm4_tunnel.c safely without affecting
the compilation of the net module.

Signed-off-by: Mianhan Liu <liumh1@shanghaitech.edu.cn>
---
 net/ipv4/xfrm4_tunnel.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/ipv4/xfrm4_tunnel.c b/net/ipv4/xfrm4_tunnel.c
index f4555a88f..9d4f418f1 100644
--- a/net/ipv4/xfrm4_tunnel.c
+++ b/net/ipv4/xfrm4_tunnel.c
@@ -8,9 +8,7 @@
 
 #include <linux/skbuff.h>
 #include <linux/module.h>
-#include <linux/mutex.h>
 #include <net/xfrm.h>
-#include <net/ip.h>
 #include <net/protocol.h>
 
 static int ipip_output(struct xfrm_state *x, struct sk_buff *skb)
-- 
2.25.1


