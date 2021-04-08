Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC27B358285
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 13:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbhDHLyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 07:54:23 -0400
Received: from simonwunderlich.de ([79.140.42.25]:33474 "EHLO
        simonwunderlich.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231329AbhDHLyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 07:54:20 -0400
Received: from kero.packetmixer.de (p200300c5971bd8e0263584131c53e2d7.dip0.t-ipconnect.de [IPv6:2003:c5:971b:d8e0:2635:8413:1c53:e2d7])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id D652C174021;
        Thu,  8 Apr 2021 13:54:03 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 2/3] batman-adv: Drop unused header preempt.h
Date:   Thu,  8 Apr 2021 13:54:00 +0200
Message-Id: <20210408115401.16988-3-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210408115401.16988-1-sw@simonwunderlich.de>
References: <20210408115401.16988-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

The commit b1de0f01b011 ("batman-adv: Use netif_rx_any_context().") removed
the last user for a function declaration from linux/preempt.h. The include
should therefore be cleaned up.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/bridge_loop_avoidance.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/batman-adv/bridge_loop_avoidance.c b/net/batman-adv/bridge_loop_avoidance.c
index bcd543ce835b..7dc133cfc363 100644
--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -25,7 +25,6 @@
 #include <linux/lockdep.h>
 #include <linux/netdevice.h>
 #include <linux/netlink.h>
-#include <linux/preempt.h>
 #include <linux/rculist.h>
 #include <linux/rcupdate.h>
 #include <linux/skbuff.h>
-- 
2.20.1

