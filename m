Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A330C2FE1B8
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 06:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbhAUF30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 00:29:26 -0500
Received: from mail.loongson.cn ([114.242.206.163]:46504 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726430AbhAUF25 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 00:28:57 -0500
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Dx2L3TEAlgPXAIAA--.13098S2;
        Thu, 21 Jan 2021 13:27:49 +0800 (CST)
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
        Xuefeng Li <lixuefeng@loongson.cn>,
        Fangrui Song <maskray@google.com>
Subject: [PATCH bpf-next v3] samples/bpf: Update build procedure for manually compiling LLVM and Clang
Date:   Thu, 21 Jan 2021 13:27:35 +0800
Message-Id: <1611206855-22555-1-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
X-CM-TRANSID: AQAAf9Dx2L3TEAlgPXAIAA--.13098S2
X-Coremail-Antispam: 1UD129KBjvJXoWxWw1Dtr43Jr4xCFWUJFyDAwb_yoWrCw17pw
        47Ka4S9rZ7Xry3XFWxGF4UXF4furs8Xa4UCa4xJ348Z3WDZrn2gr43t3yfWFW5Wr92yrW3
        Cr1fKFZ5uF1DXaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvE14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
        6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
        Y2ka0xkIwI1lc2xSY4AK67AK6r4rMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
        1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
        b7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
        vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI
        42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWI
        evJa73UjIFyTuYvjfUeF4iUUUUU
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current LLVM and Clang build procedure in samples/bpf/README.rst is
out of date. See below that the links are not accessible any more.

$ git clone http://llvm.org/git/llvm.git
Cloning into 'llvm'...
fatal: unable to access 'http://llvm.org/git/llvm.git/': Maximum (20) redirects followed
$ git clone --depth 1 http://llvm.org/git/clang.git
Cloning into 'clang'...
fatal: unable to access 'http://llvm.org/git/clang.git/': Maximum (20) redirects followed

The LLVM community has adopted new ways to build the compiler. There are
different ways to build LLVM and Clang, the Clang Getting Started page [1]
has one way. As Yonghong said, it is better to copy the build procedure
in Documentation/bpf/bpf_devel_QA.rst to keep consistent.

I verified the procedure and it is proved to be feasible, so we should
update README.rst to reflect the reality. At the same time, update the
related comment in Makefile.

Additionally, as Fangrui said, the dir llvm-project/llvm/build/install is
not used, BUILD_SHARED_LIBS=OFF is the default option [2], so also change
Documentation/bpf/bpf_devel_QA.rst together.

[1] https://clang.llvm.org/get_started.html
[2] https://www.llvm.org/docs/CMake.html

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Acked-by: Yonghong Song <yhs@fb.com>
---

v2: Update the commit message suggested by Yonghong,
    thank you very much.

v3: Remove the default option BUILD_SHARED_LIBS=OFF
    and just mkdir llvm-project/llvm/build suggested
    by Fangrui.

 Documentation/bpf/bpf_devel_QA.rst |  3 +--
 samples/bpf/Makefile               |  2 +-
 samples/bpf/README.rst             | 16 +++++++++-------
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/Documentation/bpf/bpf_devel_QA.rst b/Documentation/bpf/bpf_devel_QA.rst
index 5b613d2..18788bb 100644
--- a/Documentation/bpf/bpf_devel_QA.rst
+++ b/Documentation/bpf/bpf_devel_QA.rst
@@ -506,11 +506,10 @@ that set up, proceed with building the latest LLVM and clang version
 from the git repositories::
 
      $ git clone https://github.com/llvm/llvm-project.git
-     $ mkdir -p llvm-project/llvm/build/install
+     $ mkdir -p llvm-project/llvm/build
      $ cd llvm-project/llvm/build
      $ cmake .. -G "Ninja" -DLLVM_TARGETS_TO_BUILD="BPF;X86" \
                 -DLLVM_ENABLE_PROJECTS="clang"    \
-                -DBUILD_SHARED_LIBS=OFF           \
                 -DCMAKE_BUILD_TYPE=Release        \
                 -DLLVM_BUILD_RUNTIME=OFF
      $ ninja
diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 26fc96c..d061446 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -208,7 +208,7 @@ TPROGLDLIBS_xdpsock		+= -pthread -lcap
 TPROGLDLIBS_xsk_fwd		+= -pthread
 
 # Allows pointing LLC/CLANG to a LLVM backend with bpf support, redefine on cmdline:
-#  make M=samples/bpf/ LLC=~/git/llvm/build/bin/llc CLANG=~/git/llvm/build/bin/clang
+# make M=samples/bpf LLC=~/git/llvm-project/llvm/build/bin/llc CLANG=~/git/llvm-project/llvm/build/bin/clang
 LLC ?= llc
 CLANG ?= clang
 OPT ?= opt
diff --git a/samples/bpf/README.rst b/samples/bpf/README.rst
index dd34b2d..23006cb 100644
--- a/samples/bpf/README.rst
+++ b/samples/bpf/README.rst
@@ -65,17 +65,19 @@ To generate a smaller llc binary one can use::
 Quick sniplet for manually compiling LLVM and clang
 (build dependencies are cmake and gcc-c++)::
 
- $ git clone http://llvm.org/git/llvm.git
- $ cd llvm/tools
- $ git clone --depth 1 http://llvm.org/git/clang.git
- $ cd ..; mkdir build; cd build
- $ cmake .. -DLLVM_TARGETS_TO_BUILD="BPF;X86"
- $ make -j $(getconf _NPROCESSORS_ONLN)
+ $ git clone https://github.com/llvm/llvm-project.git
+ $ mkdir -p llvm-project/llvm/build
+ $ cd llvm-project/llvm/build
+ $ cmake .. -G "Ninja" -DLLVM_TARGETS_TO_BUILD="BPF;X86" \
+            -DLLVM_ENABLE_PROJECTS="clang"    \
+            -DCMAKE_BUILD_TYPE=Release        \
+            -DLLVM_BUILD_RUNTIME=OFF
+ $ ninja
 
 It is also possible to point make to the newly compiled 'llc' or
 'clang' command via redefining LLC or CLANG on the make command line::
 
- make M=samples/bpf LLC=~/git/llvm/build/bin/llc CLANG=~/git/llvm/build/bin/clang
+ make M=samples/bpf LLC=~/git/llvm-project/llvm/build/bin/llc CLANG=~/git/llvm-project/llvm/build/bin/clang
 
 Cross compiling samples
 -----------------------
-- 
2.1.0

