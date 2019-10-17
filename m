Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01C73DB5D3
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503193AbfJQSVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:21:40 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:35503 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503189AbfJQSVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 14:21:39 -0400
Received: by mail-pg1-f177.google.com with SMTP id p30so1835072pgl.2
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 11:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UH4mwhxKS23VNsZvCLpwMz6KLiBgNdZBK9hrJnD11Ns=;
        b=AFrtCuARMluJf7yzIz8Tz/goW2x1n58PO/cUxx17o9fbi/VF+W1hDTH6vG8BBoMgvi
         7+s7zDjvJx75vgcNm2NkabJPe+ZBegyu3AwvBmOk93zKAWWl1Y1BnqEUGT+l5kzRl5tv
         lb73kq3yLWwO5RR5J/RR+jFjrQh2Cg9gg+zO09O+uS07FZKh78IaD2keC5DOSz6otMd2
         yp9BS+G1lJaXrpiaMoG+BLqHrtuT4I3X/kOmX3curbTTn7pI4yyTbTO9iUcJIcirAQUx
         sW7458exu91cL0oiLb/EXkJcKWTFmaeV+lPMqVFKSLzb/VmcPAQ7k/YwNBaIX9sYv8xg
         eTlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UH4mwhxKS23VNsZvCLpwMz6KLiBgNdZBK9hrJnD11Ns=;
        b=E1AcbY/fAfQL1MijsyROtzGzBmCipRJuRxIA44tbn4bCZD9Cgx5U+mbbAHG5dgCTt+
         vgiA4AYXfvkmpDOu4c3oqKj0l4ZJ2UAgnr/PiHRi7r4/HYVS6V5Xm+23AVafRv118btu
         vO+xOCmNmtvUOeszChSuVk8HLD5+3s3JZ78qS6ljXyorf4WuyXwRBzvmCtb4LI793Kfp
         M0HJDQEABM+pNlvEb3Tgo9ZU4KxUVVfD+B9VMeHonN0TqnhWH9sdYn3dObMB+q4oOFW2
         hiTQn8tp9Aa0oPdhKrwrnyZs9zPRaFRpiPQXggBfEtWmsKulbo952TQfe+TvqlCup2wj
         MCQA==
X-Gm-Message-State: APjAAAU2XWfoasGuYS9GkyBhhdDGYJn2GKW8BFkOCSyT/wJ02QMGp1aX
        VIW19XHxBZeiHG9/6+hsA9JZmOT0
X-Google-Smtp-Source: APXvYqxktL7cVRoRowoqxwokCbJwVaPKeX8rAugVby5j7/pk3K/869Gr/2rBV0jMo1fwgXcVOsmASw==
X-Received: by 2002:a17:90a:2e85:: with SMTP id r5mr6025180pjd.53.1571336498853;
        Thu, 17 Oct 2019 11:21:38 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id p24sm6174603pgc.72.2019.10.17.11.21.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 11:21:38 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "John W . Linville" <linville@tuxdriver.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH 02/33] fix unused parameter warnings in do_version() and show_usage()
Date:   Thu, 17 Oct 2019 11:20:50 -0700
Message-Id: <20191017182121.103569-2-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
In-Reply-To: <20191017182121.103569-1-zenczykowski@gmail.com>
References: <CAHo-Ooze4yTO_yeimV-XSD=AXvvd0BmbKdvUK4bKWN=+LXirYQ@mail.gmail.com>
 <20191017182121.103569-1-zenczykowski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

This fixes:
  external/ethtool/ethtool.c:473:43: error: unused parameter 'ctx' [-Werror,-Wunused-parameter]
  static int do_version(struct cmd_context *ctx)

  external/ethtool/ethtool.c:5392:43: error: unused parameter 'ctx' [-Werror,-Wunused-parameter]
  static int show_usage(struct cmd_context *ctx)

Signed-off-by: Maciej Żenczykowski <maze@google.com>
Change-Id: I0cc52f33bb0e8d7627f5e84bb4e3dfa821d17cc8
---
 ethtool.c  | 4 ++--
 internal.h | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/ethtool.c b/ethtool.c
index 082e37f..5e0deda 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -470,7 +470,7 @@ static int rxflow_str_to_type(const char *str)
 	return flow_type;
 }
 
-static int do_version(struct cmd_context *ctx)
+static int do_version(struct cmd_context *ctx maybe_unused)
 {
 	fprintf(stdout,
 		PACKAGE " version " VERSION
@@ -5484,7 +5484,7 @@ static const struct option {
 	{}
 };
 
-static int show_usage(struct cmd_context *ctx)
+static int show_usage(struct cmd_context *ctx maybe_unused)
 {
 	int i;
 
diff --git a/internal.h b/internal.h
index aecf1ce..ff52c6e 100644
--- a/internal.h
+++ b/internal.h
@@ -23,6 +23,8 @@
 #include <sys/ioctl.h>
 #include <net/if.h>
 
+#define maybe_unused __attribute__((__unused__))
+
 /* ethtool.h expects these to be defined by <linux/types.h> */
 #ifndef HAVE_BE_TYPES
 typedef uint16_t __be16;
-- 
2.23.0.866.gb869b98d4c-goog

