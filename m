Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5779927264C
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 15:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727739AbgIUNsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 09:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727405AbgIUNqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 09:46:07 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E7B9C0613D3
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 06:46:07 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kKM8q-0003ED-Sn; Mon, 21 Sep 2020 15:46:04 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Masahiro Yamada <masahiroy@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 09/38] can: remove "WITH Linux-syscall-note" from SPDX tag of C files
Date:   Mon, 21 Sep 2020 15:45:28 +0200
Message-Id: <20200921134557.2251383-10-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921134557.2251383-1-mkl@pengutronix.de>
References: <20200921134557.2251383-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

The "WITH Linux-syscall-note" exception is intended for UAPI headers.

See LICENSES/exceptions/Linux-syscall-note

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Link: https://lore.kernel.org/r/20200403073741.18352-1-masahiroy@kernel.org
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/bcm.c  | 2 +-
 net/can/gw.c   | 2 +-
 net/can/proc.c | 2 +-
 net/can/raw.c  | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/can/bcm.c b/net/can/bcm.c
index d14ea12affb1..4253915800e6 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
+// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
 /*
  * bcm.c - Broadcast Manager to filter/send (cyclic) CAN content
  *
diff --git a/net/can/gw.c b/net/can/gw.c
index 65d60c93af29..49b4e3d91ad6 100644
--- a/net/can/gw.c
+++ b/net/can/gw.c
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
+// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
 /* gw.c - CAN frame Gateway/Router/Bridge with netlink interface
  *
  * Copyright (c) 2019 Volkswagen Group Electronic Research
diff --git a/net/can/proc.c b/net/can/proc.c
index e6881bfc3ed1..a4eb06c9eb70 100644
--- a/net/can/proc.c
+++ b/net/can/proc.c
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
+// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
 /*
  * proc.c - procfs support for Protocol family CAN core module
  *
diff --git a/net/can/raw.c b/net/can/raw.c
index 57235b29f571..24db4b4afdc7 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
+// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
 /* raw.c - Raw sockets for protocol family CAN
  *
  * Copyright (c) 2002-2007 Volkswagen Group Electronic Research
-- 
2.28.0

