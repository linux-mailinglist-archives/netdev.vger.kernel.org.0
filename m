Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0D874BF53C
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 10:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiBVJ5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 04:57:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbiBVJ5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 04:57:41 -0500
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 862BCD2249;
        Tue, 22 Feb 2022 01:57:14 -0800 (PST)
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9DxmMhzsxRiHa8EAA--.4515S4;
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
Subject: [PATCH bpf-next v3 2/2] bpf: Make BPF_JIT_DEFAULT_ON selectable in Kconfig
Date:   Tue, 22 Feb 2022 17:57:06 +0800
Message-Id: <1645523826-18149-3-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1645523826-18149-1-git-send-email-yangtiezhu@loongson.cn>
References: <1645523826-18149-1-git-send-email-yangtiezhu@loongson.cn>
X-CM-TRANSID: AQAAf9DxmMhzsxRiHa8EAA--.4515S4
X-Coremail-Antispam: 1UD129KBjvJXoW7KF1kuw4UKw13uFykAF1rtFb_yoW8Zw4Dpw
        4jqw1rKr92gr1fKayxCa47WF45G34UWr1UCFsxJ347ZF93AasrZr4ktr12qF17Zr92ga1Y
        qrZ5uF1kXa1Uu37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUPG14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
        x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
        Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
        8EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
        0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
        IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
        Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
        xKxwCY02Avz4vE14v_GFWl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l
        x2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14
        v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IY
        x2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87
        Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIF
        yTuYvjfUYJ5rUUUUU
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
index f3db15a..8521874 100644
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
 	  failure.
 
 config BPF_JIT_DEFAULT_ON
-	def_bool ARCH_WANT_DEFAULT_BPF_JIT || BPF_JIT_ALWAYS_ON
-	depends on HAVE_EBPF_JIT && BPF_JIT
+	bool "Enable BPF JIT by default"
+	default y if ARCH_WANT_DEFAULT_BPF_JIT
+	depends on BPF_SYSCALL && HAVE_EBPF_JIT && BPF_JIT
+	help
+	  Enables BPF JIT by default to avoid speculative execution of BPF
+	  instructions by the interpreter.
+
+	  When CONFIG_BPF_JIT_DEFAULT_ON is enabled but CONFIG_BPF_JIT_ALWAYS_ON
+	  is disabled, /proc/sys/net/core/bpf_jit_enable is set to 1 by default
+	  and can be changed to 0 or 2.
 
 config BPF_UNPRIV_DEFAULT_OFF
 	bool "Disable unprivileged BPF by default"
-- 
2.1.0

