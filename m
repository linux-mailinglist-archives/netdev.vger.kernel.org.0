Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E60CD36780A
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 05:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234799AbhDVDgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 23:36:54 -0400
Received: from mail.loongson.cn ([114.242.206.163]:59748 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234733AbhDVDgu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 23:36:50 -0400
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Dxv+4i74BgpyMMAA--.4298S2;
        Thu, 22 Apr 2021 11:36:02 +0800 (CST)
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
To:     Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xuefeng Li <lixuefeng@loongson.cn>
Subject: [PATCH bpf-next v3] bpf: Fix some invalid links in bpf_devel_QA.rst
Date:   Thu, 22 Apr 2021 11:36:00 +0800
Message-Id: <1619062560-30483-1-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
X-CM-TRANSID: AQAAf9Dxv+4i74BgpyMMAA--.4298S2
X-Coremail-Antispam: 1UD129KBjvJXoWxuryDGr45XFW7Kr43GrW3KFg_yoW5tF1xpa
        1fJw4a9r18Wr1fW3ykGr4UCrySqas3GayUCFn7JrZ5Zw1jvF92qr4S9r4rXa98Gryq9F43
        A34SkryY9a18ZrDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9014x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r
        xl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
        6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr
        0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E
        8cxan2IY04v7MxkIecxEwVAFwVW8GwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
        WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
        67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
        IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1U
        MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIda
        VFxhVjvjDU0xZFpf9x0JUa0PhUUUUU=
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There exist some errors "404 Not Found" when I click the link
of "MAINTAINERS" [1], "samples/bpf/" [2] and "selftests" [3]
in the documentation "HOWTO interact with BPF subsystem" [4].

As Alexei Starovoitov suggested, just remove "MAINTAINERS" and
"samples/bpf/" links and use correct link of "selftests".

[1] https://www.kernel.org/doc/html/MAINTAINERS
[2] https://www.kernel.org/doc/html/samples/bpf/
[3] https://www.kernel.org/doc/html/tools/testing/selftests/bpf/
[4] https://www.kernel.org/doc/html/latest/bpf/bpf_devel_QA.html

Fixes: 542228384888 ("bpf, doc: convert bpf_devel_QA.rst to use RST formatting")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---

v3: Remove "MAINTAINERS" and "samples/bpf/" links and
    use correct link of "selftests"

v2: Add Fixes: tag

 Documentation/bpf/bpf_devel_QA.rst | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/Documentation/bpf/bpf_devel_QA.rst b/Documentation/bpf/bpf_devel_QA.rst
index 2ed89ab..d05e67e 100644
--- a/Documentation/bpf/bpf_devel_QA.rst
+++ b/Documentation/bpf/bpf_devel_QA.rst
@@ -29,7 +29,7 @@ list:
 This may also include issues related to XDP, BPF tracing, etc.
 
 Given netdev has a high volume of traffic, please also add the BPF
-maintainers to Cc (from kernel MAINTAINERS_ file):
+maintainers to Cc (from kernel ``MAINTAINERS`` file):
 
 * Alexei Starovoitov <ast@kernel.org>
 * Daniel Borkmann <daniel@iogearbox.net>
@@ -234,11 +234,11 @@ be subject to change.
 
 Q: samples/bpf preference vs selftests?
 ---------------------------------------
-Q: When should I add code to `samples/bpf/`_ and when to BPF kernel
-selftests_ ?
+Q: When should I add code to ``samples/bpf/`` and when to BPF kernel
+selftests_?
 
 A: In general, we prefer additions to BPF kernel selftests_ rather than
-`samples/bpf/`_. The rationale is very simple: kernel selftests are
+``samples/bpf/``. The rationale is very simple: kernel selftests are
 regularly run by various bots to test for kernel regressions.
 
 The more test cases we add to BPF selftests, the better the coverage
@@ -246,9 +246,9 @@ and the less likely it is that those could accidentally break. It is
 not that BPF kernel selftests cannot demo how a specific feature can
 be used.
 
-That said, `samples/bpf/`_ may be a good place for people to get started,
+That said, ``samples/bpf/`` may be a good place for people to get started,
 so it might be advisable that simple demos of features could go into
-`samples/bpf/`_, but advanced functional and corner-case testing rather
+``samples/bpf/``, but advanced functional and corner-case testing rather
 into kernel selftests.
 
 If your sample looks like a test case, then go for BPF kernel selftests
@@ -645,10 +645,9 @@ when:
 
 .. Links
 .. _Documentation/process/: https://www.kernel.org/doc/html/latest/process/
-.. _MAINTAINERS: ../../MAINTAINERS
 .. _netdev-FAQ: ../networking/netdev-FAQ.rst
-.. _samples/bpf/: ../../samples/bpf/
-.. _selftests: ../../tools/testing/selftests/bpf/
+.. _selftests:
+   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/testing/selftests/bpf/
 .. _Documentation/dev-tools/kselftest.rst:
    https://www.kernel.org/doc/html/latest/dev-tools/kselftest.html
 .. _Documentation/bpf/btf.rst: btf.rst
-- 
2.1.0

