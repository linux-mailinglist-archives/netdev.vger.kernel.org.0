Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 284AB48CFB6
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 01:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiAMAa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 19:30:27 -0500
Received: from smtp-fw-80007.amazon.com ([99.78.197.218]:17417 "EHLO
        smtp-fw-80007.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbiAMAaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 19:30:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1642033823; x=1673569823;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=p0DyDQ+vWEwJliI3fARijsd3UJqqtNYA35ktKFWmfQA=;
  b=kcpZjaRKwim8JaBt6/nxEdznpqcU/OiSS7SMBcN72YavdSsYGGbHmOWE
   EHX19Jqh2AaAne2AvdTlZ4HlSuA7FxD5nnsiH7NTyyLoE83TCd29Dpx0Q
   VYrODu05vddTLfgfhp5eCO+jIE1ZXBGH4RdUnemt2OgelWDLdCrYlshIv
   I=;
X-IronPort-AV: E=Sophos;i="5.88,284,1635206400"; 
   d="scan'208";a="54982855"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-ccb3efe0.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 13 Jan 2022 00:30:21 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-ccb3efe0.us-east-1.amazon.com (Postfix) with ESMTPS id 1414BC08B9;
        Thu, 13 Jan 2022 00:30:19 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.28; Thu, 13 Jan 2022 00:30:18 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.142) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Thu, 13 Jan 2022 00:30:14 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 bpf-next 5/5] selftest/bpf: Fix a stale comment.
Date:   Thu, 13 Jan 2022 09:28:49 +0900
Message-ID: <20220113002849.4384-6-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220113002849.4384-1-kuniyu@amazon.co.jp>
References: <20220113002849.4384-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.142]
X-ClientProxiedBy: EX13D04UWB001.ant.amazon.com (10.43.161.46) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit b8a58aa6fccc ("af_unix: Cut unix_validate_addr() out of
unix_mkname().") moved the bound test part into unix_validate_addr().

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 tools/testing/selftests/bpf/progs/bpf_iter_unix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_unix.c b/tools/testing/selftests/bpf/progs/bpf_iter_unix.c
index c21e3f545371..e6aefae38894 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter_unix.c
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_unix.c
@@ -63,7 +63,7 @@ int dump_unix(struct bpf_iter__unix *ctx)
 			BPF_SEQ_PRINTF(seq, " @");
 
 			for (i = 1; i < len; i++) {
-				/* unix_mkname() tests this upper bound. */
+				/* unix_validate_addr() tests this upper bound. */
 				if (i >= sizeof(struct sockaddr_un))
 					break;
 
-- 
2.30.2

