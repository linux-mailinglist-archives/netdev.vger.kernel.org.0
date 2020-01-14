Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D310913AC34
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 15:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728975AbgANOYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 09:24:01 -0500
Received: from simonwunderlich.de ([79.140.42.25]:49834 "EHLO
        simonwunderlich.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbgANOX7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 09:23:59 -0500
Received: from kero.packetmixer.de (p200300C5970F1B0095082C17D9AE8553.dip0.t-ipconnect.de [IPv6:2003:c5:970f:1b00:9508:2c17:d9ae:8553])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 8A7C462071;
        Tue, 14 Jan 2020 15:23:54 +0100 (CET)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 6/7] batman-adv: Update copyright years for 2020
Date:   Tue, 14 Jan 2020 15:23:50 +0100
Message-Id: <20200114142351.26622-7-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200114142351.26622-1-sw@simonwunderlich.de>
References: <20200114142351.26622-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 include/uapi/linux/batadv_packet.h     | 2 +-
 include/uapi/linux/batman_adv.h        | 2 +-
 net/batman-adv/Kconfig                 | 2 +-
 net/batman-adv/Makefile                | 2 +-
 net/batman-adv/bat_algo.c              | 2 +-
 net/batman-adv/bat_algo.h              | 2 +-
 net/batman-adv/bat_iv_ogm.c            | 2 +-
 net/batman-adv/bat_iv_ogm.h            | 2 +-
 net/batman-adv/bat_v.c                 | 2 +-
 net/batman-adv/bat_v.h                 | 2 +-
 net/batman-adv/bat_v_elp.c             | 2 +-
 net/batman-adv/bat_v_elp.h             | 2 +-
 net/batman-adv/bat_v_ogm.c             | 2 +-
 net/batman-adv/bat_v_ogm.h             | 2 +-
 net/batman-adv/bitarray.c              | 2 +-
 net/batman-adv/bitarray.h              | 2 +-
 net/batman-adv/bridge_loop_avoidance.c | 2 +-
 net/batman-adv/bridge_loop_avoidance.h | 2 +-
 net/batman-adv/debugfs.c               | 2 +-
 net/batman-adv/debugfs.h               | 2 +-
 net/batman-adv/distributed-arp-table.c | 2 +-
 net/batman-adv/distributed-arp-table.h | 2 +-
 net/batman-adv/fragmentation.c         | 2 +-
 net/batman-adv/fragmentation.h         | 2 +-
 net/batman-adv/gateway_client.c        | 2 +-
 net/batman-adv/gateway_client.h        | 2 +-
 net/batman-adv/gateway_common.c        | 2 +-
 net/batman-adv/gateway_common.h        | 2 +-
 net/batman-adv/hard-interface.c        | 2 +-
 net/batman-adv/hard-interface.h        | 2 +-
 net/batman-adv/hash.c                  | 2 +-
 net/batman-adv/hash.h                  | 2 +-
 net/batman-adv/icmp_socket.c           | 2 +-
 net/batman-adv/icmp_socket.h           | 2 +-
 net/batman-adv/log.c                   | 2 +-
 net/batman-adv/log.h                   | 2 +-
 net/batman-adv/main.c                  | 2 +-
 net/batman-adv/main.h                  | 2 +-
 net/batman-adv/multicast.c             | 2 +-
 net/batman-adv/multicast.h             | 2 +-
 net/batman-adv/netlink.c               | 2 +-
 net/batman-adv/netlink.h               | 2 +-
 net/batman-adv/network-coding.c        | 2 +-
 net/batman-adv/network-coding.h        | 2 +-
 net/batman-adv/originator.c            | 2 +-
 net/batman-adv/originator.h            | 2 +-
 net/batman-adv/routing.c               | 2 +-
 net/batman-adv/routing.h               | 2 +-
 net/batman-adv/send.c                  | 2 +-
 net/batman-adv/send.h                  | 2 +-
 net/batman-adv/soft-interface.c        | 2 +-
 net/batman-adv/soft-interface.h        | 2 +-
 net/batman-adv/sysfs.c                 | 2 +-
 net/batman-adv/sysfs.h                 | 2 +-
 net/batman-adv/tp_meter.c              | 2 +-
 net/batman-adv/tp_meter.h              | 2 +-
 net/batman-adv/trace.c                 | 2 +-
 net/batman-adv/trace.h                 | 2 +-
 net/batman-adv/translation-table.c     | 2 +-
 net/batman-adv/translation-table.h     | 2 +-
 net/batman-adv/tvlv.c                  | 2 +-
 net/batman-adv/tvlv.h                  | 2 +-
 net/batman-adv/types.h                 | 2 +-
 63 files changed, 63 insertions(+), 63 deletions(-)

