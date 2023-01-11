Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0FF1665238
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 04:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232484AbjAKDR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 22:17:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231681AbjAKDRU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 22:17:20 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6AAC769
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 19:17:18 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id p24so15348206plw.11
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 19:17:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b1JoU83uEA8dwyXtle6P1+fwEOOsB8BpyzqJ+2+pwgo=;
        b=LvqwafOfaCFS3vxlD521270WEzfGUvwCZNll8WtrCeOCT8xYpK5WxSryNbsh6PWH4/
         ZIaqpdZTUv+C6I4bCYnN4u1l5C7d4cQdPhrNQoViCSo5Nod3vTJyH2ZpewIJE0eywzXy
         mnODvStd+4VntN5TV6afwSjJDufXwN7wXUCJpZJ9YplcyX9Zu4+Byly+cDs9dfH6oa6a
         REoIMfg8crsZOux3mv9lKOfkkIX+rgpOSABkGLR7ydSOUFtcSAY14OAo6/L5T2yX9DUp
         HWrBiER4O+x1OkFeOCo4RWYXCvffb/z6J2VJVUuDX1Ii34QrhuxhZKfyydUUEJTq8SbN
         iPew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b1JoU83uEA8dwyXtle6P1+fwEOOsB8BpyzqJ+2+pwgo=;
        b=Ui8HvucXIsxwFD4LNb7BZB3TIZOcsqpOjj/f5u2JOAEAX59Pjj9yt6eLDWKWWdtJ1F
         CfYqenQIdJ+tiwq1esI/55U9SJgp8yFKEvkeFfCwG2PnGeiBUS2j2W697SqMI6fYAasT
         RTtji9JVyshqowNUBcgzyCZOzJ17P8X8VCJB02c/OHHQDLLR/JfI37hWVBzE1UACxLOm
         Kaghsil4yzn9rbRYsFp+tXsw8EOS0ljnLLG4ICxEcv221D+iSxDSSPgO/n529kI+mf1f
         C2z9PfMKA3ZoPqUV8bkyhTrLyt1K0ouJO+C97uEKkiey2ETwEJMQCLUHgVXewGyji1wB
         LQ1A==
X-Gm-Message-State: AFqh2koX3bFMn2PutdynKEq4KNN2T7AbabOCWsFY4rbgN+X2QfF6rrM5
        p0C608BwBb0kIm8FaNMLd2P/hsdtXnAmqDf+iF4=
X-Google-Smtp-Source: AMrXdXvgBKCKMY18/r8+Bm45EvQH3inEJ/22uZ9Uz2F3A+eHB4+7W0JwlBdXw7yfr8HgDl1B29EmDw==
X-Received: by 2002:a17:902:7889:b0:192:6bc9:47ba with SMTP id q9-20020a170902788900b001926bc947bamr60171645pll.31.1673407038045;
        Tue, 10 Jan 2023 19:17:18 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id h5-20020a170902f7c500b0019337bf957dsm4226756plw.296.2023.01.10.19.17.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 19:17:17 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 04/10] devlink: use SPDX
Date:   Tue, 10 Jan 2023 19:17:06 -0800
Message-Id: <20230111031712.19037-5-stephen@networkplumber.org>
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

Add SPDX tag instead of GPL 2.0 or later boilerplate

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 devlink/devlink.c | 6 +-----
 devlink/mnlg.c    | 6 +-----
 devlink/mnlg.h    | 6 +-----
 3 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index ae93e7cb620e..931a768a41d1 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * devlink.c	Devlink tool
  *
- *              This program is free software; you can redistribute it and/or
- *              modify it under the terms of the GNU General Public License
- *              as published by the Free Software Foundation; either version
- *              2 of the License, or (at your option) any later version.
- *
  * Authors:     Jiri Pirko <jiri@mellanox.com>
  */
 
diff --git a/devlink/mnlg.c b/devlink/mnlg.c
index b2e0b8c0f274..d049eb5a45a3 100644
--- a/devlink/mnlg.c
+++ b/devlink/mnlg.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  *   mnlg.c	Generic Netlink helpers for libmnl
  *
- *              This program is free software; you can redistribute it and/or
- *              modify it under the terms of the GNU General Public License
- *              as published by the Free Software Foundation; either version
- *              2 of the License, or (at your option) any later version.
- *
  * Authors:     Jiri Pirko <jiri@mellanox.com>
  */
 
diff --git a/devlink/mnlg.h b/devlink/mnlg.h
index 24aa17566a9b..3249c54c45a4 100644
--- a/devlink/mnlg.h
+++ b/devlink/mnlg.h
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  *   mnlg.h	Generic Netlink helpers for libmnl
  *
- *              This program is free software; you can redistribute it and/or
- *              modify it under the terms of the GNU General Public License
- *              as published by the Free Software Foundation; either version
- *              2 of the License, or (at your option) any later version.
- *
  * Authors:     Jiri Pirko <jiri@mellanox.com>
  */
 
-- 
2.39.0

