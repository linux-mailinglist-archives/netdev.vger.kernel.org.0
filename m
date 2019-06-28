Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7984C59D59
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 15:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbfF1N4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 09:56:11 -0400
Received: from packetmixer.de ([79.140.42.25]:52982 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbfF1N4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 09:56:08 -0400
Received: from kero.packetmixer.de (p4FD57BD9.dip0.t-ipconnect.de [79.213.123.217])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mail.packetmixer.de (Postfix) with ESMTPSA id A2BD662070;
        Fri, 28 Jun 2019 15:56:06 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 03/10] batman-adv: Add missing include for atomic functions
Date:   Fri, 28 Jun 2019 15:55:57 +0200
Message-Id: <20190628135604.11581-4-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190628135604.11581-1-sw@simonwunderlich.de>
References: <20190628135604.11581-1-sw@simonwunderlich.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

main.h is using atomic_add_unless and log.h atomic_read. The main
header linux/atomic.h should be included for these files.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/log.h  | 1 +
 net/batman-adv/main.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/net/batman-adv/log.h b/net/batman-adv/log.h
index 5504637e63d8..741cfa3719ff 100644
--- a/net/batman-adv/log.h
+++ b/net/batman-adv/log.h
@@ -9,6 +9,7 @@
 
 #include "main.h"
 
+#include <linux/atomic.h>
 #include <linux/bitops.h>
 #include <linux/compiler.h>
 #include <linux/printk.h>
diff --git a/net/batman-adv/main.h b/net/batman-adv/main.h
index 11d051dbbda4..821a7de45256 100644
--- a/net/batman-adv/main.h
+++ b/net/batman-adv/main.h
@@ -205,6 +205,7 @@ enum batadv_uev_type {
 
 /* Kernel headers */
 
+#include <linux/atomic.h>
 #include <linux/compiler.h>
 #include <linux/etherdevice.h>
 #include <linux/if_vlan.h>
-- 
2.11.0

