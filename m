Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A87E32F9B96
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 09:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388084AbhARIyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 03:54:22 -0500
Received: from mail.loongson.cn ([114.242.206.163]:37702 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387937AbhARIyN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 03:54:13 -0500
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Dx++RvTAVguaoGAA--.11215S2;
        Mon, 18 Jan 2021 16:53:04 +0800 (CST)
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Xuefeng Li <lixuefeng@loongson.cn>
Subject: [PATCH bpf] samples/bpf: Update README.rst for manually compiling LLVM and clang
Date:   Mon, 18 Jan 2021 16:53:02 +0800
Message-Id: <1610959982-6420-1-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
X-CM-TRANSID: AQAAf9Dx++RvTAVguaoGAA--.11215S2
X-Coremail-Antispam: 1UD129KBjvJXoWxJr47Xw15WFWrtw4kXw1fJFb_yoW8Ar1rpF
        4UXa4a9rZYgFy2vF9xGw48ZF4fXrZ8XFy5GFyxJry8Z3ZxAFn7tr42kayrXF48WrZ29r43
        Ar1S9FWkAF1DZFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvE14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
        Y2ka0xkIwI1lc2xSY4AK67AK6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
        1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
        b7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
        vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI
        42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWI
        evJa73UjIFyTuYvjfU8Z2-UUUUU
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the current samples/bpf/README.rst, the url of llvm and clang git
may be out of date, they are unable to access:

$ git clone http://llvm.org/git/llvm.git
Cloning into 'llvm'...
fatal: unable to access 'http://llvm.org/git/llvm.git/': Maximum (20) redirects followed
$ git clone --depth 1 http://llvm.org/git/clang.git
Cloning into 'clang'...
fatal: unable to access 'http://llvm.org/git/clang.git/': Maximum (20) redirects followed

The Clang Getting Started page [1] might have more accurate information,
I verified the procedure and it is proved to be feasible, so we should
update it to reflect the reality.

[1] https://clang.llvm.org/get_started.html

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---
 samples/bpf/README.rst | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/samples/bpf/README.rst b/samples/bpf/README.rst
index dd34b2d..f606c08 100644
--- a/samples/bpf/README.rst
+++ b/samples/bpf/README.rst
@@ -65,11 +65,9 @@ To generate a smaller llc binary one can use::
 Quick sniplet for manually compiling LLVM and clang
 (build dependencies are cmake and gcc-c++)::
 
- $ git clone http://llvm.org/git/llvm.git
- $ cd llvm/tools
- $ git clone --depth 1 http://llvm.org/git/clang.git
- $ cd ..; mkdir build; cd build
- $ cmake .. -DLLVM_TARGETS_TO_BUILD="BPF;X86"
+ $ git clone https://github.com/llvm/llvm-project.git
+ $ cd llvm-project; mkdir build; cd build
+ $ cmake -DLLVM_ENABLE_PROJECTS=clang -DLLVM_TARGETS_TO_BUILD="BPF;X86" -G "Unix Makefiles" ../llvm
  $ make -j $(getconf _NPROCESSORS_ONLN)
 
 It is also possible to point make to the newly compiled 'llc' or
-- 
2.1.0

