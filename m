Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 472095188F
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 18:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732087AbfFXQY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 12:24:56 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:55450 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731930AbfFXQYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 12:24:54 -0400
Received: by mail-pl1-f201.google.com with SMTP id q11so1218377pll.22
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 09:24:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=PScmwSK+K9IB8yZqW06OWrhD6812WTEkgOnr9yWmmf4=;
        b=wEfx71v1btEOlvKmKmG4dkf1KGyws8CgL75i2MN8jxzFYdlqumo5TK3W+0T/ktO7k/
         HwHeQ1f0wq9/FGsZMXF4PsxNBKLN0DQflEMUoIPj5MdFDnnAkZZtOtTo4fGx2a/4hT3c
         Gev0bUeqtsRN1DCThef+94kIX01/oQ5bUsrLuXrFART5/z7+gOkArdXJDtyyGSSCs8rK
         qRGBp8PF02XPgqBvvgVaE1vy+yodX0/bLieUqDu2Yi/rQgL0qsRUZE4mFapSn19Zx/2/
         ah1UJZVEKEr1jOSK4F+1HbA0HSsKsLYtgBU9rKobFieW96WkuQL+3OGK6uLZ4Exli0V2
         OunQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=PScmwSK+K9IB8yZqW06OWrhD6812WTEkgOnr9yWmmf4=;
        b=juVcQdIY+SSiSzJK0LaonDVeV1XCsmuWXbUFoRDiknF1vZGVUvO67VCik+fQDHd57K
         b9TJoaylxCKKF4cqwcZ5z6VOIHW1jdsJgKmvgGPC5Na9vJlQReYGtzeJhoTZb1QxDwnU
         YBtZFa1BxyV1hB/T8sXmaDcoxfH3BGR/oGNI3h9ngZeHYLUhsqt00pfxIAKlDod/gJyB
         QEF2xqDMTSdD5YrOEqEX5sYwy1UOWbCUoyub3Nx1uOC5r/fQBe4OATQSBYPPVANyvwZr
         KUQ4K/RNIMtap6/QElY3fHhseSj8D71qyBdXyyyZUCfpIlfe7fK1qCotwPRvnZkAHxWd
         BQYQ==
X-Gm-Message-State: APjAAAV8oIPJrenBwIQLeQC8aSPlxxRsZ6jL/vD81NtCE1Wkc38vJace
        QrYT8HTkxcuYG/bGkb9+do0RxvXsPAeN+OK+hdD9PayeDxAlRT52aWPmyg6cDR+/CP3d9Knwzsx
        4tXSiTgbG9I3PaadXG/D6vgcCo5e7Ht/TFtI9rzr5htQ2jTrOt9En0w==
X-Google-Smtp-Source: APXvYqzMMHwmVqaFzQnYx7bu5yd1OmIKwA79DzoWPcErMHCvC7ljY+EnI7Uo/KFuXh+MSyIIpKQtQOU=
X-Received: by 2002:a63:8043:: with SMTP id j64mr18485659pgd.216.1561393493248;
 Mon, 24 Jun 2019 09:24:53 -0700 (PDT)
Date:   Mon, 24 Jun 2019 09:24:28 -0700
In-Reply-To: <20190624162429.16367-1-sdf@google.com>
Message-Id: <20190624162429.16367-9-sdf@google.com>
Mime-Version: 1.0
References: <20190624162429.16367-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next v8 8/9] bpf: add sockopt documentation
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>, Martin Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide user documentation about sockopt prog type and cgroup hooks.

v7:
* add description for retval=0 and optlen=-1

v6:
* describe cgroup chaining, add example

v2:
* use return code 2 for kernel bypass

Cc: Martin Lau <kafai@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 Documentation/bpf/index.rst               |  1 +
 Documentation/bpf/prog_cgroup_sockopt.rst | 82 +++++++++++++++++++++++
 2 files changed, 83 insertions(+)
 create mode 100644 Documentation/bpf/prog_cgroup_sockopt.rst

