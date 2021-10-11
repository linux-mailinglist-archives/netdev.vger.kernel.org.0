Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C558042847F
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 03:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbhJKBVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 21:21:25 -0400
Received: from mail.loongson.cn ([114.242.206.163]:34100 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231481AbhJKBVX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Oct 2021 21:21:23 -0400
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9DxP2oPkWNh8sYXAA--.22187S2;
        Mon, 11 Oct 2021 09:19:11 +0800 (CST)
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Paul Burton <paulburton@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xuefeng Li <lixuefeng@loongson.cn>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Subject: [PATCH bpf-next v2 0/2] bpf, mips: Do some small changes
Date:   Mon, 11 Oct 2021 09:19:08 +0800
Message-Id: <1633915150-13220-1-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
X-CM-TRANSID: AQAAf9DxP2oPkWNh8sYXAA--.22187S2
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYq7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E
        6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
        kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8I
        cVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87
        Iv6xkF7I0E14v26r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IE
        w4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2jsIE14v26F4j6r4UJw
        Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAG
        YxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkIecxEwVAFwVWkMxAIw28IcxkI7VAKI48JMx
        C20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAF
        wI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20x
        vE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v2
        0xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14
        v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUFE_MDUUUU
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset is based on bpf-next tree:
https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git

v2:
  -- Update patch #2 to only fix the comment,
     suggested by Johan Almbladh, thank you.

Tiezhu Yang (2):
  bpf, mips: Clean up config options about JIT
  bpf, mips: Fix comment on tail call count limiting

 arch/mips/Kconfig              | 9 ---------
 arch/mips/net/Makefile         | 6 +++---
 arch/mips/net/bpf_jit_comp32.c | 2 +-
 3 files changed, 4 insertions(+), 13 deletions(-)

-- 
2.1.0

