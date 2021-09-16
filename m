Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A17E340D6BA
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 11:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236631AbhIPJ5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 05:57:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:57872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235886AbhIPJ4q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 05:56:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33DB161212;
        Thu, 16 Sep 2021 09:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631786126;
        bh=KFZt39MYhJdE0FBZY8pCk3XsJMfrKwUmacKBtK1J1wQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uknr1V520dfXc5yR9JbBMedoKiY1uDif77Yx+087gaQQUxMHT8gsnN69X8BHl+NNg
         ObGVZ7G0iGJm2Jxfe3zmZXxm/Awtm/037IUQtCcPiSyU89/s8SbTZlyTQZg5x7Izn1
         M2Cy9kmtVSD0H99Ft5TEFycMxCoJECMdiZdoA5o8eJHs7CB/rP2sQv76HN1bmux4Wj
         oLC0XDyhvxZ6v73Uri4udvHpJuvi+ZSZB75U8QvCltJxyWjwa/ReZrbea2mBh1QNZT
         s0W16P6Q0JhXkxgK0zhepHeFzxEdJXe9A6+/elqYmuExMbshyvLoSb6XgNw4K2VoVV
         oLZbX6HYk0wBw==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1mQo72-001vTo-EA; Thu, 16 Sep 2021 11:55:24 +0200
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
Subject: [PATCH v2 08/23] tools: bpftool: update bpftool-prog.rst reference
Date:   Thu, 16 Sep 2021 11:55:07 +0200
Message-Id: <fe4bb3cf5984623976b3e8d751657bc1bcbb598e.1631785820.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1631785820.git.mchehab+huawei@kernel.org>
References: <cover.1631785820.git.mchehab+huawei@kernel.org>
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