diff --git a/include/uapi/linux/batadv_packet.h b/include/uapi/linux/batadv_packet.h
index 2a15f01c2243..0ae34c85ef9e 100644
--- a/include/uapi/linux/batadv_packet.h
+++ b/include/uapi/linux/batadv_packet.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) */
-/* Copyright (C) 2007-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2007-2020  B.A.T.M.A.N. contributors:
  *
  * Marek Lindner, Simon Wunderlich
  */
diff --git a/include/uapi/linux/batman_adv.h b/include/uapi/linux/batman_adv.h
index 67f4636758af..617c180ff0c8 100644
--- a/include/uapi/linux/batman_adv.h
+++ b/include/uapi/linux/batman_adv.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: MIT */
-/* Copyright (C) 2016-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2016-2020  B.A.T.M.A.N. contributors:
  *
  * Matthias Schiffer
  */
diff --git a/net/batman-adv/Kconfig b/net/batman-adv/Kconfig
index d5028af750d5..045b2b183213 100644
--- a/net/batman-adv/Kconfig
+++ b/net/batman-adv/Kconfig
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-# Copyright (C) 2007-2019  B.A.T.M.A.N. contributors:
+# Copyright (C) 2007-2020  B.A.T.M.A.N. contributors:
 #
 # Marek Lindner, Simon Wunderlich
 
diff --git a/net/batman-adv/Makefile b/net/batman-adv/Makefile
index fd63e116d9ff..daa49af7ff40 100644
--- a/net/batman-adv/Makefile
+++ b/net/batman-adv/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-# Copyright (C) 2007-2019  B.A.T.M.A.N. contributors:
+# Copyright (C) 2007-2020  B.A.T.M.A.N. contributors:
 #
 # Marek Lindner, Simon Wunderlich
 
diff --git a/net/batman-adv/bat_algo.c b/net/batman-adv/bat_algo.c
index fa39eaaab9d7..382fbe51fd34 100644
--- a/net/batman-adv/bat_algo.c
+++ b/net/batman-adv/bat_algo.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2007-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2007-2020  B.A.T.M.A.N. contributors:
  *
  * Marek Lindner, Simon Wunderlich
  */
diff --git a/net/batman-adv/bat_algo.h b/net/batman-adv/bat_algo.h
index 37898da8ad48..686a60bc9492 100644
--- a/net/batman-adv/bat_algo.h
+++ b/net/batman-adv/bat_algo.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2011-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2011-2020  B.A.T.M.A.N. contributors:
  *
  * Marek Lindner, Linus Lüssing
  */
diff --git a/net/batman-adv/bat_iv_ogm.c b/net/batman-adv/bat_iv_ogm.c
index 5b0b20e6da95..f0209505e41a 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2007-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2007-2020  B.A.T.M.A.N. contributors:
  *
  * Marek Lindner, Simon Wunderlich
  */
diff --git a/net/batman-adv/bat_iv_ogm.h b/net/batman-adv/bat_iv_ogm.h
index c7a9ba305bfc..0c57c1000c64 100644
--- a/net/batman-adv/bat_iv_ogm.h
+++ b/net/batman-adv/bat_iv_ogm.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2007-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2007-2020  B.A.T.M.A.N. contributors:
  *
  * Marek Lindner, Simon Wunderlich
  */
