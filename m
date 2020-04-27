Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1CDD1BA743
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 17:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbgD0PGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 11:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727947AbgD0PGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 11:06:12 -0400
Received: from simonwunderlich.de (packetmixer.de [IPv6:2001:4d88:2000:24::c0de])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69045C03C1A7
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 08:06:12 -0700 (PDT)
Received: from kero.packetmixer.de (p4FD5799A.dip0.t-ipconnect.de [79.213.121.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 26C6A62070;
        Mon, 27 Apr 2020 17:06:11 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 3/5] batman-adv: trace: Drop unneeded types.h include
Date:   Mon, 27 Apr 2020 17:06:05 +0200
Message-Id: <20200427150607.31401-4-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200427150607.31401-1-sw@simonwunderlich.de>
References: <20200427150607.31401-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

The commit 04ae87a52074 ("ftrace: Rework event_create_dir()") restructured
various macros in the ftrace framework. These changes also had the nice
side effect that the linux/types.h include is no longer necessary to define
some of the types used by these macros.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/trace.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/batman-adv/trace.h b/net/batman-adv/trace.h
index f631b1e01b89..a87547570b4e 100644
--- a/net/batman-adv/trace.h
+++ b/net/batman-adv/trace.h
@@ -15,7 +15,6 @@
 #include <linux/percpu.h>
 #include <linux/printk.h>
 #include <linux/tracepoint.h>
-#include <linux/types.h>
 
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM batadv
-- 
2.20.1

