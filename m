Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE23730C88A
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 18:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237893AbhBBRxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 12:53:55 -0500
Received: from simonwunderlich.de ([79.140.42.25]:33338 "EHLO
        simonwunderlich.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237852AbhBBRu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 12:50:56 -0500
X-Greylist: delayed 568 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Feb 2021 12:50:55 EST
Received: from kero.packetmixer.de (p4fd575e2.dip0.t-ipconnect.de [79.213.117.226])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id EEFD817401F;
        Tue,  2 Feb 2021 18:40:38 +0100 (CET)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 1/4] batman-adv: Start new development cycle
Date:   Tue,  2 Feb 2021 18:40:33 +0100
Message-Id: <20210202174037.7081-2-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210202174037.7081-1-sw@simonwunderlich.de>
References: <20210202174037.7081-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/main.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/main.h b/net/batman-adv/main.h
index 288201630ceb..2486efe4ffa6 100644
--- a/net/batman-adv/main.h
+++ b/net/batman-adv/main.h
@@ -13,7 +13,7 @@
 #define BATADV_DRIVER_DEVICE "batman-adv"
 
 #ifndef BATADV_SOURCE_VERSION
-#define BATADV_SOURCE_VERSION "2021.0"
+#define BATADV_SOURCE_VERSION "2021.1"
 #endif
 
 /* B.A.T.M.A.N. parameters */
-- 
2.20.1

