Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAD373B58CC
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 07:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbhF1F53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 01:57:29 -0400
Received: from mailout1.secunet.com ([62.96.220.44]:40978 "EHLO
        mailout1.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232203AbhF1F5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 01:57:24 -0400
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id 302E2800056;
        Mon, 28 Jun 2021 07:54:58 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 28 Jun 2021 07:54:58 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Mon, 28 Jun
 2021 07:54:57 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 9953431804CA; Mon, 28 Jun 2021 07:45:28 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 11/17] xfrm: delete xfrm4_output_finish xfrm6_output_finish declarations
Date:   Mon, 28 Jun 2021 07:45:16 +0200
Message-ID: <20210628054522.1718786-12-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210628054522.1718786-1-steffen.klassert@secunet.com>
References: <20210628054522.1718786-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antony Antony <antony.antony@secunet.com>

These function declarations are not needed any more.
The definitions were deleted.

Fixes: 2ab6096db2f1 ("xfrm: remove output_finish indirection from xfrm_state_afinfo")
Signed-off-by: Antony Antony <antony.antony@secunet.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index c8890da00b8a..3a01570410ab 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1579,7 +1579,6 @@ static inline int xfrm4_rcv_spi(struct sk_buff *skb, int nexthdr, __be32 spi)
 }
 
 int xfrm4_output(struct net *net, struct sock *sk, struct sk_buff *skb);
-int xfrm4_output_finish(struct sock *sk, struct sk_buff *skb);
 int xfrm4_protocol_register(struct xfrm4_protocol *handler, unsigned char protocol);
 int xfrm4_protocol_deregister(struct xfrm4_protocol *handler, unsigned char protocol);
 int xfrm4_tunnel_register(struct xfrm_tunnel *handler, unsigned short family);
@@ -1603,7 +1602,6 @@ int xfrm6_tunnel_deregister(struct xfrm6_tunnel *handler, unsigned short family)
 __be32 xfrm6_tunnel_alloc_spi(struct net *net, xfrm_address_t *saddr);
 __be32 xfrm6_tunnel_spi_lookup(struct net *net, const xfrm_address_t *saddr);
 int xfrm6_output(struct net *net, struct sock *sk, struct sk_buff *skb);
-int xfrm6_output_finish(struct sock *sk, struct sk_buff *skb);
 
 #ifdef CONFIG_XFRM
 void xfrm6_local_rxpmtu(struct sk_buff *skb, u32 mtu);
-- 
2.25.1

