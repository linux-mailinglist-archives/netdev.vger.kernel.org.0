Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3C4C19E666
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 18:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgDDQQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Apr 2020 12:16:33 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:32958 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbgDDQQc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Apr 2020 12:16:32 -0400
Received: by mail-wr1-f66.google.com with SMTP id a25so12318055wrd.0
        for <netdev@vger.kernel.org>; Sat, 04 Apr 2020 09:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3VrjyJKD1MwSBSjhS+ldzxOgSxhXAQyvzYBb9WsZYEE=;
        b=Bky8w0B3UkZZ/wDfOXxL+g7jIC2SifGFdFy0nie3ANfVwoQD/iuq8Nc17NrAIQhNAq
         bQ3Uzlo0k1KOg693A7VMCqQRejdc8UIfkWyuP0Aork0Ggl5/toinO3w/U+9Xcrq2mMsc
         R54TbkLAhQ2UbDP3/TWaDsL3XKp1GtFOOMptsq5I/hNQGfWiWW7mtJaNPBhxWoR/ETvS
         e9tt3tO5ZsHWaQqJV/RCROricQvvtcsrRAj64ih+dz2KPykPFN7QveM+GkPEvEOvT4ZI
         yAimGLh60kIVcE3FeMB2p5D3y6YI2ysRXuizibx28DCIO+0Agp/lelmMSU171MhXEOnx
         bsKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3VrjyJKD1MwSBSjhS+ldzxOgSxhXAQyvzYBb9WsZYEE=;
        b=sGV/nsDhBdiSY701h6DQFRkj9gqSnOH4Q2q48d+0xfjKzM1n0ce7+ZDgdfd8i6hb3Q
         L+Es+vCgWZstTaY71i9FicNIP5v390CNMNoIaBVIfrvExeBpN78CmtyFKr5aqzwpH7VZ
         V4w9K+BUr/kY4Nd9xuMIft2tqhVCeeqBBw0g//WUCdSygCiPHXQTh+ihjn5T1DxrrtqR
         hFH8wP4chKpmamd4zzrsNqFucR8aHTdxVNcxmi5Q4hRNNeFw3RBegmu5W1QMkXbYkNYF
         lOpeXK7BMfwYW1dLMDEeWyYMVpSlfp5yLXoh0GmPYzBUpPe9tdcuDN7XmfAZ330zMHOs
         qggQ==
X-Gm-Message-State: AGi0PuYwSgCLJGD+Yd6DDYiTtAfEmU4IgTNOSA+zrCM+RZlXp+ueQwlG
        O7SywNSbc7zMvGVsaHBU7R9MmBU7a0Q=
X-Google-Smtp-Source: APiQypLui6G6NAyOb7cwJXnqAfMQeWS9AVY5rhOJr1rYqA1rVbBphgPqkCseMhMvUc11qR1HwqHMiw==
X-Received: by 2002:a05:6000:187:: with SMTP id p7mr2623328wrx.196.1586016988921;
        Sat, 04 Apr 2020 09:16:28 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id v21sm15687129wmj.8.2020.04.04.09.16.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Apr 2020 09:16:28 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, mlxsw@mellanox.com
Subject: [patch iproute2/net-next 5/8] devlink: rename dpipe_counters_enable struct field to dpipe_counters_enabled
Date:   Sat,  4 Apr 2020 18:16:18 +0200
Message-Id: <20200404161621.3452-6-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200404161621.3452-1-jiri@resnulli.us>
References: <20200404161621.3452-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

To be consistent with the rest of the code and name of netlink
attribute, rename the dpipe_counters_enable struct fielt
to dpipe_counters_enabled.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 devlink/devlink.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index d40991d52cf6..575737fff985 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -307,7 +307,7 @@ struct dl_opts {
 	enum devlink_eswitch_mode eswitch_mode;
 	enum devlink_eswitch_inline_mode eswitch_inline_mode;
 	const char *dpipe_table_name;
-	bool dpipe_counters_enable;
+	bool dpipe_counters_enabled;
 	enum devlink_eswitch_encap_mode eswitch_encap_mode;
 	const char *resource_path;
 	uint64_t resource_size;
@@ -1349,7 +1349,7 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 			    dl_argv_match(dl, "counters_enabled")) &&
 			   (o_all & DL_OPT_DPIPE_TABLE_COUNTERS)) {
 			dl_arg_inc(dl);
-			err = dl_argv_bool(dl, &opts->dpipe_counters_enable);
+			err = dl_argv_bool(dl, &opts->dpipe_counters_enabled);
 			if (err)
 				return err;
 			o_found |= DL_OPT_DPIPE_TABLE_COUNTERS;
@@ -1579,7 +1579,7 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
 				  opts->dpipe_table_name);
 	if (opts->present & DL_OPT_DPIPE_TABLE_COUNTERS)
 		mnl_attr_put_u8(nlh, DEVLINK_ATTR_DPIPE_TABLE_COUNTERS_ENABLED,
-				opts->dpipe_counters_enable);
+				opts->dpipe_counters_enabled);
 	if (opts->present & DL_OPT_ESWITCH_ENCAP_MODE)
 		mnl_attr_put_u8(nlh, DEVLINK_ATTR_ESWITCH_ENCAP_MODE,
 				opts->eswitch_encap_mode);
-- 
2.21.1

