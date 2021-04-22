Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30600367F4C
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 13:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235955AbhDVLKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 07:10:47 -0400
Received: from mail.loongson.cn ([114.242.206.163]:42466 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229972AbhDVLKq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 07:10:46 -0400
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Dx7+6AWYFgpFQMAA--.4507S2;
        Thu, 22 Apr 2021 19:09:54 +0800 (CST)
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
Subject: [PATCH bpf-next v4] bpf: Fix some invalid links in bpf_devel_QA.rst
Date:   Thu, 22 Apr 2021 19:09:50 +0800
Message-Id: <1619089790-6252-1-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
X-CM-TRANSID: AQAAf9Dx7+6AWYFgpFQMAA--.4507S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Zw1kJw1fKF1UKFyfZFW5Wrg_yoW8Kr1rpa
        18Gr1a9r1Sgr1fXw4kKr4jvF4SvFs5Way7CFn7Jw1UZFyDZFykXr1S9rs8XanxGrykCFW5
        ArnakryF9w18Z37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9j14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26F4j6r4UJwAm72CE4IkC6x0Yz7v_Jr
        0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E
        8cxan2IY04v7MxkIecxEwVAFwVW8KwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
        WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
        67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
        IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1l
        IxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvf
        C2KfnxnUUI43ZEXa7VUbG2NtUUUUU==
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There exist some errors "404 Not Found" when I click the link
of "MAINTAINERS" [1], "samples/bpf/" [2] and "selftests" [3]
in the documentation "HOWTO interact with BPF subsystem" [4].

As Jesper Dangaard Brouer said, the links work if you are browsing
the document via GitHub [5], so I think maybe it is better to use
the corresponding GitHub links to fix the issues in the kernel.org
official document [4], this change has no influence on GitHub and
looks like more clear.

[1] https://www.kernel.org/doc/html/MAINTAINERS
[2] https://www.kernel.org/doc/html/samples/bpf/
[3] https://www.kernel.org/doc/html/tools/testing/selftests/bpf/
[4] https://www.kernel.org/doc/html/latest/bpf/bpf_devel_QA.html
[5] https://github.com/torvalds/linux/blob/master/Documentation/bpf/bpf_devel_QA.rst

Fixes: 542228384888 ("bpf, doc: convert bpf_devel_QA.rst to use RST formatting")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---

The initial aim is to fix the invalid links, sorry for the noisy.

v4: Use the corresponding GitHub links

v3: Remove "MAINTAINERS" and "samples/bpf/" links and
    use correct link of "selftests"

v2: Add Fixes: tag

 Documentation/bpf/bpf_devel_QA.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/bpf/bpf_devel_QA.rst b/Documentation/bpf/bpf_devel_QA.rst
index 2ed89ab..36a9b62 100644
--- a/Documentation/bpf/bpf_devel_QA.rst
+++ b/Documentation/bpf/bpf_devel_QA.rst
@@ -645,10 +645,10 @@ when:
 
 .. Links
 .. _Documentation/process/: https://www.kernel.org/doc/html/latest/process/
-.. _MAINTAINERS: ../../MAINTAINERS
+.. _MAINTAINERS: https://github.com/torvalds/linux/blob/master/MAINTAINERS
 .. _netdev-FAQ: ../networking/netdev-FAQ.rst
-.. _samples/bpf/: ../../samples/bpf/
-.. _selftests: ../../tools/testing/selftests/bpf/
+.. _samples/bpf/: https://github.com/torvalds/linux/tree/master/samples/bpf
+.. _selftests: https://github.com/torvalds/linux/tree/master/tools/testing/selftests/bpf
 .. _Documentation/dev-tools/kselftest.rst:
    https://www.kernel.org/doc/html/latest/dev-tools/kselftest.html
 .. _Documentation/bpf/btf.rst: btf.rst
-- 
2.1.0

