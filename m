Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE587666315
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 19:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238775AbjAKSwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 13:52:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238467AbjAKSwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 13:52:34 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B8E395F6
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 10:52:33 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso21081206pjt.0
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 10:52:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nv5Y0fFGPIBbIGfToOvyD5tX7UMRV0cUkXHicHhuZRg=;
        b=vNQfM907zcZQ0sRqidNp5ipAG6UlDdXTKtGcNhPbQlEWo87BT6rfNlPcj+N8xodqr7
         mo8p47+/9bIBzu8MQscREiYqXsqjo9aC2GexVKXrca171X2BDREvij4m2L5f/JGrCZf7
         j4CHUYroInRVy6LLvkUI3JU1occUgQssDnN5BsyOibBkHuxQr0c7D3SKubK84g0yJRbc
         wEJjqDQ71O1hCzu+UtdPeG4WQgHWIQsWHQF7HAuY5Sgbx0OaUYIRe0QnhRA/w7UPAb35
         n8tTxxuotUI9UqlY4uH7ugnk9BV5iUrDDUvj8drERJ2m7Pl2RlRaOJ7hktnH+Xw7qkFe
         G98Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nv5Y0fFGPIBbIGfToOvyD5tX7UMRV0cUkXHicHhuZRg=;
        b=pj/vXN6b/3bvtrkmy+GWyQtfJ0ABomYefjLr4n9ni/PdtwP6AkThN4V+CByvDn5g1s
         PoBk8Mig0dLjNCcGfltJ30R2Lsmcw9/NojD1Ucof9ppxvnDQD1gMVYoUHEoXacPJZzY4
         VP4rvkZVlVaeBdT1DxolmXjdqpiMdCfx/8fO3aOsu3+li+E2SZrbxozecDru6a6MLoS/
         gkOF/r5GvCiKTiXtbogvL/VGcV/+p5/A/8Z5/At8K+W8mcKZNgIfsPMVx/v8PSKHpxey
         MaEJk9cjAAhjM7EUQF3pLQOjj5BnafErw87WZx4uwcCIb7Qn8/IvtvyWWuDLjB01V32Z
         emDA==
X-Gm-Message-State: AFqh2krQATew+P2yRd/7mSB9QwD7OjOsucUXUI1sDYhaWQKxDDO0VWdn
        d5zje59MWmUKS5AWeCrEklW6TKeniYjD6Pkrrmg=
X-Google-Smtp-Source: AMrXdXu1yA0BnpGSgenXIacfuUF3vIxrOv226cSQMIO+fWulqEhhfZIekwvtKJPHTFtYDKDUjvkvFw==
X-Received: by 2002:a17:90b:1291:b0:226:5486:fb15 with SMTP id fw17-20020a17090b129100b002265486fb15mr3420734pjb.15.1673463152139;
        Wed, 11 Jan 2023 10:52:32 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id d7-20020a631d47000000b004a849d3d9c2sm8650447pgm.22.2023.01.11.10.52.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 10:52:31 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2 iproute2 03/11] lib: replace GPL boilerplate with SPDX
Date:   Wed, 11 Jan 2023 10:52:19 -0800
Message-Id: <20230111185227.69093-4-stephen@networkplumber.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230111185227.69093-1-stephen@networkplumber.org>
References: <20230111185227.69093-1-stephen@networkplumber.org>
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

