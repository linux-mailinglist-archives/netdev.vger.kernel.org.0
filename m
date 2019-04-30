Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C775FDD1
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 18:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbfD3Q0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 12:26:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:44674 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725942AbfD3Q0y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 12:26:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A8B90AE64;
        Tue, 30 Apr 2019 16:26:52 +0000 (UTC)
From:   mrostecki@opensuse.org
Cc:     Michal Rostecki <mrostecki@opensuse.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] bpf, libbpf: Add .so files to gitignore
Date:   Tue, 30 Apr 2019 18:25:01 +0200
Message-Id: <20190430162501.13256-1-mrostecki@opensuse.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Rostecki <mrostecki@opensuse.org>

This change adds libbpf shared libraries to .gitignore which were
previously not included there.

Signed-off-by: Michal Rostecki <mrostecki@opensuse.org>
---
 tools/lib/bpf/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/bpf/.gitignore b/tools/lib/bpf/.gitignore
index 7d9e182a1f51..0b181b23f97d 100644
--- a/tools/lib/bpf/.gitignore
+++ b/tools/lib/bpf/.gitignore
@@ -1,4 +1,5 @@
 libbpf_version.h
 libbpf.pc
+libbpf.so.0*
 FEATURE-DUMP.libbpf
 test_libbpf
-- 
2.21.0

