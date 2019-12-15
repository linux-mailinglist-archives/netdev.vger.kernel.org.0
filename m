Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4226011FB61
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 22:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfLOVIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 16:08:18 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:48739 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726267AbfLOVIR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Dec 2019 16:08:17 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 30fbf686;
        Sun, 15 Dec 2019 20:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=RupGHizOy7o14i6brojtACBcT
        D0=; b=XrYeo/s78IS0KRqlPsujR7GvIF4cCph0EcXl7FMvzAe0+2T/2iTNueyYq
        hnMpKjkv/NadclE+dkfVc0HJ+oplIHpc8GzjjMJ/5isMQnHvJ5F6udBFepGmnQji
        tmC6ZpPC7HigH7Zc2VGKDnIHlkaDqfmIH4r5hZAAH0mL+xh/OHM2MKBukRfvpnug
        l9WRZ1WLPdR3OuHwvu3xQEwghXJomzmkV4WIjM4fRbVTXp0R3DKoQ4pBsTqUN2rn
        AsAfSyk/ou5jwpTWvx/wcW+qu9vLXmO20+czJtR9M//vXXL6SDsW3Mrf5cLEuN4I
        vcjsYjvRZdwVOeT077l3TaPbkfl/A==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id db5b48d1 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Sun, 15 Dec 2019 20:11:59 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Josh Soref <jsoref@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net-next 3/5] wireguard: global: fix spelling mistakes in comments
Date:   Sun, 15 Dec 2019 22:08:02 +0100
Message-Id: <20191215210804.143919-4-Jason@zx2c4.com>
In-Reply-To: <20191215210804.143919-1-Jason@zx2c4.com>
References: <20191215210804.143919-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Josh Soref <jsoref@gmail.com>

This fixes two spelling errors in source code comments.

Signed-off-by: Josh Soref <jsoref@gmail.com>
[Jason: rewrote commit message]
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/receive.c | 2 +-
 include/uapi/linux/wireguard.h  | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireguard/receive.c b/drivers/net/wireguard/receive.c
index 7e675f541491..9c6bab9c981f 100644
--- a/drivers/net/wireguard/receive.c
+++ b/drivers/net/wireguard/receive.c
@@ -380,7 +380,7 @@ static void wg_packet_consume_data_done(struct wg_peer *peer,
 	/* We've already verified the Poly1305 auth tag, which means this packet
 	 * was not modified in transit. We can therefore tell the networking
 	 * stack that all checksums of every layer of encapsulation have already
-	 * been checked "by the hardware" and therefore is unneccessary to check
+	 * been checked "by the hardware" and therefore is unnecessary to check
 	 * again in software.
 	 */
 	skb->ip_summed = CHECKSUM_UNNECESSARY;
diff --git a/include/uapi/linux/wireguard.h b/include/uapi/linux/wireguard.h
index dd8a47c4ad11..ae88be14c947 100644
--- a/include/uapi/linux/wireguard.h
+++ b/include/uapi/linux/wireguard.h
@@ -18,13 +18,13 @@
  * one but not both of:
  *
  *    WGDEVICE_A_IFINDEX: NLA_U32
- *    WGDEVICE_A_IFNAME: NLA_NUL_STRING, maxlen IFNAMESIZ - 1
+ *    WGDEVICE_A_IFNAME: NLA_NUL_STRING, maxlen IFNAMSIZ - 1
  *
  * The kernel will then return several messages (NLM_F_MULTI) containing the
  * following tree of nested items:
  *
  *    WGDEVICE_A_IFINDEX: NLA_U32
- *    WGDEVICE_A_IFNAME: NLA_NUL_STRING, maxlen IFNAMESIZ - 1
+ *    WGDEVICE_A_IFNAME: NLA_NUL_STRING, maxlen IFNAMSIZ - 1
  *    WGDEVICE_A_PRIVATE_KEY: NLA_EXACT_LEN, len WG_KEY_LEN
  *    WGDEVICE_A_PUBLIC_KEY: NLA_EXACT_LEN, len WG_KEY_LEN
  *    WGDEVICE_A_LISTEN_PORT: NLA_U16
@@ -77,7 +77,7 @@
  * WGDEVICE_A_IFINDEX and WGDEVICE_A_IFNAME:
  *
  *    WGDEVICE_A_IFINDEX: NLA_U32
- *    WGDEVICE_A_IFNAME: NLA_NUL_STRING, maxlen IFNAMESIZ - 1
+ *    WGDEVICE_A_IFNAME: NLA_NUL_STRING, maxlen IFNAMSIZ - 1
  *    WGDEVICE_A_FLAGS: NLA_U32, 0 or WGDEVICE_F_REPLACE_PEERS if all current
  *                      peers should be removed prior to adding the list below.
  *    WGDEVICE_A_PRIVATE_KEY: len WG_KEY_LEN, all zeros to remove
@@ -121,7 +121,7 @@
  * filling in information not contained in the prior. Note that if
  * WGDEVICE_F_REPLACE_PEERS is specified in the first message, it probably
  * should not be specified in fragments that come after, so that the list
- * of peers is only cleared the first time but appened after. Likewise for
+ * of peers is only cleared the first time but appended after. Likewise for
  * peers, if WGPEER_F_REPLACE_ALLOWEDIPS is specified in the first message
  * of a peer, it likely should not be specified in subsequent fragments.
  *
-- 
2.24.1

