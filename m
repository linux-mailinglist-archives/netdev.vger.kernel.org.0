Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4294A669B
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 21:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242561AbiBAU5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 15:57:07 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58332 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236893AbiBAU44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 15:56:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD67161756;
        Tue,  1 Feb 2022 20:56:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CDE7C340ED;
        Tue,  1 Feb 2022 20:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643749015;
        bh=JjYwktbzWgaZZwjKwRtnb1xc51qgqbnt81floObI+Ww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=to+G9Qb5eqyzP8rsE+Jwnl3XgQEegaYvKjtUIXNeNSdePMOyhgkbmNe4/Yx5mSAuq
         G68kspeColB3L2HTB7TAqyf6eZZemWF9yeowZbU+4A3Esammaiyc77KDKspyPrB/CU
         lVXJsY8RN5ChGncKVo5b+ZqwK+Y56Sc6FuolYua270Hqy39EDWvWtipJ1lizK2Jda7
         bfgK2XZvMTR7kMh+pIx8RL+RkRCQWQtO2gxcTvAsGctAMZeIfukeoGRK1OGFyNnow5
         d0RSVaqHzoVD+kouQdPshWdBO/7wIBX7MMi+tNKBgiUHNVWsZaIdi72AUxHdFK9ugN
         kRTFBcGZAn1Kg==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH bpf-next 1/5] MAINTAINERS: Add scripts/pahole-flags.sh to BPF section
Date:   Tue,  1 Feb 2022 13:56:20 -0700
Message-Id: <20220201205624.652313-2-nathan@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220201205624.652313-1-nathan@kernel.org>
References: <20220201205624.652313-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, scripts/pahole-flags.sh has no formal maintainer. Add it to
the BPF section so that patches to it can be properly reviewed and
picked up.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0d7883977e9b..0d422452c8ff 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3523,6 +3523,7 @@ F:	net/sched/act_bpf.c
 F:	net/sched/cls_bpf.c
 F:	samples/bpf/
 F:	scripts/bpf_doc.py
+F:	scripts/pahole-flags.sh
 F:	tools/bpf/
 F:	tools/lib/bpf/
 F:	tools/testing/selftests/bpf/
-- 
2.35.1