diff --git a/net/batman-adv/bat_v.c b/net/batman-adv/bat_v.c
index 4ff6cf1ecae7..0ecaf1bb0068 100644
--- a/net/batman-adv/bat_v.c
+++ b/net/batman-adv/bat_v.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2013-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2013-2020  B.A.T.M.A.N. contributors:
  *
  * Linus Lüssing, Marek Lindner
  */
diff --git a/net/batman-adv/bat_v.h b/net/batman-adv/bat_v.h
index 37833db098e6..5e0be10bc84e 100644
--- a/net/batman-adv/bat_v.h
+++ b/net/batman-adv/bat_v.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2011-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2011-2020  B.A.T.M.A.N. contributors:
  *
  * Marek Lindner, Linus Lüssing
  */
diff --git a/net/batman-adv/bat_v_elp.c b/net/batman-adv/bat_v_elp.c
index 6536e8cc53a0..1e3172db7492 100644
--- a/net/batman-adv/bat_v_elp.c
+++ b/net/batman-adv/bat_v_elp.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2011-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2011-2020  B.A.T.M.A.N. contributors:
  *
  * Linus Lüssing, Marek Lindner
  */
diff --git a/net/batman-adv/bat_v_elp.h b/net/batman-adv/bat_v_elp.h
index 1a29505f4f66..4358d436be2a 100644
--- a/net/batman-adv/bat_v_elp.h
+++ b/net/batman-adv/bat_v_elp.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2013-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2013-2020  B.A.T.M.A.N. contributors:
  *
  * Linus Lüssing, Marek Lindner
  */
diff --git a/net/batman-adv/bat_v_ogm.c b/net/batman-adv/bat_v_ogm.c
index 714ce56cfcc8..969466218999 100644
--- a/net/batman-adv/bat_v_ogm.c
+++ b/net/batman-adv/bat_v_ogm.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2013-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2013-2020  B.A.T.M.A.N. contributors:
  *
  * Antonio Quartulli
  */
diff --git a/net/batman-adv/bat_v_ogm.h b/net/batman-adv/bat_v_ogm.h
index bf16d040461d..0ae2575f70bb 100644
--- a/net/batman-adv/bat_v_ogm.h
+++ b/net/batman-adv/bat_v_ogm.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2013-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2013-2020  B.A.T.M.A.N. contributors:
  *
  * Antonio Quartulli
  */
diff --git a/net/batman-adv/bitarray.c b/net/batman-adv/bitarray.c
index 7f04a6acf14e..4bc695cda397 100644
--- a/net/batman-adv/bitarray.c
+++ b/net/batman-adv/bitarray.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2006-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2006-2020  B.A.T.M.A.N. contributors:
  *
  * Simon Wunderlich, Marek Lindner
  */
diff --git a/net/batman-adv/bitarray.h b/net/batman-adv/bitarray.h
index 84ad2d2b6ac9..533c6d44cb58 100644
--- a/net/batman-adv/bitarray.h
+++ b/net/batman-adv/bitarray.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2006-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2006-2020  B.A.T.M.A.N. contributors:
  *
  * Simon Wunderlich, Marek Lindner
  */
diff --git a/net/batman-adv/bridge_loop_avoidance.c b/net/batman-adv/bridge_loop_avoidance.c
index 0eff33580f95..41cc87f06b14 100644
--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2011-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2011-2020  B.A.T.M.A.N. contributors:
  *
  * Simon Wunderlich
  */
diff --git a/net/batman-adv/bridge_loop_avoidance.h b/net/batman-adv/bridge_loop_avoidance.h
index 02b24a861a85..41edb2c4a327 100644
--- a/net/batman-adv/bridge_loop_avoidance.h
+++ b/net/batman-adv/bridge_loop_avoidance.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2011-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2011-2020  B.A.T.M.A.N. contributors:
  *
  * Simon Wunderlich
  */
