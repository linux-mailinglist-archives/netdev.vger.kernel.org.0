Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3999D40D6B6
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 11:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236718AbhIPJ5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 05:57:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:57892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236062AbhIPJ4q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 05:56:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24DC261185;
        Thu, 16 Sep 2021 09:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631786126;
        bh=VoVabcSaeL3ZnbddZwW636ond/e3tGe60XIA1dN4wnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EG1uX3hjoxF3d9QM2/ZbIDcZdSMZscBb7I2XUtrM94Q5MsKTAMemI8LcQQ4r7gJr8
         MyzDxF6aTa0S4ejBHxxIrrDzaaiKLn7Vot7daES4lWaFIAg2pXuGVq71OKmUOcKHFQ
         ByCvK7RWfZKG8SrDN4Wo/81Mee1KBOBw6a4Wnh5UecIWpIuOh9n/+zGHt4/VEA08B7
         jPDChjXqpraea2nREN3cwNTmCjpP7pJzWYDmcigFwCUKKHzvxkfOcdXZOTpKoLJcnG
         yEns8o4mVq63WX362T+i2krTMLSzt+yl3lPUGTqOcss5tcCaU3XTEUrehWmnODoDk5
         jTUtU0cLQ6SzQ==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1mQo72-001vTs-FO; Thu, 16 Sep 2021 11:55:24 +0200
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
Subject: [PATCH v2 09/23] tools: bpftool: update bpftool-map.rst reference
Date:   Thu, 16 Sep 2021 11:55:08 +0200
Message-Id: <803e3a74d7f9b5fe23e4f8222af0e6629d1cd76a.1631785820.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1631785820.git.mchehab+huawei@kernel.org>
References: <cover.1631785820.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The file name: Documentation/bpftool-map.rst
should be, instead: tools/bpf/bpftool/Documentation/bpftool-map.rst.

Update its cross-reference accordingly.

Fixes: a2b5944fb4e0 ("selftests/bpf: Check consistency between bpftool source, doc, completion")
Fixes: ff69c21a85a4 ("tools: bpftool: add documentation")
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 tools/testing/selftests/bpf/test_bpftool_synctypes.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_bpftool_synctypes.py b/tools/testing/selftests/bpf/test_bpftool_synctypes.py
index 27a2c369a798..2d7eb683bd5a 100755
--- a/tools/testing/selftests/bpf/test_bpftool_synctypes.py
+++ b/tools/testing/selftests/bpf/test_bpftool_synctypes.py
@@ -383,7 +383,7 @@ class ManMapExtractor(ManPageExtractor):
     """
     An extractor for bpftool-map.rst.
     """
-    filename = os.path.join(BPFTOOL_DIR, 'Documentation/bpftool-map.rst')
+    filename = os.path.join(BPFTOOL_DIR, 'tools/bpf/bpftool/Documentation/bpftool-map.rst')
 
     def get_map_types(self):
         return self.get_rst_list('TYPE')
-- 
2.31.1

