Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA4F058087
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 12:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbfF0Kjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 06:39:44 -0400
Received: from packetmixer.de ([79.140.42.25]:48544 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfF0Kjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 06:39:43 -0400
Received: from kero.packetmixer.de (ip-109-41-128-179.web.vodafone.de [109.41.128.179])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mail.packetmixer.de (Postfix) with ESMTPSA id 9B16D62071;
        Thu, 27 Jun 2019 12:39:42 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 01/10] batman-adv: Start new development cycle
Date:   Thu, 27 Jun 2019 12:39:29 +0200
Message-Id: <20190627103938.7488-2-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190627103938.7488-1-sw@simonwunderlich.de>
References: <20190627103938.7488-1-sw@simonwunderlich.de>
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

