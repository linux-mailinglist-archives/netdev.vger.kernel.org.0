Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94383231F0C
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 15:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbgG2NJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 09:09:36 -0400
Received: from mail.loongson.cn ([114.242.206.163]:42620 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726476AbgG2NJg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 09:09:36 -0400
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9DxP97xdCFf0hcCAA--.2S2;
        Wed, 29 Jul 2020 21:09:05 +0800 (CST)
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
To:     Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Cc:     "Tobin C. Harding" <me@tobin.cc>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next] Documentation/bpf: Use valid and new links in index.rst
Date:   Wed, 29 Jul 2020 21:09:04 +0800
Message-Id: <1596028144-31374-1-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
X-CM-TRANSID: AQAAf9DxP97xdCFf0hcCAA--.2S2
X-Coremail-Antispam: 1UD129KBjvJXoW7trW3ZF13Wr4UXr4Dtr1UZFb_yoW8GrWkpF
        15WF1Sgrn8tF43Xws7GF47Cr1YgayfGF4Uua1UJw1Fqrn8Xa4v9F1S9rs0q3WUtrWFvFWr
        ZFyfKr90qrn7u3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvvb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I
        8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
        64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVW8JVWxJw
        Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkI
        wI1lc2xSY4AK67AK6ry8MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI
        8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AK
        xVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI
        8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E
        87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73Uj
        IFyTuYvjxUyOVyDUUUU
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There exists an error "404 Not Found" when I clik the html link of
"Documentation/networking/filter.rst" in the BPF documentation [1],
fix it.

Additionally, use the new links about "BPF and XDP Reference Guide"
and "bpf(2)" to avoid redirects.

[1] https://www.kernel.org/doc/html/latest/bpf/

Fixes: d9b9170a2653 ("docs: bpf: Rename README.rst to index.rst")
Fixes: cb3f0d56e153 ("docs: networking: convert filter.txt to ReST")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---
 Documentation/bpf/index.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/bpf/index.rst b/Documentation/bpf/index.rst
index 26f4bb3..1b901b4 100644
--- a/Documentation/bpf/index.rst
+++ b/Documentation/bpf/index.rst
@@ -68,7 +68,7 @@ Testing and debugging BPF
 
 
 .. Links:
-.. _Documentation/networking/filter.rst: ../networking/filter.txt
+.. _Documentation/networking/filter.rst: ../networking/filter.html
 .. _man-pages: https://www.kernel.org/doc/man-pages/
-.. _bpf(2): http://man7.org/linux/man-pages/man2/bpf.2.html
-.. _BPF and XDP Reference Guide: http://cilium.readthedocs.io/en/latest/bpf/
+.. _bpf(2): https://man7.org/linux/man-pages/man2/bpf.2.html
+.. _BPF and XDP Reference Guide: https://docs.cilium.io/en/latest/bpf/
-- 
2.1.0

