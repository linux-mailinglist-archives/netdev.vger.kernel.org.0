Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCB0759D4F
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 15:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfF1N4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 09:56:07 -0400
Received: from packetmixer.de ([79.140.42.25]:52968 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbfF1N4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 09:56:07 -0400
Received: from kero.packetmixer.de (p4FD57BD9.dip0.t-ipconnect.de [79.213.123.217])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mail.packetmixer.de (Postfix) with ESMTPSA id E8F916206C;
        Fri, 28 Jun 2019 15:56:05 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 01/10] batman-adv: Start new development cycle
Date:   Fri, 28 Jun 2019 15:55:55 +0200
Message-Id: <20190628135604.11581-2-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190628135604.11581-1-sw@simonwunderlich.de>
References: <20190628135604.11581-1-sw@simonwunderlich.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/main.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/main.h b/net/batman-adv/main.h
index c59afcba31e0..11d051dbbda4 100644
--- a/net/batman-adv/main.h
+++ b/net/batman-adv/main.h
@@ -13,7 +13,7 @@
 #define BATADV_DRIVER_DEVICE "batman-adv"
 
 #ifndef BATADV_SOURCE_VERSION
-#define BATADV_SOURCE_VERSION "2019.2"
+#define BATADV_SOURCE_VERSION "2019.3"
 #endif
 
 /* B.A.T.M.A.N. parameters */
-- 
2.11.0

