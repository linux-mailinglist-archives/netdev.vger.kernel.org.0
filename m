Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C334348B4AE
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 18:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344910AbiAKRzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 12:55:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344937AbiAKRy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 12:54:56 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D36DC061245
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 09:54:53 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id i8-20020a17090a138800b001b3936fb375so6728086pja.1
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 09:54:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TKvyW1CxSmDrJRaWV+QQIO2dUVX4LQYIgEeEqJM0ZTQ=;
        b=ULtfXFJDKWaOVpubQ7eGnMXe2zGo97mwrhPDjODp3r6PYbE/IxBpr7if+gKI2wWSli
         sOZoedudwsrucRsXdayLe8xpOkFbOHOt7tUaH5q9qRIXez4Iq/DMlbxa89qrsJlNHaLR
         Zv35l1H0KDFNEOEc148xsvL6g4RmnoFDbOxs+AYvX4khxz7APTbfbLhTV3CNJJJMdQ1h
         Q3Xvz8J5aG+OC38ozmSzgjWHx3CZhgW548Ilcb9Cpty+8Od9Gh4VDbkTmNz6dJZqC1wA
         W5+G422ghtnLmI1CqVyAnfeUWlpiAiFJ0M40eFnqxJ/50WMyV8/kRklrwVXRXjHqy6F4
         Sygw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TKvyW1CxSmDrJRaWV+QQIO2dUVX4LQYIgEeEqJM0ZTQ=;
        b=pe8iW+0OnEKQyy7FBadgoRX434hCUIl+waRPbhDPuEQoYVTIVgAMGy6xDCG7ixO5Ai
         gdDsv7+TjwFckDc/98yCt5WWjzcWdpsD/b/PbPzBDaiGUQWIdim7delTbUMCDlRKNhBL
         vmlfZ2Fdx6GRVsqibM1GJBpGvHxMtHKm9GUmM4Lh2JBNCBYoyJXH+mXX8P0jdAsEog+L
         F70p3BqhIXNHwVawTHqC6DSmMGttoy3pXLZ+pDF0jr13kH0UF78azfXvajaWfDy6C8tw
         etoXsL05U97f7NmPG/L6JrGZco1zqhA2TVMQbSz0RKVE64Ig5BwKjsoLXdH7PDU5dij8
         i5/w==
X-Gm-Message-State: AOAM531Mav51h89dqBklCy96maGP4Ubr/hZGDK/x0KOd3q0G2f+xQC0x
        A1ovcUJZZ7ZQ8bd71LmVEJC4Dy8iqu51gg==
X-Google-Smtp-Source: ABdhPJy9PsD8cvJHhiC4/7ZeHfyaUzoXKUwlU94EHJmsyA/e3+FtNfqlQmUQpXIaL0VCqiPD09kkeg==
X-Received: by 2002:a17:902:7688:b0:149:5029:a55a with SMTP id m8-20020a170902768800b001495029a55amr5456765pll.15.1641923692292;
        Tue, 11 Jan 2022 09:54:52 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id f8sm23925pga.69.2022.01.11.09.54.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 09:54:51 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
X-Google-Original-From: Stephen Hemminger <sthemmin@microsoft.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <sthemmin@microsoft.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2 iproute2-next 11/11] json_print: suppress clang format warning
Date:   Tue, 11 Jan 2022 09:54:38 -0800
Message-Id: <20220111175438.21901-12-sthemmin@microsoft.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220111175438.21901-1-sthemmin@microsoft.com>
References: <20220111175438.21901-1-sthemmin@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang complains about using non-format string in print_color_tv.

The ideal fix would be to put format attribute on all the print_XXX functions
in json_print.h. But that leads to furthur complications because the existing
code may pass a NULL as format if the format is unused since the print
is being done only for JSON output.

The comprimise is to just disable the warning for the one place
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

