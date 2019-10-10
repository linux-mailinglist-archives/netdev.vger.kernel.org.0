Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4B5CD2933
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 14:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387660AbfJJMSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 08:18:18 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:52613 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387537AbfJJMSQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 08:18:16 -0400
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1iIXOZ-0006Lw-47; Thu, 10 Oct 2019 14:18:15 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org, linux-can <linux-can@vger.kernel.org>
Cc:     davem@davemloft.net, kernel@pengutronix.de,
        jhofstee@victronenergy.com,
        =?UTF-8?q?Martin=20Hundeb=C3=B8ll?= <martin@geanix.com>,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        Yegor Yefremov <yegorslists@googlemail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 29/29] can: don't use deprecated license identifiers
Date:   Thu, 10 Oct 2019 14:17:50 +0200
Message-Id: <20191010121750.27237-30-mkl@pengutronix.de>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010121750.27237-1-mkl@pengutronix.de>
References: <20191010121750.27237-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yegor Yefremov <yegorslists@googlemail.com>

The "GPL-2.0" license identifier changed to "GPL-2.0-only" in SPDX v3.0.

Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 include/uapi/linux/can.h         | 2 +-
 include/uapi/linux/can/bcm.h     | 2 +-
 include/uapi/linux/can/error.h   | 2 +-
 include/uapi/linux/can/gw.h      | 2 +-
 include/uapi/linux/can/j1939.h   | 2 +-
 include/uapi/linux/can/netlink.h | 2 +-
 include/uapi/linux/can/raw.h     | 2 +-
 include/uapi/linux/can/vxcan.h   | 2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/can.h b/include/uapi/linux/can.h
index 1e988fdeba34..6a6d2c7655ff 100644
--- a/include/uapi/linux/can.h
+++ b/include/uapi/linux/can.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
+/* SPDX-License-Identifier: ((GPL-2.0-only WITH Linux-syscall-note) OR BSD-3-Clause) */
 /*
  * linux/can.h
  *
diff --git a/include/uapi/linux/can/bcm.h b/include/uapi/linux/can/bcm.h
index 0fb328d93148..dd2b925b09ac 100644
--- a/include/uapi/linux/can/bcm.h
+++ b/include/uapi/linux/can/bcm.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
+/* SPDX-License-Identifier: ((GPL-2.0-only WITH Linux-syscall-note) OR BSD-3-Clause) */
 /*
  * linux/can/bcm.h
  *
diff --git a/include/uapi/linux/can/error.h b/include/uapi/linux/can/error.h
index bfc4b5d22a5e..34633283de64 100644
--- a/include/uapi/linux/can/error.h
+++ b/include/uapi/linux/can/error.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
+/* SPDX-License-Identifier: ((GPL-2.0-only WITH Linux-syscall-note) OR BSD-3-Clause) */
 /*
  * linux/can/error.h
  *
diff --git a/include/uapi/linux/can/gw.h b/include/uapi/linux/can/gw.h
index 3aea5388c8e4..c2190bbe21d8 100644
--- a/include/uapi/linux/can/gw.h
+++ b/include/uapi/linux/can/gw.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
+/* SPDX-License-Identifier: ((GPL-2.0-only WITH Linux-syscall-note) OR BSD-3-Clause) */
 /*
  * linux/can/gw.h
  *
diff --git a/include/uapi/linux/can/j1939.h b/include/uapi/linux/can/j1939.h
index c32325342d30..df6e821075c1 100644
--- a/include/uapi/linux/can/j1939.h
+++ b/include/uapi/linux/can/j1939.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/* SPDX-License-Identifier: GPL-2.0-only WITH Linux-syscall-note */
 /*
  * j1939.h
  *
diff --git a/include/uapi/linux/can/netlink.h b/include/uapi/linux/can/netlink.h
index 1bc70d3a4d39..6f598b73839e 100644
--- a/include/uapi/linux/can/netlink.h
+++ b/include/uapi/linux/can/netlink.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/* SPDX-License-Identifier: GPL-2.0-only WITH Linux-syscall-note */
 /*
  * linux/can/netlink.h
  *
diff --git a/include/uapi/linux/can/raw.h b/include/uapi/linux/can/raw.h
index be3b36e7ff61..6a11d308eb5c 100644
--- a/include/uapi/linux/can/raw.h
+++ b/include/uapi/linux/can/raw.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
+/* SPDX-License-Identifier: ((GPL-2.0-only WITH Linux-syscall-note) OR BSD-3-Clause) */
 /*
  * linux/can/raw.h
  *
diff --git a/include/uapi/linux/can/vxcan.h b/include/uapi/linux/can/vxcan.h
index 066812d118a2..4fa9d8777a07 100644
--- a/include/uapi/linux/can/vxcan.h
+++ b/include/uapi/linux/can/vxcan.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/* SPDX-License-Identifier: GPL-2.0-only WITH Linux-syscall-note */
 #ifndef _UAPI_CAN_VXCAN_H
 #define _UAPI_CAN_VXCAN_H
 
-- 
2.23.0

