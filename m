Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35A18666316
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 19:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238898AbjAKSwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 13:52:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238514AbjAKSwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 13:52:34 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB8D3C3A6
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 10:52:33 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id o13so13282452pjg.2
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 10:52:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b1JoU83uEA8dwyXtle6P1+fwEOOsB8BpyzqJ+2+pwgo=;
        b=S9fBhzYHwC+feT7xPke8/DreQnik8EA3yOpD7iWl8u/PNcFk1MeopneC4vBWbrfQed
         3DeTDGT3VPu8rF/k9T6DXpPEXGOgv/YqcVZtNMpPdqpIVptyyQLPyv2xaU60KF5f8PS8
         8a3eR2pwGqDoZbLjDfwXAEnu1RQNHQwZJ5aCUSQM9ThW26Ki1HezKL5Zy6O3LBR8vvpb
         36FsUHsGykv3ZrIK42xHJVs7Q0RXxLNgBRByR7wqHw03aYaVX7Rg6FdSgyz/Oglm4ldz
         OesWbn+vQZk2fsfWKOAfVSFqUyCwNPiJ3AK2GsZdikDV5kfc7pGw3QSKS+QZ1iaaC1gq
         764w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b1JoU83uEA8dwyXtle6P1+fwEOOsB8BpyzqJ+2+pwgo=;
        b=rOHbn1o83CJCHlTn2V0BNwTMagwPizJv0aCMJ3RWIGuWWNdmCgeBy47xorj+RD+YAD
         LTDFJnX2l75QXMjNV1ozsa2sAv3PZEbUbbOCSDcAoWlPBQQADrW2QIdYYCVShFsnDRxs
         bLclf+ck266s6seluyxb2r8Jt8gVvqkP/kGsJhSQQMY7t91m23v9+gtNEMxzx9VMhvWO
         UyNSS4gcUMtqMt3eRIURXqa6Uj9QOlham2mX5CeOImOb3HRNFOCdLEcjCvybW/lNyNzi
         4CLUhdYhOiCaxZFCH9i0ApL7S7XgnGwnI1FlWP+xHcMHEyx3lZMdspSDuhU1VjnTXnBh
         QbYg==
X-Gm-Message-State: AFqh2kqC5C7MFY910i/Eo3rgV8+TPBAGQM21UmoFZSU+nOzkWB4Wh6NY
        GLQ0ebIPfg4CJgkdwVNNvv8vhC0RYtq9jo0JdAo=
X-Google-Smtp-Source: AMrXdXuiCzWCOW9bJcvpu95aYBlYhg6HTfvHLRa3UUqnoUpwoC6Jl7zFlpPjq2elo4OgBTn9IjeyYQ==
X-Received: by 2002:a05:6a20:5494:b0:ad:94d0:ac97 with SMTP id i20-20020a056a20549400b000ad94d0ac97mr5066689pzk.48.1673463152846;
        Wed, 11 Jan 2023 10:52:32 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id d7-20020a631d47000000b004a849d3d9c2sm8650447pgm.22.2023.01.11.10.52.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 10:52:32 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2 iproute2 04/11] devlink: use SPDX
Date:   Wed, 11 Jan 2023 10:52:20 -0800
Message-Id: <20230111185227.69093-5-stephen@networkplumber.org>
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

