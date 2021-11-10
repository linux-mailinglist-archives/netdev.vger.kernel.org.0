Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F171544C051
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 12:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbhKJLta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 06:49:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231473AbhKJLt3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 06:49:29 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 186E3C061766
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 03:46:42 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id 77-20020a1c0450000000b0033123de3425so4404651wme.0
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 03:46:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+WeD3KpnuzAogYoo0Fzko2zvRDHXEul7LGZwbgrCd2g=;
        b=ChNZ7Yib7GsLqjHfQYqhRTSgynXyFEx+cUVopa/d517A0ta7Iw92OVdTDTXQQ/pSPN
         YYZUIHHLwDLmWknl03yTjXE3YCEnoWWECaetFyTZEzwYXr7QnyQoteIy3YxfT276pz1w
         XDhPbenszTBcPMDv35f221Zdwer2OsIQ1wcioCiblfX9Xf1zNhzDPRqpUfZof8QSD8Bj
         LJLwdayPOYqpesLUkTc1qmXHG1BxU1YZWpMfaz9QGOt9ofhmp7Gg8akfFdAzfnaGDnJm
         LzdtBj8P/+pU/nqC+b1m5v4skvsWI6Q+aFtWHZAqUwVwYvoUR0boA8TYHz2hNqW3ME3k
         QE7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+WeD3KpnuzAogYoo0Fzko2zvRDHXEul7LGZwbgrCd2g=;
        b=6is8m5d54T2FNXAZ4125t4VEadb78qHFwCVREZ4QGgdbNluNPo39n+a4jJnz36feCO
         p6RFGmxGSyryhcSbdGo1LjFf6xBFa7+j87u2bzA50L3KfG4OWfHTccMtnon3B6AQcwdP
         VrWZRZLaWlKPH4iyuI6TbIhKcIn7w2X0CMxHS3hjoMifEHn2bVFuBVZq8dH0yoMq4Rcd
         2f3IbDdtPD+n51wcIX7wmnnAI4/71j7n3uHdVAM/iY+HwKO2REwQbIyCc4LPDVhXfVlJ
         W8+zrq0FQXeVMMCvKGHqKdAyLQd0d+EI8RlcksJNMemcaTuyj2RGyRz4ySMzKtEgwFNc
         3OJw==
X-Gm-Message-State: AOAM5303hypuKmW6DdI3VUWTEH/fqr3k4fw7Xj6Sd+SZeW0iQCLVHUYE
        kC8c9yL7Pne2DbUldKDAm458p0yqSlMg4A==
X-Google-Smtp-Source: ABdhPJzHhohJYOAnDT33oQtmFXEC8jh4rEQNBXwB43fpXdlxLAonyPbyVUNJdbfPSP+D1CKD5+To4g==
X-Received: by 2002:a1c:e912:: with SMTP id q18mr16442857wmc.121.1636544800618;
        Wed, 10 Nov 2021 03:46:40 -0800 (PST)
Received: from localhost.localdomain ([149.86.79.190])
        by smtp.gmail.com with ESMTPSA id i15sm6241152wmq.18.2021.11.10.03.46.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 03:46:40 -0800 (PST)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 6/6] bpftool: Fix mixed indentation in documentation
Date:   Wed, 10 Nov 2021 11:46:32 +0000
Message-Id: <20211110114632.24537-7-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211110114632.24537-1-quentin@isovalent.com>
References: <20211110114632.24537-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some paragraphs in bpftool's documentation have a mix of tabs and spaces
for indentation. Let's make it consistent.

This patch brings no change to the text content.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 .../bpftool/Documentation/bpftool-cgroup.rst  | 10 +--
 .../bpf/bpftool/Documentation/bpftool-net.rst | 62 +++++++++----------
 2 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst b/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
index 13a217a2503d..8069d37dd991 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
@@ -30,9 +30,9 @@ CGROUP COMMANDS
 |	*PROG* := { **id** *PROG_ID* | **pinned** *FILE* | **tag** *PROG_TAG* }
 |	*ATTACH_TYPE* := { **ingress** | **egress** | **sock_create** | **sock_ops** | **device** |
 |		**bind4** | **bind6** | **post_bind4** | **post_bind6** | **connect4** | **connect6** |
-|               **getpeername4** | **getpeername6** | **getsockname4** | **getsockname6** | **sendmsg4** |
-|               **sendmsg6** | **recvmsg4** | **recvmsg6** | **sysctl** | **getsockopt** | **setsockopt** |
-|               **sock_release** }
+|		**getpeername4** | **getpeername6** | **getsockname4** | **getsockname6** | **sendmsg4** |
+|		**sendmsg6** | **recvmsg4** | **recvmsg6** | **sysctl** | **getsockopt** | **setsockopt** |
+|		**sock_release** }
 |	*ATTACH_FLAGS* := { **multi** | **override** }
 
 DESCRIPTION
@@ -98,9 +98,9 @@ DESCRIPTION
 		  **sendmsg6** call to sendto(2), sendmsg(2), sendmmsg(2) for an
 		  unconnected udp6 socket (since 4.18);
 		  **recvmsg4** call to recvfrom(2), recvmsg(2), recvmmsg(2) for
-                  an unconnected udp4 socket (since 5.2);
+		  an unconnected udp4 socket (since 5.2);
 		  **recvmsg6** call to recvfrom(2), recvmsg(2), recvmmsg(2) for
-                  an unconnected udp6 socket (since 5.2);
+		  an unconnected udp6 socket (since 5.2);
 		  **sysctl** sysctl access (since 5.2);
 		  **getsockopt** call to getsockopt (since 5.3);
 		  **setsockopt** call to setsockopt (since 5.3);
