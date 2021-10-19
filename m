Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5254330A3
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 10:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234965AbhJSIHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 04:07:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:36300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234719AbhJSIGl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 04:06:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB8CC613A1;
        Tue, 19 Oct 2021 08:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634630667;
        bh=Bx3pYVSsyeLYtIU48WDc61BgSRFYlI2YfsZiMvIGhhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eh9hDX6SZrJVjbWC2FCyqRTIwBeadzTzMeT4AUU3IeIaIcopNl88MW32R+ROOnhxu
         4mSKhRxWb+40FjUS1C4aJKfQKTdAEH2BXnMwZwf+i6FNa/oQLyz9xguBK0weFK+a75
         76xhtVXvhh8VCIrVgPiL1+Zc6NpjCTTBjGXGB+pJUB8BlWCPnkAXZ0TX3vj4AtgKyH
         XPTEBDP5URW50tgSDgg/dPw35He3jy4w8QOhsMZTktDMMvEy/Pv3auFmdEbfUCi1gp
         E1OFpvxnF2gJ97+LGjwe98bL06H2k45yENf+tGlaZ7oxFOG2U+2cPPqvV/rxz7H+ei
         e3VAA+C9Mctkg==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1mck6j-001oJU-7F; Tue, 19 Oct 2021 09:04:25 +0100
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
Subject: [PATCH v3 14/23] bpftool: update bpftool-cgroup.rst reference
Date:   Tue, 19 Oct 2021 09:04:13 +0100
Message-Id: <11f3dc3cfc192e2ee271467d7a6c7c1920006766.1634630486.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1634630485.git.mchehab+huawei@kernel.org>
References: <cover.1634630485.git.mchehab+huawei@kernel.org>
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

To mailbombing on a large number of people, only mailing lists were C/C on the cover.
See [PATCH v3 00/23] at: https://lore.kernel.org/all/cover.1634630485.git.mchehab+huawei@kernel.org/

 tools/testing/selftests/bpf/test_bpftool_synctypes.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_bpftool_synctypes.py b/tools/testing/selftests/bpf/test_bpftool_synctypes.py
index be54b7335a76..617b8084c440 100755
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

