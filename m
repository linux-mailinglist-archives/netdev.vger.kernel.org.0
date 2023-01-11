Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44E59665234
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 04:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232087AbjAKDRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 22:17:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbjAKDRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 22:17:18 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE2A12D14
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 19:17:17 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id jn22so15344135plb.13
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 19:17:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r7WJSoy0uegw9dFl9dl6tf8Vv4Ve655TU6QGZBJXNy8=;
        b=gNUXxy5WUtYA2nnmG1Hzs2/9yBRt3YvawSw5RTR8mnFDMb0RYyz6RynhssYxwz9QiQ
         RfE2nGh9Yo6hS+PovZtwOkSUaLWrp5O0S5V8nKebsYhVLSmv4nggiGbjI3zV00KVnMN8
         NtYTeqyjCgcLsR9cLSuCVeOnO8E4R9fn7wHPCoJeIb6OHRZ/Pi3kG6CoHc9asbMyO9HG
         3yOERf/4cTWvgNgoXPq+axmLUnX6FXMW+RmgLlbeIRMoXd/kmMxcFM/fQEyo7vg4dEew
         gwtOXaIFWwR2TuLttWXbgdra2pB+Kl9TGT7kJQB4/hQZH8C1uEaQxeS0TcQoWRYhOdNh
         3eHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r7WJSoy0uegw9dFl9dl6tf8Vv4Ve655TU6QGZBJXNy8=;
        b=1B/f/xCLehyzj/g+e1ns/H+iOtEJW1OLn3s5xsfjPJa1YZzjM9b9kkVB3QaWNJZ/qj
         jIzbKoohP2neHPrH40ctoEjjPyd+5PwjE/3ZEuu9Pw/EdQ0flaSSabuR18xUofYdEZU7
         xlw2GWPb19emJglHl0xj/1XIx3r6+yUA/fomrZ3zIWNFYcmcDodCkppUo36PEtZD3R8f
         X7anDsHO2NFbKIExW6qVIiq18VH/nQ0HkWJ76serIXX0EShXdXOoxNgDopa0I0w79V1e
         XPE4+cr3LAM8TSruH8zkmjjwTPqX0UOA6+vfURqT8rHq4fZu3/rdeF8h+OH3+5Afsw5A
         785w==
X-Gm-Message-State: AFqh2krmXGUTZ5B5k73dQOCM8knwbulH4Gu+9zsBmfyMmNm3vYUh67HN
        q6nsMJA7ZjOvP/EoALBWgSBy4pHHyDkMxwps7g4=
X-Google-Smtp-Source: AMrXdXsTZSqva4i5IiBRsZmPHICdTX+EVlatziQrDplKt09l3ue9Osn6DMhkFaN6k8Oim6Nn4G3lyw==
X-Received: by 2002:a17:902:e789:b0:193:15bb:daff with SMTP id cp9-20020a170902e78900b0019315bbdaffmr13199453plb.16.1673407036348;
        Tue, 10 Jan 2023 19:17:16 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id h5-20020a170902f7c500b0019337bf957dsm4226756plw.296.2023.01.10.19.17.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 19:17:15 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 02/10] genl: use SPDX
Date:   Tue, 10 Jan 2023 19:17:04 -0800
Message-Id: <20230111031712.19037-3-stephen@networkplumber.org>
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

