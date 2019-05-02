Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66F5B11529
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 10:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbfEBIPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 04:15:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:56834 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725905AbfEBIPs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 04:15:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 31865AEE2;
        Thu,  2 May 2019 08:15:46 +0000 (UTC)
From:   Michal Rostecki <mrostecki@opensuse.org>
Cc:     Michal Rostecki <mrostecki@opensuse.org>,
        Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v2] bpf, libbpf: Add .so files to gitignore
Date:   Thu,  2 May 2019 10:14:54 +0200
Message-Id: <20190502081453.25097-1-mrostecki@opensuse.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change adds libbpf shared libraries to .gitignore which were
previously not included there.

Acked-by: Yonghong Song <yhs@fb.com>
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

