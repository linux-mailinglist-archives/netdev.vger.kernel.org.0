Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF664955DA
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 22:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377785AbiATVMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 16:12:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377787AbiATVMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 16:12:08 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ACA2C061748
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 13:12:08 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id 187so6159267pga.10
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 13:12:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ib33Nc1WOE8/cBTRuaybrv6PK430iHqYq4REXeC17gw=;
        b=ph0cLbiB+j9mUQKsmxAJo0BP4IfbPgIjebLITiIgTFL2KtjtMF9ikw/uu/DYMYs3VB
         PvKJ9EP8js99sBzIadnpb8WR9Nncnd6stmgOWpO12Xda8tgKVtjzWbx0qyAEWwA3vnJz
         SkiEbfJ7P2Co9D9wi5nMwTRONYT1lhRh1FHY/d4XnWSFPezRmYywWJl2aocCbjLp0UDU
         9wgqqYu39xLTFlByS2ux+7JwPE407cabcoQTb95/UrfVgU87ra7JWDaqKygLmcGTI0aF
         hGUzWyu6R5DzqBswxuuTI6Ws3E/f1Jd58L4C40s9ixCS7okaTJOITiecVMxqbKFTaDze
         JByw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ib33Nc1WOE8/cBTRuaybrv6PK430iHqYq4REXeC17gw=;
        b=zedJs9Rh4QPtFSW7KqnxzeJekx/N/gXmKDfN9tpEp+IXoPw5XzWfP2WbHDIv052hzy
         3m7GQMM88HVA4ALSbnQKGokNrmbcYHI60+ccuhWR/yTj/pBVYbyWR+Sf5tbBRnvn6p1u
         9VXsuRSNI0wg21aJb3+AUZqQ0OgwMs5+vYH4FP3CeboOjuofaEklLc6wM4Rl7ZjPPi7c
         bAXtySRE6yQdpyJ/3jk7qbiAeF7PfaYPbrGprgiX3+hAE4hzkXJY3OwoP1g6n2BcCQ5L
         gklqq6a8PTHsGxw4KrmGR8TuukdsC3q7k+BcOj4Cv3enSacQBhMGAOpTeNMRc9fkC/E3
         N8EA==
X-Gm-Message-State: AOAM533J6W3Ru6pkewCEKMJ/LqZnc80SNK+QbeRAJIT+vSRvnae/1Mw3
        SjoFF+4Ah78xWQVLl1uCQRQSgyboAjT75Q==
X-Google-Smtp-Source: ABdhPJwWUZnr+Ui7AimZ1RZp6JXyknsg2HUoN1ZGCQ89xkpA1iHhywCpgDvLRiEO8FXEvpUIh7//wg==
X-Received: by 2002:a62:2f86:0:b0:4bc:fe4d:4831 with SMTP id v128-20020a622f86000000b004bcfe4d4831mr520251pfv.23.1642713127444;
        Thu, 20 Jan 2022 13:12:07 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id rj9sm3357187pjb.49.2022.01.20.13.12.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 13:12:06 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v4 iproute2-next 11/11] json_print: suppress clang format warning
Date:   Thu, 20 Jan 2022 13:11:53 -0800
Message-Id: <20220120211153.189476-12-stephen@networkplumber.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220120211153.189476-1-stephen@networkplumber.org>
References: <20220120211153.189476-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang complains about using non-format string in print_color_tv.
The ideal fix would be to put format attribute on all the print_XXX functions
in json_print.h. But that leads to further complications because the existing
code may pass a NULL as format if the format is unused since the print
is being done only for JSON output.

The compromise is to just disable the warning for the one place
it shows up.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 lib/json_print.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/lib/json_print.c b/lib/json_print.c
index e3a88375fe7c..741acdcff990 100644
--- a/lib/json_print.c
+++ b/lib/json_print.c
@@ -299,6 +299,13 @@ int print_color_null(enum output_type type,
 	return ret;
 }
 
+/*
+ * This function does take printf style argument but applying
+ * format attribute to causes more warnings since the print_XXX
+ * functions are used with NULL for format if unused.
+ */
+#pragma GCC diagnostic push
+#pragma GCC diagnostic ignored "-Wformat-nonliteral"
 int print_color_tv(enum output_type type,
 		   enum color_attr color,
 		   const char *key,
@@ -311,6 +318,7 @@ int print_color_tv(enum output_type type,
 
 	return print_color_float(type, color, key, fmt, time);
 }
+#pragma GCC diagnostic pop
 
 /* Print line separator (if not in JSON mode) */
 void print_nl(void)
-- 
2.30.2

