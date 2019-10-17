Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47E69DB5D4
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503198AbfJQSVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:21:43 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37634 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503189AbfJQSVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 14:21:43 -0400
Received: by mail-pf1-f193.google.com with SMTP id y5so2166352pfo.4
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 11:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+t0sQaIN+b2gzOsXb/K4zQqxIvXTP8XYDM3ST4QCg48=;
        b=aFzUwJasL9wJWy6eJSW2SoAU5smj718rOIWRDXFInixV5saka1JcBC2gMkUoq/JYE8
         o4t8fiZ9tpBcVXYywr36HhVD7qwBRHxwleLa3x/uYnO0eXv4gZHjtY3hkBwbuZxFofdR
         tra3JHlVTK5J+a8gyDDaCcQE79/08TyQtRodHBKeM21dyBmFh7ytkx0dgxY7STha/C4C
         x0g8E3Ald9XUuIuDjbxTjtv+9TtA7DTEZV4FTusk8/BKG6/hyNLdDOH6MZXYxT5y0lbm
         sOfWYPv3da64KY+5QsB+snLoclapCQJ84bVatUwYJ+ikdfcI9uPa1o8W4ZWQPcRL31H9
         rydQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+t0sQaIN+b2gzOsXb/K4zQqxIvXTP8XYDM3ST4QCg48=;
        b=T3LIykWN7BRjky8PJ7w8oN9IQbng1yk7WiyS6AXo15qu9G2T40XNPN035Pug0NkX8t
         6v/nVTw8ywLklVMveY39Q7yuZMy34/OEaXMPExrN7TCGzF8DYKZxM/Qey6WpIe34qZms
         ufOB2GgIWjPu5HVI174IAIFGXuoEwXFSPsx287Huu1a/72Oy4DrBekVNLR1ElnE2RzTA
         jrjYWaHDrR19BioMTyFOoPYSckCM7U2Ovr36WmHlInZzBSkl4XxsPrqIG1+w5sy1w9fZ
         G/MAGxl4DKljqApOqB9bpMTZ+PcgMFpyBbNYClacf6GP9WRyLbFHVqR7OKR5jhmOHEGf
         X4xQ==
X-Gm-Message-State: APjAAAWcXW40hbaKJq+Z2PK9JMvtS4HYT5EIxRd6D1cAJtCOO4ZawIGq
        dEPe/l6YbkupV1oDr40krYg=
X-Google-Smtp-Source: APXvYqwVtlTcCJLG+2BluhzgbjYpRBy2V2kVf20JMupQLXL3QUofpwcNLLreSPhqTEynVlSCWVKlxw==
X-Received: by 2002:a63:5d04:: with SMTP id r4mr5626268pgb.22.1571336500636;
        Thu, 17 Oct 2019 11:21:40 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id p24sm6174603pgc.72.2019.10.17.11.21.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 11:21:39 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "John W . Linville" <linville@tuxdriver.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH 03/33] fix unused parameter warning in find_option()
Date:   Thu, 17 Oct 2019 11:20:51 -0700
Message-Id: <20191017182121.103569-3-zenczykowski@gmail.com>
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
  external/ethtool/ethtool.c:5417:28: error: unused parameter 'argc' [-Werror,-Wunused-parameter]
  static int find_option(int argc, char **argp)

Signed-off-by: Maciej Żenczykowski <maze@google.com>
Change-Id: I7782cac5f58e217fc6032037a2f248b03573b9d4
---
 ethtool.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/ethtool.c b/ethtool.c
index 5e0deda..0f3fe7f 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5507,7 +5507,7 @@ static int show_usage(struct cmd_context *ctx maybe_unused)
 	return 0;
 }
 
-static int find_option(int argc, char **argp)
+static int find_option(char *arg)
 {
 	const char *opt;
 	size_t len;
@@ -5517,8 +5517,7 @@ static int find_option(int argc, char **argp)
 		opt = args[k].opts;
 		for (;;) {
 			len = strcspn(opt, "|");
-			if (strncmp(*argp, opt, len) == 0 &&
-			    (*argp)[len] == 0)
+			if (strncmp(arg, opt, len) == 0 && arg[len] == 0)
 				return k;
 
 			if (opt[len] == 0)
@@ -5667,7 +5666,7 @@ static int do_perqueue(struct cmd_context *ctx)
 		ctx->argp++;
 	}
 
-	i = find_option(ctx->argc, ctx->argp);
+	i = find_option(ctx->argp[0]);
 	if (i < 0)
 		exit_bad_args();
 
@@ -5719,7 +5718,7 @@ int main(int argc, char **argp)
 	if (argc == 0)
 		exit_bad_args();
 
-	k = find_option(argc, argp);
+	k = find_option(*argp);
 	if (k >= 0) {
 		argp++;
 		argc--;
-- 
2.23.0.866.gb869b98d4c-goog