diff --git a/tools/bpf/bpftool/Documentation/bpftool-net.rst b/tools/bpf/bpftool/Documentation/bpftool-net.rst
index 1ae0375e8fea..7ec57535a7c1 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-net.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-net.rst
@@ -31,44 +31,44 @@ NET COMMANDS
 DESCRIPTION
 ===========
 	**bpftool net { show | list }** [ **dev** *NAME* ]
-                  List bpf program attachments in the kernel networking subsystem.
+		  List bpf program attachments in the kernel networking subsystem.
 
-                  Currently, only device driver xdp attachments and tc filter
-                  classification/action attachments are implemented, i.e., for
-                  program types **BPF_PROG_TYPE_SCHED_CLS**,
-                  **BPF_PROG_TYPE_SCHED_ACT** and **BPF_PROG_TYPE_XDP**.
-                  For programs attached to a particular cgroup, e.g.,
-                  **BPF_PROG_TYPE_CGROUP_SKB**, **BPF_PROG_TYPE_CGROUP_SOCK**,
-                  **BPF_PROG_TYPE_SOCK_OPS** and **BPF_PROG_TYPE_CGROUP_SOCK_ADDR**,
-                  users can use **bpftool cgroup** to dump cgroup attachments.
-                  For sk_{filter, skb, msg, reuseport} and lwt/seg6
-                  bpf programs, users should consult other tools, e.g., iproute2.
+		  Currently, only device driver xdp attachments and tc filter
+		  classification/action attachments are implemented, i.e., for
+		  program types **BPF_PROG_TYPE_SCHED_CLS**,
+		  **BPF_PROG_TYPE_SCHED_ACT** and **BPF_PROG_TYPE_XDP**.
+		  For programs attached to a particular cgroup, e.g.,
+		  **BPF_PROG_TYPE_CGROUP_SKB**, **BPF_PROG_TYPE_CGROUP_SOCK**,
+		  **BPF_PROG_TYPE_SOCK_OPS** and **BPF_PROG_TYPE_CGROUP_SOCK_ADDR**,
+		  users can use **bpftool cgroup** to dump cgroup attachments.
+		  For sk_{filter, skb, msg, reuseport} and lwt/seg6
+		  bpf programs, users should consult other tools, e.g., iproute2.
 
-                  The current output will start with all xdp program attachments, followed by
-                  all tc class/qdisc bpf program attachments. Both xdp programs and
-                  tc programs are ordered based on ifindex number. If multiple bpf
-                  programs attached to the same networking device through **tc filter**,
-                  the order will be first all bpf programs attached to tc classes, then
-                  all bpf programs attached to non clsact qdiscs, and finally all
-                  bpf programs attached to root and clsact qdisc.
+		  The current output will start with all xdp program attachments, followed by
+		  all tc class/qdisc bpf program attachments. Both xdp programs and
+		  tc programs are ordered based on ifindex number. If multiple bpf
+		  programs attached to the same networking device through **tc filter**,
+		  the order will be first all bpf programs attached to tc classes, then
+		  all bpf programs attached to non clsact qdiscs, and finally all
+		  bpf programs attached to root and clsact qdisc.
 
 	**bpftool** **net attach** *ATTACH_TYPE* *PROG* **dev** *NAME* [ **overwrite** ]
-                  Attach bpf program *PROG* to network interface *NAME* with
-                  type specified by *ATTACH_TYPE*. Previously attached bpf program
-                  can be replaced by the command used with **overwrite** option.
-                  Currently, only XDP-related modes are supported for *ATTACH_TYPE*.
+		  Attach bpf program *PROG* to network interface *NAME* with
+		  type specified by *ATTACH_TYPE*. Previously attached bpf program
+		  can be replaced by the command used with **overwrite** option.
+		  Currently, only XDP-related modes are supported for *ATTACH_TYPE*.
 
-                  *ATTACH_TYPE* can be of:
-                  **xdp** - try native XDP and fallback to generic XDP if NIC driver does not support it;
-                  **xdpgeneric** - Generic XDP. runs at generic XDP hook when packet already enters receive path as skb;
-                  **xdpdrv** - Native XDP. runs earliest point in driver's receive path;
-                  **xdpoffload** - Offload XDP. runs directly on NIC on each packet reception;
+		  *ATTACH_TYPE* can be of:
+		  **xdp** - try native XDP and fallback to generic XDP if NIC driver does not support it;
+		  **xdpgeneric** - Generic XDP. runs at generic XDP hook when packet already enters receive path as skb;
+		  **xdpdrv** - Native XDP. runs earliest point in driver's receive path;
+		  **xdpoffload** - Offload XDP. runs directly on NIC on each packet reception;
 
 	**bpftool** **net detach** *ATTACH_TYPE* **dev** *NAME*
-                  Detach bpf program attached to network interface *NAME* with
-                  type specified by *ATTACH_TYPE*. To detach bpf program, same
-                  *ATTACH_TYPE* previously used for attach must be specified.
-                  Currently, only XDP-related modes are supported for *ATTACH_TYPE*.
+		  Detach bpf program attached to network interface *NAME* with
+		  type specified by *ATTACH_TYPE*. To detach bpf program, same
+		  *ATTACH_TYPE* previously used for attach must be specified.
+		  Currently, only XDP-related modes are supported for *ATTACH_TYPE*.
 
 	**bpftool net help**
 		  Print short help message.
-- 
2.32.0