diff --git a/net/batman-adv/debugfs.c b/net/batman-adv/debugfs.c
index 38c4d8e51155..452856c27d20 100644
--- a/net/batman-adv/debugfs.c
+++ b/net/batman-adv/debugfs.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2010-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2010-2020  B.A.T.M.A.N. contributors:
  *
  * Marek Lindner
  */
diff --git a/net/batman-adv/debugfs.h b/net/batman-adv/debugfs.h
index 1c5afd301ce9..7e2e8f586f42 100644
--- a/net/batman-adv/debugfs.h
+++ b/net/batman-adv/debugfs.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2010-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2010-2020  B.A.T.M.A.N. contributors:
  *
  * Marek Lindner
  */
diff --git a/net/batman-adv/distributed-arp-table.c b/net/batman-adv/distributed-arp-table.c
index 5004e38fe792..906011b60d66 100644
--- a/net/batman-adv/distributed-arp-table.c
+++ b/net/batman-adv/distributed-arp-table.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2011-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2011-2020  B.A.T.M.A.N. contributors:
  *
  * Antonio Quartulli
  */
diff --git a/net/batman-adv/distributed-arp-table.h b/net/batman-adv/distributed-arp-table.h
index 67c7729add55..2bff2f4a325c 100644
--- a/net/batman-adv/distributed-arp-table.h
+++ b/net/batman-adv/distributed-arp-table.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2011-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2011-2020  B.A.T.M.A.N. contributors:
  *
  * Antonio Quartulli
  */
diff --git a/net/batman-adv/fragmentation.c b/net/batman-adv/fragmentation.c
index 385fccdcf69d..7cad97644d05 100644
--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2013-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2013-2020  B.A.T.M.A.N. contributors:
  *
  * Martin Hundebøll <martin@hundeboll.net>
  */
diff --git a/net/batman-adv/fragmentation.h b/net/batman-adv/fragmentation.h
index abfe8c6556de..881ef328b6cd 100644
--- a/net/batman-adv/fragmentation.h
+++ b/net/batman-adv/fragmentation.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2013-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2013-2020  B.A.T.M.A.N. contributors:
  *
  * Martin Hundebøll <martin@hundeboll.net>
  */
diff --git a/net/batman-adv/gateway_client.c b/net/batman-adv/gateway_client.c
index 47df4c678988..e22e49289677 100644
--- a/net/batman-adv/gateway_client.c
+++ b/net/batman-adv/gateway_client.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2009-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2009-2020  B.A.T.M.A.N. contributors:
  *
  * Marek Lindner
  */
diff --git a/net/batman-adv/gateway_client.h b/net/batman-adv/gateway_client.h
index 0be8e7178ec7..88b5dba84354 100644
--- a/net/batman-adv/gateway_client.h
+++ b/net/batman-adv/gateway_client.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2009-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2009-2020  B.A.T.M.A.N. contributors:
  *
  * Marek Lindner
  */
diff --git a/net/batman-adv/gateway_common.c b/net/batman-adv/gateway_common.c
index fc55750542e4..16cd9450ceb1 100644
--- a/net/batman-adv/gateway_common.c
+++ b/net/batman-adv/gateway_common.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2009-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2009-2020  B.A.T.M.A.N. contributors:
  *
  * Marek Lindner
  */
diff --git a/net/batman-adv/gateway_common.h b/net/batman-adv/gateway_common.h
index 211b14b37db8..c3a0c5a7f7e9 100644
--- a/net/batman-adv/gateway_common.h
+++ b/net/batman-adv/gateway_common.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2009-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2009-2020  B.A.T.M.A.N. contributors:
  *
  * Marek Lindner
  */
diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interface.c
index afb52282d5bd..c7e98a40dd33 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2007-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2007-2020  B.A.T.M.A.N. contributors:
  *
  * Marek Lindner, Simon Wunderlich
  */
