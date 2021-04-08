Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEAE358282
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 13:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbhDHLyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 07:54:16 -0400
Received: from simonwunderlich.de ([79.140.42.25]:33434 "EHLO
        simonwunderlich.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbhDHLyP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 07:54:15 -0400
Received: from kero.packetmixer.de (p200300c5971bd8e0263584131c53e2d7.dip0.t-ipconnect.de [IPv6:2003:c5:971b:d8e0:2635:8413:1c53:e2d7])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 4EE64174020;
        Thu,  8 Apr 2021 13:54:03 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 1/3] batman-adv: Fix order of kernel doc in batadv_priv
Date:   Thu,  8 Apr 2021 13:53:59 +0200
Message-Id: <20210408115401.16988-2-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210408115401.16988-1-sw@simonwunderlich.de>
References: <20210408115401.16988-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Linus Lüssing <linus.luessing@c0d3.blue>

During the inlining process of kerneldoc in commit 8b84cc4fb556
("batman-adv: Use inline kernel-doc for enum/struct"), some comments were
placed at the wrong struct members. Fixing this by reordering the comments.

Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/types.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/batman-adv/types.h b/net/batman-adv/types.h
index 7c0b475cc22a..2be5d4a712c5 100644
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -1659,19 +1659,19 @@ struct batadv_priv {
 	/** @tp_list: list of tp sessions */
 	struct hlist_head tp_list;
 
-	/** @tp_num: number of currently active tp sessions */
+	/** @orig_hash: hash table containing mesh participants (orig nodes) */
 	struct batadv_hashtable *orig_hash;
 
-	/** @orig_hash: hash table containing mesh participants (orig nodes) */
+	/** @forw_bat_list_lock: lock protecting forw_bat_list */
 	spinlock_t forw_bat_list_lock;
 
-	/** @forw_bat_list_lock: lock protecting forw_bat_list */
+	/** @forw_bcast_list_lock: lock protecting forw_bcast_list */
 	spinlock_t forw_bcast_list_lock;
 
-	/** @forw_bcast_list_lock: lock protecting forw_bcast_list */
+	/** @tp_list_lock: spinlock protecting @tp_list */
 	spinlock_t tp_list_lock;
 
-	/** @tp_list_lock: spinlock protecting @tp_list */
+	/** @tp_num: number of currently active tp sessions */
 	atomic_t tp_num;
 
 	/** @orig_work: work queue callback item for orig node purging */
-- 
2.20.1

