Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D35446444A
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 01:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346246AbhLAAzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 19:55:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346148AbhLAAyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 19:54:36 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CDB9C0617A0;
        Tue, 30 Nov 2021 16:50:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3F7B1CE1D5A;
        Wed,  1 Dec 2021 00:50:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A72C53FCB;
        Wed,  1 Dec 2021 00:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638319830;
        bh=Dho9jZYQAxQreqJGYGeVwHqRvMi7nJtvEsyDeEnGsCA=;
        h=Date:From:To:Cc:Subject:Reply-To:From;
        b=hn7FoChv4yGJef6buV70Oqy0Pi0sObtduaofg/Y58Sh0DSdfYXY7w3Sfa7w4bthFb
         UpgHtCthKDdBV2f51g7Mf+oFjNgD+CG3iCmeHtAmmtrykQBUE/DhDqoICzECkjmDRc
         smQ2zetkupIXR9liACHPNvvKX9r2R18YbcBe1DDD804/pLBCY2T8MDQ/QR50sJW3Mg
         mxtONdrTtc3PZM2PZvoq2Ff/MpEGWJiDjC24lrTLJFOpotFlHO7qjpCZnPglc6h+SH
         nQueebF0tvqr8wtQcRH2IAKmUNM2Aa/GrGHsNK1K/qU5Tq9i/y1sdJbmDe/92CvcNZ
         JzuTtZ74L8IlA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 22A435C0E58; Tue, 30 Nov 2021 16:50:30 -0800 (PST)
Date:   Tue, 30 Nov 2021 16:50:30 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     ast@kernel.org, shuah@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Subject: [PATCH] testing/bpf: Update test names for xchg and cmpxchg
Message-ID: <20211201005030.GA3071525@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The test_cmpxchg() and test_xchg() functions say "test_run add".
Therefore, make them say "test_run cmpxchg" and "test_run xchg",
respectively.

Cc: Shuah Khan <shuah@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: <linux-kselftest@vger.kernel.org>
Cc: <netdev@vger.kernel.org>
Cc: <bpf@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>

diff --git a/tools/testing/selftests/bpf/prog_tests/atomics.c b/tools/testing/selftests/bpf/prog_tests/atomics.c
index 0f9525293881b..86b7d5d84eec4 100644
--- a/tools/testing/selftests/bpf/prog_tests/atomics.c
+++ b/tools/testing/selftests/bpf/prog_tests/atomics.c
@@ -167,7 +167,7 @@ static void test_cmpxchg(struct atomics_lskel *skel)
 	prog_fd = skel->progs.cmpxchg.prog_fd;
 	err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
 				NULL, NULL, &retval, &duration);
-	if (CHECK(err || retval, "test_run add",
+	if (CHECK(err || retval, "test_run cmpxchg",
 		  "err %d errno %d retval %d duration %d\n", err, errno, retval, duration))
 		goto cleanup;
 
@@ -196,7 +196,7 @@ static void test_xchg(struct atomics_lskel *skel)
 	prog_fd = skel->progs.xchg.prog_fd;
 	err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
 				NULL, NULL, &retval, &duration);
-	if (CHECK(err || retval, "test_run add",
+	if (CHECK(err || retval, "test_run xchg",
 		  "err %d errno %d retval %d duration %d\n", err, errno, retval, duration))
 		goto cleanup;
 
