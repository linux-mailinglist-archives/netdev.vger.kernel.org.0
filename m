Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3668B39C86A
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 15:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbhFENU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 09:20:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:35038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230029AbhFENUZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Jun 2021 09:20:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88F3961408;
        Sat,  5 Jun 2021 13:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622899117;
        bh=TBS6JoAxPmOD9dx9GzeTj3rbPrTu3AsIuW9k8qlWnzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=be7GRwMB8z4uvJGHXiovODyFjICco4VKZLeIBW91i+IBt6MH3Ra5hWzecpGYk2Ow3
         WlHxa+DbW6mm2qI0VzmczqpRYOqlgAcg+gcoULNR0zp0Aiiz19niZuyn4PKra/I0F4
         KPrJajcdeJKG4RGD4N9dhy+bnDRvTfkQftxfUxwcvfvSRHo3Zrnz8Ev+XLskNdlbiV
         o06OJNZQOCHHMK+K+4OFJL9fACsb988O+R1SgOYAzD6pkX+ZIldHIbhSfTwOLf8+9e
         KwaKGtnXti3V6CajH4ACTXkn1X1WXYhfwD+SPtQNEgVl083Npx2jcCyFJLy068uyaD
         Ue4R6EhfnQliA==
Received: by mail.kernel.org with local (Exim 4.94.2)
        (envelope-from <mchehab@kernel.org>)
        id 1lpWCB-008GFB-Nm; Sat, 05 Jun 2021 15:18:35 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     "Jonathan Corbet" <corbet@lwn.net>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Brendan Jackman <jackmanb@chromium.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Florent Revest <revest@chromium.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 11/34] docs: bpf: bpf_lsm.rst: avoid using ReSt :doc:`foo` markup
Date:   Sat,  5 Jun 2021 15:18:10 +0200
Message-Id: <fd6ac38a544907ec33e1294eece7e48acfaabcf3.1622898327.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1622898327.git.mchehab+huawei@kernel.org>
References: <cover.1622898327.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The :doc:`foo` tag is auto-generated via automarkup.py.
So, use the filename at the sources, instead of :doc:`foo`.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/bpf/bpf_lsm.rst | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/Documentation/bpf/bpf_lsm.rst b/Documentation/bpf/bpf_lsm.rst
index 1c0a75a51d79..0dc3fb0d9544 100644
--- a/Documentation/bpf/bpf_lsm.rst
+++ b/Documentation/bpf/bpf_lsm.rst
@@ -20,10 +20,10 @@ LSM hook:
 Other LSM hooks which can be instrumented can be found in
 ``include/linux/lsm_hooks.h``.
 
-eBPF programs that use :doc:`/bpf/btf` do not need to include kernel headers
-for accessing information from the attached eBPF program's context. They can
-simply declare the structures in the eBPF program and only specify the fields
-that need to be accessed.
+eBPF programs that use Documentation/bpf/btf.rst do not need to include kernel
+headers for accessing information from the attached eBPF program's context.
+They can simply declare the structures in the eBPF program and only specify
+the fields that need to be accessed.
 
 .. code-block:: c
 
@@ -88,8 +88,9 @@ example:
 
 The ``__attribute__((preserve_access_index))`` is a clang feature that allows
 the BPF verifier to update the offsets for the access at runtime using the
-:doc:`/bpf/btf` information. Since the BPF verifier is aware of the types, it
-also validates all the accesses made to the various types in the eBPF program.
+Documentation/bpf/btf.rst information. Since the BPF verifier is aware of the
+types, it also validates all the accesses made to the various types in the
+eBPF program.
 
 Loading
 -------
-- 
2.31.1