diff --git a/net/batman-adv/hard-interface.h b/net/batman-adv/hard-interface.h
index bbb8a6f18d6b..bad2e50135e8 100644
--- a/net/batman-adv/hard-interface.h
+++ b/net/batman-adv/hard-interface.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2007-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2007-2020  B.A.T.M.A.N. contributors:
  *
  * Marek Lindner, Simon Wunderlich
  */
diff --git a/net/batman-adv/hash.c b/net/batman-adv/hash.c
index a9d4e176f4de..68638e0450a6 100644
--- a/net/batman-adv/hash.c
+++ b/net/batman-adv/hash.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2006-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2006-2020  B.A.T.M.A.N. contributors:
  *
  * Simon Wunderlich, Marek Lindner
  */
diff --git a/net/batman-adv/hash.h b/net/batman-adv/hash.h
index 57877f0b78e0..91ae9f32b580 100644
--- a/net/batman-adv/hash.h
+++ b/net/batman-adv/hash.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2006-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2006-2020  B.A.T.M.A.N. contributors:
  *
  * Simon Wunderlich, Marek Lindner
  */
diff --git a/net/batman-adv/icmp_socket.c b/net/batman-adv/icmp_socket.c
index 0a70b66e8770..ccb535c77e5d 100644
--- a/net/batman-adv/icmp_socket.c
+++ b/net/batman-adv/icmp_socket.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2007-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2007-2020  B.A.T.M.A.N. contributors:
  *
  * Marek Lindner
  */
diff --git a/net/batman-adv/icmp_socket.h b/net/batman-adv/icmp_socket.h
index 27fafff586df..6abd0f4742ef 100644
--- a/net/batman-adv/icmp_socket.h
+++ b/net/batman-adv/icmp_socket.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2007-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2007-2020  B.A.T.M.A.N. contributors:
  *
  * Marek Lindner
  */
diff --git a/net/batman-adv/log.c b/net/batman-adv/log.c
index 11941cf1adcc..a67b2b091447 100644
--- a/net/batman-adv/log.c
+++ b/net/batman-adv/log.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2010-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2010-2020  B.A.T.M.A.N. contributors:
  *
  * Marek Lindner
  */
diff --git a/net/batman-adv/log.h b/net/batman-adv/log.h
index 41fd900121c5..f9884dc56cf3 100644
--- a/net/batman-adv/log.h
+++ b/net/batman-adv/log.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2007-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2007-2020  B.A.T.M.A.N. contributors:
  *
  * Marek Lindner, Simon Wunderlich
  */
diff --git a/net/batman-adv/main.c b/net/batman-adv/main.c
index 4a89177def64..0b840e1e3dfa 100644
--- a/net/batman-adv/main.c
+++ b/net/batman-adv/main.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2007-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2007-2020  B.A.T.M.A.N. contributors:
  *
  * Marek Lindner, Simon Wunderlich
  */
diff --git a/net/batman-adv/main.h b/net/batman-adv/main.h
index fd8c0728ddc7..692306df7b6f 100644
--- a/net/batman-adv/main.h
+++ b/net/batman-adv/main.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2007-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2007-2020  B.A.T.M.A.N. contributors:
  *
  * Marek Lindner, Simon Wunderlich
  */
diff --git a/net/batman-adv/multicast.c b/net/batman-adv/multicast.c
index f9ec8e7507b6..9ebdc1e864b9 100644
--- a/net/batman-adv/multicast.c
+++ b/net/batman-adv/multicast.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2014-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2014-2020  B.A.T.M.A.N. contributors:
  *
  * Linus Lüssing
  */
diff --git a/net/batman-adv/multicast.h b/net/batman-adv/multicast.h
index 5d9e2bb29c97..ebf825991ecd 100644
--- a/net/batman-adv/multicast.h
+++ b/net/batman-adv/multicast.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2014-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2014-2020  B.A.T.M.A.N. contributors:
  *
  * Linus Lüssing
  */
diff --git a/net/batman-adv/netlink.c b/net/batman-adv/netlink.c
index 7e052d6f759b..02ed073f95a9 100644
--- a/net/batman-adv/netlink.c
+++ b/net/batman-adv/netlink.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2016-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2016-2020  B.A.T.M.A.N. contributors:
  *
  * Matthias Schiffer
  */
