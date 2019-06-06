Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 698DC37B8B
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 19:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730361AbfFFRwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 13:52:07 -0400
Received: from mail-ot1-f73.google.com ([209.85.210.73]:46274 "EHLO
        mail-ot1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729125AbfFFRwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 13:52:06 -0400
Received: by mail-ot1-f73.google.com with SMTP id z52so1383645otb.13
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 10:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=5w1rHDEgykvg+sQcOr0DvAmAd6C30bFeeDMr27zQ+cU=;
        b=CmsZKKGiG1CEHXcfLO3rtCWAfGA9soWVEmPZ1tTWhyJNWmJxasbV9ViZ8+uVG+NTAR
         ubBUttUV6epqJv9aqG+b6jqoNJ3OT7vgqMGIcnLduXeQ86OeaXa57YFZnKfGV+EQMxTt
         f/4fWZRwhk2WwIYWJnQfekwPAI+85XfZ4SGnW0XAnOeXBlIXwYuztEiTGw/4Ft9aa6I8
         Q3tGYDEmPg9yJ3wrnn1SDiPpQ+VwXoavZ4cP+JdwolICctaBf4k1AddBrvKmxm5blONQ
         XtOsDFP56uRNBLyViPZSR9QZcPWDmsp11kHEP2juTE48my2CMRmzFMNNfewgXvqfEdl6
         MxAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=5w1rHDEgykvg+sQcOr0DvAmAd6C30bFeeDMr27zQ+cU=;
        b=DSxXMSQeLAFRv3Pl6s+SFqt4W8nd/RLZW4CbwPDhNcTbZXBQHZSwq9GS9Ylfe8AWyI
         SXDROSIz6LENu6Pp5i1KNz9/UCldfx9RrDUxy3wcgea+3HefFccu/ryAA2LaPmHxi1oV
         3TFFNyxVnZ8LtGHia1IBVEZD3JTaXEJJegV2Lc3B0Pw62gdFOCSfkTBX0EOWlJ6RHUBR
         YnVE2SxLRMy2/sxsYD16hrqlEV490bS03GwrY8GyyscAeSpuBJW37/aRZ67wsQAQkAuX
         w1FfK+LXN7vTR5HuzB5PN7NELQodVmhd5abOWxmn+6IEVCf9NZGYylCuNbAh+VqDHVLA
         SE7Q==
X-Gm-Message-State: APjAAAWv4RO8VwhbDH01+4zB+AwdOvsRFrRX0uMd/kpE5YGRYz46eTSj
        Dtf5tJ2n7jmPdy/cPnfDvxakG+TYUu0/rJmeSH0k/NHfT//DVtUGJWa8eHuhAEqFdspyy/W5hEe
        iIXcDb7Zs0Z056k44im9SzaSfduVHYMVSiTi1FL3gSNE/4dWfv+Ti7A==
X-Google-Smtp-Source: APXvYqy/F8lP++S6JIgAQc1Z/Hy5Pp0FnN9HnCTl/TIsvA6lUvwi0v7voqAH6DT+bvfkduZuaXb/VmI=
X-Received: by 2002:a9d:5511:: with SMTP id l17mr15988239oth.158.1559843525807;
 Thu, 06 Jun 2019 10:52:05 -0700 (PDT)
Date:   Thu,  6 Jun 2019 10:51:45 -0700
In-Reply-To: <20190606175146.205269-1-sdf@google.com>
Message-Id: <20190606175146.205269-8-sdf@google.com>
Mime-Version: 1.0
References: <20190606175146.205269-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.rc1.311.g5d7573a151-goog
Subject: [PATCH bpf-next v2 7/8] bpf: add sockopt documentation
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

v2:
* use return code 2 for kernel bypass

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
2.22.0.rc1.311.g5d7573a151-goog

