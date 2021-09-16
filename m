Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36C8040D1FE
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 05:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234098AbhIPDW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 23:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234037AbhIPDW0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 23:22:26 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8D6C061574;
        Wed, 15 Sep 2021 20:21:06 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id m21-20020a17090a859500b00197688449c4so3781017pjn.0;
        Wed, 15 Sep 2021 20:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F/KGT5A07ZPxIeschCSaV/SSgAUrLa/GKYhWvkN70OE=;
        b=Is/B2At2nlNpxePAIDBsGyCCLNuIeTXCL7KDKJctcZo80Kwwq9E7cARoMLkPeu1FSV
         WiVcaXqJdEczQ1UnOljbMkRyulmfWG3W4ix8gvGAbUg7Gv6bQIiUnbuYAC4k83Gu3Pbk
         KgtlC/BPqibBXNL2BjcVx/hXlty3ZeCnwWBC/0Eay/ORWRlAWFAC0m4IbqJY1Nkk/NaW
         cEfB0ZZyDU35XS8L7g9KDDsvJCLn4XqIdjKNDerm71Z0HqegZNhrm2GTZ9rWF1euaYp2
         vqGUiq42y2JN/2CNlCWE//fxnvTU4yJGinP02JvanBxXh5mjMdx0SQaMcl6khFbel9M9
         4cww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F/KGT5A07ZPxIeschCSaV/SSgAUrLa/GKYhWvkN70OE=;
        b=uq5DIOTxoPi5jV0JiZ/aGNdYsXVoNAitRN2F+/yj7iWDMfCxLrbHcB8m+Xsfavt4kG
         n3LpVkk18vxqrTYV43Y0xqI02/PqR7Igx2VBHpVveOdph4LRF3YllP4UoRhAT5jlAg+h
         DKUr2tCwzgxgBRn0pQLC7IyCMMbZePAqp4WkrxajfwOHHhUHDoGkHWZyVEjz4loB3VfG
         Vr2ZaKnRc3KM9H3aMmIMBoxLDk0twnY1VjggVHn2PhltcIbHots2Mm1FABvvUlMegKvz
         gioDTHC7vfS3qelIpVu3X3nV8etYFHCTpnbWJ1Xo6Jv/z0aBJRGfyMn8lmfNFLM7XZ7p
         D1DA==
X-Gm-Message-State: AOAM533bWIElOUCdyswtE2iPvhM+ciQ1L1mFTpNDWtRyL2BlACYK83Px
        nLuwD4M+2GxNeUdVcn1VEwg=
X-Google-Smtp-Source: ABdhPJzoo7Rezucxzgz9BudH4gM7JhYkZASOUi8J0rW8TaqgMIXy5nkidlxZVymJimYnG5FF0NqA7g==
X-Received: by 2002:a17:902:834b:b0:13a:347b:8a00 with SMTP id z11-20020a170902834b00b0013a347b8a00mr2778524pln.54.1631762466024;
        Wed, 15 Sep 2021 20:21:06 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:860c])
        by smtp.gmail.com with ESMTPSA id g19sm5638587pjl.25.2021.09.15.20.21.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Sep 2021 20:21:05 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, kuba@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf-next] bpf: Document BPF licensing.
Date:   Wed, 15 Sep 2021 20:21:04 -0700
Message-Id: <20210916032104.35822-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Document and clarify BPF licensing.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Joe Stringer <joe@cilium.io>
Acked-by: Lorenz Bauer <lmb@cloudflare.com>
Acked-by: Dave Thaler <dthaler@microsoft.com>
---
 Documentation/bpf/bpf_licensing.rst | 91 +++++++++++++++++++++++++++++
 1 file changed, 91 insertions(+)
 create mode 100644 Documentation/bpf/bpf_licensing.rst

diff --git a/Documentation/bpf/bpf_licensing.rst b/Documentation/bpf/bpf_licensing.rst
new file mode 100644
index 000000000000..62391923af07
--- /dev/null
+++ b/Documentation/bpf/bpf_licensing.rst
@@ -0,0 +1,91 @@
+=============
+BPF licensing
+=============
+
+Background
+==========
+
+* Classic BPF was BSD licensed
+
+"BPF" was originally introduced as BSD Packet Filter in
+http://www.tcpdump.org/papers/bpf-usenix93.pdf. The corresponding instruction
+set and its implementation came from BSD with BSD license. That original
+instruction set is now known as "classic BPF".
+
+However an instruction set is a specification for machine-language interaction,
+similar to a programming language.  It is not a code. Therefore, the
+application of a BSD license may be misleading in a certain context, as the
+instruction set may enjoy no copyright protection.
+
+* eBPF (extended BPF) instruction set continues to be BSD
+
+In 2014, the classic BPF instruction set was significantly extended. We
+typically refer to this instruction set as eBPF to disambiguate it from cBPF.
+The eBPF instruction set is still BSD licensed.
+
+Implementations of eBPF
+=======================
+
+Using the eBPF instruction set requires implementing code in both kernel space
+and user space.
+
+In Linux Kernel
+---------------
+
+The reference implementations of the eBPF interpreter and various just-in-time
+compilers are part of Linux and are GPLv2 licensed. The implementation of
+eBPF helper functions is also GPLv2 licensed. Interpreters, JITs, helpers,
+and verifiers are called eBPF runtime.
+
+In User Space
+-------------
+
+There are also implementations of eBPF runtime (interpreter, JITs, helper
+functions) under
+Apache2 (https://github.com/iovisor/ubpf),
+MIT (https://github.com/qmonnet/rbpf), and
+BSD (https://github.com/DPDK/dpdk/blob/main/lib/librte_bpf).
+
+In HW
+-----
+
+The HW can choose to execute eBPF instruction natively and provide eBPF runtime
+in HW or via the use of implementing firmware with a proprietary license.
+
+In other operating systems
+--------------------------
+
+Other kernels or user space implementations of eBPF instruction set and runtime
+can have proprietary licenses.
+
+Using BPF programs in the Linux kernel
+======================================
+
+Linux Kernel (while being GPLv2) allows linking of proprietary kernel modules
+under these rules:
+https://www.kernel.org/doc/html/latest/process/license-rules.html#id1
+When a kernel module is loaded, the linux kernel checks which functions it
+intends to use. If any function is marked as "GPL only," the corresponding
+module or program has to have GPL compatible license.
+
+Loading BPF program into the Linux kernel is similar to loading a kernel
+module. BPF is loaded at run time and not statically linked to the Linux
+kernel. BPF program loading follows the same license checking rules as kernel
+modules. BPF programs can be proprietary if they don't use "GPL only" BPF
+helper functions.
+
+Further, some BPF program types - Linux Security Modules (LSM) and TCP
+Congestion Control (struct_ops), as of Aug 2021 - are required to be GPL
+compatible even if they don't use "GPL only" helper functions directly. The
+registration step of LSM and TCP congestion control modules of the Linux
+kernel is done through EXPORT_SYMBOL_GPL kernel functions. In that sense LSM
+and struct_ops BPF programs are implicitly calling "GPL only" functions.
+The same restriction applies to BPF programs that call kernel functions
+directly via unstable interface also known as "kfunc".
+
+Packaging BPF programs with user space applications
+====================================================
+
+Generally, proprietary-licensed applications and GPL licensed BPF programs
+written for the Linux kernel in the same package can co-exist because they are
+separate executable processes. This applies to both cBPF and eBPF programs.
-- 
2.30.2

