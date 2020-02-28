Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD2D174196
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 22:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbgB1Vm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 16:42:57 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46971 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbgB1Vm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 16:42:57 -0500
Received: by mail-pg1-f194.google.com with SMTP id y30so2147779pga.13
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 13:42:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rxl8Z4zjv55KVDE1T0Q9cCSbbPKGHOJh2+MBJXLfJN4=;
        b=11NAhYaWqFPw06BFkTIlJ3qxgihL4rYe0scKY7fTZM4rZS2TnwUObpwM8IwugzledV
         kHLrIpNsASrpvRNgBOci3GoTi11Ok9kO7e/cZtu2Y1Etc565+0SsmPJcOJmywH8nrniX
         9hHpTZwLqYE1wFjYJnOv/pB1mW5NBCYZ70XUvkGdLhjcMXeKS2DmE4/SFSWSzOubUc1j
         r1zv7WMRUN+PH1+WkMO03fUq+v/isEBdjJM0xaUpJaSiBMlVqAVyxLQBXLwvtCHgb+Fd
         8IMF4Ha4C5FodENbVqXTiPKTv+vr4COkilO2Vt70XTSM4AXXKKdx3i4Xbk2l0U8R3cdz
         tCqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rxl8Z4zjv55KVDE1T0Q9cCSbbPKGHOJh2+MBJXLfJN4=;
        b=QvH6IQmxvqEup0WT/h45+VBw0vsCi5OHqIE2M4141f2KsTHVVxCkXWCwEiapl87q2I
         I1vFiDuj2LYCjPT27b9UBRBduz1lUjmUn9k2LbYbuZmfvEkjoHU/6zaBbnU8ZKVwaCry
         9Z5/ci45vE3Wd3hcGvjYA6iUh2QMXbdDBjVBxANZy+oTBzedPVBzlE1f0gxUZnryea4Y
         wpWI8cRV8qH+kwpeBGV/eUarf8/4+7I2gPcpEcb2k25QjeCaUIKRURTwFQqHZv6Rfs0v
         msSdB/TZdilkTc67MvF9FjH9ktLgeJk3Y92QKynVEjY96V/voaz/4qVlL9zY5SX3QKOS
         oZDg==
X-Gm-Message-State: ANhLgQ2XcJVAeVSuLZb3VVcPh1ukI+RDgAXXZbKspvWrEeX2VgxTQhqo
        +Uzaca6qTLEq+JkSF5X1kkSo6RVTB00=
X-Google-Smtp-Source: ADFU+vsxMPjkxCN3PuAn3vql1/zyofv+aXYUy9Q/2aOimty/gqn8/lJsJDlZRTMQ/7jB/Q2vhtf3nw==
X-Received: by 2002:aa7:8d82:: with SMTP id i2mr340128pfr.179.1582926174243;
        Fri, 28 Feb 2020 13:42:54 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id u41sm11856780pgn.8.2020.02.28.13.42.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 13:42:53 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 2/2] ss: indentation in ssfilter
Date:   Fri, 28 Feb 2020 13:42:43 -0800
Message-Id: <20200228214243.27344-2-stephen@networkplumber.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200228214243.27344-1-stephen@networkplumber.org>
References: <20200228214243.27344-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Indent switch statement like kernel.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 misc/ss.c | 46 ++++++++++++++++++++++------------------------
 1 file changed, 22 insertions(+), 24 deletions(-)

