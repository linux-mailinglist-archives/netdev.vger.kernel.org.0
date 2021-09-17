Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC1F5410191
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 01:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbhIQXCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 19:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245611AbhIQXCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 19:02:01 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E47DC061574;
        Fri, 17 Sep 2021 16:00:37 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id m26so10567416pff.3;
        Fri, 17 Sep 2021 16:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sfReti7a83D3VGk5l/sH9Oiuc/+dmaGav6YFwsSinKc=;
        b=N5T3zAyKWHKjCh8YJqYdH5TEoqJTPVNOIj7zcOxerZGX3VFNRxLRAe0PMMKZP/4slC
         6EodiMO9zHOEDR6LipScNpyAYeu4IlRRys+4Yws3r9CWUjtBZ4R3qPctFpK7/PfbfwzO
         3sWfStJ08fiMV9PpP2bY6f3TYDX1FoFuRRyzjPczKgSkKTyZqPDgpdqm7i3fMEkT/h4H
         iadJmUMSbHbpgu7P/pCtdv6l5A9ajtEbb4YxEeLvrFHEaAUovJOYriH2m/MtdJoRqQs6
         Oed0LRLy5/z0FSinJT8FLQoUZHyzE4KiMbeLBlzMs8/udfd/T5oebMmgTeUXdQ0b6P07
         asog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sfReti7a83D3VGk5l/sH9Oiuc/+dmaGav6YFwsSinKc=;
        b=NOKx0gsdGDGm9OP4J7V8vurXAArKw8qw1VCxXHp8VBbJ74men3Wv0AkxZpMyfR0mM9
         KaxHeQ3HyfDYCZ9eX0seqnS/fJoJtjZUde7qwzt0L+mHdcBJpkQu+z9k39Rt/7x6tK2i
         AZ8JbmbJu6Jx+QudZsO0X0U8hlc8NVVGPnpcIlOz90JFEjXsS4gCvpUW5wXBNNsdeRLP
         V5gPvxuht8ZyAY95FcX97x15viOvkMItYlVqN89Qp2hqcLUgRCt6DoPcZR2xqWZhtVHH
         3FtXXuvoVzj4WnFO5gMswucMayUUlV9OSHAHq60aH9/Ptrj0riMxxRw9vveWRHn8951j
         D3aA==
X-Gm-Message-State: AOAM530X1nUaewVOZ9fw+AlHc5GyuG0FXrGV54tosS/uTCGjpY3kFkKH
        ucZFhF4pn57VmN2NsaDbEU7ecxXJ2Wk=
X-Google-Smtp-Source: ABdhPJy057EE88i2UOc1JXm3kZxcFovzh8j0N0/5CGxZ9T+nbu4kr8v1HjWRYIolYAXH2ivgIUnu6w==
X-Received: by 2002:a63:790b:: with SMTP id u11mr11819433pgc.71.1631919636770;
        Fri, 17 Sep 2021 16:00:36 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:500::6:db29])
        by smtp.gmail.com with ESMTPSA id v25sm6768312pfm.202.2021.09.17.16.00.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 Sep 2021 16:00:36 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v2 bpf-next] bpf: Document BPF licensing.
Date:   Fri, 17 Sep 2021 16:00:34 -0700
Message-Id: <20210917230034.51080-1-alexei.starovoitov@gmail.com>
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
Acked-by: Stephen Hemminger <stephen@networkplumber.org>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: KP Singh <kpsingh@kernel.org>

---
v1->V2: Address Jonathan's feedback. Add Acks.
---
 Documentation/bpf/bpf_licensing.rst | 92 +++++++++++++++++++++++++++++
 Documentation/bpf/index.rst         |  9 +++
 2 files changed, 101 insertions(+)
 create mode 100644 Documentation/bpf/bpf_licensing.rst

diff --git a/Documentation/bpf/bpf_licensing.rst b/Documentation/bpf/bpf_licensing.rst
new file mode 100644
index 000000000000..b19c433f41d2
--- /dev/null
+++ b/Documentation/bpf/bpf_licensing.rst
@@ -0,0 +1,92 @@
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
+Documentation/process/license-rules.rst
+
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
diff --git a/Documentation/bpf/index.rst b/Documentation/bpf/index.rst
index 1ceb5d704a97..37f273a7e8b6 100644
--- a/Documentation/bpf/index.rst
+++ b/Documentation/bpf/index.rst
@@ -82,6 +82,15 @@ Testing and debugging BPF
    s390
 
 
+Licensing
+=========
+
+.. toctree::
+   :maxdepth: 1
+
+   bpf_licensing
+
+
 Other
 =====
 
-- 
2.30.2