diff --git a/Documentation/bpf/index.rst b/Documentation/bpf/index.rst
index d3fe4cac0c90..801a6ed3f2e5 100644
--- a/Documentation/bpf/index.rst
+++ b/Documentation/bpf/index.rst
@@ -42,6 +42,7 @@ Program types
 .. toctree::
    :maxdepth: 1
 
+   prog_cgroup_sockopt
    prog_cgroup_sysctl
    prog_flow_dissector
 
diff --git a/Documentation/bpf/prog_cgroup_sockopt.rst b/Documentation/bpf/prog_cgroup_sockopt.rst
new file mode 100644
index 000000000000..24985740711a
--- /dev/null
+++ b/Documentation/bpf/prog_cgroup_sockopt.rst
@@ -0,0 +1,82 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+============================
+BPF_PROG_TYPE_CGROUP_SOCKOPT
+============================
+
+``BPF_PROG_TYPE_CGROUP_SOCKOPT`` program type can be attached to two
+cgroup hooks:
+
+* ``BPF_CGROUP_GETSOCKOPT`` - called every time process executes ``getsockopt``
+  system call.
+* ``BPF_CGROUP_SETSOCKOPT`` - called every time process executes ``setsockopt``
+  system call.
+
+The context (``struct bpf_sockopt``) has associated socket (``sk``) and
+all input arguments: ``level``, ``optname``, ``optval`` and ``optlen``.
+
+BPF_CGROUP_SETSOCKOPT
+=====================
+
+``BPF_CGROUP_SETSOCKOPT`` is triggered *before* the kernel handling of
+sockopt and it has mostly read-only context (it can modify only ``optlen``).
+This hook has access to cgroup and socket local storage.
+
+If BPF program sets ``optlen`` to -1, the control will be returned
+back to the userspace after all other BPF programs in the cgroup
+chain finish (i.e. kernel ``setsockopt`` handling will *not* be executed).
+
+Note, that the only acceptable value to set to ``optlen`` is -1. Any
+other value will trigger ``EFAULT``.
+
+Return Type
+-----------
+
+* ``0`` - reject the syscall, ``EPERM`` will be returned to the userspace.
+* ``1`` - success, continue with next BPF program in the cgroup chain.
+
+BPF_CGROUP_GETSOCKOPT
+=====================
+
+``BPF_CGROUP_GETSOCKOPT`` is triggered *after* the kernel handing of
+sockopt. The BPF hook can observe ``optval``, ``optlen`` and ``retval``
+if it's interested in whatever kernel has returned. BPF hook can override
+the values above, adjust ``optlen`` and reset ``retval`` to 0. If ``optlen``
+has been increased above initial ``setsockopt`` value (i.e. userspace
+buffer is too small), ``EFAULT`` is returned.
+
+Note, that the only acceptable value to set to ``retval`` is 0 and the
+original value that the kernel returned. Any other value will trigger
+``EFAULT``.
+
+Return Type
+-----------
+
+* ``0`` - reject the syscall, ``EPERM`` will be returned to the userspace.
+* ``1`` - success: copy ``optval`` and ``optlen`` to userspace, return
+  ``retval`` from the syscall (note that this can be overwritten by
+  the BPF program from the parent cgroup).
+
+Cgroup Inheritance
+==================
+
+Suppose, there is the following cgroup hierarchy where each cgroup
+has ``BPF_CGROUP_GETSOCKOPT`` attached at each level with
+``BPF_F_ALLOW_MULTI`` flag::
+
+  A (root, parent)
+   \
+    B (child)
+
+When the application calls ``getsockopt`` syscall from the cgroup B,
+the programs are executed from the bottom up: B, A. First program
+(B) sees the result of kernel's ``getsockopt``. It can optionally
+adjust ``optval``, ``optlen`` and reset ``retval`` to 0. After that
+control will be passed to the second (A) program which will see the
+same context as B including any potential modifications.
+
+Example
+=======
+
+See ``tools/testing/selftests/bpf/progs/sockopt_sk.c`` for an example
+of BPF program that handles socket options.
-- 
2.22.0.410.gd8fdbe21b5-goog

