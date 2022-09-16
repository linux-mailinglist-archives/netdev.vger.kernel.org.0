Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36A805BB0FC
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 18:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiIPQPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 12:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbiIPQPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 12:15:07 -0400
X-Greylist: delayed 327 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 16 Sep 2022 09:15:05 PDT
Received: from simonwunderlich.de (simonwunderlich.de [23.88.38.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC06A4F384
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 09:15:05 -0700 (PDT)
Received: from kero.packetmixer.de (p200300C5973c57D0711F6270F7F2Cd25.dip0.t-ipconnect.de [IPv6:2003:c5:973c:57d0:711f:6270:f7f2:cd25])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id A34CFFA2A8;
        Fri, 16 Sep 2022 18:15:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=simonwunderlich.de;
        s=09092022; t=1663344903; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hFzEhch0wSLSZ+/C82epaSdcXfqynQqW7sxrB59l6sU=;
        b=q9Ic3zwE00TPFzf49LnL6nRI71DiCHQNHJgCZ1raHgjU6lJNFBcA5LHf6Hbvn/RtIXWCKE
        AptBoQ8Q4ZoGV3clZj7neSxZX15r4H8YeKlpVlbVh4/UEV7F2Q779kn2tzCrrJ141EOLwk
        3EMvVVHB5SJbjrF7lDuijzCCXsUBv2FqKXhYciPAKiy5cQHhmwcIcyUJDRn7xshHo6xtJz
        vvSo25l3KIxnE0P4EFsUFrQfbsLRSAukzJbm05udNh9XkK+CIrH1G0eTwAh2wBGLC8fLe1
        n8D+6weB8w2UKQS6PRI/jCm896IQQCxd6+olEXjP+vfChOQJNDibuLGnVf0iBg==
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4/4] batman-adv: remove unused struct definitions
Date:   Fri, 16 Sep 2022 18:14:54 +0200
Message-Id: <20220916161454.1413154-5-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220916161454.1413154-1-sw@simonwunderlich.de>
References: <20220916161454.1413154-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
        d=simonwunderlich.de; s=09092022; t=1663344903;
        h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hFzEhch0wSLSZ+/C82epaSdcXfqynQqW7sxrB59l6sU=;
        b=dCfdILMrTwcKUmS9A6vyzOtZlZjJeFvaqCGD2af6gVYodjrPCCjgL5CkshgLLX7C2yuT7H
        eH7EKDYZvgEsgFVHtsVzY4sYOx2EZpYzQaB+T5OwMyapVUQUd1TSjuSsW7jHTL0SWDONrQ
        8vu5It+/WEguODsicqHRlwPry2a6/xbDjEclcrOHynidaLz3tL69uI4xij0iByUPY3YY4V
        NUzqwH/CMoLEuxK8PiCZrnhSm8kCcesV/pRyOFSBESXin3l6WKtlxvmprRRNn4trkVKxMf
        K9Q9JKQeJ5V50P2aKl9i6lEx9kQ2aesFlMiemzl64xYeAd6GFCBgFi+7Lo8beQ==
ARC-Seal: i=1; s=09092022; d=simonwunderlich.de; t=1663344903; a=rsa-sha256;
        cv=none;
        b=VbHgrBzwVYfuwoG3BbPtsWU/HNmHiPmy7DfvCkfrqiXQDMpSpquErqOT6bG1kMA3yS1TbD6TAeJnOgH3u3L7e9BsM7/SEinucunvGeww6+7IBwGAL/bAsPhLbzXG/p1IVZXCTMwJwcPpimNCHwMUackjLSmM3OPLyOhc4VJfwOP24RkuaccwDVE5EMSGwkKr9OQNjTxZW0eZhVe9vfG/M7LiHGff4PN29NumKcRhConbLuR8D9CF/rfZmhzAjyvuljmSWfzZuvCUIBfxovpMPAYDYgZZLj4Lg/9191FyUQZiojmvnn7pn/A0HV1/emMDcZ6igDkTIRA1+ECyBA+psQ==
ARC-Authentication-Results: i=1;
        simonwunderlich.de;
        auth=pass smtp.auth=sw@simonwunderlich.de smtp.mailfrom=sw@simonwunderlich.de
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Lindner <mareklindner@neomailbox.ch>

Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/types.h | 39 ---------------------------------------
 1 file changed, 39 deletions(-)

diff --git a/net/batman-adv/types.h b/net/batman-adv/types.h
index 2be5d4a712c5..758cd797a063 100644
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -1740,45 +1740,6 @@ struct batadv_priv {
 #endif
 };
 
-/**
- * struct batadv_socket_client - layer2 icmp socket client data
- */
-struct batadv_socket_client {
-	/**
-	 * @queue_list: packet queue for packets destined for this socket client
-	 */
-	struct list_head queue_list;
-
-	/** @queue_len: number of packets in the packet queue (queue_list) */
-	unsigned int queue_len;
-
-	/** @index: socket client's index in the batadv_socket_client_hash */
-	unsigned char index;
-
-	/** @lock: lock protecting queue_list, queue_len & index */
-	spinlock_t lock;
-
-	/** @queue_wait: socket client's wait queue */
-	wait_queue_head_t queue_wait;
-
-	/** @bat_priv: pointer to soft_iface this client belongs to */
-	struct batadv_priv *bat_priv;
-};
-
-/**
- * struct batadv_socket_packet - layer2 icmp packet for socket client
- */
-struct batadv_socket_packet {
-	/** @list: list node for &batadv_socket_client.queue_list */
-	struct list_head list;
-
-	/** @icmp_len: size of the layer2 icmp packet */
-	size_t icmp_len;
-
-	/** @icmp_packet: layer2 icmp packet */
-	u8 icmp_packet[BATADV_ICMP_MAX_PACKET_SIZE];
-};
-
 #ifdef CONFIG_BATMAN_ADV_BLA
 
 /**
-- 
2.30.2

