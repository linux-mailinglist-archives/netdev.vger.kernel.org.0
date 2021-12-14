Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 823D1474459
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 15:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbhLNOEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 09:04:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbhLNOEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 09:04:21 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E8EC061574;
        Tue, 14 Dec 2021 06:04:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=c3sVg+FOnnrAjIuYNGgmpnKM7+jMk1UCUDYyQOig0Cg=; b=lqYkVhyuYv4cjQ7UZO7XX5oyVy
        JCC4ZXdLn0MQ1ex/UAn+lzDDlUuzInBZpEK4CJLYyQE8eZDo4BFUZbzV+fr9sGXXFJCQPrVRliHHk
        x0N4ORjY5JJEdCDrjKYawp7D/dZVMMrkHLnWxu1I8TPkOiWxlw19MW5TGYGwNwjX4tGerJtxFH5aE
        Wmbdf4l8/lGukKqSz8i6zzkOwnbvzJmK1kEF2V51ejFjig+dAYQATo57guxEvMgCqHQK1c7NH5h7Q
        9BVGTgfWMxhWYaBTm8/EPcz20rflxxErv14CjmWhwqi2yXvowdVTB62sC9ImpZePUzkF6Ib94hHfK
        bgL5Mi5g==;
Received: from [2001:4bb8:180:a1c8:4ccb:3bf7:77a2:141f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mx8PV-00DlVH-Sc; Tue, 14 Dec 2021 14:04:06 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH 1/4] bpf, docs: Fix verifier reference
Date:   Tue, 14 Dec 2021 15:03:59 +0100
Message-Id: <20211214140402.288101-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211214140402.288101-1-hch@lst.de>
References: <20211214140402.288101-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use normal RST file reference instead of linkage copied from the old filter.rst
document that does not actually work when using HTML output.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/bpf/instruction-set.rst | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/Documentation/bpf/instruction-set.rst b/Documentation/bpf/instruction-set.rst
index fa7cba59031e5..fa469078301be 100644
--- a/Documentation/bpf/instruction-set.rst
+++ b/Documentation/bpf/instruction-set.rst
@@ -203,7 +203,7 @@ Some core changes of the eBPF format from classic BPF:
     bpf_exit
 
   After the call the registers R1-R5 contain junk values and cannot be read.
-  An in-kernel `eBPF verifier`_ is used to validate eBPF programs.
+  An in-kernel verifier.rst is used to validate eBPF programs.
 
 Also in the new design, eBPF is limited to 4096 insns, which means that any
 program will terminate quickly and will only call a fixed number of kernel
@@ -234,7 +234,7 @@ optimizations, socket filters and seccomp are using it as assembler. Tracing
 filters may use it as assembler to generate code from kernel. In kernel usage
 may not be bounded by security considerations, since generated eBPF code
 may be optimizing internal code path and not being exposed to the user space.
-Safety of eBPF can come from the `eBPF verifier`_. In such use cases as
+Safety of eBPF can come from the verifier.rst. In such use cases as
 described, it may be used as safe instruction set.
 
 Just like the original BPF, eBPF runs within a controlled environment,
@@ -462,6 +462,3 @@ of two consecutive ``struct bpf_insn`` 8-byte blocks and interpreted as single
 instruction that loads 64-bit immediate value into a dst_reg.
 Classic BPF has similar instruction: ``BPF_LD | BPF_W | BPF_IMM`` which loads
 32-bit immediate value into a register.
-
-.. Links:
-.. _eBPF verifier: verifiers.rst
-- 
2.30.2

