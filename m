Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B045B46B11A
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 03:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbhLGC6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 21:58:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbhLGC6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 21:58:01 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F7CC061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 18:54:32 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id u80so12017534pfc.9
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 18:54:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gnyvU6aQ6cmCKxvU8HYEIJ+gYj3b+e+4xn0kCc3JbyQ=;
        b=Y61mHEre39uukCq3k5ck7FoZ58bVuOu1h2gezHbztizXgKxe4suicjcdnZrq1mdQgc
         7JDzF6hE2Bjq/UyqRscml09/jP8OQYMI1Dvz5r5yYwXxLMy5wwC/e8E+1JBQJsbnP7w3
         Kfbb3Yd12iy6jeDLW3un4mkyv9kXFNfyMALEuIYTT6khXLeIqAN5pYUKTOVtG/z1g3Qn
         kmYuq954bmSwtzI3JVegNBNJ3LNCjUqXRAnlK7HM9GSS42Ow4CXJ7+3zPg5kqZw1UCzY
         f/zf5Y1wg2H0PuBOvO6f6B/QRZ8MnzAKvasiCZexs6XmApDj9FiO0UX3OK3BhHT/ibDe
         Ku6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gnyvU6aQ6cmCKxvU8HYEIJ+gYj3b+e+4xn0kCc3JbyQ=;
        b=CaurWzwzP332R/R7OEZng52wM3YbtdIpIINMxPAM/pOVlbYCm6JpnUtEjcs+UUq5cf
         x8Vvk6Yws9PYuGyti6MGFqhcyfI7hqtcs6kxz1Fezcu9RmiiqyEd/NWBxQuZDLbk9wcv
         Tjdg9f21zyJAyeAM4aOO/+7+gJmKthzoF9ieZSvkGUnNpJWdWi0Du6ZGtl9m7fcUz3fq
         r0EByGSdICbgWZlrovjGfZTeo19MTnWJHqyZTztb682cVMXiuv9wcjSN/oW8tOVUm+pU
         aC9DpGrG20wq3FV8HfPBWlf6ZbJZZ10bpQKGwxD8bbP/5djtyfGqJKKGEiNdHRL5f4Ng
         0iXQ==
X-Gm-Message-State: AOAM530t1OIbNu0AZGv3uW3vUfIOwEbPuqlK6BvopRRLtQidr31qW53v
        rrLKJ+DM7j4RB7CltbiWHX0=
X-Google-Smtp-Source: ABdhPJyQPGeJzo1slV1gU6cbWx35uO5G2CAk30fZySXEUS9I412ZlzIGGtjV37NHOuX7RrwFyeW2xA==
X-Received: by 2002:aa7:9dcd:0:b0:494:658c:3943 with SMTP id g13-20020aa79dcd000000b00494658c3943mr40073696pfq.19.1638845671882;
        Mon, 06 Dec 2021 18:54:31 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d17sm13323990pfj.124.2021.12.06.18.54.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 18:54:31 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     wireguard@lists.zx2c4.com
Cc:     netdev@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH wireguard] wireguard: remove redundancy include files
Date:   Tue,  7 Dec 2021 10:54:21 +0800
Message-Id: <20211207025421.1903782-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove redundancy include files based on tool include-what-you-use
result. The tool will suggest using direct include headers and removing
some big headers. e.g. it will suggests to use linux/spinlock_types.h
for spinlock_t. But actually, we only need to include linux/spinlock.h
directly. So I just take the result as a reference and remove the include
files I do not find related structure/functions.

Tested with gcc-8.5.0 and the compilation passed.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 drivers/net/wireguard/device.c   | 1 -
 drivers/net/wireguard/device.h   | 1 -
 drivers/net/wireguard/noise.c    | 4 ----
 drivers/net/wireguard/noise.h    | 1 -
 drivers/net/wireguard/peer.h     | 1 -
 drivers/net/wireguard/queueing.h | 2 --
 drivers/net/wireguard/send.c     | 5 -----
 drivers/net/wireguard/socket.c   | 2 --
 drivers/net/wireguard/socket.h   | 5 -----
 9 files changed, 22 deletions(-)

diff --git a/drivers/net/wireguard/device.c b/drivers/net/wireguard/device.c
index a46067c38bf5..06b74da2133f 100644
--- a/drivers/net/wireguard/device.c
+++ b/drivers/net/wireguard/device.c
@@ -11,7 +11,6 @@
 #include "peer.h"
 #include "messages.h"
 
-#include <linux/module.h>
 #include <linux/rtnetlink.h>
 #include <linux/inet.h>
 #include <linux/netdevice.h>
