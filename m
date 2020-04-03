Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59A7E19D15F
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 09:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390362AbgDCHip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 03:38:45 -0400
Received: from conuserg-12.nifty.com ([210.131.2.79]:30544 "EHLO
        conuserg-12.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390267AbgDCHip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 03:38:45 -0400
Received: from localhost.localdomain (p14092-ipngnfx01kyoto.kyoto.ocn.ne.jp [153.142.97.92]) (authenticated)
        by conuserg-12.nifty.com with ESMTP id 0337bnR8018752;
        Fri, 3 Apr 2020 16:37:49 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-12.nifty.com 0337bnR8018752
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1585899470;
        bh=kd64Egtcv7z+eNdTYSdkDz1izi5aQNUps8DVTK9PF4s=;
        h=From:To:Cc:Subject:Date:From;
        b=0anGhdcPT5b4H1i35chsiMv+k2P947lf69UkgT33PdrESwTDs1uDWHfzUYrFlXReZ
         2CVNN9d6cPtDKFl4FAHFdNXanLYzJhac87krTrDce1RNEz3RGY9PlRvP8Pw/jLvGNW
         /9LLTPjPbNoIuPE8fXraN4q4pJ7FrKqHVs9UG+dwRzSbGLCVDboKP5pQuwrcwIzdlU
         C1tFIofg9AqvEXZNv8E5A2e1aNY9Umzwr1WM11O5ZDO5KRLMIfJP2s866/tHtiInM6
         zPJvV0RXfswm2c6P3OhNyzdSa25/J++x3l37j+S2EqbsSWhmeHQt95xT7nIUa5a/kQ
         7S7zQ8atPJhFw==
X-Nifty-SrcIP: [153.142.97.92]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] net: can: remove "WITH Linux-syscall-note" from SPDX tag of C files
Date:   Fri,  3 Apr 2020 16:37:41 +0900
Message-Id: <20200403073741.18352-1-masahiroy@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "WITH Linux-syscall-note" exception is intended for UAPI headers.

See LICENSES/exceptions/Linux-syscall-note

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

 net/can/bcm.c  | 2 +-
 net/can/gw.c   | 2 +-
 net/can/proc.c | 2 +-
 net/can/raw.c  | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/can/bcm.c b/net/can/bcm.c
index c96fa0f33db3..d94b20933339 100644
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
index 59c039d73c6d..ab104cc18562 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
+// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
 /* raw.c - Raw sockets for protocol family CAN
  *
  * Copyright (c) 2002-2007 Volkswagen Group Electronic Research
-- 
2.17.1

