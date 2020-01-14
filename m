Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2A813AC31
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 15:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728944AbgANOX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 09:23:56 -0500
Received: from simonwunderlich.de ([79.140.42.25]:49806 "EHLO
        simonwunderlich.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728741AbgANOXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 09:23:55 -0500
Received: from kero.packetmixer.de (p200300C5970F1B0095082C17D9AE8553.dip0.t-ipconnect.de [IPv6:2003:c5:970f:1b00:9508:2c17:d9ae:8553])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 5F8A96206D;
        Tue, 14 Jan 2020 15:23:53 +0100 (CET)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 3/7] batman-adv: Fix typo metAdata
Date:   Tue, 14 Jan 2020 15:23:47 +0100
Message-Id: <20200114142351.26622-4-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200114142351.26622-1-sw@simonwunderlich.de>
References: <20200114142351.26622-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/types.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/batman-adv/types.h b/net/batman-adv/types.h
index 47718a82eaf2..bdf9827b5f63 100644
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -457,7 +457,7 @@ struct batadv_orig_node {
 	/**
 	 * @tt_lock: prevents from updating the table while reading it. Table
 	 *  update is made up by two operations (data structure update and
-	 *  metdata -CRC/TTVN-recalculation) and they have to be executed
+	 *  metadata -CRC/TTVN-recalculation) and they have to be executed
 	 *  atomically in order to avoid another thread to read the
 	 *  table/metadata between those.
 	 */
@@ -1011,7 +1011,7 @@ struct batadv_priv_tt {
 	/**
 	 * @commit_lock: prevents from executing a local TT commit while reading
 	 *  the local table. The local TT commit is made up by two operations
-	 *  (data structure update and metdata -CRC/TTVN- recalculation) and
+	 *  (data structure update and metadata -CRC/TTVN- recalculation) and
 	 *  they have to be executed atomically in order to avoid another thread
 	 *  to read the table/metadata between those.
 	 */
-- 
2.20.1

