Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3875E4BF53D
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 10:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbiBVJ5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 04:57:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbiBVJ5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 04:57:41 -0500
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B0C10D224B;
        Tue, 22 Feb 2022 01:57:14 -0800 (PST)
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9DxmMhzsxRiHa8EAA--.4515S3;
        Tue, 22 Feb 2022 17:57:08 +0800 (CST)
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
Subject: [PATCH bpf-next v3 1/2] bpf: Add some description about BPF_JIT_ALWAYS_ON in Kconfig
Date:   Tue, 22 Feb 2022 17:57:05 +0800
Message-Id: <1645523826-18149-2-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1645523826-18149-1-git-send-email-yangtiezhu@loongson.cn>
References: <1645523826-18149-1-git-send-email-yangtiezhu@loongson.cn>
X-CM-TRANSID: AQAAf9DxmMhzsxRiHa8EAA--.4515S3
X-Coremail-Antispam: 1UD129KBjvdXoWrtF47WF4fJFyxCFWfJr1DZFb_yoWkXFc_tr
        y5tF48Wws0yFyF9F1a9a1fCFZ7Zr1UGr18C3Wagr17Za4avFnxGwn8JF1jkFy3Wws0vrZr
        WrZ3A392yr1SvjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbgAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGwA2048vs2IY02
        0Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
        wVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4
        x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I2
        62IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcV
        AFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG
        0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI
        1lc2xSY4AK67AK6r4fMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I
        3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxV
        WUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8I
        cVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aV
        AFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZE
        Xa7VUUuHq3UUUUU==
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When CONFIG_BPF_JIT_ALWAYS_ON is enabled, /proc/sys/net/core/bpf_jit_enable
is permanently set to 1 and setting any other value than that will return
failure.

Add the above description in the help text of config BPF_JIT_ALWAYS_ON, and
then we can distinguish between BPF_JIT_ALWAYS_ON and BPF_JIT_DEFAULT_ON.

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Acked-by: Song Liu <songliubraving@fb.com>
---
 kernel/bpf/Kconfig | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/bpf/Kconfig b/kernel/bpf/Kconfig
index d24d518..f3db15a 100644
--- a/kernel/bpf/Kconfig
+++ b/kernel/bpf/Kconfig
@@ -58,6 +58,10 @@ config BPF_JIT_ALWAYS_ON
 	  Enables BPF JIT and removes BPF interpreter to avoid speculative
 	  execution of BPF instructions by the interpreter.
 
+	  When CONFIG_BPF_JIT_ALWAYS_ON is enabled, /proc/sys/net/core/bpf_jit_enable
+	  is permanently set to 1 and setting any other value than that will return
+	  failure.
+
 config BPF_JIT_DEFAULT_ON
 	def_bool ARCH_WANT_DEFAULT_BPF_JIT || BPF_JIT_ALWAYS_ON
 	depends on HAVE_EBPF_JIT && BPF_JIT
-- 
2.1.0

