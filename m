Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A14796CF2
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 01:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbfHTXJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 19:09:15 -0400
Received: from lekensteyn.nl ([178.21.112.251]:51785 "EHLO lekensteyn.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726317AbfHTXJI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 19:09:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lekensteyn.nl; s=s2048-2015-q1;
        h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From; bh=4pxomqX2YRpm2Ejb0bxAI4CKwQidMFt5OJE5J3FrhiE=;
        b=X19LfTUdA3joSllsolRzkLSGkOMA7VihhSE3hrFbZhBJIdzjW18Dsl0mbfkoUEUK0a9wgnpkplKN9YNbPUsjJAlJz05gVShVIc4ZMk7l7XEilcOXKNrcmQ7xzoDmyyN72FBGGPP5sUa+Z1zg9r0n3M+ZmR2OTmHipEc3EcYho9cCaGmtoEVG/5Q2EiEqS+yHI/cJZvSfSEed2vYwZBPo90CHCtLH+nxmz0DtpcEMGG8Sh7LMrf4hoBPHTEbiE8dUAvXXr6eraSLmcU1iETpkcS2xjH8y6lEz4FXUvRP3Xg7RFiD6ytUwmb+hTuWNGa/8nOh+ZyX9qZzwz0j+lhiEiA==;
Received: by lekensteyn.nl with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <peter@lekensteyn.nl>)
        id 1i0DFQ-00055S-W4; Wed, 21 Aug 2019 01:09:05 +0200
From:   Peter Wu <peter@lekensteyn.nl>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH v2 2/4] bpf: fix 'struct pt_reg' typo in documentation
Date:   Wed, 21 Aug 2019 00:08:58 +0100
Message-Id: <20190820230900.23445-3-peter@lekensteyn.nl>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190820230900.23445-1-peter@lekensteyn.nl>
References: <20190820230900.23445-1-peter@lekensteyn.nl>
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
 include/uapi/linux/bpf.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

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
-- 
2.22.0

