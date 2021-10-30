Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19A4F4407DB
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 09:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbhJ3H3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 03:29:10 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:37678 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231691AbhJ3H3J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Oct 2021 03:29:09 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 08E6B2009B;
        Sat, 30 Oct 2021 09:26:39 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id rhqz2BUmNHzM; Sat, 30 Oct 2021 09:26:36 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 4B008204A4;
        Sat, 30 Oct 2021 09:26:36 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id 3CEB380004A;
        Sat, 30 Oct 2021 09:26:36 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Sat, 30 Oct 2021 09:26:36 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.14; Sat, 30 Oct
 2021 09:26:35 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id F0686318040E; Sat, 30 Oct 2021 09:26:35 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 1/2] net/ipv4/xfrm4_tunnel.c: remove superfluous header files from xfrm4_tunnel.c
Date:   Sat, 30 Oct 2021 09:26:32 +0200
Message-ID: <20211030072633.4158069-2-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211030072633.4158069-1-steffen.klassert@secunet.com>
References: <20211030072633.4158069-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mianhan Liu <liumh1@shanghaitech.edu.cn>

xfrm4_tunnel.c hasn't use any macro or function declared in mutex.h and ip.h
Thus, these files can be removed from xfrm4_tunnel.c safely without affecting
the compilation of the net module.

Signed-off-by: Mianhan Liu <liumh1@shanghaitech.edu.cn>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv4/xfrm4_tunnel.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/ipv4/xfrm4_tunnel.c b/net/ipv4/xfrm4_tunnel.c
index f4555a88f86b..9d4f418f1bf8 100644
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

