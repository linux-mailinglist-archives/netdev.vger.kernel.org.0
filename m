Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABB29666321
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 19:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238781AbjAKSxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 13:53:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238633AbjAKSwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 13:52:41 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AAAD3D1D5
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 10:52:40 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id c6so17754411pls.4
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 10:52:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OLSabfIaVF9fDMHORSlaf8YoAUasv6/RH4gjuNRf70U=;
        b=Zeh9EdunMXLN0vZpC7ZVIHzltFGLWAidQ7aMghlV7io/qhqRcGUDdLy8+K1CXm8oPo
         PgLXcF537hy31mDP4PGkOueMdiSGXWOQy3uQEyVDL3JnWcCmey1HLf7duDMpEPhBMCeJ
         BM95ozeAM7IqvDy7k8kPgkHddFtcKWJNd4R6Bm9WZ5N9Ox3vfRWngAHlyv0clJ6jSY53
         2gB9u+VUaYpdZyCYsWJhK+m1hWDL/RtJrdhua9fu8wtpAXE+rJkYaztXdXtKgdnUW0DW
         jmEpypFKR8H07Onnc371GRF5VXjuX7O+B6WyRMbnoGVeftb6lr8bd+JmIPtTkl1OnrSQ
         aNtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OLSabfIaVF9fDMHORSlaf8YoAUasv6/RH4gjuNRf70U=;
        b=vBsAdg1MbVEoQXfbMGh0/3/qOpb37ddPB2lgVhDWQXKBx0HerPIyoUfBp5xo5wq8pu
         X7GQpCVT6Jo87gRBZDgq6vmT4mfXMkXMmXg+7jyzXAGFOxBDuaLacG450kBldZ0SDE3h
         FRRCDpy8pwiS3DhlnwCwkgKwxfnrsFPbRDXvvqErNMrQehpVCx4tXMLc2DO1DxLmy0HN
         xNp/hzPiYSFyX75UYcom2cERBB46LTu0Dfin8MRHDToIOS0lF9haUFFaoLXiGQL8zgP9
         r6KUNy4tQ6awWSn9PfOz5E9GjYTIbQK4xWOPngam6tE3hgvIuKy0ZqaZvzHJfEaD/3/I
         xTpw==
X-Gm-Message-State: AFqh2kpfxSc47TUv5Khaux+tEosUhUbnoTWRNmg84IIW07q43yiKIzXA
        fRDK8w8OI6jYNNkH30IYmJny/e8HFzqZLf+RvQI=
X-Google-Smtp-Source: AMrXdXtPYfFD641sP1qIg7TZyFIuunrcG2rCZoZKdpuSVH5h5YnhjYTr2rye7fU1Z8CrgOfgPNnKWg==
X-Received: by 2002:a05:6a20:2a96:b0:b2:5cf9:817b with SMTP id v22-20020a056a202a9600b000b25cf9817bmr118628643pzh.5.1673463159481;
        Wed, 11 Jan 2023 10:52:39 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id d7-20020a631d47000000b004a849d3d9c2sm8650447pgm.22.2023.01.11.10.52.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 10:52:38 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2 iproute2 11/11] netem: add SPDX license header
Date:   Wed, 11 Jan 2023 10:52:27 -0800
Message-Id: <20230111185227.69093-12-stephen@networkplumber.org>
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

The netem directory contains code to generate tables for netem.
This code came from NISTnet which was public domain.
Add appropriate license tag.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 netem/maketable.c    | 1 +
 netem/normal.c       | 1 +
 netem/pareto.c       | 1 +
 netem/paretonormal.c | 1 +
 netem/stats.c        | 1 +
 5 files changed, 5 insertions(+)

diff --git a/netem/maketable.c b/netem/maketable.c
index ccb8f0c68b06..ad8620a47ce2 100644
--- a/netem/maketable.c
+++ b/netem/maketable.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: NIST-PD */
 /*
  * Experimental data  distribution table generator
  * Taken from the uncopyrighted NISTnet code (public domain).
diff --git a/netem/normal.c b/netem/normal.c
index 90963f4e91a4..5414be41fa52 100644
--- a/netem/normal.c
+++ b/netem/normal.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: NIST-PD */
 /*
  * Normal distribution table generator
  * Taken from the uncopyrighted NISTnet code.
diff --git a/netem/pareto.c b/netem/pareto.c
index 51d9437dbcb2..5c802c902baa 100644
--- a/netem/pareto.c
+++ b/netem/pareto.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: NIST-PD */
 /*
  * Pareto distribution table generator
  * Taken from the uncopyrighted NISTnet code.
diff --git a/netem/paretonormal.c b/netem/paretonormal.c
index 9773e370e6bc..c36e325fcd2b 100644
--- a/netem/paretonormal.c
+++ b/netem/paretonormal.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: NIST-PD */
 /*
  * Paretoormal distribution table generator
  *
diff --git a/netem/stats.c b/netem/stats.c
index ed70f1676342..99c4feedfa6f 100644
--- a/netem/stats.c
+++ b/netem/stats.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: NIST-PD */
 /*
  * Experimental data  distribution table generator
  * Taken from the uncopyrighted NISTnet code (public domain).
-- 
2.39.0

