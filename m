Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1378D862BD
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 15:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732992AbfHHNPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 09:15:23 -0400
Received: from packetmixer.de ([79.140.42.25]:58744 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732982AbfHHNPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 09:15:23 -0400
Received: from kero.packetmixer.de (p200300C5971AA600E0A7EA13A3520353.dip0.t-ipconnect.de [IPv6:2003:c5:971a:a600:e0a7:ea13:a352:353])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mail.packetmixer.de (Postfix) with ESMTPSA id CC7A062075;
        Thu,  8 Aug 2019 15:06:21 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 1/4] batman-adv: Start new development cycle
Date:   Thu,  8 Aug 2019 15:06:16 +0200
Message-Id: <20190808130619.4481-2-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190808130619.4481-1-sw@simonwunderlich.de>
References: <20190808130619.4481-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/main.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/main.h b/net/batman-adv/main.h
index 3d4c04d87ff3..6967f2e4c3f4 100644
--- a/net/batman-adv/main.h
+++ b/net/batman-adv/main.h
@@ -13,7 +13,7 @@
 #define BATADV_DRIVER_DEVICE "batman-adv"
 
 #ifndef BATADV_SOURCE_VERSION
-#define BATADV_SOURCE_VERSION "2019.3"
+#define BATADV_SOURCE_VERSION "2019.4"
 #endif
 
 /* B.A.T.M.A.N. parameters */
-- 
2.20.1

