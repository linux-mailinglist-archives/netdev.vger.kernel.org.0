Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB583A77DC
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 09:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbhFOHWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 03:22:31 -0400
Received: from mailout2.secunet.com ([62.96.220.49]:44790 "EHLO
        mailout2.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbhFOHW0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 03:22:26 -0400
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id 247BF80004A;
        Tue, 15 Jun 2021 09:20:19 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 15 Jun 2021 09:20:18 +0200
Received: from moon.secunet.de (172.18.26.122) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 15 Jun
 2021 09:20:18 +0200
Date:   Tue, 15 Jun 2021 09:20:08 +0200
From:   Antony Antony <antony.antony@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Antony Antony <antony.antony@secunet.com>
Subject: [PATCH v2] xfrm: delete xfrm4_output_finish xfrm6_output_finish
 declarations
Message-ID: <ff67f5acbb4060a3c89953687488e96cb40fa862.1623741174.git.antony.antony@secunet.com>
Reply-To: <antony.antony@secunet.com>
References: <d65237e307458f84e33687bff5be9fd93d6b375b.1623332566.git.antony.antony@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d65237e307458f84e33687bff5be9fd93d6b375b.1623332566.git.antony.antony@secunet.com>
Organization: secunet
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These function declarations are not needed any more.
The definitions were deleted.

Fixes: 2ab6096db2f1 ("xfrm: remove output_finish indirection from xfrm_state_afinfo")
Signed-off-by: Antony Antony <antony.antony@secunet.com>
---
 v1->v2 rebase to ipsec-next

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
2.20.1