diff --git a/misc/ss.c b/misc/ss.c
index b478ab47da4e..40b55d8bdd82 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -1806,15 +1806,14 @@ static void ssfilter_patch(char *a, int len, int reloc)
 static int ssfilter_bytecompile(struct ssfilter *f, char **bytecode)
 {
 	switch (f->type) {
-		case SSF_S_AUTO:
-	{
+	case SSF_S_AUTO: {
 		if (!(*bytecode = malloc(4))) abort();
 		((struct inet_diag_bc_op *)*bytecode)[0] = (struct inet_diag_bc_op){ INET_DIAG_BC_AUTO, 4, 8 };
 		return 4;
 	}
-		case SSF_DCOND:
-		case SSF_SCOND:
-	{
+
+	case SSF_DCOND:
+	case SSF_SCOND:	{
 		struct aafilter *a = (void *)f->pred;
 		struct aafilter *b;
 		char *ptr;
@@ -1852,8 +1851,8 @@ static int ssfilter_bytecompile(struct ssfilter *f, char **bytecode)
 		}
 		return ptr - *bytecode;
 	}
-		case SSF_D_GE:
-	{
+
+	case SSF_D_GE: {
 		struct aafilter *x = (void *)f->pred;
 
 		if (!(*bytecode = malloc(8))) abort();
@@ -1861,8 +1860,8 @@ static int ssfilter_bytecompile(struct ssfilter *f, char **bytecode)
 		((struct inet_diag_bc_op *)*bytecode)[1] = (struct inet_diag_bc_op){ 0, 0, x->port };
 		return 8;
 	}
-		case SSF_D_LE:
-	{
+
+	case SSF_D_LE: {
 		struct aafilter *x = (void *)f->pred;
 
 		if (!(*bytecode = malloc(8))) abort();
@@ -1870,8 +1869,8 @@ static int ssfilter_bytecompile(struct ssfilter *f, char **bytecode)
 		((struct inet_diag_bc_op *)*bytecode)[1] = (struct inet_diag_bc_op){ 0, 0, x->port };
 		return 8;
 	}
-		case SSF_S_GE:
-	{
+
+	case SSF_S_GE: {
 		struct aafilter *x = (void *)f->pred;
 
 		if (!(*bytecode = malloc(8))) abort();
@@ -1879,8 +1878,7 @@ static int ssfilter_bytecompile(struct ssfilter *f, char **bytecode)
 		((struct inet_diag_bc_op *)*bytecode)[1] = (struct inet_diag_bc_op){ 0, 0, x->port };
 		return 8;
 	}
-		case SSF_S_LE:
-	{
+	case SSF_S_LE: {
 		struct aafilter *x = (void *)f->pred;
 
 		if (!(*bytecode = malloc(8))) abort();
@@ -1889,8 +1887,7 @@ static int ssfilter_bytecompile(struct ssfilter *f, char **bytecode)
 		return 8;
 	}
 
-		case SSF_AND:
-	{
+	case SSF_AND: {
 		char *a1 = NULL, *a2 = NULL, *a;
 		int l1, l2;
 
@@ -1909,8 +1906,8 @@ static int ssfilter_bytecompile(struct ssfilter *f, char **bytecode)
 		*bytecode = a;
 		return l1+l2;
 	}
-		case SSF_OR:
-	{
+
+	case SSF_OR: {
 		char *a1 = NULL, *a2 = NULL, *a;
 		int l1, l2;
 
@@ -1929,8 +1926,8 @@ static int ssfilter_bytecompile(struct ssfilter *f, char **bytecode)
 		*bytecode = a;
 		return l1+l2+4;
 	}
-		case SSF_NOT:
-	{
+
+	case SSF_NOT: {
 		char *a1 = NULL, *a;
 		int l1;
 
@@ -1946,13 +1943,13 @@ static int ssfilter_bytecompile(struct ssfilter *f, char **bytecode)
 		*bytecode = a;
 		return l1+4;
 	}
-		case SSF_DEVCOND:
-	{
+
+	case SSF_DEVCOND: {
 		/* bytecompile for SSF_DEVCOND not supported yet */
 		return 0;
 	}
-		case SSF_MARKMASK:
-	{
+
+	case SSF_MARKMASK: {
 		struct aafilter *a = (void *)f->pred;
 		struct instr {
 			struct inet_diag_bc_op op;
@@ -1968,7 +1965,8 @@ static int ssfilter_bytecompile(struct ssfilter *f, char **bytecode)
 
 		return inslen;
 	}
-		default:
+
+	default:
 		abort();
 	}
 }
-- 
2.20.1

