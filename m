Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5313ECB7E
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 23:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbhHOVkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Aug 2021 17:40:32 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:59428
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229935AbhHOVkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Aug 2021 17:40:32 -0400
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net [80.193.200.194])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 722CE3F105;
        Sun, 15 Aug 2021 21:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1629063593;
        bh=To/roSNPwpACvahNmxSV8eOGz8/vn9OEVd54wbHH0M8=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=IUB08UJ6OCwbikGR7AON9oDovGqBPGO0lbd9y1MW5UqYW0Ql/zq/HdWqAiewu2gkU
         k1RJHNTpUUhwBd6zu608WCBD6HtIfHi2khOuFmFu/tQYv0I4/Bxi+mNbHycfEa16RC
         qNxyx2zkhNFpXKv8p7KCajIa47Hteqz0giHSeFgDda++bkUrKnaig4qaTXMA13VDHv
         viFdqGSq0+fYE2TIPw/C2RkgAE37YJNXEFZNZ4mBIHJ9L1O2B9mK82eC9sXCtUAZLU
         F2IHzvN/peWiX9feFTaLrmm0UVgsWJwvHWa84ijGjTlmmnOBibqLhigQIXmPpsscnt
         WseQKPHEUhtdw==
From:   Colin King <colin.king@canonical.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] bpf, tests: Fix spelling mistake "shoft" -> "shift"
Date:   Sun, 15 Aug 2021 22:39:50 +0100
Message-Id: <20210815213950.47751-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a literal string. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 lib/test_bpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 44d8197bbffb..77fe6fde56c5 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -5163,7 +5163,7 @@ static struct bpf_test tests[] = {
 		{ { 0, -1 } }
 	},
 	{
-		"ALU64_ARSH_K: Zero shoft",
+		"ALU64_ARSH_K: Zero shift",
 		.u.insns_int = {
 			BPF_LD_IMM64(R0, 0x8123456789abcdefLL),
 			BPF_ALU64_IMM(BPF_ARSH, R0, 0),
-- 
2.32.0

