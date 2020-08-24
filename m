Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2DB625028D
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 18:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgHXQdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 12:33:07 -0400
Received: from simonwunderlich.de ([79.140.42.25]:47670 "EHLO
        simonwunderlich.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727864AbgHXQ1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 12:27:52 -0400
X-Greylist: delayed 392 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Aug 2020 12:27:52 EDT
Received: from kero.packetmixer.de (p200300c5970d68d0e0160e8a82c5fd76.dip0.t-ipconnect.de [IPv6:2003:c5:970d:68d0:e016:e8a:82c5:fd76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 6D31262071;
        Mon, 24 Aug 2020 18:27:46 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 1/5] batman-adv: Start new development cycle
Date:   Mon, 24 Aug 2020 18:27:37 +0200
Message-Id: <20200824162741.880-2-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200824162741.880-1-sw@simonwunderlich.de>
References: <20200824162741.880-1-sw@simonwunderlich.de>
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
index 0393bb9ed3d0..a47dc332d796 100644
--- a/net/batman-adv/main.h
+++ b/net/batman-adv/main.h
@@ -13,7 +13,7 @@
 #define BATADV_DRIVER_DEVICE "batman-adv"
 
 #ifndef BATADV_SOURCE_VERSION
-#define BATADV_SOURCE_VERSION "2020.3"
+#define BATADV_SOURCE_VERSION "2020.4"
 #endif
 
 /* B.A.T.M.A.N. parameters */
-- 
2.20.1

