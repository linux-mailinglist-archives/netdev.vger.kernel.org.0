Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28D2348120E
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 12:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239938AbhL2Lgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 06:36:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbhL2Lgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 06:36:44 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C5FBC061574;
        Wed, 29 Dec 2021 03:36:44 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id s1so43946591wrg.1;
        Wed, 29 Dec 2021 03:36:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=tgQgC9zrZkk0bpKvRYeyEIEkgTdWGOn530GFH+U60f4=;
        b=DBmBTXZ9N7R5xny3Xhbf/9VzqHyG1qHwZ0ogN9hlUkm1UokqlhrVmBK+JPhakpZCb3
         BvIiABAD3k4iy3SzAWPiaSMgl0TTAVart+Lw6batF5j8pVoM3+2haKZQWPFBnl12hZZ3
         npXqywiP7YqZUQY0VaFQwuyjcCiweC1dbCbXLR/FYYPhqbaQApkoV82JscrYvhlrDXTb
         AfmlByrKgZKz3iwr2MsB9CWGWwEd+XD3F8AbqdzgG6+7Vi81D/J8wXgHmeozgc2zdGLc
         zfhk1rrXdpBB8hNXTkiJnDVKnybV664GNlZFIv1mZ7TwRCgrO3aSQ6/lw8f6MQJC+lm3
         VLGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=tgQgC9zrZkk0bpKvRYeyEIEkgTdWGOn530GFH+U60f4=;
        b=1wsHeuBikP+yBUS7NNlv8RO08yutITYsSYLa7P1fdk4xU2T+tdLXa9i7YMFh1QLrxT
         Z+1o2Rtg8sEobmmXzm8dX0M4dXouIqo60sFWY4RDkaGY3cIvfiPM5aDOjH8DIpQlq+Ko
         6SmCZ/aCuKncqE8Fy6qhOPbsx8Iw/mz51xEdV2fBeWqwBSAcUk8t8m6Sq9k8F96G6yC4
         c4vPRuENlEuzPkjFbhtvq4DjZ1jWEGE0T+TKP5IlHcL3irAdzAOLsp1hH/nxLx9niK79
         D+k44zJvkRQmJYscLCcL4DBGCfBrdVkpDVSR1Vf4GahgK9WGqqFhp34KU9V8Xo8Jm68o
         Ph4A==
X-Gm-Message-State: AOAM530dav8L+VYL1Uzp/VdZR1Pj47xF31IxWJjOvYa1DB/nDEXlCbdc
        5GyET6fuLPHou1qIfSnf8K8=
X-Google-Smtp-Source: ABdhPJybI31hTpHogstiIh8mdLYNbz2WBu/xtq0+PebXM4nHl9LL9hYaX48mV2sAi1BHcfo4CXFnAg==
X-Received: by 2002:a5d:6349:: with SMTP id b9mr19711615wrw.152.1640777802918;
        Wed, 29 Dec 2021 03:36:42 -0800 (PST)
Received: from felia.fritz.box ([2001:16b8:2626:5600:5f5:a4cc:1dcf:a62])
        by smtp.gmail.com with ESMTPSA id d62sm23871555wmd.3.2021.12.29.03.36.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 03:36:42 -0800 (PST)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] net: remove references to CONFIG_IRDA in network header files
Date:   Wed, 29 Dec 2021 12:36:20 +0100
Message-Id: <20211229113620.19368-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit d64c2a76123f ("staging: irda: remove the irda network stack and
drivers") removes the config IRDA.

Remove the remaining references to this non-existing config in the network
header files.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
 include/linux/atalk.h     | 2 +-
 include/linux/netdevice.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/atalk.h b/include/linux/atalk.h
index f6034ba774be..a55bfc6567d0 100644
--- a/include/linux/atalk.h
+++ b/include/linux/atalk.h
@@ -113,7 +113,7 @@ extern int aarp_proto_init(void);
 /* Inter module exports */
 
 /* Give a device find its atif control structure */
-#if IS_ENABLED(CONFIG_IRDA) || IS_ENABLED(CONFIG_ATALK)
+#if IS_ENABLED(CONFIG_ATALK)
 static inline struct atalk_iface *atalk_find_dev(struct net_device *dev)
 {
 	return dev->atalk_ptr;
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 2684bdb6defa..6f99c8f51b60 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2098,7 +2098,7 @@ struct net_device {
 #if IS_ENABLED(CONFIG_TIPC)
 	struct tipc_bearer __rcu *tipc_ptr;
 #endif
-#if IS_ENABLED(CONFIG_IRDA) || IS_ENABLED(CONFIG_ATALK)
+#if IS_ENABLED(CONFIG_ATALK)
 	void 			*atalk_ptr;
 #endif
 	struct in_device __rcu	*ip_ptr;
-- 
2.17.1

