Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C203C4839E5
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 02:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbiADBej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 20:34:39 -0500
Received: from smtp-fw-80006.amazon.com ([99.78.197.217]:59191 "EHLO
        smtp-fw-80006.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbiADBej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 20:34:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1641260079; x=1672796079;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=p0DyDQ+vWEwJliI3fARijsd3UJqqtNYA35ktKFWmfQA=;
  b=do1RnvfFXT5aB+TIsV4NwNNZkEJ/1Mj1/ruJfDVDKYSKwf6wU3b0aCmb
   XssEb9ZFNEIk8LcJ9XJz30AKLtGCJCvM63oTZurFbzP5uxNB2+XUhpAdr
   4T7kn6gC1oQ8B2zy3pxdc9UaB/4PhMU+YCOOGEC2Wvn9Y9eti1ljaSwJT
   w=;
X-IronPort-AV: E=Sophos;i="5.88,258,1635206400"; 
   d="scan'208";a="52418794"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-1cb212d9.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 04 Jan 2022 01:34:39 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-1cb212d9.us-west-2.amazon.com (Postfix) with ESMTPS id 11FB2C0950;
        Tue,  4 Jan 2022 01:34:39 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Tue, 4 Jan 2022 01:34:37 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.97) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Tue, 4 Jan 2022 01:34:34 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH bpf-next 6/6] selftest/bpf: Fix a stale comment.
Date:   Tue, 4 Jan 2022 10:31:53 +0900
Message-ID: <20220104013153.97906-7-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220104013153.97906-1-kuniyu@amazon.co.jp>
References: <20220104013153.97906-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.97]
X-ClientProxiedBy: EX13D19UWA004.ant.amazon.com (10.43.160.102) To
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

