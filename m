Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97501490FEE
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 18:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242051AbiAQRuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 12:50:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241939AbiAQRud (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 12:50:33 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C374C061401
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 09:50:33 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id c3so22034508pls.5
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 09:50:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ib33Nc1WOE8/cBTRuaybrv6PK430iHqYq4REXeC17gw=;
        b=v339RgVIQD4rLRHV7GXiBMLty9ZfRJn/gQCS4fxFMX2PZg7AvHrqmFI2K/jpqmQKGg
         q4CwgOv1u4iStsAIdsL9F8UFjd9CC0uwWfoTgAM6wuuZE0Dsd1sDXBkgHdRopJEeliev
         2ElKL1LbVTXSTn7AyE2+IDcngE+n8LXENNjQuE9ycVyyXBYI0UmhDZp25WmRs/wLyYGb
         NR/6khXolqPBSUIhKjHglqKmH1HC6JdCkLzDGUr9WAriNzN73Kicm2RNtiHRjYV4eckC
         cQuBR0j4+ax6h0Tnkvj4SjD+mxPuAYvxMuTX4c+Zvf2e1+CIoCUo0EAMsI67Z7VP+0ax
         Fe2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ib33Nc1WOE8/cBTRuaybrv6PK430iHqYq4REXeC17gw=;
        b=6FUJN6fW4URIVMtWWK0//P24rW40RK60vtxXufCOXKqUfBWFpXtiMXqYjwITF431r4
         3uE5bJKH3AitLgxyfnnVUZ9/N/O3NAMBWaAm59M8lmTHOyFqeLb0dy0NDDBFLJc2G6AH
         VNe6dYAJYFa7ZTacQxxTrsnbH2oxjnlC86bQd0AF7eqNQMwe9SqT6aGPbR8S8eI2mXl1
         dKmjo4QjnvA25slVhTd9KUfEjEf0qj+F9bKNQ0yt9KDcM25Mv9u7lNzOveXfpl0wcGQG
         FfoheKKUgWSojCk52l4qeywiH6mwl6C9Argc3Qf62EbvvwuQP+RcVMSb7OK+1UxjyA4q
         nTEw==
X-Gm-Message-State: AOAM530kOeFNwPTCfenMC1WgJrcyKqojVfYnliz5NqWDpEDSq3x3PH7F
        tA5t6DTwehWXszXz1EANA+x9QC15m3pmog==
X-Google-Smtp-Source: ABdhPJzt8r+g+2AkC1WyChsIIbKACn4YNnlgNZeRnhl6UFOPi3TBczkAaA4DzcHQVi8Xyzh9OJwBrw==
X-Received: by 2002:a17:90a:d596:: with SMTP id v22mr7604696pju.87.1642441832463;
        Mon, 17 Jan 2022 09:50:32 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id q19sm15819117pfk.131.2022.01.17.09.50.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 09:50:31 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v3 iproute2-next 11/11] json_print: suppress clang format warning
Date:   Mon, 17 Jan 2022 09:50:19 -0800
Message-Id: <20220117175019.13993-12-stephen@networkplumber.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220117175019.13993-1-stephen@networkplumber.org>
References: <20220117175019.13993-1-stephen@networkplumber.org>
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

