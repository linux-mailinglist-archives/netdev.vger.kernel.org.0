Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7BC1917DE
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 18:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727609AbgCXRkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 13:40:52 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36419 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727266AbgCXRkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 13:40:52 -0400
Received: by mail-pf1-f195.google.com with SMTP id i13so9670719pfe.3;
        Tue, 24 Mar 2020 10:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=YhiLqIoYtWaeo+b59KQvNZJFmnotR12vApEKv2KkKKg=;
        b=EM+JwBdey2hknC7bLTtzQl1Gkj8zTWw8cxLe5zOafCUMGRY2mNZflhndxpY7byFLUQ
         cKbCv6JsZUPBJb8HNvIcmUHOcgHw+5MRp/0YkSBxSSI0I51McejKS+LbX3RDoHNqCuSH
         evybQRKemfJ1yxY9mvAEd0H9B7Rz/BbHDIOG1UbZmYHQ8C0et5bZWhV9hdNNPgP7J78x
         NJlyiQKfHXbgtFIz/JgfPD/fz7kVcpqTxoMBIv4NlHhwBa8TUbSMC5nLbKElO+1puaUM
         6jJgkrqhN6AsLnDU/43Iw0SywqZ21KgaNLWSYq8y/8vONWAK+cV7kAOnmsreDEg4bPgx
         r85Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=YhiLqIoYtWaeo+b59KQvNZJFmnotR12vApEKv2KkKKg=;
        b=ipZ7F5nPTRMhVteDFBpLn44nvPiuOo3Z06s4giPmfJSSINthX5Y+EC69PnleWrGAFo
         7mIjVR74eF/NtHEuEmNG6x3fzlOTDIa2dc4hXo7RLs+KkAM8I71U4MaT3ljBJkR/3xfr
         lHPuwIqzH54JjGwHavqIFr5ax3XnMX4kCzxVGMSH0A73lcdiyN8g2rERyKSUnbkiMqpL
         a1LddpCPCcDg6FyGzY0I7SBY2YdE0UXFpYdghESphXOdSEUOGuvltkcPrOR3elwQ7LWJ
         lfNeYZb9naaf84iIgnqunTmrBIGGepoNooOAmA5bqXBsuHLOIc6/UFpYDYJ0nDHL/stg
         Lr7g==
X-Gm-Message-State: ANhLgQ1zB3fu862nDr2t9ovnZSbm6PPILUjT0sII0smpYzngk/E2IK2j
        iDWWMZEULxXWb9MvUxOqBXI=
X-Google-Smtp-Source: ADFU+vtQ5tWlbp2xnRTVvbFc1FtLI4jC/qujGDZZnESfOmNtHv7bshjQqe+0U3iDil9e55aWVDMV9A==
X-Received: by 2002:a63:b04f:: with SMTP id z15mr27494569pgo.58.1585071649390;
        Tue, 24 Mar 2020 10:40:49 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id o11sm2860572pjb.18.2020.03.24.10.40.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Mar 2020 10:40:49 -0700 (PDT)
Subject: [bpf-next PATCH 09/10] bpf: test_verifier,
 #65 error message updates for trunc of boundary-cross
From:   John Fastabend <john.fastabend@gmail.com>
To:     ecree@solarflare.com, yhs@fb.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Tue, 24 Mar 2020 10:40:36 -0700
Message-ID: <158507163638.15666.12642752583323152341.stgit@john-Precision-5820-Tower>
In-Reply-To: <158507130343.15666.8018068546764556975.stgit@john-Precision-5820-Tower>
References: <158507130343.15666.8018068546764556975.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After changes to add update_reg_bounds after ALU ops and 32-bit bounds
tracking truncation of boundary crossing range will fail earlier and with
a different error message. Now the test error trace is the following

11: (17) r1 -= 2147483584
12: R0_w=map_value(id=0,off=0,ks=8,vs=8,imm=0)
    R1_w=invP(id=0,smin_value=-2147483584,smax_value=63)
    R10=fp0 fp-8_w=mmmmmmmm
12: (17) r1 -= 2147483584
13: R0_w=map_value(id=0,off=0,ks=8,vs=8,imm=0)
    R1_w=invP(id=0,
              umin_value=18446744069414584448,umax_value=18446744071562068095,
              var_off=(0xffffffff00000000; 0xffffffff))
    R10=fp0 fp-8_w=mmmmmmmm
13: (77) r1 >>= 8
14: R0_w=map_value(id=0,off=0,ks=8,vs=8,imm=0)
    R1_w=invP(id=0,
              umin_value=72057594021150720,umax_value=72057594029539328,
              var_off=(0xffffffff000000; 0xffffff),
              s32_min_value=-16777216,s32_max_value=-1,
              u32_min_value=-16777216)
    R10=fp0 fp-8_w=mmmmmmmm
14: (0f) r0 += r1
value 72057594021150720 makes map_value pointer be out of bounds

Because we have 'umin_value == umax_value' instead of previously
where 'umin_value != umax_value' we can now fail earlier noting
that pointer addition is out of bounds.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 tools/testing/selftests/bpf/verifier/bounds.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/bpf/verifier/bounds.c b/tools/testing/selftests/bpf/verifier/bounds.c
index 7c9b659..cf72fcc 100644
--- a/tools/testing/selftests/bpf/verifier/bounds.c
+++ b/tools/testing/selftests/bpf/verifier/bounds.c
@@ -257,17 +257,15 @@
 	 *      [0x00ff'ffff'ff00'0000, 0x00ff'ffff'ffff'ffff]
 	 */
 	BPF_ALU64_IMM(BPF_RSH, BPF_REG_1, 8),
-	/* no-op or OOB pointer computation */
+	/* error on OOB pointer computation */
 	BPF_ALU64_REG(BPF_ADD, BPF_REG_0, BPF_REG_1),
-	/* potentially OOB access */
-	BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_0, 0),
 	/* exit */
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
 	.fixup_map_hash_8b = { 3 },
 	/* not actually fully unbounded, but the bound is very high */
-	.errstr = "R0 unbounded memory access",
+	.errstr = "value 72057594021150720 makes map_value pointer be out of bounds",
 	.result = REJECT
 },
 {
@@ -299,17 +297,15 @@
 	 *      [0x00ff'ffff'ff00'0000, 0x00ff'ffff'ffff'ffff]
 	 */
 	BPF_ALU64_IMM(BPF_RSH, BPF_REG_1, 8),
-	/* no-op or OOB pointer computation */
+	/* error on OOB pointer computation */
 	BPF_ALU64_REG(BPF_ADD, BPF_REG_0, BPF_REG_1),
-	/* potentially OOB access */
-	BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_0, 0),
 	/* exit */
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
 	.fixup_map_hash_8b = { 3 },
 	/* not actually fully unbounded, but the bound is very high */
-	.errstr = "R0 unbounded memory access",
+	.errstr = "value 72057594021150720 makes map_value pointer be out of bounds",
 	.result = REJECT
 },
 {

