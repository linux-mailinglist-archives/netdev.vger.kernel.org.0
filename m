Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF89054FC18
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 19:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383206AbiFQRUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 13:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234564AbiFQRT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 13:19:59 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA5EDB85D
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 10:19:58 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id w21so4727537pfc.0
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 10:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y5E+f8DixtatyJl/1R9t+fbyxOazWNOgNfue3k/7yyQ=;
        b=atF/RFrGoxmpi6DMASC7o8rww1n099h7JdEgNK0mPyImiKX7lYcbQnA55oRwqYpx0K
         P3G1mOSs14UR48bwmgRwijSga7H9e0mnRegzj7K8cg923s84b4tRU2xqMpRYSsJWC3DB
         m6jgTYeURQRubCJvwTPKFa76LZBhYdtSv4uec44+t7KNsIb8oy3uZkjiypf5aOGvOEEK
         Hqq4f6F6IN1HCXIHKu0sTToaukg1xcRuZtGmAervFiuauO8BWlBiLPFWt9TGgp0iyy/f
         g1X7eHhWeYaLulcLXM2urHtOXbcABCuQx1L3TAR8v2Y5j0bMD6IJqebxxXndQoS4newc
         VyGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y5E+f8DixtatyJl/1R9t+fbyxOazWNOgNfue3k/7yyQ=;
        b=zheLvUo9PpArTL7ueqYFrfo3loVDqcG8FkZpepfTfCkasUn+LQ5wieGCC7wxEqR+px
         wReun+UYcmCfgNXhm2gAHI2amf/mtfkVGAMcdW5iLszRQuPb/cTV6h+ewihCwFktRMCY
         T4uZX1oIKmMPRZ1Pjv1XEhic3f33eJxqLzSIpd2vHeTYkHMBPXdwfyrslcPQb+dHaROD
         iMpb8L4PCDsncy9FJUgTxlunlg1lU2K4+fiKXUwbOF/5RSqfQDvLe2F/F+2p2l50kUqN
         glWtsiangWoDG2Jxwj6mQ3zqz53xDeNXiC9p7o7AQhbTNW2WXndCLHC13RzWydiFJ56Z
         p4PA==
X-Gm-Message-State: AJIora/MBpLLPUvdgHuzRsfqN8HrP34Grnw3Rq3srwQluvvQvQ865vO3
        itVclZn49DUFsLlMt1D5Tz0UEuDwEpsQsxmw
X-Google-Smtp-Source: AGRyM1seb/fdi43txqxqLSICZW1eWXyioLy3uBoNRKBmIX4mqcznyW67YYqKZHznUv7TH+VveGhRqQ==
X-Received: by 2002:a63:d57:0:b0:3fd:ac2b:75aa with SMTP id 23-20020a630d57000000b003fdac2b75aamr9705500pgn.533.1655486398023;
        Fri, 17 Jun 2022 10:19:58 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id o26-20020a63921a000000b00408a3724b38sm4074714pgd.76.2022.06.17.10.19.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 10:19:57 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 2/2] tc: declaration hides parameter
Date:   Fri, 17 Jun 2022 10:19:53 -0700
Message-Id: <20220617171953.38720-3-stephen@networkplumber.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220617171953.38720-1-stephen@networkplumber.org>
References: <20220617171953.38720-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In several places (code reuse?), the variable handle is a parameter
to the function, but then is defined inside basic block for classid.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 tc/f_basic.c    |  6 +++---
 tc/f_bpf.c      |  6 +++---
 tc/f_flower.c   | 14 +++++++-------
 tc/f_fw.c       |  6 +++---
 tc/f_matchall.c |  6 +++---
 tc/f_route.c    |  6 +++---
 tc/f_rsvp.c     |  6 +++---
 7 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/tc/f_basic.c b/tc/f_basic.c
