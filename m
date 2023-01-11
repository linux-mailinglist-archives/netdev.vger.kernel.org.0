Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C14866631E
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 19:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239152AbjAKSxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 13:53:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238632AbjAKSwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 13:52:41 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66E3636313
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 10:52:39 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id g23so2147833plq.12
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 10:52:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MhXuqhaiQikdfV+g3gVkxxNyLpmfrWJY6QCud8NyIjw=;
        b=oSrhfWpP2Fz6U7Y65u44rNjGgWm0W4UPqgGBPfaXsfCYtWhngP8+zbjSiHLXv4ObtW
         Hdz/kQDPWXDejmaN3yHC/tcEVZqwE9tC3vkerBePwNG2Bf2jZh6r3x+5r6b2v1oKdjmn
         1bwkH6ac9kjZ29/FxsBqx4Wyxetpi75WXTh8+1oIpkHkBVOlpIpcT9KU9WZKnAh6MQpu
         LYn1qaidkw8C/Hb2ksO4o/hFgBq8DP/S3gvRjtM7xzP4RH1QUzNa15TTI1Yn7YUY4CuN
         5cyco1AVzLs2o7EsxZeI53dMN4WqNZ9LZUzB9C+Pu8/Ul+OZGv67d5GSOuK5hllt8OSM
         rmng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MhXuqhaiQikdfV+g3gVkxxNyLpmfrWJY6QCud8NyIjw=;
        b=Sx/hoXEl+WfDnLGLloqRwquL8Colbc2fAqy85B+WdboCSzDgzBm45R+yltcGs8Knx/
         dLyZcbKf+nBDPHuvw1KbA5k7OXvnhaVJWNQKOKnS3alN30PyUgAIqXT+zW4872MZraZL
         3QZGUrl9xBaVAY4kqIyxu9e7UmKJ1d3lnJBv1ZvHtFvc2Tkcx91eU4cFxXkcQPnpKnwZ
         gRJNBIA06dj/rbOdjue2vUGhpABiWeJaBRxirPmiX/KPN/m0t0sFg8IOvbj5uLEc21Be
         ZhkrCh9Bo1GRKFxigvlsBjSMuGxyBLqD9rgSJUYzJqgASOnW5pj43c9/hSgLziZNMoCI
         2ESg==
X-Gm-Message-State: AFqh2koy2OlplvkjOOMW9A8uvuue5sZzsxirR5ojL+2c502d5vHVht44
        uJ4Ge8vUL7IeRkPfjigr5X9GXtyAAkpyd0HfIrg=
X-Google-Smtp-Source: AMrXdXvjWMmZrzSG1rxfPuIyHN3a05PKY3C+Ni1fK8y3wQSk/VVlYCBh08M9wHQgc3Bbq09qn+UpvA==
X-Received: by 2002:a05:6a20:b213:b0:a7:8b3e:1207 with SMTP id eh19-20020a056a20b21300b000a78b3e1207mr3690737pzb.13.1673463158459;
        Wed, 11 Jan 2023 10:52:38 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id d7-20020a631d47000000b004a849d3d9c2sm8650447pgm.22.2023.01.11.10.52.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 10:52:38 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2 iproute2 10/11] misc: use SPDX
Date:   Wed, 11 Jan 2023 10:52:26 -0800
Message-Id: <20230111185227.69093-11-stephen@networkplumber.org>
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

Use SPDX tag instead of GPL boilerplate.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 misc/arpd.c           | 6 +-----
 misc/ifstat.c         | 6 +-----
 misc/lnstat.c         | 7 +------
 misc/lnstat_util.c    | 7 +------
 misc/nstat.c          | 6 +-----
 misc/rtacct.c         | 7 +------
 misc/ss.c             | 6 +-----
 misc/ss_util.h        | 1 +
 misc/ssfilter.h       | 1 +
 misc/ssfilter.y       | 1 +
 misc/ssfilter_check.c | 1 +
 11 files changed, 11 insertions(+), 38 deletions(-)

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
 
diff --git a/misc/ss_util.h b/misc/ss_util.h
index f7e40bb9b93c..37936c6623ea 100644
--- a/misc/ss_util.h
+++ b/misc/ss_util.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 #ifndef __SS_UTIL_H__
 #define __SS_UTIL_H__
 
diff --git a/misc/ssfilter.h b/misc/ssfilter.h
index 0be3b1e03b9f..73e55e042b6b 100644
--- a/misc/ssfilter.h
+++ b/misc/ssfilter.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 #include <stdbool.h>
 
 enum {
diff --git a/misc/ssfilter.y b/misc/ssfilter.y
index 8e16b44638f6..3195723b2277 100644
--- a/misc/ssfilter.y
+++ b/misc/ssfilter.y
@@ -1,4 +1,5 @@
 %{
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 
 #include <stdio.h>
 #include <stdlib.h>
diff --git a/misc/ssfilter_check.c b/misc/ssfilter_check.c
index 38c960c1bc91..a188bb346999 100644
--- a/misc/ssfilter_check.c
+++ b/misc/ssfilter_check.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 #include <stdio.h>
 #include <stdlib.h>
 #include <errno.h>
-- 
2.39.0

