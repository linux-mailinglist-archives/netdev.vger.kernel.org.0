Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D10464BC533
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 04:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241263AbiBSDPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 22:15:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240940AbiBSDPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 22:15:30 -0500
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9DC0C50B12;
        Fri, 18 Feb 2022 19:15:10 -0800 (PST)
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9DxWMm3YBBi94UDAA--.2803S4;
        Sat, 19 Feb 2022 11:15:05 +0800 (CST)
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
Subject: [PATCH bpf-next v2 2/2] bpf: Make BPF_JIT_DEFAULT_ON selectable in Kconfig
Date:   Sat, 19 Feb 2022 11:15:02 +0800
Message-Id: <1645240502-13398-3-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1645240502-13398-1-git-send-email-yangtiezhu@loongson.cn>
References: <1645240502-13398-1-git-send-email-yangtiezhu@loongson.cn>
X-CM-TRANSID: AQAAf9DxWMm3YBBi94UDAA--.2803S4
X-Coremail-Antispam: 1UD129KBjvJXoW7KF1kuw4UKw13uFykAF1rtFb_yoW8urWDpw
        1Yqw1Fkr92gr1fKayxCa47uF45Gw1UWr1UCFsxJ34UXF93AasrZr1ktr17XF47Zr92qa1Y
        qrZ3u3WkXa1UW37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUPK14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
        x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
        Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1l84
        ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxVW8Jr0_Cr1U
        M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
        v20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
        F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2
        IY04v7MxkIecxEwVAFwVW8GwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8
        JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1V
        AFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xII
        jxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4
        A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU
        0xZFpf9x0JUajgcUUUUU=
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, only x86, arm64 and s390 select ARCH_WANT_DEFAULT_BPF_JIT,
the other archs do not select ARCH_WANT_DEFAULT_BPF_JIT. On the archs
without ARCH_WANT_DEFAULT_BPF_JIT, if we want to set bpf_jit_enable to
1 by default, the only way is to enable CONFIG_BPF_JIT_ALWAYS_ON, then
the users can not change it to 0 or 2, it seems bad for some users. We
can select ARCH_WANT_DEFAULT_BPF_JIT for those archs if it is proper,
but at least for now, make BPF_JIT_DEFAULT_ON selectable can give them
a chance.

Additionally, with this patch, under !BPF_JIT_ALWAYS_ON, we can disable
BPF_JIT_DEFAULT_ON on the archs with ARCH_WANT_DEFAULT_BPF_JIT when make
menuconfig, it seems flexible for some developers.

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---
 kernel/bpf/Kconfig | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/Kconfig b/kernel/bpf/Kconfig
index cbf3f65..461ac60 100644
--- a/kernel/bpf/Kconfig
+++ b/kernel/bpf/Kconfig
@@ -54,6 +54,7 @@ config BPF_JIT
 config BPF_JIT_ALWAYS_ON
 	bool "Permanently enable BPF JIT and remove BPF interpreter"
 	depends on BPF_SYSCALL && HAVE_EBPF_JIT && BPF_JIT
+	select BPF_JIT_DEFAULT_ON
 	help
 	  Enables BPF JIT and removes BPF interpreter to avoid speculative
 	  execution of BPF instructions by the interpreter.
@@ -63,8 +64,16 @@ config BPF_JIT_ALWAYS_ON
 	  in failure.
 
 config BPF_JIT_DEFAULT_ON
-	def_bool ARCH_WANT_DEFAULT_BPF_JIT || BPF_JIT_ALWAYS_ON
-	depends on HAVE_EBPF_JIT && BPF_JIT
+	bool "Defaultly enable BPF JIT and remove BPF interpreter"
+	default y if ARCH_WANT_DEFAULT_BPF_JIT
+	depends on BPF_SYSCALL && HAVE_EBPF_JIT && BPF_JIT
+	help
+	  Enables BPF JIT and removes BPF interpreter to avoid speculative
+	  execution of BPF instructions by the interpreter.
+
+	  When CONFIG_BPF_JIT_DEFAULT_ON is enabled but CONFIG_BPF_JIT_ALWAYS_ON
+	  is disabled, /proc/sys/net/core/bpf_jit_enable is set to 1 by default
+	  and can be changed to 0 or 2.
 
 config BPF_UNPRIV_DEFAULT_OFF
 	bool "Disable unprivileged BPF by default"
-- 
2.1.0

