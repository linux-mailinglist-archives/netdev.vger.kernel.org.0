Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 687B240D6CF
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 11:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237227AbhIPJ5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 05:57:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:58054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236221AbhIPJ4s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 05:56:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 422DE61246;
        Thu, 16 Sep 2021 09:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631786126;
        bh=SoojYHvRGcHq15wi1lokm8T7b2MKM9WukjphpKpCLUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qNqk8O4PX1qXimy6EWm5bQoVNFiVTR5H3v6A43glANGoBIWoKM/8Tzvig7E5moXtT
         l1/0IqcfiTwxlPZGO9wQDDYvh3G2dFW673LPfUvSG8FhJtXWgsm6McLgJvTassg1/W
         BRTx36XZrifByAfgOmkfwtP48stDuKpUH/8WXzDdGjiD5d02DZkg78B09ZBW4HVo/y
         6YM74V+b1EdkuM4VUaHeZrwlFQkb7kcBVsOLBwJjcw6dsHrWypnIk0vOGF78UF0V1I
         Q6fNOtbAUT+CU4A1HKWmaABEXYsBFawsegShcjzQU8oVZG9ssnEDAtBOOW47npnz5m
         0h07Tuz/vydlA==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1mQo72-001vTw-Gk; Thu, 16 Sep 2021 11:55:24 +0200
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
Subject: [PATCH v2 10/23] bpftool: update bpftool-cgroup.rst reference
Date:   Thu, 16 Sep 2021 11:55:09 +0200
Message-Id: <9e9f62ab09c26736338545f9aa27c0e825517a32.1631785820.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1631785820.git.mchehab+huawei@kernel.org>
References: <cover.1631785820.git.mchehab+huawei@kernel.org>
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

