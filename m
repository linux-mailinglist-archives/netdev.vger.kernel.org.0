Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4306D23413D
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 10:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731895AbgGaI3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 04:29:42 -0400
Received: from mail.loongson.cn ([114.242.206.163]:41852 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731648AbgGaI3l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 04:29:41 -0400
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9DxH99O1iNfpO8CAA--.8S2;
        Fri, 31 Jul 2020 16:29:03 +0800 (CST)
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
To:     Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Tobin C. Harding" <me@tobin.cc>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v3] Documentation/bpf: Use valid and new links in index.rst
Date:   Fri, 31 Jul 2020 16:29:02 +0800
Message-Id: <1596184142-18476-1-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
X-CM-TRANSID: AQAAf9DxH99O1iNfpO8CAA--.8S2
X-Coremail-Antispam: 1UD129KBjvJXoWxGFW8WFW7Kr4UXF15CFWfKrg_yoW5Gw1DpF
        n8Wryftrn8KFWUJw4xGF47Cr13WFWfAF4UWFykGw1Fqrn8JF1FgF4Sgrn0q3WUKryFyFW5
        ZF1fKFn8Xr18Z3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvlb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwV
        C2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
        0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Cr0_Gr
        1UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACI402YVCY1x02628vn2kI
        c2xKxwCY02Avz4vE14v_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr
        1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE
        14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7
        IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvE
        x4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvj
        DU0xZFpf9x07b5q2iUUUUU=
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There exists an error "404 Not Found" when I click the html link of
"Documentation/networking/filter.rst" in the BPF documentation [1],
fix it.

Additionally, use the new links about "BPF and XDP Reference Guide"
and "bpf(2)" to avoid redirects.

[1] https://www.kernel.org/doc/html/latest/bpf/

Fixes: d9b9170a2653 ("docs: bpf: Rename README.rst to index.rst")
Fixes: cb3f0d56e153 ("docs: networking: convert filter.txt to ReST")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---
 Documentation/bpf/index.rst         | 12 ++++++------
 Documentation/networking/filter.rst |  2 ++
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/Documentation/bpf/index.rst b/Documentation/bpf/index.rst
index 26f4bb3..44ca8ea 100644
--- a/Documentation/bpf/index.rst
+++ b/Documentation/bpf/index.rst
@@ -5,10 +5,10 @@ BPF Documentation
 This directory contains documentation for the BPF (Berkeley Packet
 Filter) facility, with a focus on the extended BPF version (eBPF).
 
-This kernel side documentation is still work in progress.  The main
+This kernel side documentation is still work in progress. The main
 textual documentation is (for historical reasons) described in
-`Documentation/networking/filter.rst`_, which describe both classical
-and extended BPF instruction-set.
+:ref:`networking-filter`, which describe both classical and extended
+BPF instruction-set.
 The Cilium project also maintains a `BPF and XDP Reference Guide`_
 that goes into great technical depth about the BPF Architecture.
 
@@ -68,7 +68,7 @@ Testing and debugging BPF
 
 
 .. Links:
-.. _Documentation/networking/filter.rst: ../networking/filter.txt
+.. _networking-filter: ../networking/filter.rst
 .. _man-pages: https://www.kernel.org/doc/man-pages/
-.. _bpf(2): http://man7.org/linux/man-pages/man2/bpf.2.html
-.. _BPF and XDP Reference Guide: http://cilium.readthedocs.io/en/latest/bpf/
+.. _bpf(2): https://man7.org/linux/man-pages/man2/bpf.2.html
+.. _BPF and XDP Reference Guide: https://docs.cilium.io/en/latest/bpf/
diff --git a/Documentation/networking/filter.rst b/Documentation/networking/filter.rst
index a1d3e19..debb59e 100644
--- a/Documentation/networking/filter.rst
+++ b/Documentation/networking/filter.rst
@@ -1,5 +1,7 @@
 .. SPDX-License-Identifier: GPL-2.0
 
+.. _networking-filter:
+
 =======================================================
 Linux Socket Filtering aka Berkeley Packet Filter (BPF)
 =======================================================
-- 
2.1.0

