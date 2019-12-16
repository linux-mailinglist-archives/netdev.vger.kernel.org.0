Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFB941200BB
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 10:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbfLPJOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 04:14:16 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:39514 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727181AbfLPJOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 04:14:14 -0500
Received: by mail-pj1-f66.google.com with SMTP id v93so2696058pjb.6;
        Mon, 16 Dec 2019 01:14:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qigMm4EqiyANinCkFguk39Cl6HfqkkQUc4cgfeXf+Bk=;
        b=BckQdlsi9Dt8xH9pgrko9rHI855k7PWdnlZrhPLcQy1knWeDRCLkG4wmWQGrD3H9cl
         DTETfafa7A/GSj+Gt8KZfmw4HoHFjPhXHz/y7pWqTG0IGvA7h7Mx6PGpkYImGk/ItzsS
         bcVjB9HDw1w6xoHheeRZxgBzmmVjntrQWxIXykYzH3nGVQUFJzWRSz6wwW5JGRwxR+Jm
         pJ+ehcrStwAelXTioCm+lwQPBh9B+w34pAXtkbWD6vv8IKhncG2t/jDtjWKVKB93XLi9
         OM4noU82f6UvjevNGfYkH9Ts/L4ck85HkMgQVjH6cKPjiizKKGgBVO5hpaNT62ZyDdsd
         nHZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qigMm4EqiyANinCkFguk39Cl6HfqkkQUc4cgfeXf+Bk=;
        b=VlEn+FCqau5FdhluXgObc8j82OTYkTL1c6IzTVRtM8MBGQ1Q4dtr7i18R1vptCFeeY
         89ctWOJyWur9sil+70vVrZ4Wkt4jzsEe2zFReNlVsLt1mvIxtmmfTvEahZmnJUIBKTuH
         Y+vwZg78nW48d41hy0Od5g357eYSwI9x3e72SsJqt4rrTwuChHDYLUQpT8yCJlp6Zv0F
         mgIHnxcxi6ffruf5FpPrHXdi/u2geT/d8XdhSqEEeeoQRL3ZlMntOf/zZ0U0WCdgLRJ3
         XnGkUoMcFQBeMnwn1dv0kRlUia04Aba5UKMsoF4vJaWZPtozQwwz0852A4hrdDRIeUf1
         Zavg==
X-Gm-Message-State: APjAAAUj9VA64IuDnIo9M6EMcMaIHIIWB9xrkNBBXg21r2dnV5QZc/xe
        CQMmjTv/mydfANeA23/a28k=
X-Google-Smtp-Source: APXvYqxYqrVllDXaRnxxFZ6SRKc2DpVooTXs1XkSRJUyLVLcEMZa21+AMT6rkirvRyXtPMIQO7C7OQ==
X-Received: by 2002:a17:90b:30c4:: with SMTP id hi4mr16752987pjb.62.1576487653507;
        Mon, 16 Dec 2019 01:14:13 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr04-ext.fm.intel.com. [192.55.55.39])
        by smtp.gmail.com with ESMTPSA id x21sm12505033pfn.164.2019.12.16.01.14.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 01:14:13 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     daniel@iogearbox.net, ast@kernel.org, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        linux-riscv@lists.infradead.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v2 8/9] riscv, bpf: add missing uapi header for BPF_PROG_TYPE_PERF_EVENT programs
Date:   Mon, 16 Dec 2019 10:13:42 +0100
Message-Id: <20191216091343.23260-9-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191216091343.23260-1-bjorn.topel@gmail.com>
References: <20191216091343.23260-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing uapi header the BPF_PROG_TYPE_PERF_EVENT programs by
exporting struct user_regs_struct instead of struct pt_regs which is
in-kernel only.

Signed-off-by: Björn Töpel <bjorn.topel@gmail.com>
---
 arch/riscv/include/uapi/asm/bpf_perf_event.h | 9 +++++++++
 tools/include/uapi/asm/bpf_perf_event.h      | 2 ++
 2 files changed, 11 insertions(+)
 create mode 100644 arch/riscv/include/uapi/asm/bpf_perf_event.h

diff --git a/arch/riscv/include/uapi/asm/bpf_perf_event.h b/arch/riscv/include/uapi/asm/bpf_perf_event.h
new file mode 100644
index 000000000000..6cb1c2823288
--- /dev/null
+++ b/arch/riscv/include/uapi/asm/bpf_perf_event.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI__ASM_BPF_PERF_EVENT_H__
+#define _UAPI__ASM_BPF_PERF_EVENT_H__
+
+#include <asm/ptrace.h>
+
+typedef struct user_regs_struct bpf_user_pt_regs_t;
+
+#endif /* _UAPI__ASM_BPF_PERF_EVENT_H__ */
diff --git a/tools/include/uapi/asm/bpf_perf_event.h b/tools/include/uapi/asm/bpf_perf_event.h
index 13a58531e6fa..39acc149d843 100644
--- a/tools/include/uapi/asm/bpf_perf_event.h
+++ b/tools/include/uapi/asm/bpf_perf_event.h
@@ -2,6 +2,8 @@
 #include "../../arch/arm64/include/uapi/asm/bpf_perf_event.h"
 #elif defined(__s390__)
 #include "../../arch/s390/include/uapi/asm/bpf_perf_event.h"
+#elif defined(__riscv)
+#include "../../arch/riscv/include/uapi/asm/bpf_perf_event.h"
 #else
 #include <uapi/asm-generic/bpf_perf_event.h>
 #endif
-- 
2.20.1

