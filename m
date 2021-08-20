Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF2ED3F2876
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 10:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232832AbhHTIdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 04:33:46 -0400
Received: from simonwunderlich.de ([79.140.42.25]:49662 "EHLO
        simonwunderlich.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231992AbhHTIdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 04:33:44 -0400
Received: from kero.packetmixer.de (p200300c5970e73c0a32126881010a2d4.dip0.t-ipconnect.de [IPv6:2003:c5:970e:73c0:a321:2688:1010:a2d4])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id BFE81174022;
        Fri, 20 Aug 2021 10:33:05 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 3/6] batman-adv: Switch to kstrtox.h for kstrtou64
Date:   Fri, 20 Aug 2021 10:32:57 +0200
Message-Id: <20210820083300.32289-4-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210820083300.32289-1-sw@simonwunderlich.de>
References: <20210820083300.32289-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

The commit 4c52729377ea ("kernel.h: split out kstrtox() and simple_strtox()
to a separate header") moved the kstrtou64 function to a new header called
linux/kstrtox.h.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/gateway_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/gateway_common.c b/net/batman-adv/gateway_common.c
index fdde305a198e..9349c76f30c5 100644
--- a/net/batman-adv/gateway_common.c
+++ b/net/batman-adv/gateway_common.c
@@ -10,7 +10,7 @@
 #include <linux/atomic.h>
 #include <linux/byteorder/generic.h>
 #include <linux/errno.h>
-#include <linux/kernel.h>
+#include <linux/kstrtox.h>
 #include <linux/limits.h>
 #include <linux/math64.h>
 #include <linux/netdevice.h>
-- 
2.20.1

