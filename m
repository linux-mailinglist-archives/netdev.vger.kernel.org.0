Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3BC0F02DC
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 17:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390489AbfKEQcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 11:32:55 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:50075 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390468AbfKEQcw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 11:32:52 -0500
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1iS1lC-0002Hp-GQ; Tue, 05 Nov 2019 17:32:50 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Yegor Yefremov <yegorslists@googlemail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 33/33] can: don't use deprecated license identifiers
Date:   Tue,  5 Nov 2019 17:32:15 +0100
Message-Id: <20191105163215.30194-34-mkl@pengutronix.de>
X-Mailer: git-send-email 2.24.0.rc1
In-Reply-To: <20191105163215.30194-1-mkl@pengutronix.de>
References: <20191105163215.30194-1-mkl@pengutronix.de>
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
2.24.0.rc1

