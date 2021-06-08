Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56D8939FA30
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 17:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbhFHPVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 11:21:07 -0400
Received: from mail-lf1-f42.google.com ([209.85.167.42]:33455 "EHLO
        mail-lf1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbhFHPVH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 11:21:07 -0400
Received: by mail-lf1-f42.google.com with SMTP id t7so25564424lff.0
        for <netdev@vger.kernel.org>; Tue, 08 Jun 2021 08:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6MwjdJLeEpSC0apKdrMCy6GpFHPBUueYy/xEq2Hv4io=;
        b=kwbPIiDLHkRMufb2YxgISZsRSbm/GagyaCa9VHTv0lQ/5Slza/CSFZceLnA9XRY2Ul
         Dld7kVJYCFkkaFyT1WHUrzSjK/hhRvpL0mq/7umCK7N8U4boGBcHYvRD1F+uA60TqvlG
         kNNT5jh+uvhFIDPJfWdS/eF/moYWSdiS/E7Tk0CEgh3GYyJAeyhG1gSzXymZssyuYTgB
         ZGK6KYfBR5AT8P+987ONKgPghScs1kRupTl1JADk6e7/PiaBbPgNvOYD6T+bkkscXPE3
         sVDGbgEKjb37U0Je1pnAkCf2zyqVKjgxwIt0RRPBz/QejwGFRXmNOdhmCskzG7eTzy81
         06MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6MwjdJLeEpSC0apKdrMCy6GpFHPBUueYy/xEq2Hv4io=;
        b=Oh7C9v1+QzGaJBk/q6G2L4bwxr11l3ySD52AjJOi+mFrgybg6LWsSn6M6S0A240/1p
         2+z2Oc9USBuV0jdkO7e1I3gDBIwW3LW0ymqopVy5nl0+ckTtQB38SecWASE35VRj6gGO
         scT0qxBn0aY0pobF1DzYI8eB+PNsQe9UDBQgaq7zK1BRsOnxK+fC32qVGhR5dILTX+V4
         794oD5n5xil6ceInT8ih8Bpgg8b0sYQFn6fjztNquh5DhL/xRiTRdgayEbon/9/PX2Xd
         ANPfVsHUViNNG6+z0rYphLkAV34FU8i8Fj3XSF8znhkCSolPma6Cysk6rEwqGsqluE6H
         IVWw==
X-Gm-Message-State: AOAM530nf39aBgcHAIdjQ8t0zXEsLxVKupN28L/wPbWqrWD9meG+9hyD
        661io43Kc1DaVV6VQGTctUE=
X-Google-Smtp-Source: ABdhPJxInk2gYl9TGXWq536sx4l9EnLbhAw7QWJFEsknsxemgAdL60J4wpDgmSw1y+4HoYjdZ1xZ9Q==
X-Received: by 2002:a19:7604:: with SMTP id c4mr11474486lff.398.1623165479446;
        Tue, 08 Jun 2021 08:17:59 -0700 (PDT)
Received: from dau-work-pc.sunlink.ru ([87.244.6.228])
        by smtp.googlemail.com with ESMTPSA id x10sm2367ljj.126.2021.06.08.08.17.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 08:17:59 -0700 (PDT)
From:   Anton Danilov <littlesmilingcloud@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org,
        Anton Danilov <littlesmilingcloud@gmail.com>
Subject: [PATCH] [RFC iproute2-next] tc: f_u32: Rename commands and functions ip6 to ipv6 to unify naming
Date:   Tue,  8 Jun 2021 18:17:39 +0300
Message-Id: <20210608151739.3220-3-littlesmilingcloud@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210608151739.3220-1-littlesmilingcloud@gmail.com>
References: <20210608151739.3220-1-littlesmilingcloud@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before patch:
~$ tc filter add dev dummy0 parent 1: protocol ipv6 prio 10 \
    u32 match ip6 src aa:bb:cc:dd::/128 flowid 1:1

After patch:
~$ tc filter add dev dummy0 parent 1: protocol ipv6 prio 10 \
    u32 match ipv6 src aa:bb:cc:dd::/128 flowid 1:1

Signed-off-by: Anton Danilov <littlesmilingcloud@gmail.com>
---
 tc/f_u32.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/tc/f_u32.c b/tc/f_u32.c
index 2ed5254a..3fd3eb17 100644
--- a/tc/f_u32.c
+++ b/tc/f_u32.c
@@ -35,7 +35,7 @@ static void explain(void)
 		"or         u32 divisor DIVISOR\n"
 		"\n"
 		"Where: SELECTOR := SAMPLE SAMPLE ...\n"
-		"       SAMPLE := { ip | ip6 | udp | tcp | icmp | u{32|16|8} | mark }\n"
+		"       SAMPLE := { ip | ipv6 | udp | tcp | icmp | u{32|16|8} | mark }\n"
 		"                 SAMPLE_ARGS [ divisor DIVISOR ]\n"
 		"       FILTERID := X:Y:Z\n"
 		"\nNOTE: CLASSID is parsed at hexadecimal input.\n");
