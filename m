Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82EF5491EC2
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 06:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiARFFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 00:05:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiARFFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 00:05:17 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A54C061574
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 21:05:17 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id q25so6316336pfl.8
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 21:05:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pgHBVqzyss5z67PjOd+ce1TqPbJGOrA2LTgEJUVAU04=;
        b=1qeL+mYH8QS9g/RME3UDJ3ZDiFr5snEElkBOfQWpjN2s7DpUbfSVAzYsiYCyFvbm+4
         99jCL3AtNAjXnx25AHwfFV68U0WXwMGCicDrgEO7hikTjy1TBVS3VpLd2u5C1s0007/V
         lodqr91lWsylRwds9C5sl4UhA+Yj0TRzad8QIPgEeNHJbOw/3PfCVSfPIzMot7h4soH4
         OgmZ/dB020pZNAS28NQEWhMOf7tw13GMQdRfHtuxcM6w59tFgy0t49Z314M/vAHGvlmV
         JrMotWqcgNmKTIuhpc2r5myWzxzXO/nKoOBdQnVnSoqC4Wyz68WMz6L2gqlLQLS3V8cP
         yCgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pgHBVqzyss5z67PjOd+ce1TqPbJGOrA2LTgEJUVAU04=;
        b=Y0S2g81QGxpNaKKFZpzG1JUKzJtapD+wwiR0jKmTNfjA7Lm+9J/LaJ0QPi4Ng6Pg3m
         gqGnfbYQm0fGQj93C38eHv1U9n9mmPuo1dkBnTLd4bSNRfr27iZEIQCGfuLRJTTEPLkH
         WwvOo5FcO71BREh7HNH+hdLBCuNKpzmVq+/V1LsGEhVoq/FZDfjtemCuOQnIAzPdZGU4
         hTZzQF2vVAmTv4OarRW9T/bjQqamr6edqQQ4BR57PFgoU+dcAiiARfgMQK3ZrMa/o4VN
         Ln4q4SoENUgt9n/9SAeiFGRTkqp2ticFzwCvR/bkq+hWlJtYPxS2rNucI0AQ6eRiz5zp
         6+Qw==
X-Gm-Message-State: AOAM531Enu03z4YWBhwGEB/E0lwkp397k0tqG0AmsAdwQ3W1Doi6gz/V
        WBDZCV8gYpuGehtae6KdEnaU3De3cYF3EQ==
X-Google-Smtp-Source: ABdhPJyE2qwJ9rZdks3/F8CbhSbj36Awn3GbwpBJZFpJiz5BItENrtwL4Nui++SW2yU3rNp4dR/jbA==
X-Received: by 2002:aa7:9483:0:b0:4bf:29d6:75a9 with SMTP id z3-20020aa79483000000b004bf29d675a9mr24334511pfk.36.1642482316328;
        Mon, 17 Jan 2022 21:05:16 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id j20sm14987664pfh.22.2022.01.17.21.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 21:05:15 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 2/2] f_flower: fix checkpatch warnings
Date:   Mon, 17 Jan 2022 21:05:12 -0800
Message-Id: <20220118050512.14198-2-stephen@networkplumber.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220118050512.14198-1-stephen@networkplumber.org>
References: <20220118050512.14198-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix minor whitespace and other easy to fix complaints from
checkpatch.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 tc/f_flower.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/tc/f_flower.c b/tc/f_flower.c
index 6d70b92a2894..728b280c708c 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -84,7 +84,7 @@ static void explain(void)
 		"			geneve_opts MASKED-OPTIONS |\n"
 		"			vxlan_opts MASKED-OPTIONS |\n"
 		"                       erspan_opts MASKED-OPTIONS |\n"
-		"			ip_flags IP-FLAGS | \n"
+		"			ip_flags IP-FLAGS |\n"
 		"			enc_dst_port [ port_number ] |\n"
 		"			ct_state MASKED_CT_STATE |\n"
 		"			ct_label MASKED_CT_LABEL |\n"
@@ -118,7 +118,7 @@ static int flower_parse_eth_addr(char *str, int addr_type, int mask_type,
 	addattr_l(n, MAX_MSG, addr_type, addr, sizeof(addr));
 
 	if (slash) {
-		unsigned bits;
+		unsigned int bits;
 
 		if (!get_unsigned(&bits, slash + 1, 10)) {
 			uint64_t mask;
@@ -529,8 +529,7 @@ static int flower_parse_u8(char *str, int value_type, int mask_type,
 		ret = get_u8(&mask, slash + 1, 10);
 		if (ret)
 			goto err;
-	}
-	else {
+	} else {
 		mask = UINT8_MAX;
 	}
 
@@ -1865,11 +1864,9 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
 				return -1;
 			}
 			continue;
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
@@ -1917,7 +1914,7 @@ static int __mask_bits(char *addr, size_t len)
 				bits++;
 			} else if (bits) {
 				hole = true;
-			} else{
+			} else {
 				return -1;
 			}
 		}
@@ -2780,8 +2777,7 @@ static int flower_print_opt(struct filter_util *qu, FILE *f,
 				print_uint(PRINT_ANY, "in_hw_count",
 					   " in_hw_count %u", count);
 			}
-		}
-		else if (flags & TCA_CLS_FLAGS_NOT_IN_HW) {
+		} else if (flags & TCA_CLS_FLAGS_NOT_IN_HW) {
 			print_nl();
 			print_bool(PRINT_ANY, "not_in_hw", "  not_in_hw", true);
 		}
-- 
2.30.2

