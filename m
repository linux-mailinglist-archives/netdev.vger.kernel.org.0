Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADA0540D5D9
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 11:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235626AbhIPJQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 05:16:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:40940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235449AbhIPJPm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 05:15:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 694A861241;
        Thu, 16 Sep 2021 09:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631783661;
        bh=KFZt39MYhJdE0FBZY8pCk3XsJMfrKwUmacKBtK1J1wQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NVpLX3fFHnguS0eSdwwT+N/EGTWbVIJnmvalJWJOcEEivlKbY9WYTPQTw5SFa4VQc
         wpIUqmxYxp7WU2A9qxrhCPY28tvnp6kdV2kVHKMGOKtDN8HoZPYB/9vjk9sbLq3qxd
         h+85QyelY6A659hfETsIptUKl+ZiLjkDARsJtvlbBKkHKF3NOhs5lGrLxDiMmGIlv8
         JhvW2yimXzkXAv+gxStbYx+ii3F4YIHYWNW5bng5vhHi2hHN33wvTlTCiuaBifOhmI
         BhBoJBSQ93ML/Fgi81USIIMYL62DIyajMTR2ByLQhlkihJyFMj/oec1s84cZd5zcIE
         cfLLgsSWLaPEA==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1mQnTH-001sL5-IO; Thu, 16 Sep 2021 11:14:19 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Beckett <david.beckett@netronome.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Shuah Khan <shuah@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 08/24] tools: bpftool: update bpftool-prog.rst reference
Date:   Thu, 16 Sep 2021 11:14:01 +0200
Message-Id: <dc4bae7a14518fbfff20a0f539df06a5c19b09de.1631783482.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1631783482.git.mchehab+huawei@kernel.org>
References: <cover.1631783482.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The file name: Documentation/bpftool-prog.rst
should be, instead: tools/bpf/bpftool/Documentation/bpftool-prog.rst.

Update its cross-reference accordingly.

Fixes: a2b5944fb4e0 ("selftests/bpf: Check consistency between bpftool source, doc, completion")
Fixes: ff69c21a85a4 ("tools: bpftool: add documentation")
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 tools/testing/selftests/bpf/test_bpftool_synctypes.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_bpftool_synctypes.py b/tools/testing/selftests/bpf/test_bpftool_synctypes.py
index be54b7335a76..27a2c369a798 100755
--- a/tools/testing/selftests/bpf/test_bpftool_synctypes.py
+++ b/tools/testing/selftests/bpf/test_bpftool_synctypes.py
@@ -374,7 +374,7 @@ class ManProgExtractor(ManPageExtractor):
     """
     An extractor for bpftool-prog.rst.
     """
-    filename = os.path.join(BPFTOOL_DIR, 'Documentation/bpftool-prog.rst')
+    filename = os.path.join(BPFTOOL_DIR, 'tools/bpf/bpftool/Documentation/bpftool-prog.rst')
 
     def get_attach_types(self):
         return self.get_rst_list('ATTACH_TYPE')
-- 
2.31.1

