Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4334F58BA3
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 22:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbfF0UZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 16:25:05 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:36073 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbfF0UYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 16:24:41 -0400
Received: by mail-pl1-f201.google.com with SMTP id a5so2074215pla.3
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 13:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ZJbz/C3e+sb5O/hI+5UE82UL50nEjTNC67t2N91YPtY=;
        b=lCTviplsuxpS22jrClW1mL6aRTLXQXF+1uQJl4GrP6ELiwrIM8+E29QIF7dhjFLGfi
         L6OYMLcLR2eAiHqKQuu83jwzMnjqC5d8Apw/sEF4B89WA6KsBhICw+c7ZFjW194I2AKo
         vxPW6ly4lbZGqGoPxV6yi0G/Vr/JY/b2bQILBmVoE2LEgToG3BoC8Bms2fPRezw3FAs6
         rs55e9Cxo/7e9nAqAkEepnKDI9q6NhBx6QmhfqaQ900R2wEifq7T8W4DPfu6MGZT+Khf
         btHFXN3aHvhR6hYd745qdaYxuXS86cfNwyWHwJRzvRmhaRolW+lpmW328cecxh0/DACC
         ucIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ZJbz/C3e+sb5O/hI+5UE82UL50nEjTNC67t2N91YPtY=;
        b=ZrSUZVbgX3I+tF7RNoD2lY5kF0ZuVMzFjnmvgL3/V7Co5MpOJLmE7YT7q96zExQOvs
         XC+qtIFkTxzp73QED75lNYDOuMFjD7mA5ywGscOvJT+bbQ4b0SAqaH2vgZMsi77xQ7R3
         uqlzjeXxLEdEw0uEe0+fEoJHnARMsXJjINy8cz/TLWNdfmCsIrsXKvB3bHgIUwO3DFoP
         QSUw60jpPy/KfMHLvvrozQos2uawoEKgEHg6dU91l0uZhghnmZkW1tnuAKpB4+GVuuFU
         /tYZXtSLC+ax9nRtZtuut7IbcYk8NdlFPRzNQ6yPbP0mVtOmxx+NcDhBrLk85TPlhOln
         W2Rg==
X-Gm-Message-State: APjAAAVIvN7g7U7rb0cki+CoU0bW47XqasEyEJEEHD96cPi/0JPj1f0C
        5W0r+eBvAInVImRJwFe0/LbF/2Fqkk91
X-Google-Smtp-Source: APXvYqxPs9/hX31AxgdEdEA6GWdFRzA3e8KBAWPjSOpGxJSpn8o6xpvG+ON50dqck6rcViGHvFWvoMlbXgXp
X-Received: by 2002:a63:5c1c:: with SMTP id q28mr5467792pgb.288.1561667080410;
 Thu, 27 Jun 2019 13:24:40 -0700 (PDT)
Date:   Thu, 27 Jun 2019 13:24:14 -0700
In-Reply-To: <20190627202417.33370-1-brianvv@google.com>
Message-Id: <20190627202417.33370-4-brianvv@google.com>
Mime-Version: 1.0
References: <20190627202417.33370-1-brianvv@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [RFC PATCH bpf-next v2 3/6] bpf: keep bpf.h in sync with tools/
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Brian Vazquez <brianvv@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds bpf_attr.dump structure to libbpf.

Suggested-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Brian Vazquez <brianvv@google.com>
---
 tools/include/uapi/linux/bpf.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index b077507efa3f3..1d753958874df 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -106,6 +106,7 @@ enum bpf_cmd {
 	BPF_TASK_FD_QUERY,
 	BPF_MAP_LOOKUP_AND_DELETE_ELEM,
 	BPF_MAP_FREEZE,
+	BPF_MAP_DUMP,
 };
 
 enum bpf_map_type {
@@ -385,6 +386,14 @@ union bpf_attr {
 		__u64		flags;
 	};
 
+	struct { /* struct used by BPF_MAP_DUMP command */
+		__u32		map_fd;
+		__aligned_u64	prev_key;
+		__aligned_u64	buf;
+		__aligned_u64	buf_len; /* input/output: len of buf */
+		__u64		flags;
+	} dump;
+
 	struct { /* anonymous struct used by BPF_PROG_LOAD command */
 		__u32		prog_type;	/* one of enum bpf_prog_type */
 		__u32		insn_cnt;
-- 
2.22.0.410.gd8fdbe21b5-goog

