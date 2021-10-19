Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4AF4433087
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 10:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234801AbhJSIGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 04:06:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:36256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234713AbhJSIGk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 04:06:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1B306139E;
        Tue, 19 Oct 2021 08:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634630667;
        bh=/Vuy2qYN6tzcoCI8XehyWZlcCbAKDGIPiOkwjFdSsyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kyxew2eGQ4Fvu15FGUrZvOjZt5FRXMotpDYXpZr4Ci9gnnl0uZ1Y/do9zASiFJ0Zi
         yLSgzVSsNkAlyhX2EdiLLH1dx++A7R1B9zS/8aYXKM0jKlQnC2MUFS9d1HW9Brlp/P
         13YXAId0gUZ53yVqRX03BNXGjE0fT/EP6fraVPhDWAO8Dm58yBHsgM4s3j7PinJ+cv
         37NoOp1szKsr5W8TmEBkc5CWXgRkvv0rQZYPaT1Hsfz8aK7Sz2iP7QkdLlxFq5W6wI
         08N0JrngF1odEQZ4YBsituHZ+MGP5gCEYNkn4A+u6/dyi+eymEVs0y5hAEAmkLrHOE
         kYzqtpt4LcDWw==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1mck6j-001oIu-13; Tue, 19 Oct 2021 09:04:25 +0100
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
Subject: [PATCH v3 02/23] libbpf: update index.rst reference
Date:   Tue, 19 Oct 2021 09:04:01 +0100
Message-Id: <83beca0ec615afcce4c9f9244f640615beb0ea72.1634630485.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1634630485.git.mchehab+huawei@kernel.org>
References: <cover.1634630485.git.mchehab+huawei@kernel.org>
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
See [PATCH v3 00/23] at: https://lore.kernel.org/all/cover.1634630485.git.mchehab+huawei@kernel.org/

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
2.31.1

