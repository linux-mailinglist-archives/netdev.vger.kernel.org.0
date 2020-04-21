Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A28701B336F
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 01:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbgDUXhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 19:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726296AbgDUXhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 19:37:00 -0400
X-Greylist: delayed 450 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 21 Apr 2020 16:37:00 PDT
Received: from sym2.noone.org (sym2.noone.org [IPv6:2a01:4f8:120:4161::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0079C0610D5
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 16:37:00 -0700 (PDT)
Received: by sym2.noone.org (Postfix, from userid 1002)
        id 496KXR40w9zvjc1; Wed, 22 Apr 2020 01:29:27 +0200 (CEST)
From:   Tobias Klauser <tklauser@distanz.ch>
To:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] xsk: Fix typo in xsk_umem_consume_tx and xsk_generic_xmit comments
Date:   Wed, 22 Apr 2020 01:29:27 +0200
Message-Id: <20200421232927.21082-1-tklauser@distanz.ch>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/backpreassure/backpressure/

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 net/xdp/xsk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index c350108aa38d..f6e6609f70a3 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -322,7 +322,7 @@ bool xsk_umem_consume_tx(struct xdp_umem *umem, struct xdp_desc *desc)
 		if (!xskq_cons_peek_desc(xs->tx, desc, umem))
 			continue;
 
-		/* This is the backpreassure mechanism for the Tx path.
+		/* This is the backpressure mechanism for the Tx path.
 		 * Reserve space in the completion queue and only proceed
 		 * if there is space in it. This avoids having to implement
 		 * any buffering in the Tx path.
@@ -406,7 +406,7 @@ static int xsk_generic_xmit(struct sock *sk)
 		addr = desc.addr;
 		buffer = xdp_umem_get_data(xs->umem, addr);
 		err = skb_store_bits(skb, 0, buffer, len);
-		/* This is the backpreassure mechanism for the Tx path.
+		/* This is the backpressure mechanism for the Tx path.
 		 * Reserve space in the completion queue and only proceed
 		 * if there is space in it. This avoids having to implement
 		 * any buffering in the Tx path.
-- 
2.26.1

