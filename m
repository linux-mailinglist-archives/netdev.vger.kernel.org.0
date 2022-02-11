Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E43AB4B20F1
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 10:04:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346113AbiBKJEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 04:04:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243695AbiBKJEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 04:04:10 -0500
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CFB32F1B;
        Fri, 11 Feb 2022 01:04:08 -0800 (PST)
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9DxWMr7JAZin3sAAA--.392S3;
        Fri, 11 Feb 2022 16:57:32 +0800 (CST)
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     Xuefeng Li <lixuefeng@loongson.cn>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next 1/2] bpf: Add some description about BPF_JIT_ALWAYS_ON in Kconfig
Date:   Fri, 11 Feb 2022 16:57:30 +0800
Message-Id: <1644569851-20859-2-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1644569851-20859-1-git-send-email-yangtiezhu@loongson.cn>
References: <1644569851-20859-1-git-send-email-yangtiezhu@loongson.cn>
X-CM-TRANSID: AQAAf9DxWMr7JAZin3sAAA--.392S3
X-Coremail-Antispam: 1UD129KBjvdXoWrtF47WF4fJFyxCFWfJr1DZFb_yoWDArX_tr
        y5tr4kWws0kF9Y9F129F4fWFykXr15GF18C3Wagr1UA34ava13G3s8JF1jkF9xWw4Yyrnr
        WrZ3A39akr1IvjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUby8FF20E14v26ryj6rWUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGwA2048vs2IY02
        0Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
        wVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM2
        8EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AI
        xVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20x
        vE14v26r106r15McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xv
        r2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04
        v7MxkIecxEwVAFwVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC2
        0s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI
        0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv2
        0xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2js
        IE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZF
        pf9x0JUba9-UUUUU=
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When CONFIG_BPF_JIT_ALWAYS_ON is enabled, bpf_jit_enable is permanently
set to 1 and setting any other value than that will return in failure.

Add the above description in the help text of BPF_JIT_ALWAYS_ON, and then
we can distinguish between BPF_JIT_ALWAYS_ON and BPF_JIT_DEFAULT_ON.

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---
 kernel/bpf/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/bpf/Kconfig b/kernel/bpf/Kconfig
index d24d518..88409f8 100644
--- a/kernel/bpf/Kconfig
+++ b/kernel/bpf/Kconfig
@@ -58,6 +58,9 @@ config BPF_JIT_ALWAYS_ON
 	  Enables BPF JIT and removes BPF interpreter to avoid speculative
 	  execution of BPF instructions by the interpreter.
 
+	  When CONFIG_BPF_JIT_ALWAYS_ON is enabled, bpf_jit_enable is permanently
+	  set to 1 and setting any other value than that will return in failure.
+
 config BPF_JIT_DEFAULT_ON
 	def_bool ARCH_WANT_DEFAULT_BPF_JIT || BPF_JIT_ALWAYS_ON
 	depends on HAVE_EBPF_JIT && BPF_JIT
-- 
2.1.0

