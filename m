Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5ECD665236
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 04:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbjAKDRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 22:17:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbjAKDRT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 22:17:19 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66A9F13CF1
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 19:17:18 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id q64so14481450pjq.4
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 19:17:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nv5Y0fFGPIBbIGfToOvyD5tX7UMRV0cUkXHicHhuZRg=;
        b=7rY5kiIIwGZCQUTHdAC7NSJClBm1cu+Yv9+pzY05Pdgp9/MNr29tvJwoq9p7Hm2xHe
         tsK7fJla6RflT/O7SDPAfRxTyaaVVEWu/KcArcs7794bmvRPFtipjutc3R9f8RMhwZBS
         mzYlGir9dBKvmbz8tXsUXw8ae89zzN/AUMNMfzaZB2x71u7fYUWpH5WMcwBCH5daN0qa
         IbzAjnLl30NA8Mk5AqXBoM0bt0MZ9G+nEqKc64FaNtseUCGGa/VGpFkAcPty2D9fMmbA
         vjAVmgaBATdcFsFVl1fTQ7JzdEsfq3ZFEJ2iw47kkTtwYL5q4Q80Yg4NVHDENioWlk8e
         P1+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nv5Y0fFGPIBbIGfToOvyD5tX7UMRV0cUkXHicHhuZRg=;
        b=cVTTixJ7NN3E/QypGEHJ5tMa+fadQcE2mQS+iHMbyVKixgse/u/tz5WrMN6oo3Lgo3
         4wTMa26nofh5dJor+EK03cAcb3faJp/tRqADVCo9/22fMryRZg4iiWxHyzOOL3FWu7NH
         cuJzNpKVwBvzogCHH791aMVfT8/TahA3fwQOvSFfkmfV3U0W5zrOFA3Ua0+V+neMNnqs
         +MFKKUG5DX5eccafmsvvomfDXqtEbouSlHwMhVsUsP8/PYnMou4WHuTyMSUKWJ+7knuZ
         Hhf2AAEtY2QVzzsA8WhnDsNrazXtNDwjmNlEQzefTEY/P2fX04OeedGTkqQAzgJ3nC2C
         6M1g==
X-Gm-Message-State: AFqh2koEKQxgUWq/FA/nP19G5/hqB7r2SwDBiBrX0TNxSN+AvQAO6ivL
        4TsnCs5agi5D2k5DZsGMQ40wEHFiqwriKI2yGXU=
X-Google-Smtp-Source: AMrXdXvgPdxvaTEUMOVqGck4O//mTvIHInGbWg96besDZNsOHFBfESU+NUzgQHpKA6SGlI+uhwjT3w==
X-Received: by 2002:a17:903:260d:b0:192:9090:fe9 with SMTP id jd13-20020a170903260d00b0019290900fe9mr50246460plb.49.1673407037423;
        Tue, 10 Jan 2023 19:17:17 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id h5-20020a170902f7c500b0019337bf957dsm4226756plw.296.2023.01.10.19.17.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 19:17:16 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 03/10] lib: replace GPL boilerplate with SPDX
Date:   Tue, 10 Jan 2023 19:17:05 -0800
Message-Id: <20230111031712.19037-4-stephen@networkplumber.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230111031712.19037-1-stephen@networkplumber.org>
References: <20230111031712.19037-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace standard GPL 2.0 or later text with SPDX tag.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 lib/bpf_legacy.c | 6 +-----
 lib/cg_map.c     | 6 +-----
 lib/fs.c         | 7 +------
 lib/inet_proto.c | 7 +------
 lib/json_print.c | 8 ++------
 lib/libnetlink.c | 7 +------
 lib/ll_addr.c    | 6 +-----
 lib/ll_map.c     | 7 +------
 lib/ll_proto.c   | 5 +----
 lib/ll_types.c   | 6 +-----
 lib/names.c      | 7 +------
 lib/namespace.c  | 6 +-----
 lib/rt_names.c   | 6 +-----
 lib/utils.c      | 7 +------
 14 files changed, 15 insertions(+), 76 deletions(-)

diff --git a/lib/bpf_legacy.c b/lib/bpf_legacy.c
index 4fabdcc899e4..8ac642358969 100644
--- a/lib/bpf_legacy.c
+++ b/lib/bpf_legacy.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * bpf.c	BPF common code
  *
- *		This program is free software; you can distribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Daniel Borkmann <daniel@iogearbox.net>
  *		Jiri Pirko <jiri@resnulli.us>
  *		Alexei Starovoitov <ast@kernel.org>
