Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E25C740D5A6
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 11:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235632AbhIPJPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 05:15:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:40852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235383AbhIPJPl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 05:15:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5099861209;
        Thu, 16 Sep 2021 09:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631783661;
        bh=83vkFWOnmUdHmvdZYCb71ZYm+RoKY7l/VWT0C4zUsJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E+lyG1uloXhex9KJPzmERJ3/tNtAQeJV7eTNB8mZFXHv/gDwyyG+pYEv5ko8Dkn1T
         UMNuZZPpEshs5pCUZ7dcLyjqwghAlh3HAtVR4RT0OUXRJOKKdtWKKw3G03zLGrAJTX
         uVemPgyMaJuyNEermSBMcxsXQ9EWFuHa4RWSoYekzz8LdOE7sgx3RTQ6cYj1Dp0VAa
         SeqEBrQipxYXiBpSXd63V5XTrzJKB5fuGD/0M/4MLWEfgzr03F7HZ7/7FqB3GmXJxm
         XEHuflOkrFQttorRbUDFr8/CWGtkV89b1gAuwQwLTlhsrNqxdrMDb6vR6Wv+bDbePu
         7x/XuJ4YYU2xA==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1mQnTH-001sKx-Fd; Thu, 16 Sep 2021 11:14:19 +0200
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
Subject: [PATCH 06/24] libbpf: update index.rst reference
Date:   Thu, 16 Sep 2021 11:13:59 +0200
Message-Id: <ae12f5de645a2ae07f183babe6615bdf0384f9a8.1631783482.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1631783482.git.mchehab+huawei@kernel.org>
References: <cover.1631783482.git.mchehab+huawei@kernel.org>
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
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/bpf/index.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/bpf/index.rst b/Documentation/bpf/index.rst
index 1ceb5d704a97..817a201a1282 100644
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
2.31.1

