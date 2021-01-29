Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07E343088B6
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 12:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232439AbhA2L64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 06:58:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232920AbhA2L5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 06:57:10 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B006CC033256
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 03:51:54 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id dj23so10185555edb.13
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 03:51:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZvmKhhGuNfQqKYS0ONCipHml5PaR0WqqxykEBH6rscI=;
        b=ip6LdHc/G3yEH9xz5h6f+xeDxBXZwmiONIChDNt1lGD19nYiDc5DCCLV7DxI555Xn+
         bUMtYieBQ6B1aLSk42ueetUHQenPlixh/wlXfBONAPcEVP6SrBbKhR+HTee0o+YZv+qP
         Y0IBsyKgJMFi6JOScWUujlkZtAwGvtCK3a4KsyGtTYuhOnUY+THayB0DQPMe9eVZy6RT
         y/zPae2K1TC+d7Y6z1jlPCe109/JGMabIq+EWdBi+OKdKgNukHTIouABMas6FY++1Zt/
         Z6KKFFEb52V8o3tsPp8ybiRzmCZallGfD066bIRU3xFog5Ts20bAfDDR/rpktm0comUI
         rfGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZvmKhhGuNfQqKYS0ONCipHml5PaR0WqqxykEBH6rscI=;
        b=BZdp8BqbDRbeMSiiK3D7h0t8zGiQQgBywP+d3rN3O7mzIOQ3GpG/oBQkhCB++5imYN
         U73A7tsA0QvzaFJfUQ21Gs88x5wbYCdDnr6zK5bf29OrS+V0cFP+bAtkWj7fZyZz2uhU
         hbVMj2P/BdZVwzZbqj5pX6WuCbcjbdKAU4JMgUzhCE0VzOzD7v0tZsi04w5AL2+A/nc5
         Mi0mGwO6dN4LGl4B42o2mdysTRa/VU7VTpRsOI6FJzIQQMEeL7qyLaCSmSNa2TDXkG9A
         MUqfUxl7YmmYU5F6/jPcXPiSf4T2hCazNYIl4vlfyDTUxWkdToFP7ERvgLaUFI6BkIqT
         8Omw==
X-Gm-Message-State: AOAM532Tr/OmFmP43R6mpB4k+ZNOQEhq4ZXLhCAjEcGUe88tDjlg96AN
        iuQlGH8Ejg5OO6d8GujIM5ghQBSL7BK6eNmjDxU=
X-Google-Smtp-Source: ABdhPJyvSKxl3ILg15YLnCwXHKL/JiYO/eXmx7WRqWlc2kDJuNUygPlLKWZbyjXNrVQiCRRJ0SdPHQ==
X-Received: by 2002:aa7:cdc7:: with SMTP id h7mr4674096edw.353.1611921113225;
        Fri, 29 Jan 2021 03:51:53 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id u23sm4450130edt.87.2021.01.29.03.51.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 03:51:52 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        kuba@kernel.org, davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 2/2] net: bridge: add warning comments to avoid extending sysfs
Date:   Fri, 29 Jan 2021 13:51:42 +0200
Message-Id: <20210129115142.188455-3-razor@blackwall.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210129115142.188455-1-razor@blackwall.org>
References: <20210129115142.188455-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

We're moving to netlink-only options, so add comments in the bridge's
sysfs files to warn against adding any new sysfs entries.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_sysfs_br.c | 4 ++++
 net/bridge/br_sysfs_if.c | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
index 7db06e3f642a..71f0f671c4ef 100644
--- a/net/bridge/br_sysfs_br.c
+++ b/net/bridge/br_sysfs_br.c
@@ -19,6 +19,10 @@
 
 #include "br_private.h"
 
+/* IMPORTANT: new bridge options must be added with netlink support only
+ *            please do not add new sysfs entries
+ */
+
 #define to_bridge(cd)	((struct net_bridge *)netdev_priv(to_net_dev(cd)))
 
 /*
diff --git a/net/bridge/br_sysfs_if.c b/net/bridge/br_sysfs_if.c
index 7a59cdddd3ce..96ff63cde1be 100644
--- a/net/bridge/br_sysfs_if.c
+++ b/net/bridge/br_sysfs_if.c
@@ -17,6 +17,10 @@
 
 #include "br_private.h"
 
+/* IMPORTANT: new bridge port options must be added with netlink support only
+ *            please do not add new sysfs entries
+ */
+
 struct brport_attribute {
 	struct attribute	attr;
 	ssize_t (*show)(struct net_bridge_port *, char *);
-- 
2.29.2

