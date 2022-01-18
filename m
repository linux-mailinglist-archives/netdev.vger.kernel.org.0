Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39F02491EC1
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 06:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbiARFFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 00:05:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiARFFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 00:05:16 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4332DC061574
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 21:05:16 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id x83so12845264pgx.4
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 21:05:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nN9NpJjxaNk+PMjOnDVcI733qB2iOALHz4zWXgC/ixA=;
        b=y/gfqybBaMY4cAFptBpgB6rIaplVCe+uAazb1aiXsaC3wpsIUOt7TsS+daoIBANdL6
         IB8Cpc2IydtMqGrRMErb6S9aO8m64gcE2a4TOW7l3nE20Etea6GKhmGRtvnBw0kucyjr
         U3VP3HTWPUTC/1Enig04W3q74pJG11ai6fpAkaKoRHPgYsvZE0Kq+908YPNIWYvcHXVF
         pW8+EdDt2+vIeq506DHL0ab8QdRheSMIeYrsvULPcpI7u1i/+Y2If/mMdJ+VQ3YEI05C
         SXNIGXHW2YMIPNZXvqJCfTU43sByuLlUN6qnKMHl5kX+FngkUjOqnfugRucLpBzgOhIM
         R8OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nN9NpJjxaNk+PMjOnDVcI733qB2iOALHz4zWXgC/ixA=;
        b=eoQr+H31aPoj7pqA9Y0QIVwps+5Lnop6CeAZPWkddz3X/ovh3HRe78/9f//1rd4/VF
         Sgb2/SFhEegg9ek62EOjuQAxCtE4G6KZsdwUzJfqXQAgD+AA/pCxRrFZmFIRHTh0SBsg
         hxWlCaeoaH5ZP3PhCYAVadUDa/NAbznnTk2gMF65vQFfmlglS3QTBKcw9GryPuh1nsR8
         AJQmc45BcmQQfKjcVKZvGAg0Ki85FfQsNGoQw2ZWJQzlNR6mJA7D5Wt8lFPkpisXiJ1K
         iZkwyH3neHyRXENROHyvIM5tA+Tnjeabwqu7wabCjkWxa19qxV1KiaSkdMOr0LLlOEMV
         /xQw==
X-Gm-Message-State: AOAM531pAiw9X3Zks1PzPJOxLsTMtBTBWQMf3DypX0MIXwX2Rfm4Tl5a
        V3X4T62I4urfpKj77b+V6Xc+O9Ds1LjEoQ==
X-Google-Smtp-Source: ABdhPJw68/A0JDhVTC2T5XMAK/ngRjUzqJIUIceItHGSZy75Vs9qNyPmfQLiJyr0h2O3ztfcFal/gg==
X-Received: by 2002:a05:6a00:1505:b0:4c4:330:b86d with SMTP id q5-20020a056a00150500b004c40330b86dmr9736208pfu.82.1642482315409;
        Mon, 17 Jan 2022 21:05:15 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id j20sm14987664pfh.22.2022.01.17.21.05.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 21:05:14 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 1/2] netem: fix checkpatch warnings
Date:   Mon, 17 Jan 2022 21:05:11 -0800
Message-Id: <20220118050512.14198-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netem is old and pre-dates checkpatch, so fix it up.
Switch to SPDX and remove boilerplate.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 tc/q_netem.c | 59 +++++++++++++++++++++++-----------------------------
 1 file changed, 26 insertions(+), 33 deletions(-)

diff --git a/tc/q_netem.c b/tc/q_netem.c
index 2e5a46ab7b25..f45a64b9d554 100644
--- a/tc/q_netem.c
+++ b/tc/q_netem.c
@@ -1,13 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
- * q_netem.c		NETEM.
- *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
- * Authors:	Stephen Hemminger <shemminger@linux-foundation.org>
- *
+ * Author:	Stephen Hemminger <shemminger@linux-foundation.org>
  */
 
 #include <stdio.h>