diff --git a/net/batman-adv/netlink.h b/net/batman-adv/netlink.h
index ddc674e47dbb..7ee48f916997 100644
--- a/net/batman-adv/netlink.h
+++ b/net/batman-adv/netlink.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2016-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2016-2020  B.A.T.M.A.N. contributors:
  *
  * Matthias Schiffer
  */
diff --git a/net/batman-adv/network-coding.c b/net/batman-adv/network-coding.c
index 580609389f0f..8f0717c3f7b5 100644
--- a/net/batman-adv/network-coding.c
+++ b/net/batman-adv/network-coding.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2012-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2012-2020  B.A.T.M.A.N. contributors:
  *
  * Martin Hundebøll, Jeppe Ledet-Pedersen
  */
diff --git a/net/batman-adv/network-coding.h b/net/batman-adv/network-coding.h
index 753fa49723cf..334289084127 100644
--- a/net/batman-adv/network-coding.h
+++ b/net/batman-adv/network-coding.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2012-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2012-2020  B.A.T.M.A.N. contributors:
  *
  * Martin Hundebøll, Jeppe Ledet-Pedersen
  */
diff --git a/net/batman-adv/originator.c b/net/batman-adv/originator.c
index 38613487fb1b..5b0c2fffc214 100644
--- a/net/batman-adv/originator.c
+++ b/net/batman-adv/originator.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2009-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2009-2020  B.A.T.M.A.N. contributors:
  *
  * Marek Lindner, Simon Wunderlich
  */
diff --git a/net/batman-adv/originator.h b/net/batman-adv/originator.h
index 512a1f99dd75..7bc01c138b3a 100644
--- a/net/batman-adv/originator.h
+++ b/net/batman-adv/originator.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2007-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2007-2020  B.A.T.M.A.N. contributors:
  *
  * Marek Lindner, Simon Wunderlich
  */
diff --git a/net/batman-adv/routing.c b/net/batman-adv/routing.c
index f0f864820dea..3632bd976c56 100644
--- a/net/batman-adv/routing.c
+++ b/net/batman-adv/routing.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2007-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2007-2020  B.A.T.M.A.N. contributors:
  *
  * Marek Lindner, Simon Wunderlich
  */
diff --git a/net/batman-adv/routing.h b/net/batman-adv/routing.h
index c20feac95107..2ed49db6eff5 100644
--- a/net/batman-adv/routing.h
+++ b/net/batman-adv/routing.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2007-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2007-2020  B.A.T.M.A.N. contributors:
  *
  * Marek Lindner, Simon Wunderlich
  */
diff --git a/net/batman-adv/send.c b/net/batman-adv/send.c
index 3ce5f7bad369..7f8ade04e08e 100644
--- a/net/batman-adv/send.c
+++ b/net/batman-adv/send.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2007-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2007-2020  B.A.T.M.A.N. contributors:
  *
  * Marek Lindner, Simon Wunderlich
  */
diff --git a/net/batman-adv/send.h b/net/batman-adv/send.h
index 5fc0fd1e5d08..0d36e15589f6 100644
--- a/net/batman-adv/send.h
+++ b/net/batman-adv/send.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2007-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2007-2020  B.A.T.M.A.N. contributors:
  *
  * Marek Lindner, Simon Wunderlich
  */
diff --git a/net/batman-adv/soft-interface.c b/net/batman-adv/soft-interface.c
index 832e156c519e..5f05a728f347 100644
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2007-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2007-2020  B.A.T.M.A.N. contributors:
  *
  * Marek Lindner, Simon Wunderlich
  */
diff --git a/net/batman-adv/soft-interface.h b/net/batman-adv/soft-interface.h
index 29139ad769fe..534e08d6ad91 100644
--- a/net/batman-adv/soft-interface.h
+++ b/net/batman-adv/soft-interface.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2007-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2007-2020  B.A.T.M.A.N. contributors:
  *
  * Marek Lindner
  */
