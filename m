Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC01666313
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 19:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238714AbjAKSwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 13:52:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238273AbjAKSwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 13:52:33 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 247B336313
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 10:52:32 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id z4-20020a17090a170400b00226d331390cso18213620pjd.5
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 10:52:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r7WJSoy0uegw9dFl9dl6tf8Vv4Ve655TU6QGZBJXNy8=;
        b=moAi5fXhGPuLOPffOhHQ5LKCNDfz/feSFGB5NF1EyqBxbkj+Uu5k2AoVMBSKM+xrmP
         teBPfy0Oxpt8D8byh8+VVrJRYZjWFxdL7xYZK7X0Diva6Ppw3FFYGCp8BEiU6rVb7RRn
         W9+rb80CrKAcTgTLkVQVN0/A3/AqpNL3vrIFKHiBDyyvETP3aJni9lwk4dWwDbvOuOC/
         SMG49R9tkEQs9tDe5LF9Mm7ut4wvFwl+8V4mfKLuJAif85E/mt5/fhJiAF8y+KFAguKy
         tWIVsDmiG/xtIWxMHRZDCwtyKX+nbI+0EfI22w5+TverYA1bD2cft4l9yeuKYYobsk9r
         24xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r7WJSoy0uegw9dFl9dl6tf8Vv4Ve655TU6QGZBJXNy8=;
        b=dZRYHGKgdLT8iw/V/fwUFjNSo6OJjuT3Fs/8tSxBKF5HjBZD6+YZowSugGe7aEzBs7
         RhJn75iCXUlPqhZT6LMvY63duF6w79+23HeYEvRvf/y5aJK4hEjixUKSjfAVWENN+8yI
         dSwMUk0n7gg+dtyY68ExPQucpREi0uxiVSNjrTqDaokeWUf3P12r2ymLwDgSXP0hKhH3
         GzjriL3qka/Kl0CJUFg4Ha2UdY6nhBW9XSoxfllZWo8lF+1qhI8vYsBww5bc4iGyQ9P1
         LDkX9CK348HZC2iQfFhTn+kMImGILtVN7KiCLTitXCL05175uAs4FLJZLaLgmTB5t6AJ
         l58A==
X-Gm-Message-State: AFqh2krNz2lE8gCc4n8fgSDk+ABnU9Hz/BNWBOn5BA2NkZf3zh2IAJ3v
        yU7kbkMi9MOQhnDWbYNssK8pJNJgeQH2mOS92KE=
X-Google-Smtp-Source: AMrXdXsHeuLWOxvmrzNxd3BeggMAD40tdHIPx00RsIP0dfcmGI+bQ38vFiPlPECKcNgqpE9h3omg4Q==
X-Received: by 2002:a05:6a20:9399:b0:ad:a277:eeee with SMTP id x25-20020a056a20939900b000ada277eeeemr81549888pzh.45.1673463151349;
        Wed, 11 Jan 2023 10:52:31 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id d7-20020a631d47000000b004a849d3d9c2sm8650447pgm.22.2023.01.11.10.52.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 10:52:30 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2 iproute2 02/11] genl: use SPDX
Date:   Wed, 11 Jan 2023 10:52:18 -0800
Message-Id: <20230111185227.69093-3-stephen@networkplumber.org>
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

Replace GPL 2.0 or later boilerplate.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 genl/ctrl.c | 6 +-----
 genl/genl.c | 7 +------
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/genl/ctrl.c b/genl/ctrl.c
index 549bc6635831..a2d87af0ad07 100644
--- a/genl/ctrl.c
+++ b/genl/ctrl.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * ctrl.c	generic netlink controller
  *
- *		This program is free software; you can distribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	J Hadi Salim (hadi@cyberus.ca)
  *		Johannes Berg (johannes@sipsolutions.net)
  */
diff --git a/genl/genl.c b/genl/genl.c
index 6557e6bc6ce6..85cc73bb2e18 100644
--- a/genl/genl.c
+++ b/genl/genl.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * genl.c		"genl" utility frontend.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Jamal Hadi Salim
- *
  */
 
 #include <stdio.h>
-- 
2.39.0