index 7b19cea6e87e..9a60758e803e 100644
--- a/tc/f_basic.c
+++ b/tc/f_basic.c
@@ -70,14 +70,14 @@ static int basic_parse_opt(struct filter_util *qu, char *handle,
 			continue;
 		} else if (matches(*argv, "classid") == 0 ||
 			   strcmp(*argv, "flowid") == 0) {
-			unsigned int handle;
+			unsigned int classid;
 
 			NEXT_ARG();
-			if (get_tc_classid(&handle, *argv)) {
+			if (get_tc_classid(&classid, *argv)) {
 				fprintf(stderr, "Illegal \"classid\"\n");
 				return -1;
 			}
-			addattr_l(n, MAX_MSG, TCA_BASIC_CLASSID, &handle, 4);
+			addattr_l(n, MAX_MSG, TCA_BASIC_CLASSID, &classid, 4);
 		} else if (matches(*argv, "action") == 0) {
 			NEXT_ARG();
 			if (parse_action(&argc, &argv, TCA_BASIC_ACT, n)) {
diff --git a/tc/f_bpf.c b/tc/f_bpf.c
index fa3552aefffd..96e4576aa2f8 100644
--- a/tc/f_bpf.c
+++ b/tc/f_bpf.c
@@ -126,14 +126,14 @@ opt_bpf:
 			bpf_uds_name = cfg.uds;
 		} else if (matches(*argv, "classid") == 0 ||
 			   matches(*argv, "flowid") == 0) {
-			unsigned int handle;
+			unsigned int classid;
 
 			NEXT_ARG();
-			if (get_tc_classid(&handle, *argv)) {
+			if (get_tc_classid(&classid, *argv)) {
 				fprintf(stderr, "Illegal \"classid\"\n");
 				return -1;
 			}
-			addattr32(n, MAX_MSG, TCA_BPF_CLASSID, handle);
+			addattr32(n, MAX_MSG, TCA_BPF_CLASSID, classid);
 		} else if (matches(*argv, "direct-action") == 0 ||
 			   matches(*argv, "da") == 0) {
 			bpf_flags |= TCA_BPF_FLAG_ACT_DIRECT;
diff --git a/tc/f_flower.c b/tc/f_flower.c
index 805ca6718fa7..622ec321f310 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -1452,17 +1452,17 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
 	while (argc > 0) {
 		if (matches(*argv, "classid") == 0 ||
 		    matches(*argv, "flowid") == 0) {
-			unsigned int handle;
+			unsigned int classid;
 
 			NEXT_ARG();
-			ret = get_tc_classid(&handle, *argv);
+			ret = get_tc_classid(&classid, *argv);
 			if (ret) {
 				fprintf(stderr, "Illegal \"classid\"\n");
 				return -1;
 			}
-			addattr_l(n, MAX_MSG, TCA_FLOWER_CLASSID, &handle, 4);
+			addattr_l(n, MAX_MSG, TCA_FLOWER_CLASSID, &classid, 4);
 		} else if (matches(*argv, "hw_tc") == 0) {
-			unsigned int handle;
+			unsigned int classid;
 			__u32 tc;
 			char *end;
 
@@ -1476,10 +1476,10 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
 				fprintf(stderr, "TC index exceeds max range\n");
 				return -1;
 			}
-			handle = TC_H_MAKE(TC_H_MAJ(t->tcm_parent),
+			classid = TC_H_MAKE(TC_H_MAJ(t->tcm_parent),
 					   TC_H_MIN(tc + TC_H_MIN_PRIORITY));
-			addattr_l(n, MAX_MSG, TCA_FLOWER_CLASSID, &handle,
-				  sizeof(handle));
+			addattr_l(n, MAX_MSG, TCA_FLOWER_CLASSID, &classid,
+				  sizeof(classid));
 		} else if (matches(*argv, "ip_flags") == 0) {
 			NEXT_ARG();
 			ret = flower_parse_matching_flags(*argv,
diff --git a/tc/f_fw.c b/tc/f_fw.c
index 688364f55d1d..3c6ea93d2944 100644
--- a/tc/f_fw.c
+++ b/tc/f_fw.c
@@ -70,14 +70,14 @@ static int fw_parse_opt(struct filter_util *qu, char *handle, int argc, char **a
 	while (argc > 0) {
 		if (matches(*argv, "classid") == 0 ||
 		    matches(*argv, "flowid") == 0) {
-			unsigned int handle;
+			unsigned int classid;
 
 			NEXT_ARG();
-			if (get_tc_classid(&handle, *argv)) {
+			if (get_tc_classid(&classid, *argv)) {
 				fprintf(stderr, "Illegal \"classid\"\n");
 				return -1;
 			}
-			addattr_l(n, 4096, TCA_FW_CLASSID, &handle, 4);
+			addattr_l(n, 4096, TCA_FW_CLASSID, &classid, 4);
 		} else if (matches(*argv, "police") == 0) {
 			NEXT_ARG();
 			if (parse_police(&argc, &argv, TCA_FW_POLICE, n)) {
diff --git a/tc/f_matchall.c b/tc/f_matchall.c
index 253ed5ce42e0..231d749e1f43 100644
--- a/tc/f_matchall.c
+++ b/tc/f_matchall.c
@@ -63,14 +63,14 @@ static int matchall_parse_opt(struct filter_util *qu, char *handle,
 	while (argc > 0) {
 		if (matches(*argv, "classid") == 0 ||
 			   strcmp(*argv, "flowid") == 0) {
-			unsigned int handle;
+			unsigned int classid;
 
 			NEXT_ARG();
-			if (get_tc_classid(&handle, *argv)) {
+			if (get_tc_classid(&classid, *argv)) {
 				fprintf(stderr, "Illegal \"classid\"\n");
 				return -1;
 			}
-			addattr_l(n, MAX_MSG, TCA_MATCHALL_CLASSID, &handle, 4);
+			addattr_l(n, MAX_MSG, TCA_MATCHALL_CLASSID, &classid, 4);
 		} else if (matches(*argv, "action") == 0) {
 			NEXT_ARG();
 			if (parse_action(&argc, &argv, TCA_MATCHALL_ACT, n)) {
diff --git a/tc/f_route.c b/tc/f_route.c
index 31fa96a0565e..ad516b382ac0 100644
--- a/tc/f_route.c
+++ b/tc/f_route.c
@@ -91,14 +91,14 @@ static int route_parse_opt(struct filter_util *qu, char *handle, int argc, char
 			fh |= (0x8000|id)<<16;
 		} else if (matches(*argv, "classid") == 0 ||
 			   strcmp(*argv, "flowid") == 0) {
-			unsigned int handle;
+			unsigned int classid;
 
 			NEXT_ARG();
-			if (get_tc_classid(&handle, *argv)) {
+			if (get_tc_classid(&classid, *argv)) {
 				fprintf(stderr, "Illegal \"classid\"\n");
 				return -1;
 			}
-			addattr_l(n, 4096, TCA_ROUTE4_CLASSID, &handle, 4);
+			addattr_l(n, 4096, TCA_ROUTE4_CLASSID, &classid, 4);
 		} else if (matches(*argv, "police") == 0) {
 			NEXT_ARG();
 			if (parse_police(&argc, &argv, TCA_ROUTE4_POLICE, n)) {
diff --git a/tc/f_rsvp.c b/tc/f_rsvp.c
index 388e9ee59ad3..0211c3f5e74b 100644
--- a/tc/f_rsvp.c
+++ b/tc/f_rsvp.c
@@ -230,14 +230,14 @@ static int rsvp_parse_opt(struct filter_util *qu, char *handle, int argc,
 			pinfo_ok++;
 		} else if (matches(*argv, "classid") == 0 ||
 			   strcmp(*argv, "flowid") == 0) {
-			unsigned int handle;
+			unsigned int classid;
 
 			NEXT_ARG();
-			if (get_tc_classid(&handle, *argv)) {
+			if (get_tc_classid(&classid, *argv)) {
 				fprintf(stderr, "Illegal \"classid\"\n");
 				return -1;
 			}
-			addattr_l(n, 4096, TCA_RSVP_CLASSID, &handle, 4);
+			addattr_l(n, 4096, TCA_RSVP_CLASSID, &classid, 4);
 		} else if (strcmp(*argv, "tunnelid") == 0) {
 			unsigned int tid;
 
-- 
2.35.1

