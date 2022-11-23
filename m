Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14CE9634E30
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 04:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235137AbiKWDDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 22:03:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235493AbiKWDDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 22:03:16 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C380013F83
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 19:02:59 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id y10so14280055plp.3
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 19:02:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TP7s9Y9Q2KQLZ/1+LnRi+cOoQZPAG76X0n534nrf4IE=;
        b=UI78rJmTRMKEo+3UdGlo5iwGgHPFWMdcIGEv14yfM8JLJCQIjzjC86pP5iCdDDx/Mw
         doXtNM/Lz994Ghjh0Sry2RFlmzXHJnMB8rsMZDhEGNRQR5aSY0/Ad25icHuwO4ny1kZ4
         +wunorTqBK21TNy7jC6swEO/ef6QRxoH+HnkZ6S7mzSA9RbD0nSuaIMcpif8Yp2SRcY6
         cvraYxMdqWm4B0mnn12Huj/PPWfbsMDAqXhaLAYgujOXBCVRrbFKLPUfAuWt21GvdkBt
         JsCXJ/TnOpa+TDEqQRKBhHB4RSFRlJjqjDvaHJeNitVUTyGjsIUVUpQImqIS8CA0pt8C
         WZZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TP7s9Y9Q2KQLZ/1+LnRi+cOoQZPAG76X0n534nrf4IE=;
        b=Je3ScS/0yVgtMbvN1FI7/CURBqwNWYfZ7mmj7VDnLFga8FA5RTyKJ+m1WQIr2bfERK
         HjJeJeVjHSuIl1FGm7F9760m5jIhZ5V6f01BcwjGhEH5XNSy53WmZ/yAytnH/ks5ED17
         yQBfrNyVHwdXAtTcVb4jso1i4rl18lMW4+x/D0tF8/q+BApuXrcWMEs9SomNEiYfOgt4
         05tWFghZYexkiTGHJarXZdBr4e5fM5Pm6ytfvdKGbFy5N3teltYfWD9tOduu5H3JKapo
         qP5Zrw93jDxawxmHWj8OEXSbRJhYqeDbgPDnwjxn3sJaL+R5jBl3OygZU9NqG1Y4sDhC
         IppA==
X-Gm-Message-State: ANoB5pkIEcQ81P3ZBAViLX8zkVbVxIRHFX/3iLYJRR4k2F1KRWov+ZyD
        Qt3eQB9DEwKav4LQpIlfqXiTid1bx+9+JKR0
X-Google-Smtp-Source: AA0mqf6d2axTO36wBTqurwSIKZeHIgC0onIwBz6kwbxaphmjWljl6Oaz4ScVp+URWQJv1iwGvxQMXw==
X-Received: by 2002:a17:903:2441:b0:189:3d5e:1b0 with SMTP id l1-20020a170903244100b001893d5e01b0mr2614138pls.34.1669172578710;
        Tue, 22 Nov 2022 19:02:58 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id s2-20020a170902a50200b00187022627d7sm12736252plq.36.2022.11.22.19.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 19:02:57 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2] remove #if 0 code
Date:   Tue, 22 Nov 2022 19:02:56 -0800
Message-Id: <20221123030256.63229-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.35.1
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

Let's not keep unused code. The YAGNI means that this dead
code doesn't work now, and if it did it would have to change.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 ip/ipmroute.c   | 12 +-----------
 ip/xfrm_state.c | 11 -----------
 tc/p_icmp.c     | 24 ------------------------
 tc/q_gred.c     |  3 +--
 tc/tc_class.c   |  4 ----
 5 files changed, 2 insertions(+), 52 deletions(-)

diff --git a/ip/ipmroute.c b/ip/ipmroute.c
index 981baf2acd94..32019c944c52 100644
--- a/ip/ipmroute.c
+++ b/ip/ipmroute.c
@@ -39,9 +39,6 @@ static void usage(void)
 		"Usage: ip mroute show [ [ to ] PREFIX ] [ from PREFIX ] [ iif DEVICE ]\n"
 		"                      [ table TABLE_ID ]\n"
 		"TABLE_ID := [ local | main | default | all | NUMBER ]\n"
-#if 0
-	"Usage: ip mroute [ add | del ] DESTINATION from SOURCE [ iif DEVICE ] [ oif DEVICE ]\n"
-#endif
 	);
 	exit(-1);
 }
