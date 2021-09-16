Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5845A40D5AB
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 11:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235735AbhIPJPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 05:15:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:40884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235160AbhIPJPl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 05:15:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 556846120C;
        Thu, 16 Sep 2021 09:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631783661;
        bh=SoojYHvRGcHq15wi1lokm8T7b2MKM9WukjphpKpCLUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d6AJ8SLxqiJamJEz59k6m+fiBUQcUNUXLK8ccBNaSHJwcbeniL0A0v0o1t7dIYRCg
         v15IJl3R3I10ftx3MXtgWK8pOItD551xyPG0MowQV9ghtVx/4/9arQWZnDrNjt26gQ
         5dFeLLBdM7YEptcq6cGiaRckIj5OkJD8e+wp6yZWdnmX0M4njVFwNfvfiGz7B2D2jQ
         KgrJWrNU7ZTRMENM5Ks62ptNzm2USo2fy4yZ69C0hWXwjEx6v5KjXB5Zks54qt3u93
         tXwXszeA/ctlxQfSsOR0d6iatbDWeOOzChA939MA+mJ4akTP7ue8aKRl4RzlcReaL+
         X9LtqYG+gFLhg==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1mQnTH-001sLG-L9; Thu, 16 Sep 2021 11:14:19 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Roman Gushchin <guro@fb.com>, Shuah Khan <shuah@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 10/24] bpftool: update bpftool-cgroup.rst reference
Date:   Thu, 16 Sep 2021 11:14:03 +0200
Message-Id: <223f42a5074982a2c6e1766bf413922ac257545f.1631783482.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1631783482.git.mchehab+huawei@kernel.org>
References: <cover.1631783482.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The file name: Documentation/bpftool-cgroup.rst
should be, instead: tools/bpf/bpftool/Documentation/bpftool-cgroup.rst.

Update its cross-reference accordingly.

Fixes: a2b5944fb4e0 ("selftests/bpf: Check consistency between bpftool source, doc, completion")
Fixes: 5ccda64d38cc ("bpftool: implement cgroup bpf operations")
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 tools/testing/selftests/bpf/test_bpftool_synctypes.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_bpftool_synctypes.py b/tools/testing/selftests/bpf/test_bpftool_synctypes.py
index 2d7eb683bd5a..c974abd4db13 100755
--- a/tools/testing/selftests/bpf/test_bpftool_synctypes.py
+++ b/tools/testing/selftests/bpf/test_bpftool_synctypes.py
@@ -392,7 +392,7 @@ class ManCgroupExtractor(ManPageExtractor):
     """
     An extractor for bpftool-cgroup.rst.
     """
-    filename = os.path.join(BPFTOOL_DIR, 'Documentation/bpftool-cgroup.rst')
+    filename = os.path.join(BPFTOOL_DIR, 'tools/bpf/bpftool/Documentation/bpftool-cgroup.rst')
 
     def get_attach_types(self):
         return self.get_rst_list('ATTACH_TYPE')
-- 
2.31.1

