Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC1084531E5
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 13:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236054AbhKPMOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 07:14:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:50864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234468AbhKPMOX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 07:14:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD9C861B44;
        Tue, 16 Nov 2021 12:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637064686;
        bh=WLAAKJcCW/GrnGEfZiGrJFuEjwCJ0ZeSMJCGY1qmQAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cbRYB8HqwIhclLp0dUm/ThDhGgLIYx8diFTDjxRJRDKFxhavM7rIB7UDGijmF3UEw
         jfyWcaNHaVVGiiVno3w5n/SOb2bib/xcLKqm9+tO9Wz1px0V3hhQe/5Zsw29dMS4J1
         djakfiWrpM2OXzjFfbFZkPPmDyJQ9293iPG1dGoyMGsenX0E1VwF1IKGETJZ+BHiHp
         bpp+KffLRMn4dVFoOwgkKd6es2zNP6/NkKW5b/Zk627487T/6YyOKp8R8pPKCOLQ99
         BOxowcxEVK36oLWV6+U/SEwMz09lwOnCSc5HigNv5eMPPBSogTzs8Jne5bVlLOVEL1
         hzZh2ce337K4A==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1mmxJ6-00A9LR-B5; Tue, 16 Nov 2021 12:11:24 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Grant Seltzer <grantseltzer@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 1/4] libbpf: update index.rst reference
Date:   Tue, 16 Nov 2021 12:11:20 +0000
Message-Id: <85ad6cfa0447f2e3309f709f6a9ffb00b9cbeb55.1637064577.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1637064577.git.mchehab+huawei@kernel.org>
References: <cover.1637064577.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changeset d20b41115ad5 ("libbpf: Rename libbpf documentation index file")
renamed: Documentation/bpf/libbpf/libbpf.rst
to: Documentation/bpf/libbpf/index.rst.

Update its cross-reference accordingly.

Fixes: d20b41115ad5 ("libbpf: Rename libbpf documentation index file")
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---

To mailbombing on a large number of people, only mailing lists were C/C on the cover.
See [PATCH 0/4] at: https://lore.kernel.org/all/cover.1637064577.git.mchehab+huawei@kernel.org/

 Documentation/bpf/index.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/bpf/index.rst b/Documentation/bpf/index.rst
index 37f273a7e8b6..610450f59e05 100644
--- a/Documentation/bpf/index.rst
+++ b/Documentation/bpf/index.rst
@@ -15,7 +15,7 @@ that goes into great technical depth about the BPF Architecture.
 libbpf
 ======
 
-Documentation/bpf/libbpf/libbpf.rst is a userspace library for loading and interacting with bpf programs.
+Documentation/bpf/libbpf/index.rst is a userspace library for loading and interacting with bpf programs.
 
 BPF Type Format (BTF)
 =====================
-- 
2.33.1

