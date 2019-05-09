Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7246318AC9
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 15:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbfEINgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 09:36:24 -0400
Received: from packetmixer.de ([79.140.42.25]:33558 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbfEINgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 09:36:23 -0400
Received: from kero.packetmixer.de (unknown [IPv6:2001:16b8:55c8:9400:604e:fca1:2145:dcdc])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mail.packetmixer.de (Postfix) with ESMTPSA id EE31962074;
        Thu,  9 May 2019 15:28:18 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 1/2] batman-adv: Start new development cycle
Date:   Thu,  9 May 2019 15:28:14 +0200
Message-Id: <20190509132815.3723-2-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190509132815.3723-1-sw@simonwunderlich.de>
References: <20190509132815.3723-1-sw@simonwunderlich.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/main.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/main.h b/net/batman-adv/main.h
index 3ed669d7dc6b..06880c650598 100644
--- a/net/batman-adv/main.h
+++ b/net/batman-adv/main.h
@@ -25,7 +25,7 @@
 #define BATADV_DRIVER_DEVICE "batman-adv"
 
 #ifndef BATADV_SOURCE_VERSION
-#define BATADV_SOURCE_VERSION "2019.1"
+#define BATADV_SOURCE_VERSION "2019.2"
 #endif
 
 /* B.A.T.M.A.N. parameters */
-- 
2.11.0

