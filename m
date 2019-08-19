Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4D0F94FC9
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 23:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728574AbfHSVV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 17:21:29 -0400
Received: from lekensteyn.nl ([178.21.112.251]:34193 "EHLO lekensteyn.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728305AbfHSVV2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 17:21:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lekensteyn.nl; s=s2048-2015-q1;
        h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From; bh=7CupV58WRWiKDxvQAu9+9At5uK+8XL0fGrHzxya5eWk=;
        b=TG42tdnvVmRV8yPboaizVeQmKvtJjMpuv7o06/I1+F/9Jx8JzuTL3bD/wIoI81Rdi24LSrdsGuKKrLXGpp073aDShnYTEpgjymslcOuCKxLEbxhxSl8BaDatcINUgPqndmvkNwxgydcYpRBnTiT/2rWX2T7Y+RGwW5gczDRQmqDsAJOe75tMknHKbe9E/PYywjSV7/TMEl5S9jSpiito3qlJ9p2kgxD0YJmtxLbc27hglJ5KwML2psT4QN4HgX2XfgvqRzVqAbUU0d3i8jTB68BmE2F/JgcK6A8c2Ogef8p341SkWMwQOMLmqV1lLMlB3QJX3T5CO6iNU3Cdzo3QNw==;
Received: by lekensteyn.nl with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <peter@lekensteyn.nl>)
        id 1hzp5g-0005T6-Ha; Mon, 19 Aug 2019 23:21:24 +0200
From:   Peter Wu <peter@lekensteyn.nl>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH 1/2] bpf: fix 'struct pt_reg' typo in documentation
Date:   Mon, 19 Aug 2019 22:21:21 +0100
Message-Id: <20190819212122.10286-2-peter@lekensteyn.nl>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190819212122.10286-1-peter@lekensteyn.nl>
References: <20190819212122.10286-1-peter@lekensteyn.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -0.0 (/)
X-Spam-Status: No, hits=-0.0 required=5.0 tests=NO_RELAYS=-0.001 autolearn=unavailable autolearn_force=no
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no 'struct pt_reg'.

Signed-off-by: Peter Wu <peter@lekensteyn.nl>
---
 include/uapi/linux/bpf.h       | 6 +++---
 tools/include/uapi/linux/bpf.h | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index fa1c753dcdbc..9ca333c3ce91 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1013,7 +1013,7 @@ union bpf_attr {
  * 		The realm of the route for the packet associated to *skb*, or 0
  * 		if none was found.
  *
- * int bpf_perf_event_output(struct pt_reg *ctx, struct bpf_map *map, u64 flags, void *data, u64 size)
+ * int bpf_perf_event_output(struct pt_regs *ctx, struct bpf_map *map, u64 flags, void *data, u64 size)
  * 	Description
  * 		Write raw *data* blob into a special BPF perf event held by
  * 		*map* of type **BPF_MAP_TYPE_PERF_EVENT_ARRAY**. This perf
@@ -1075,7 +1075,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_get_stackid(struct pt_reg *ctx, struct bpf_map *map, u64 flags)
+ * int bpf_get_stackid(struct pt_regs *ctx, struct bpf_map *map, u64 flags)
  * 	Description
  * 		Walk a user or a kernel stack and return its id. To achieve
  * 		this, the helper needs *ctx*, which is a pointer to the context
@@ -1724,7 +1724,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_override_return(struct pt_reg *regs, u64 rc)
+ * int bpf_override_return(struct pt_regs *regs, u64 rc)
  * 	Description
  * 		Used for error injection, this helper uses kprobes to override
  * 		the return value of the probed function, and to set it to *rc*.
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 4e455018da65..8bff70ff5ce9 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1013,7 +1013,7 @@ union bpf_attr {
  * 		The realm of the route for the packet associated to *skb*, or 0
  * 		if none was found.
  *
- * int bpf_perf_event_output(struct pt_reg *ctx, struct bpf_map *map, u64 flags, void *data, u64 size)
+ * int bpf_perf_event_output(struct pt_regs *ctx, struct bpf_map *map, u64 flags, void *data, u64 size)
  * 	Description
  * 		Write raw *data* blob into a special BPF perf event held by
  * 		*map* of type **BPF_MAP_TYPE_PERF_EVENT_ARRAY**. This perf
@@ -1075,7 +1075,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_get_stackid(struct pt_reg *ctx, struct bpf_map *map, u64 flags)
+ * int bpf_get_stackid(struct pt_regs *ctx, struct bpf_map *map, u64 flags)
  * 	Description
  * 		Walk a user or a kernel stack and return its id. To achieve
  * 		this, the helper needs *ctx*, which is a pointer to the context
@@ -1721,7 +1721,7 @@ union bpf_attr {
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  *
- * int bpf_override_return(struct pt_reg *regs, u64 rc)
+ * int bpf_override_return(struct pt_regs *regs, u64 rc)
  * 	Description
  * 		Used for error injection, this helper uses kprobes to override
  * 		the return value of the probed function, and to set it to *rc*.
-- 
2.22.0