diff --git a/lib/cg_map.c b/lib/cg_map.c
index 39f244dbc5bd..e5d14d512c39 100644
--- a/lib/cg_map.c
+++ b/lib/cg_map.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * cg_map.c	cgroup v2 cache
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Dmitry Yakunin <zeil@yandex-team.ru>
  */
 
diff --git a/lib/fs.c b/lib/fs.c
index 3752931cf8f8..22d4af7583dd 100644
--- a/lib/fs.c
+++ b/lib/fs.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * fs.c         filesystem APIs
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	David Ahern <dsa@cumulusnetworks.com>
- *
  */
 
 #include <sys/types.h>
diff --git a/lib/inet_proto.c b/lib/inet_proto.c
index 41e2e8b88d82..71cd3b128841 100644
--- a/lib/inet_proto.c
+++ b/lib/inet_proto.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * inet_proto.c
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Alexey Kuznetsov, <kuznet@ms2.inr.ac.ru>
- *
  */
 
 #include <stdio.h>
diff --git a/lib/json_print.c b/lib/json_print.c
index 741acdcff990..d7ee76b10de8 100644
--- a/lib/json_print.c
+++ b/lib/json_print.c
@@ -1,10 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
- * json_print.c		"print regular or json output, based on json_writer".
- *
- *             This program is free software; you can redistribute it and/or
- *             modify it under the terms of the GNU General Public License
- *             as published by the Free Software Foundation; either version
- *             2 of the License, or (at your option) any later version.
+ * json_print.c	 - print regular or json output, based on json_writer
  *
  * Authors:    Julien Fortin, <julien@cumulusnetworks.com>
  */
diff --git a/lib/libnetlink.c b/lib/libnetlink.c
index 001efc1d7f24..c89760436aba 100644
--- a/lib/libnetlink.c
+++ b/lib/libnetlink.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * libnetlink.c	RTnetlink service routines.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Alexey Kuznetsov, <kuznet@ms2.inr.ac.ru>
- *
  */
 
 #include <stdio.h>
diff --git a/lib/ll_addr.c b/lib/ll_addr.c
index d6fd736b1e3a..5e9245915ef3 100644
--- a/lib/ll_addr.c
+++ b/lib/ll_addr.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * ll_addr.c
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Alexey Kuznetsov, <kuznet@ms2.inr.ac.ru>
  */
 
diff --git a/lib/ll_map.c b/lib/ll_map.c
index 70ea3d499c8f..8970c20f3cdd 100644
--- a/lib/ll_map.c
+++ b/lib/ll_map.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * ll_map.c
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Alexey Kuznetsov, <kuznet@ms2.inr.ac.ru>
- *
  */
 
 #include <stdio.h>
diff --git a/lib/ll_proto.c b/lib/ll_proto.c
index 925e2caa05e5..526e582fbbba 100644
--- a/lib/ll_proto.c
+++ b/lib/ll_proto.c
@@ -1,10 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * ll_proto.c
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
  *
  * Authors:	Alexey Kuznetsov, <kuznet@ms2.inr.ac.ru>
  */
diff --git a/lib/ll_types.c b/lib/ll_types.c
index 49da15df911d..fa57ceb5c3b8 100644
--- a/lib/ll_types.c
+++ b/lib/ll_types.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * ll_types.c
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Alexey Kuznetsov, <kuznet@ms2.inr.ac.ru>
  */
 
diff --git a/lib/names.c b/lib/names.c
index b46ea7910946..cbfa971ff61b 100644
--- a/lib/names.c
+++ b/lib/names.c
@@ -1,11 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * names.c		db names
- *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  */
 
 #include <stdio.h>
diff --git a/lib/namespace.c b/lib/namespace.c
index 45a7deddb6c4..1202fa85f97d 100644
--- a/lib/namespace.c
+++ b/lib/namespace.c
@@ -1,10 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * namespace.c
- *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
  */
 
 #include <sys/statvfs.h>
diff --git a/lib/rt_names.c b/lib/rt_names.c
index b976471d7979..2432224acc0a 100644
--- a/lib/rt_names.c
+++ b/lib/rt_names.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * rt_names.c		rtnetlink names DB.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Alexey Kuznetsov, <kuznet@ms2.inr.ac.ru>
  */
 
diff --git a/lib/utils.c b/lib/utils.c
index dd3cdb31239c..b740531ab6c9 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * utils.c
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Alexey Kuznetsov, <kuznet@ms2.inr.ac.ru>
- *
  */
 
 #include <stdio.h>
-- 
2.39.0