diff --git a/net/batman-adv/sysfs.c b/net/batman-adv/sysfs.c
index e5bbc28ed12c..c45962d8527b 100644
--- a/net/batman-adv/sysfs.c
+++ b/net/batman-adv/sysfs.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2010-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2010-2020  B.A.T.M.A.N. contributors:
  *
  * Marek Lindner
  */
diff --git a/net/batman-adv/sysfs.h b/net/batman-adv/sysfs.h
index 5e466093dfa5..d987f8b30a98 100644
--- a/net/batman-adv/sysfs.h
+++ b/net/batman-adv/sysfs.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2010-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2010-2020  B.A.T.M.A.N. contributors:
  *
  * Marek Lindner
  */
diff --git a/net/batman-adv/tp_meter.c b/net/batman-adv/tp_meter.c
index dd6a9a40dbb9..bd2ac570c42c 100644
--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2012-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2012-2020  B.A.T.M.A.N. contributors:
  *
  * Edo Monticelli, Antonio Quartulli
  */
diff --git a/net/batman-adv/tp_meter.h b/net/batman-adv/tp_meter.h
index 78d310da0ad3..140105215aa2 100644
--- a/net/batman-adv/tp_meter.h
+++ b/net/batman-adv/tp_meter.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2012-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2012-2020  B.A.T.M.A.N. contributors:
  *
  * Edo Monticelli, Antonio Quartulli
  */
diff --git a/net/batman-adv/trace.c b/net/batman-adv/trace.c
index 3cedd2c36528..3444d9e4e90d 100644
--- a/net/batman-adv/trace.c
+++ b/net/batman-adv/trace.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2010-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2010-2020  B.A.T.M.A.N. contributors:
  *
  * Sven Eckelmann
  */
diff --git a/net/batman-adv/trace.h b/net/batman-adv/trace.h
index d8f764521c0b..f631b1e01b89 100644
--- a/net/batman-adv/trace.h
+++ b/net/batman-adv/trace.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2010-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2010-2020  B.A.T.M.A.N. contributors:
  *
  * Sven Eckelmann
  */
diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index 8a482c5ec67b..852932838ddc 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2007-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2007-2020  B.A.T.M.A.N. contributors:
  *
  * Marek Lindner, Simon Wunderlich, Antonio Quartulli
  */
diff --git a/net/batman-adv/translation-table.h b/net/batman-adv/translation-table.h
index 4a98860d7f0e..b24d35b9226a 100644
--- a/net/batman-adv/translation-table.h
+++ b/net/batman-adv/translation-table.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2007-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2007-2020  B.A.T.M.A.N. contributors:
  *
  * Marek Lindner, Simon Wunderlich, Antonio Quartulli
  */
diff --git a/net/batman-adv/tvlv.c b/net/batman-adv/tvlv.c
index aae63f0d21eb..0963a43ad996 100644
--- a/net/batman-adv/tvlv.c
+++ b/net/batman-adv/tvlv.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright (C) 2007-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2007-2020  B.A.T.M.A.N. contributors:
  *
  * Marek Lindner, Simon Wunderlich
  */
diff --git a/net/batman-adv/tvlv.h b/net/batman-adv/tvlv.h
index 36985000a0a8..d509d00c7a23 100644
--- a/net/batman-adv/tvlv.h
+++ b/net/batman-adv/tvlv.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2007-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2007-2020  B.A.T.M.A.N. contributors:
  *
  * Marek Lindner, Simon Wunderlich
  */
diff --git a/net/batman-adv/types.h b/net/batman-adv/types.h
index bdf9827b5f63..4a17a66cc572 100644
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (C) 2007-2019  B.A.T.M.A.N. contributors:
+/* Copyright (C) 2007-2020  B.A.T.M.A.N. contributors:
  *
  * Marek Lindner, Simon Wunderlich
  */
-- 
2.20.1

