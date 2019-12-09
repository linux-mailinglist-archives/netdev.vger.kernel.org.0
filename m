Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41EE81172D4
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 18:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbfLIRcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 12:32:08 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:45110 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfLIRcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 12:32:08 -0500
Received: by mail-pj1-f68.google.com with SMTP id r11so6174169pjp.12;
        Mon, 09 Dec 2019 09:32:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qigMm4EqiyANinCkFguk39Cl6HfqkkQUc4cgfeXf+Bk=;
        b=vOpqIJ6q75D7Put1Ibs+aBj9GoAdDjQOk0kztitX4aNnyO/uS5BEGTuVOgzGw3NuBq
         JhC61Pb0KNlCTr4SsK7zAwkA3PhZlEAIDpK9DHRPY9T8ODSc9+HqQ7xpE8Ta/uMp8QUW
         qHTBgLILsfFr+3JqxiF26oCYVBtFk2gGrj72WTrXW3GF5KB0cxTJi0xpP/oy4drKf1vA
         ZxqCN+fhD3HZ716kGXZCnQqRhyvSGhQg8vPxDf4XLKKz8GX+t7jFrKyhuLlHH/z8klwd
         Y91XRDVJEquj55w7xMkcNWqqJnBOyzRGmO3lrm7tXbKsPFW1J+nIqrjeMe6b3wBgC90K
         Ogaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qigMm4EqiyANinCkFguk39Cl6HfqkkQUc4cgfeXf+Bk=;
        b=GeboLOxaxXDVeM4STJ7US0nnB0avA0DGgHO6KGf4jhk1Ya1jPIPsP89ZZjxrsjR5xv
         MUNsE7D4yeQpz0ly3fsAQe05CgpffAZEIWcab3XQsUDBIANmEErHu2Ng71Nm0bDq6un6
         XosxVG3emdvmxK70Hn0jr6eivJDDLLqJVdrMq6QIJjlRJ8iMWj7hj1YDK7NSylGprAjX
         r5ZqyuZFcEkU7y+HXNTmEvjKz4BVPDwhog5+fK9kFkFRyqGK0kTlM8Lq28OjGy3717Fl
         JYKBEoB+HUCxbjvl9LybbYGAV2Mb/JMH8Kmx4jcUi0UzGNayMHcV1o/K0QETyTWazpW1
         T/pg==
X-Gm-Message-State: APjAAAVTr4Is0WJt+2JrFIX5ZrVWyMzjWhJGHHhWBC42wVrINKEKMTkX
        ekndWvKZrmkBlPLai9NhLbSFCKVFWuQ=
X-Google-Smtp-Source: APXvYqyWxdQ0hJhMJ0rThrltp9ujToYcSdgDSDZcAlBK2cFpYYNKVR4Jr1SX1fsoeMJ7K9c2xhIJGA==
X-Received: by 2002:a17:902:ac8b:: with SMTP id h11mr30749482plr.87.1575912727095;
        Mon, 09 Dec 2019 09:32:07 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id d23sm54943pfo.176.2019.12.09.09.32.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 09:32:06 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     daniel@iogearbox.net, ast@kernel.org, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        linux-riscv@lists.infradead.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next 7/8] riscv, bpf: add missing uapi header for BPF_PROG_TYPE_PERF_EVENT programs
Date:   Mon,  9 Dec 2019 18:31:35 +0100
Message-Id: <20191209173136.29615-8-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191209173136.29615-1-bjorn.topel@gmail.com>
References: <20191209173136.29615-1-bjorn.topel@gmail.com>
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