@@ -322,14 +319,7 @@ int do_multiroute(int argc, char **argv)
 {
 	if (argc < 1)
 		return mroute_list(0, NULL);
-#if 0
-	if (matches(*argv, "add") == 0)
-		return mroute_modify(RTM_NEWADDR, argc-1, argv+1);
-	if (matches(*argv, "delete") == 0)
-		return mroute_modify(RTM_DELADDR, argc-1, argv+1);
-	if (matches(*argv, "get") == 0)
-		return mroute_get(argc-1, argv+1);
-#endif
+
 	if (matches(*argv, "list") == 0 || matches(*argv, "show") == 0
 	    || matches(*argv, "lst") == 0)
 		return mroute_list(argc-1, argv+1);
diff --git a/ip/xfrm_state.c b/ip/xfrm_state.c
index 6fee7efd18c7..b2294d9fe58f 100644
--- a/ip/xfrm_state.c
+++ b/ip/xfrm_state.c
@@ -124,11 +124,6 @@ static int xfrm_algo_parse(struct xfrm_algo *alg, enum xfrm_attr_type_t type,
 	int len;
 	int slen = strlen(key);
 
-#if 0
-	/* XXX: verifying both name and key is required! */
-	fprintf(stderr, "warning: ALGO-NAME/ALGO-KEYMAT values will be sent to the kernel promiscuously! (verifying them isn't implemented yet)\n");
-#endif
-
 	strlcpy(alg->alg_name, name, sizeof(alg->alg_name));
 
 	if (slen > 2 && strncmp(key, "0x", 2) == 0) {
@@ -791,12 +786,6 @@ static int xfrm_state_allocspi(int argc, char **argv)
 		.n.nlmsg_flags = NLM_F_REQUEST,
 		.n.nlmsg_type = XFRM_MSG_ALLOCSPI,
 		.xspi.info.family = preferred_family,
-#if 0
-		.xspi.lft.soft_byte_limit = XFRM_INF,
-		.xspi.lft.hard_byte_limit = XFRM_INF,
-		.xspi.lft.soft_packet_limit = XFRM_INF,
-		.xspi.lft.hard_packet_limit = XFRM_INF,
-#endif
 	};
 	char *idp = NULL;
 	char *minp = NULL;
diff --git a/tc/p_icmp.c b/tc/p_icmp.c
index 15ce32309e39..933ca8a5ff1e 100644
--- a/tc/p_icmp.c
+++ b/tc/p_icmp.c
@@ -27,31 +27,7 @@ static int
 parse_icmp(int *argc_p, char ***argv_p,
 	   struct m_pedit_sel *sel, struct m_pedit_key *tkey)
 {
-	int res = -1;
-#if 0
-	int argc = *argc_p;
-	char **argv = *argv_p;
-
-	if (argc < 2)
-		return -1;
-
-	if (strcmp(*argv, "type") == 0) {
-		NEXT_ARG();
-		res = parse_u8(&argc, &argv, 0);
-		goto done;
-	}
-	if (strcmp(*argv, "code") == 0) {
-		NEXT_ARG();
-		res = parse_u8(&argc, &argv, 1);
-		goto done;
-	}
 	return -1;
-
-done:
-	*argc_p = argc;
-	*argv_p = argv;
-#endif
-	return res;
 }
 
 struct m_pedit_util p_pedit_icmp = {
diff --git a/tc/q_gred.c b/tc/q_gred.c
index 89aeb086038f..01f12eeeffad 100644
--- a/tc/q_gred.c
+++ b/tc/q_gred.c
@@ -27,8 +27,7 @@
 
 #include "tc_red.h"
 
-
-#if 0
+#ifdef DEBUG
 #define DPRINTF(format, args...) fprintf(stderr, format, ##args)
 #else
 #define DPRINTF(format, args...)
diff --git a/tc/tc_class.c b/tc/tc_class.c
index 39bea9712dda..b3e7c92491e0 100644
--- a/tc/tc_class.c
+++ b/tc/tc_class.c
@@ -474,10 +474,6 @@ int do_class(int argc, char **argv)
 		return tc_class_modify(RTM_NEWTCLASS, NLM_F_CREATE, argc-1, argv+1);
 	if (matches(*argv, "delete") == 0)
 		return tc_class_modify(RTM_DELTCLASS, 0,  argc-1, argv+1);
-#if 0
-	if (matches(*argv, "get") == 0)
-		return tc_class_get(RTM_GETTCLASS, 0,  argc-1, argv+1);
-#endif
 	if (matches(*argv, "list") == 0 || matches(*argv, "show") == 0
 	    || matches(*argv, "lst") == 0)
 		return tc_class_list(argc-1, argv+1);
-- 
2.35.1