@@ -30,22 +23,20 @@
 static void explain(void)
 {
 	fprintf(stderr,
-		"Usage: ... netem	[ limit PACKETS ]\n" \
-		"			[ delay TIME [ JITTER [CORRELATION]]]\n" \
-		"			[ distribution {uniform|normal|pareto|paretonormal} ]\n" \
-		"			[ corrupt PERCENT [CORRELATION]]\n" \
-		"			[ duplicate PERCENT [CORRELATION]]\n" \
-		"			[ loss random PERCENT [CORRELATION]]\n" \
-		"			[ loss state P13 [P31 [P32 [P23 P14]]]\n" \
-		"			[ loss gemodel PERCENT [R [1-H [1-K]]]\n" \
-		"			[ ecn ]\n" \
-		"			[ reorder PERCENT [CORRELATION] [ gap DISTANCE ]]\n" \
-		"			[ rate RATE [PACKETOVERHEAD] [CELLSIZE] [CELLOVERHEAD]]\n" \
-		"			[ slot MIN_DELAY [MAX_DELAY] [packets MAX_PACKETS]" \
-		" [bytes MAX_BYTES]]\n" \
-		"		[ slot distribution" \
-		" {uniform|normal|pareto|paretonormal|custom} DELAY JITTER" \
-		" [packets MAX_PACKETS] [bytes MAX_BYTES]]\n");
+		"Usage: ... netem [ limit PACKETS ]\n"
+		"                 [ delay TIME [ JITTER [CORRELATION]]]\n"
+		"                 [ distribution {uniform|normal|pareto|paretonormal} ]\n"
+		"                 [ corrupt PERCENT [CORRELATION]]\n"
+		"                 [ duplicate PERCENT [CORRELATION]]\n"
+		"                 [ loss random PERCENT [CORRELATION]]\n"
+		"                 [ loss state P13 [P31 [P32 [P23 P14]]]\n"
+		"                 [ loss gemodel PERCENT [R [1-H [1-K]]]\n"
+		"                 [ ecn ]\n"
+		"                 [ reorder PERCENT [CORRELATION] [ gap DISTANCE ]]\n"
+		"                 [ rate RATE [PACKETOVERHEAD] [CELLSIZE] [CELLOVERHEAD]]\n"
+		"                 [ slot MIN_DELAY [MAX_DELAY] [packets MAX_PACKETS] [bytes MAX_BYTES]]\n"
+		"                 [ slot distribution {uniform|normal|pareto|paretonormal|custom}\n"
+		"                   DELAY JITTER [packets MAX_PACKETS] [bytes MAX_BYTES]]\n");
 }
 
 static void explain1(const char *arg)
@@ -138,7 +129,8 @@ static int get_distribution(const char *type, __s16 *data, int maxdata)
 	char name[128];
 
 	snprintf(name, sizeof(name), "%s/%s.dist", get_tc_lib(), type);
-	if ((f = fopen(name, "r")) == NULL) {
+	f = fopen(name, "r");
+	if (f == NULL) {
 		fprintf(stderr, "No distribution data for %s (%s: %s)\n",
 			type, name, strerror(errno));
 		return -1;
@@ -175,8 +167,10 @@ static int get_distribution(const char *type, __s16 *data, int maxdata)
 #define NEXT_IS_SIGNED_NUMBER() \
 	(NEXT_ARG_OK() && (isdigit(argv[1][0]) || argv[1][0] == '-'))
 
-/* Adjust for the fact that psched_ticks aren't always usecs
-   (based on kernel PSCHED_CLOCK configuration */
+/*
+ * Adjust for the fact that psched_ticks aren't always usecs
+ *  (based on kernel PSCHED_CLOCK configuration
+ */
 static int get_ticks(__u32 *ticks, const char *str)
 {
 	unsigned int t;
@@ -258,7 +252,7 @@ static int netem_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 
 			if (!strcmp(*argv, "random")) {
 				NEXT_ARG();
-			random_loss_model:
+random_loss_model:
 				if (get_percent(&opt.loss, *argv)) {
 					explain1("loss percent");
 					return -1;
@@ -523,6 +517,7 @@ static int netem_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 			if (NEXT_ARG_OK() &&
 			    matches(*(argv+1), "bytes") == 0) {
 				unsigned int max_bytes;
+
 				NEXT_ARG();
 				if (!NEXT_ARG_OK() ||
 				    get_size(&max_bytes, *(argv+1))) {
@@ -532,11 +527,9 @@ static int netem_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 				slot.max_bytes = (int) max_bytes;
 				NEXT_ARG();
 			}
-		} else if (strcmp(*argv, "help") == 0) {
-			explain();
-			return -1;
 		} else {
-			fprintf(stderr, "What is \"%s\"?\n", *argv);
+			if (strcmp(*argv, "help") != 0)
+				fprintf(stderr, "What is \"%s\"?\n", *argv);
 			explain();
 			return -1;
 		}
-- 
2.30.2

