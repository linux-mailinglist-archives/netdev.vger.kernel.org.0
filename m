Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC418351F8
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 23:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfFDVfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 17:35:46 -0400
Received: from mail-yb1-f201.google.com ([209.85.219.201]:50756 "EHLO
        mail-yb1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbfFDVfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 17:35:45 -0400
Received: by mail-yb1-f201.google.com with SMTP id v5so2421777ybq.17
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 14:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=8dSHIXMBuFDqeVT5UIEbUOlUOx0oG7SBhAbd5Rhh1no=;
        b=iMukRS9atKUykqPrrIoSJ6wIQm7YK8WlGYCBT8h0H69VUH8SEy3KRRm7kV2oxVfYuv
         rnajzgJeagpqRviyszKLaeF1p4ixFGDbqsx/QMyQfJS3EMndwcsYhxQU1/MRp2oQKk2D
         lfoUeXx9nXxgAmC2U5xFmLPVCCzPdcqkZsadFIP3tcG3yGrra3hFYhbMcO/9n6pHcTDL
         KrB+oIANjpCeHaDj/iCqLEh93f+/BTgbRlJ681vnTT6kl9mo5yWTgByN7c1eMw9QmQAi
         GMqP48/F1Qcrb+GLts48E9wBRggSfRXykuL6Zv6Dcp5Xs47Myqy1kCdfGjIHrsanQEz0
         wxBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=8dSHIXMBuFDqeVT5UIEbUOlUOx0oG7SBhAbd5Rhh1no=;
        b=FLgolcHaEIP1sK0jFoxQPYjrFUcVm6YFK9lQCTRC7gj7Mr7FdDSRB0Oc/xqvNoheKg
         wqgyai15donPpOwsxDQY6HbDT8JUSL84dG6Gt25HYL6k3ovNWfUfKF6B+mIyvqPjdlvZ
         0iYC/ALc9KK3GWa8vYcD6juT1gUIBxFVVMYzPsRHHwTWN7yP7Ukyxxiimo21NtWSgoIM
         muQQ6sldztlHqKgCbFI5gfa2HEihBhyWqFG1VZx7d751/AtvfyzUeVH/gpi0uTM4+DYZ
         SJTaEPCE9nKcSoMoEywaI2Unn0uTp/1oFAO/RPeL6QTFh6js4jNtJcYbIizY1Hnq+ilx
         DxQQ==
X-Gm-Message-State: APjAAAUzDe/vlAty1Ilui/u6tuy/C+7MTZEW4i8SdxdGuHZSgfn6U+Ml
        xSsF4m8wLGR+ACowa8393Rd79SJueI3zUjLjE/VEyQ4VJGprm1FhFhsk2lRkA505CO/6BQBIQ0V
        WCfeawe0If5EZBq1wRBkp78nDBXkpIgK0qC8WjA+mgcSwTdGIlKB1UQ==
X-Google-Smtp-Source: APXvYqxI13FZdfBQArgkMDGgvFyl/a+mC2dcWIaRZIrGGHmu+hCagk/j4lqS84hc02FkZHQqql9dmxI=
X-Received: by 2002:a25:7bc4:: with SMTP id w187mr9686675ybc.122.1559684144124;
 Tue, 04 Jun 2019 14:35:44 -0700 (PDT)
Date:   Tue,  4 Jun 2019 14:35:23 -0700
In-Reply-To: <20190604213524.76347-1-sdf@google.com>
Message-Id: <20190604213524.76347-7-sdf@google.com>
Mime-Version: 1.0
References: <20190604213524.76347-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.rc1.311.g5d7573a151-goog
Subject: [PATCH bpf-next 6/7] bpf: add sockopt documentation
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide user documentation about sockopt prog type and cgroup hooks.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 Documentation/bpf/index.rst               |  1 +
 Documentation/bpf/prog_cgroup_sockopt.rst | 42 +++++++++++++++++++++++
 2 files changed, 43 insertions(+)
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
index 000000000000..7e34ed0b59c0
--- /dev/null
+++ b/Documentation/bpf/prog_cgroup_sockopt.rst
@@ -0,0 +1,42 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=====================
+BPF_PROG_TYPE_SOCKOPT
+=====================
+
+``BPF_PROG_TYPE_SOCKOPT`` program type can be attached to two cgroup hooks:
+
+* ``BPF_CGROUP_GETSOCKOPT`` - called every time process executes ``getsockopt``
+  system call.
+* ``BPF_CGROUP_SETSOCKOPT`` - called every time process executes ``setsockopt``
+  system call.
+
+The context (``struct bpf_sockopt``) has associated socket (``sk``) and
+all input arguments: ``level``, ``optname``, ``optval`` and ``optlen``.
+
+By default, when the hook returns, kernel code that handles ``getsockopt``
+or ``setsockopt`` is executed as well. That way BPF code can handle a
+subset of options and let kernel handle the rest. To prevent kernel
+handlers to be executed, there is a new helper called
+``bpf_sockopt_handled()``. It tells kernel that BPF program has handled
+the socket option and control should be returned to userspace.
+
+BPF_CGROUP_SETSOCKOPT
+=====================
+
+``BPF_CGROUP_SETSOCKOPT`` has a read-only context and this hook has
+access to cgroup and socket local storage.
+
+BPF_CGROUP_GETSOCKOPT
+=====================
+
+``BPF_CGROUP_GETSOCKOPT`` has to fill in ``optval`` and adjust
+``optlen`` accordingly. Input ``optlen`` contains the maximum length
+of data that can be returned to the userspace. In other words, BPF
+program can't increase ``optlen``, it can only decrease it.
+
+Return Type
+===========
+
+* ``0`` - reject the syscall, ``EPERM`` will be returned to the userspace.
+* ``1`` - success.
-- 
2.22.0.rc1.311.g5d7573a151-goog