diff --git a/drivers/net/wireguard/device.h b/drivers/net/wireguard/device.h
index 43c7cebbf50b..0782dcef9fc1 100644
--- a/drivers/net/wireguard/device.h
+++ b/drivers/net/wireguard/device.h
@@ -8,7 +8,6 @@
 
 #include "noise.h"
 #include "allowedips.h"
-#include "peerlookup.h"
 #include "cookie.h"
 
 #include <linux/types.h>
diff --git a/drivers/net/wireguard/noise.c b/drivers/net/wireguard/noise.c
index c0cfd9b36c0b..59be94077767 100644
--- a/drivers/net/wireguard/noise.c
+++ b/drivers/net/wireguard/noise.c
@@ -7,14 +7,10 @@
 #include "device.h"
 #include "peer.h"
 #include "messages.h"
-#include "queueing.h"
 #include "peerlookup.h"
 
 #include <linux/rcupdate.h>
 #include <linux/slab.h>
-#include <linux/bitmap.h>
-#include <linux/scatterlist.h>
-#include <linux/highmem.h>
 #include <crypto/algapi.h>
 
 /* This implements Noise_IKpsk2:
diff --git a/drivers/net/wireguard/noise.h b/drivers/net/wireguard/noise.h
index c527253dba80..75b8f0d50084 100644
--- a/drivers/net/wireguard/noise.h
+++ b/drivers/net/wireguard/noise.h
@@ -12,7 +12,6 @@
 #include <linux/spinlock.h>
 #include <linux/atomic.h>
 #include <linux/rwsem.h>
-#include <linux/mutex.h>
 #include <linux/kref.h>
 
 struct noise_replay_counter {
diff --git a/drivers/net/wireguard/peer.h b/drivers/net/wireguard/peer.h
index 76e4d3128ad4..05af76b62583 100644
--- a/drivers/net/wireguard/peer.h
+++ b/drivers/net/wireguard/peer.h
@@ -11,7 +11,6 @@
 #include "cookie.h"
 
 #include <linux/types.h>
-#include <linux/netfilter.h>
 #include <linux/spinlock.h>
 #include <linux/kref.h>
 #include <net/dst_cache.h>
diff --git a/drivers/net/wireguard/queueing.h b/drivers/net/wireguard/queueing.h
index e2388107f7fd..bd54373b4485 100644
--- a/drivers/net/wireguard/queueing.h
+++ b/drivers/net/wireguard/queueing.h
@@ -9,8 +9,6 @@
 #include "peer.h"
 #include <linux/types.h>
 #include <linux/skbuff.h>
-#include <linux/ip.h>
-#include <linux/ipv6.h>
 #include <net/ip_tunnels.h>
 
 struct wg_device;
diff --git a/drivers/net/wireguard/send.c b/drivers/net/wireguard/send.c
index 5368f7c35b4b..f5b25f6fc55b 100644
--- a/drivers/net/wireguard/send.c
+++ b/drivers/net/wireguard/send.c
@@ -11,12 +11,7 @@
 #include "messages.h"
 #include "cookie.h"
 
-#include <linux/uio.h>
-#include <linux/inetdevice.h>
-#include <linux/socket.h>
 #include <net/ip_tunnels.h>
-#include <net/udp.h>
-#include <net/sock.h>
 
 static void wg_packet_send_handshake_initiation(struct wg_peer *peer)
 {
diff --git a/drivers/net/wireguard/socket.c b/drivers/net/wireguard/socket.c
index 6f07b949cb81..0d645613349a 100644
--- a/drivers/net/wireguard/socket.c
+++ b/drivers/net/wireguard/socket.c
@@ -9,9 +9,7 @@
 #include "queueing.h"
 #include "messages.h"
 
-#include <linux/ctype.h>
 #include <linux/net.h>
-#include <linux/if_vlan.h>
 #include <linux/if_ether.h>
 #include <linux/inetdevice.h>
 #include <net/udp_tunnel.h>
diff --git a/drivers/net/wireguard/socket.h b/drivers/net/wireguard/socket.h
index bab5848efbcd..d69c84f12e66 100644
--- a/drivers/net/wireguard/socket.h
+++ b/drivers/net/wireguard/socket.h
@@ -6,11 +6,6 @@
 #ifndef _WG_SOCKET_H
 #define _WG_SOCKET_H
 
-#include <linux/netdevice.h>
-#include <linux/udp.h>
-#include <linux/if_vlan.h>
-#include <linux/if_ether.h>
-
 int wg_socket_init(struct wg_device *wg, u16 port);
 void wg_socket_reinit(struct wg_device *wg, struct sock *new4,
 		      struct sock *new6);
-- 
2.31.1

