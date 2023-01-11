Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E075366523C
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 04:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbjAKDRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 22:17:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231949AbjAKDRZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 22:17:25 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE704C769
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 19:17:24 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id q64so14481697pjq.4
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 19:17:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7UlqYIkF/JSunUkxXsfD/cmMI2Wy1EfGm66d0ZtC2LU=;
        b=cELB6wbawM2u2bmHxiEKyoShQYX6dKVzSzyqNCYv83hWLEO7UBDZTzvfUW7Ois8bNM
         qnKSrRZK0x/BzwoHh6xrTp4XLshIltAe6vO8PhC1kdXltegXeQkt2oZlYzVrXoRsfEYK
         HmeM7communeMQTeRnV+pAOukHi8GSQAsgSIoUsEJxuibGkzsB6DK70/ykVWd57VL6bm
         7W85w6+tGVvLPVuHCXJwydAH1RPsvU1XEI9LNOg+0v16gfr/hEKEqn1mkn2MuDR2tXYn
         ftUKdwoe4CrNp6/wKsqhSpW8XYbagN6BPPtkQkXgUX6tdfYD5YzD9Mlpc1eL3szFpvBr
         /t3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7UlqYIkF/JSunUkxXsfD/cmMI2Wy1EfGm66d0ZtC2LU=;
        b=ni+2G2shJ/XaUwTODACgjf66Ssblvr9NSNtF/SETAnWgslEqN6x0znstjKAmBU2k8M
         vFFAIa4PwQFlxDa13nzo8o8pSd/5Q99rkVQpkmo8axIHsn9Csdr0LGuhQEGseqZrzQ6Y
         E9aFAX9wULfuZlivKZhxFz4NZjYJkOgjDsdg8bxVBszZSj9O2tfL1AhO8CcVZb+DgAfl
         8xrx2mnL3YAtlWZBKvQj1bfwKjwcN/etoLsiAzRj9QxdutSuq+xqUVZrbW3m09AwRrpr
         TjHM7lEfldKjoADOVIYa4sZeF3D6tvjAON5z4WMH29nH7jklQb+8sApfKb+0F1iOPLPQ
         hTYg==
X-Gm-Message-State: AFqh2ko6USI0SAJ8zNSShPNwy9I8NNw9KWWFFQ+J5uiYgpXk44ATyF6W
        v3mLz6JZkqpNj0X1rkjJ5vLOcB9K2LZqxUKarYw=
X-Google-Smtp-Source: AMrXdXtIhUQSiOCm8y8jCqwBGmhqVGRmkRoSa4Rxvpcw2U67h+NldIRkcoDnecsoU7qqy9z+MYFmuA==
X-Received: by 2002:a17:902:a5ca:b0:191:3aad:cf33 with SMTP id t10-20020a170902a5ca00b001913aadcf33mr66592242plq.55.1673407044326;
        Tue, 10 Jan 2023 19:17:24 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id h5-20020a170902f7c500b0019337bf957dsm4226756plw.296.2023.01.10.19.17.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 19:17:24 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 10/10] misc: use SPDX
Date:   Tue, 10 Jan 2023 19:17:12 -0800
Message-Id: <20230111031712.19037-11-stephen@networkplumber.org>
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

Use SPDX tag instead of GPL boilerplate.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 misc/arpd.c        | 6 +-----
 misc/ifstat.c      | 6 +-----
 misc/lnstat.c      | 7 +------
 misc/lnstat_util.c | 7 +------
 misc/nstat.c       | 6 +-----
 misc/rtacct.c      | 7 +------
 misc/ss.c          | 6 +-----
 7 files changed, 7 insertions(+), 38 deletions(-)

diff --git a/misc/arpd.c b/misc/arpd.c
index 504961cb5e3a..1ef837c61581 100644
--- a/misc/arpd.c
+++ b/misc/arpd.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * arpd.c	ARP helper daemon.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Alexey Kuznetsov, <kuznet@ms2.inr.ac.ru>
  */
 
diff --git a/misc/ifstat.c b/misc/ifstat.c
index 291f288b3752..4ce5ca8af4e7 100644
--- a/misc/ifstat.c
+++ b/misc/ifstat.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * ifstat.c	handy utility to read net interface statistics
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Alexey Kuznetsov, <kuznet@ms2.inr.ac.ru>
  */
 
diff --git a/misc/lnstat.c b/misc/lnstat.c
index c3293a8eb12f..c3f2999cc255 100644
--- a/misc/lnstat.c
+++ b/misc/lnstat.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /* lnstat - Unified linux network statistics
  *
  * Copyright (C) 2004 by Harald Welte <laforge@gnumonks.org>
@@ -8,12 +9,6 @@
  *
  * Copyright 2001 by Robert Olsson <robert.olsson@its.uu.se>
  *                                 Uppsala University, Sweden
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  */
 
 /* Maximum number of fields that can be displayed */
diff --git a/misc/lnstat_util.c b/misc/lnstat_util.c
index c2dc42ec1ff1..3f53e91afbf8 100644
--- a/misc/lnstat_util.c
+++ b/misc/lnstat_util.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /* lnstat.c:  Unified linux network statistics
  *
  * Copyright (C) 2004 by Harald Welte <laforge@gnumonks.org>
@@ -8,12 +9,6 @@
  *
  * Copyright 2001 by Robert Olsson <robert.olsson@its.uu.se>
  *                                 Uppsala University, Sweden
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  */
 
 #include <unistd.h>
diff --git a/misc/nstat.c b/misc/nstat.c
index 7160c59be222..0ab92ecbeb47 100644
--- a/misc/nstat.c
+++ b/misc/nstat.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * nstat.c	handy utility to read counters /proc/net/netstat and snmp
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Alexey Kuznetsov, <kuznet@ms2.inr.ac.ru>
  */
 
diff --git a/misc/rtacct.c b/misc/rtacct.c
index 47b27e3fd88d..08363bfd4f26 100644
--- a/misc/rtacct.c
+++ b/misc/rtacct.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * rtacct.c		Applet to display contents of /proc/net/rt_acct.
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
diff --git a/misc/ss.c b/misc/ss.c
index ccfa9fa9ef8e..de02fccb539b 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * ss.c		"sockstat", socket statistics
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Alexey Kuznetsov, <kuznet@ms2.inr.ac.ru>
  */
 
-- 
2.39.0