@@ -356,7 +356,7 @@ static int parse_ip_addr(int *argc_p, char ***argv_p, struct tc_u32_sel *sel,
 	return res;
 }
 
-static int parse_ip6_addr(int *argc_p, char ***argv_p,
+static int parse_ipv6_addr(int *argc_p, char ***argv_p,
 			  struct tc_u32_sel *sel, int off)
 {
 	int res = -1;
@@ -403,7 +403,7 @@ static int parse_ip6_addr(int *argc_p, char ***argv_p,
 	return res;
 }
 
-static int parse_ip6_class(int *argc_p, char ***argv_p, struct tc_u32_sel *sel)
+static int parse_ipv6_class(int *argc_p, char ***argv_p, struct tc_u32_sel *sel)
 {
 	int res = -1;
 	int argc = *argc_p;
@@ -538,7 +538,7 @@ static int parse_ip(int *argc_p, char ***argv_p, struct tc_u32_sel *sel)
 	return res;
 }
 
-static int parse_ip6(int *argc_p, char ***argv_p, struct tc_u32_sel *sel)
+static int parse_ipv6(int *argc_p, char ***argv_p, struct tc_u32_sel *sel)
 {
 	int res = -1;
 	int argc = *argc_p;
@@ -549,13 +549,13 @@ static int parse_ip6(int *argc_p, char ***argv_p, struct tc_u32_sel *sel)
 
 	if (strcmp(*argv, "src") == 0) {
 		NEXT_ARG();
-		res = parse_ip6_addr(&argc, &argv, sel, 8);
+		res = parse_ipv6_addr(&argc, &argv, sel, 8);
 	} else if (strcmp(*argv, "dst") == 0) {
 		NEXT_ARG();
-		res = parse_ip6_addr(&argc, &argv, sel, 24);
-	} else if (strcmp(*argv, "priority") == 0) {
+		res = parse_ipv6_addr(&argc, &argv, sel, 24);
+	} else if (strcmp(*argv, "priority") == 0 || strcmp(*argv, "class") == 0) {
 		NEXT_ARG();
-		res = parse_ip6_class(&argc, &argv, sel);
+		res = parse_ipv6_class(&argc, &argv, sel);
 	} else if (strcmp(*argv, "protocol") == 0) {
 		NEXT_ARG();
 		res = parse_u8(&argc, &argv, sel, 6, 0);
@@ -712,9 +712,9 @@ static int parse_selector(int *argc_p, char ***argv_p,
 	} else if (matches(*argv, "ip") == 0) {
 		NEXT_ARG();
 		res = parse_ip(&argc, &argv, sel);
-	} else	if (matches(*argv, "ip6") == 0) {
+	} else	if (matches(*argv, "ip6") == 0 || matches(*argv, "ipv6") == 0) {
 		NEXT_ARG();
-		res = parse_ip6(&argc, &argv, sel);
+		res = parse_ipv6(&argc, &argv, sel);
 	} else if (matches(*argv, "udp") == 0) {
 		NEXT_ARG();
 		res = parse_udp(&argc, &argv, sel);
-- 
2.20.1

