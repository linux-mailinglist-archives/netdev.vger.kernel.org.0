Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7F6199302
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 12:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730419AbgCaKAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 06:00:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38742 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730153AbgCaKAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 06:00:38 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jJDh8-0002Tv-TZ; Tue, 31 Mar 2020 10:00:31 +0000
From:   Colin King <colin.king@canonical.com>
To:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] bpf: Test_verifier: fix spelling mistake "arithmatic" -> "arithmetic"
Date:   Tue, 31 Mar 2020 11:00:30 +0100
Message-Id: <20200331100030.41372-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are a couple of spelling mistakes in two literal strings, fix them.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 tools/testing/selftests/bpf/verifier/bounds.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/verifier/bounds.c b/tools/testing/selftests/bpf/verifier/bounds.c
index 4d0d09574bf4..a253a064e6e0 100644
--- a/tools/testing/selftests/bpf/verifier/bounds.c
+++ b/tools/testing/selftests/bpf/verifier/bounds.c
@@ -501,7 +501,7 @@
 	.result = REJECT
 },
 {
-	"bounds check mixed 32bit and 64bit arithmatic. test1",
+	"bounds check mixed 32bit and 64bit arithmetic. test1",
 	.insns = {
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_MOV64_IMM(BPF_REG_1, -1),
@@ -520,7 +520,7 @@
 	.result = ACCEPT
 },
 {
-	"bounds check mixed 32bit and 64bit arithmatic. test2",
+	"bounds check mixed 32bit and 64bit arithmetic. test2",
 	.insns = {
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_MOV64_IMM(BPF_REG_1, -1),
-- 
2.25.1

