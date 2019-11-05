Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E83ACEF986
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 10:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730798AbfKEJfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 04:35:37 -0500
Received: from simonwunderlich.de ([79.140.42.25]:35612 "EHLO
        simonwunderlich.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730769AbfKEJfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 04:35:37 -0500
Received: from kero.packetmixer.de (p200300C5970F5D00F0ACF07C9CF9C7D8.dip0.t-ipconnect.de [IPv6:2003:c5:970f:5d00:f0ac:f07c:9cf9:c7d8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 6B48E6205F;
        Tue,  5 Nov 2019 10:35:35 +0100 (CET)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 5/5] batman-adv: Drop lockdep.h include for soft-interface.c
Date:   Tue,  5 Nov 2019 10:35:31 +0100
Message-Id: <20191105093531.11398-6-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191105093531.11398-1-sw@simonwunderlich.de>
References: <20191105093531.11398-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

The commit ab92d68fc22f ("net: core: add generic lockdep keys") removed
all lockdep functionality from soft-interface.c but didn't remove the
include for this functionality.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/soft-interface.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/batman-adv/soft-interface.c b/net/batman-adv/soft-interface.c
index 697f2da12487..832e156c519e 100644
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -22,7 +22,6 @@
 #include <linux/kernel.h>
 #include <linux/kref.h>
 #include <linux/list.h>
-#include <linux/lockdep.h>
 #include <linux/netdevice.h>
 #include <linux/netlink.h>
 #include <linux/percpu.h>
-- 
2.20.1

