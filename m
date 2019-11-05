Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36BB5EF98D
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 10:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730819AbfKEJfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 04:35:41 -0500
Received: from simonwunderlich.de ([79.140.42.25]:35566 "EHLO
        simonwunderlich.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730755AbfKEJfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 04:35:36 -0500
Received: from kero.packetmixer.de (p200300C5970F5D00F0ACF07C9CF9C7D8.dip0.t-ipconnect.de [IPv6:2003:c5:970f:5d00:f0ac:f07c:9cf9:c7d8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id E7BDF62059;
        Tue,  5 Nov 2019 10:35:33 +0100 (CET)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 1/5] batman-adv: Start new development cycle
Date:   Tue,  5 Nov 2019 10:35:27 +0100
Message-Id: <20191105093531.11398-2-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191105093531.11398-1-sw@simonwunderlich.de>
References: <20191105093531.11398-1-sw@simonwunderlich.de>
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
index 6967f2e4c3f4..c7b340ddd0e7 100644
--- a/net/batman-adv/main.h
+++ b/net/batman-adv/main.h
@@ -13,7 +13,7 @@
 #define BATADV_DRIVER_DEVICE "batman-adv"
 
 #ifndef BATADV_SOURCE_VERSION
-#define BATADV_SOURCE_VERSION "2019.4"
+#define BATADV_SOURCE_VERSION "2019.5"
 #endif
 
 /* B.A.T.M.A.N. parameters */
-- 
2.20.1

