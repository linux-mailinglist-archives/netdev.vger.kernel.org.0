Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 577904681E0
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 02:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233882AbhLDCBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 21:01:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231452AbhLDCBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 21:01:11 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1BC3C061751
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 17:57:45 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id z6so4555001pfe.7
        for <netdev@vger.kernel.org>; Fri, 03 Dec 2021 17:57:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QovkmamtP5hvoMBleKHHJ8UE1clZelwXpIRC2NV3VU8=;
        b=gsJcnoHm1qyWGycZJ4FOGky+I4RtQ0RGxVeyli8dLLKECFrHmzJ//naVJKBqXutQZZ
         PoxjrMJ6LJRaNbFRF8P/vHiq75P1IQ4PE9iI/gQQtVEanY5ZSeeMO/Pec5XV/+El7CAh
         l6KtqyHW9wXog7wBGTk7aDLeANpzcs95Pw56EwC7WpApVRk5NnZFArh3d8jxYoavA1I7
         9Xv6euz9F11wxGKzkaDlKe/s3G4Ab/D+X4E4z7nBQrjfatD7GSY4PrTjMXAtWmemmrD3
         XKlozJO0/oIeoJY4segGzEgM7nTWI0CjE2cdX1h5OUTWmJIZllxC808lktyDm7G2KXM8
         pZIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QovkmamtP5hvoMBleKHHJ8UE1clZelwXpIRC2NV3VU8=;
        b=Pme6Qje32KHYyRwO9+i1vB8C14ZJRfmVWJAMUGhBkpj2OMT9KxPIQsdCv6WVgsGf8p
         TyRFVihaiQEe73vdRYE06W0ntX52WCZxhUODums8CRPj09uqTYwKwEZAKao/F/IP8wh+
         xKYYxa6w2F1PZNaGix670kpTlL0ql4UuzyQOLLZG/45copBq/Y9aRvPbXeS5E6B6j5T8
         3h4TRHKNcS2jPslxPCpNIDhKTkbdBiZ/JNS6E3j3bI6leGRmMGwgsrZJtZuBL89SumqH
         3Fj1CjOFnJYLSpgslNF6Y+dajIt+n1152/xGwcr7IZmJZlL6oVi3J9pETfw+f9aXheaB
         XMSA==
X-Gm-Message-State: AOAM530AMp8pHMUO0s6Bbw1RQREG4HmY/Vcr0l962eMisZ+itVUsQ1ga
        pqLr7Qmgxhk/WYJOsKdi5G0=
X-Google-Smtp-Source: ABdhPJzVChR+KBFmWX0/bGmPddw223xzarRdwmoU5/x+eJgyGzend8XTZnClTX/+RpAd1uyq1/JGoQ==
X-Received: by 2002:a63:205:: with SMTP id 5mr7491364pgc.57.1638583065549;
        Fri, 03 Dec 2021 17:57:45 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:2440:7862:6d8b:2ea])
        by smtp.gmail.com with ESMTPSA id v38sm3430240pgl.38.2021.12.03.17.57.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 17:57:44 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] net: add missing htmldocs
Date:   Fri,  3 Dec 2021 17:57:41 -0800
Message-Id: <20211204015741.3358725-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

include/linux/netdevice.h:2278: warning: Function parameter or member 'refcnt_tracker' not described in 'net_device'
include/net/devlink.h:679: warning: Function parameter or member 'dev_tracker' not described in 'devlink_trap_metadata'
include/linux/netdevice.h:2283: warning: Function parameter or member 'refcnt_tracker' not described in 'net_device'
include/linux/mroute_base.h:40: warning: Function parameter or member 'dev_tracker' not described in 'vif_device'

Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---

This is the followup patch.

If you prefer I can insert it the next round of patches.

 include/linux/mroute_base.h | 1 +
 include/linux/netdevice.h   | 2 ++
 include/net/devlink.h       | 1 +
 3 files changed, 4 insertions(+)

diff --git a/include/linux/mroute_base.h b/include/linux/mroute_base.h
index 91ab497bd3e579b9d78f423d8c28310cf6b07f58..e05ee9f001ffbf30f7b26ab5555e2db5cc058560 100644
--- a/include/linux/mroute_base.h
+++ b/include/linux/mroute_base.h
@@ -12,6 +12,7 @@
 /**
  * struct vif_device - interface representor for multicast routing
  * @dev: network device being used
+ * @dev_tracker: refcount tracker for @dev reference
  * @bytes_in: statistic; bytes ingressing
  * @bytes_out: statistic; bytes egresing
  * @pkt_in: statistic; packets ingressing
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 990fb906b524860451b32df6b4bf625780b6d9d7..a0ad38ebf8f6c5e98a1a349892553adb13f2dc9f 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1877,6 +1877,7 @@ enum netdev_ml_priv_type {
  *	@pcpu_refcnt:		Number of references to this device
  *	@dev_refcnt:		Number of references to this device
  *	@todo_list:		Delayed register/unregister
+ *	@refcnt_tracker:	Tracker directory for tracked references to this device
  *	@link_watch_list:	XXX: need comments on this one
  *
  *	@reg_state:		Register/unregister state machine
@@ -1949,6 +1950,7 @@ enum netdev_ml_priv_type {
  *			keep a list of interfaces to be deleted.
  *
  *	@dev_addr_shadow:	Copy of @dev_addr to catch direct writes.
+ *	@linkwatch_dev_tracker: refcount tracker used by linkwatch.
  *
  *	FIXME: cleanup struct net_device such that network protocol info
  *	moves out.
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 09b75fdfa74e268aaeb05ec640fd76ec5ba777ac..00ee43186983679cb835847ce358f04b08b90a48 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -664,6 +664,7 @@ struct devlink_health_reporter_ops {
  * @trap_name: Trap name.
  * @trap_group_name: Trap group name.
  * @input_dev: Input netdevice.
+ * @dev_tracker: refcount tracker for @input_dev
  * @fa_cookie: Flow action user cookie.
  * @trap_type: Trap type.
  */
-- 
2.34.1.400.ga245620fadb-goog

