Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12C174A55EA
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 05:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233451AbiBAE20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 23:28:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233450AbiBAE2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 23:28:24 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C18C061714
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 20:28:24 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id l13so5723168plg.9
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 20:28:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rlG4REPOvHPZswdOoTuu1A8AEMNjKEsA0Bsepvhgcvs=;
        b=l450vmeV10TGSXR3/Pwka9DfQNr4fvuBp1Fmny/U6ELJ4BZAWV5lwnmo95K05ZePNW
         xRNq1vVfRXE/opYB8FEWkP1T1DvwhMBTnQu8/F0l/q2ExkXeZ3GpLTQElzRyADxmrK2p
         DijPRe/0CYleTreJvdClfmbhpR87k0hrMgef5WpgYlq4QaMFoXd34Jh3kNthgStOUp/Q
         wcYPaZFqw57cMu0UEqAZMv9JB4mKKETKvW1KrK0AkIzKIDas3CpqgfWrGAadfFnAs5hU
         IUKpEm95te47iJkhxOk7VlVYZh77yfMC9tIJJRpcBEyxyilV4lhf0QxG7EZ4+0p4Invo
         RdvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rlG4REPOvHPZswdOoTuu1A8AEMNjKEsA0Bsepvhgcvs=;
        b=VqMna/02dskF+YjgD44KyrHeJA3slg44NKVl9QL9fg0GtJH/Q1gMxJJd4sRJYWVrlj
         Y613HvuoFDZ1S7VOi7YslAweiimCH/U2i5xzfHTFI6PsNcWPl7W4O1stb0CL/0BApld1
         jkkJJlybrTUrD+YflPSd1fO1myd2lLDpCSJLe3kwjrmE8aGpDTasRPXHL9bV4tsp59DU
         pVRsVX6q9s/AwjkEr1gXSpBwoka4kkKwvccqRY0hIeTTe6MDwMmDypu9kUTR/nh/ULxB
         hB1T/NWY2x/98ZtE78srEIoRbHvsLqTFMx+TucF3PcNTyQNYLkouvzjxBmwxDue1ZEhl
         vSrg==
X-Gm-Message-State: AOAM531WNmF/DGQ6x7iQorgllnpsHksyMa8BlH3WQ4CYSkm60cmIXjGA
        VqmL6h0aloURa5Sffzo0C6hi7g==
X-Google-Smtp-Source: ABdhPJyySmsN7f5ghhdyHU4AHztHc7y7mm2rdVWKzxohS4/HI+Z6tCM8l9801eke6i0KInOQ1T1kEQ==
X-Received: by 2002:a17:90b:911:: with SMTP id bo17mr221796pjb.165.1643689704260;
        Mon, 31 Jan 2022 20:28:24 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id l8sm20441335pfc.187.2022.01.31.20.28.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 20:28:23 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     dsahern@gmail.com
Cc:     netdev@vger.kernel.org, Victor Nogueira <victor@mojatatu.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next 2/2] tc/f_flower: fix indentation
Date:   Mon, 31 Jan 2022 20:28:19 -0800
Message-Id: <20220201042819.322106-2-stephen@networkplumber.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220201042819.322106-1-stephen@networkplumber.org>
References: <CA+NMeC-uzWxn182SfF57e7xjXUdLmJV7fV0VN2a681LCh95R5g@mail.gmail.com>
 <20220201042819.322106-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce print_indent_name_value to do the indented style
used in flower.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
This was in second version of clang patches but missed during merge.

 tc/f_flower.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/tc/f_flower.c b/tc/f_flower.c
index 674e0d0384db..d3f79bdf4252 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -102,6 +102,13 @@ static void explain(void)
 		"	to specify different mask, he has to use different prio.\n");
 }
 
+/* prints newline, two spaces, name/value */
+static void print_indent_name_value(const char *name, const char *value)
+{
+	print_string(PRINT_FP, NULL, "%s  ", _SL_);
+	print_string_name_value(name, value);
+}
+
 static int flower_parse_eth_addr(char *str, int addr_type, int mask_type,
 				 struct nlmsghdr *n)
 {
@@ -1945,8 +1952,7 @@ static void flower_print_eth_addr(const char *name, struct rtattr *addr_attr,
 			sprintf(out + done, "/%d", bits);
 	}
 
-	print_nl();
-	print_string_name_value(name, out);
+	print_indent_name_value(name, out);
 }
 
 static void flower_print_eth_type(__be16 *p_eth_type,
@@ -2089,8 +2095,7 @@ static void flower_print_ip_addr(char *name, __be16 eth_type,
 	else if (bits < len * 8)
 		sprintf(out + done, "/%d", bits);
 
-	print_nl();
-	print_string_name_value(name, out);
+	print_indent_name_value(name, out);
 }
 
 static void flower_print_ip4_addr(char *name, struct rtattr *addr_attr,
@@ -2123,8 +2128,7 @@ static void flower_print_port_range(char *name, struct rtattr *min_attr,
 
 		done = sprintf(out, "%u", rta_getattr_be16(min_attr));
 		sprintf(out + done, "-%u", rta_getattr_be16(max_attr));
-		print_nl();
-		print_string_name_value(name, out);
+		print_indent_name_value(name, out);
 	}
 }
 
@@ -2141,8 +2145,7 @@ static void flower_print_tcp_flags(const char *name, struct rtattr *flags_attr,
 	if (mask_attr)
 		sprintf(out + done, "/%x", rta_getattr_be16(mask_attr));
 
-	print_nl();
-	print_string_name_value(name, out);
+	print_indent_name_value(name, out);
 }
 
 static void flower_print_ct_state(struct rtattr *flags_attr,
@@ -2438,8 +2441,7 @@ static void flower_print_masked_u8(const char *name, struct rtattr *attr,
 	if (mask != UINT8_MAX)
 		sprintf(out + done, "/%d", mask);
 
-	print_nl();
-	print_string_name_value(name, out);
+	print_indent_name_value(name, out);
 }
 
 static void flower_print_u8(const char *name, struct rtattr *attr)
-- 
2.34.1

