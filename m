Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2160C3BE1C
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 23:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389953AbfFJVIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 17:08:52 -0400
Received: from mail-oi1-f202.google.com ([209.85.167.202]:55144 "EHLO
        mail-oi1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389928AbfFJVIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 17:08:51 -0400
Received: by mail-oi1-f202.google.com with SMTP id x23so3246816oia.21
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 14:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ICt8unkfgBC7WFQ3SzlOOLIw6vRRyqFe1e0RPZOj5V8=;
        b=Sj2lcK54w1SCvsZ3GZn23+44shb9wyS9/d6FOlgKyApPwdJoBFiHdiqO4hrPwgGlU3
         9BRh40x9qvHOXzz2/qejMoVrg7iaqq/wzgDfpUTWc0Rm/gsGmDgEfjfOJRMOu24TVOnL
         cMxfbzJzD7B+4w+J9CuKavweaYvOM/y0K/YVsJx12da79P9RQCtQU61oSLBDx0q0j6MJ
         ueFdeY/PO9OAOjeh5r6TkNsTEdRpbMc65Ir/JIN8vYPou6cR/hn02KjjrYbtO6IEq9V0
         okKv1a4h16QFWlr3K9ZGRZe4gxnpokDaaqBG1N4z0jTFPftZeByarnsONarnRXrot+/7
         OBOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ICt8unkfgBC7WFQ3SzlOOLIw6vRRyqFe1e0RPZOj5V8=;
        b=fNGmlZUEhb4TDwAcRlANuJ3bMtU4h5hauk2EZR31jDzENLoea8m5YtkkxqkHZZ0tAN
         AozzVGsMqyDWl9Anslc5DQxzhQ+Qe1u23gDZwDfU1TnyD6axwpIK+j3TCf6y66vGJ6y7
         fQD/TDLVRQEMa3F1yM/p0Fld4KnR4oeQlZCiVSTrTYn4nM/BUVrH/bgTuWaYf3mWwS+N
         8jG9KEAO0pyz74JxZFeCD/hefQvsn4EDQAspjZicCfxS2uhe1k3DZDid0FsiLk0xH1co
         OFZJDqmCIpotsF0FE7yxYXR2D3uXyTqlIvf23UrSUz6BLY/BwKkX70z4mQ+2Rh/pEg8Q
         014A==
X-Gm-Message-State: APjAAAXA/e5eWQN8epfqZe1WmaQFZ8U09Ki38oMexVbmnuWHVv/iDjIJ
        YLt205pDuyb10p71Z+j3GDg/iFGfYMcdGI15BjkQW4yzoErRaPu+MirIMkNPWF9R4cmR/gNO7Wq
        ZhmWWu9Q7AnDrcf3FkpWbUqIKdcaeA9Yx1gnOb6vVMsrbn9AO9ox66Q==
X-Google-Smtp-Source: APXvYqzM0EqUDtcLIxeVLHoZQmg9KNnqdnJIt5ym/tR9W8FLrRfhXhvtvygQqQWqZotCHlAMsdLhtBE=
X-Received: by 2002:a05:6830:93:: with SMTP id a19mr391872oto.127.1560200931254;
 Mon, 10 Jun 2019 14:08:51 -0700 (PDT)
Date:   Mon, 10 Jun 2019 14:08:29 -0700
In-Reply-To: <20190610210830.105694-1-sdf@google.com>
Message-Id: <20190610210830.105694-8-sdf@google.com>
Mime-Version: 1.0
References: <20190610210830.105694-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.rc2.383.gf4fbbf30c2-goog
Subject: [PATCH bpf-next v5 7/8] bpf: add sockopt documentation
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

v2:
* use return code 2 for kernel bypass

Cc: Martin Lau <kafai@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 Documentation/bpf/index.rst               |  1 +
 Documentation/bpf/prog_cgroup_sockopt.rst | 39 +++++++++++++++++++++++
 2 files changed, 40 insertions(+)
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
index 000000000000..b117451ab571
--- /dev/null
+++ b/Documentation/bpf/prog_cgroup_sockopt.rst
@@ -0,0 +1,39 @@
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
+* ``1`` - success: after returning from the BPF hook, kernel will also
+  handle this socket option.
+* ``2`` - success: after returning from the BPF hook, kernel will _not_
+  handle this socket option; control will be returned to the userspace
+  instead.
-- 
2.22.0.rc2.383.gf4fbbf30c2-goog

