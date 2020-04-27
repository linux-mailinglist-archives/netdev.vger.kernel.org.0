Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99BD71BA73A
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 17:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbgD0PGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 11:06:14 -0400
Received: from simonwunderlich.de ([79.140.42.25]:37872 "EHLO
        simonwunderlich.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727966AbgD0PGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 11:06:14 -0400
Received: from kero.packetmixer.de (p4FD5799A.dip0.t-ipconnect.de [79.213.121.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 464F962058;
        Mon, 27 Apr 2020 17:06:12 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        YueHaibing <yuehaibing@huawei.com>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 5/5] batman-adv: remove unused inline function batadv_arp_change_timeout
Date:   Mon, 27 Apr 2020 17:06:07 +0200
Message-Id: <20200427150607.31401-6-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200427150607.31401-1-sw@simonwunderlich.de>
References: <20200427150607.31401-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

There's no callers in-tree.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/distributed-arp-table.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/batman-adv/distributed-arp-table.h b/net/batman-adv/distributed-arp-table.h
index 2bff2f4a325c..4e031661682a 100644
--- a/net/batman-adv/distributed-arp-table.h
+++ b/net/batman-adv/distributed-arp-table.h
@@ -163,11 +163,6 @@ static inline void batadv_dat_init_own_addr(struct batadv_priv *bat_priv,
 {
 }
 
-static inline void batadv_arp_change_timeout(struct net_device *soft_iface,
-					     const char *name)
-{
-}
-
 static inline int batadv_dat_init(struct batadv_priv *bat_priv)
 {
 	return 0;
-- 
2.20.1

