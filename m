Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A14EC512D0F
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 09:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245523AbiD1HjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 03:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245610AbiD1HjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 03:39:05 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0FEAC344ED;
        Thu, 28 Apr 2022 00:35:49 -0700 (PDT)
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9BxUNrQQ2piqFEBAA--.6543S4;
        Thu, 28 Apr 2022 15:35:46 +0800 (CST)
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next RESEND 2/2] bpf, docs: BPF_FROM_BE exists as alias for BPF_TO_BE
Date:   Thu, 28 Apr 2022 15:35:44 +0800
Message-Id: <1651131344-24528-3-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1651131344-24528-1-git-send-email-yangtiezhu@loongson.cn>
References: <1651131344-24528-1-git-send-email-yangtiezhu@loongson.cn>
X-CM-TRANSID: AQAAf9BxUNrQQ2piqFEBAA--.6543S4
X-Coremail-Antispam: 1UD129KBjvdXoW7GrWrJryUJrWruF47WF17KFg_yoW3Zrg_CF
        1kJ3Z5Wa1rCryruw1UWF1xCF97AFWrur4UA3WIyF4DAayqqws8Cr98W34DArWUGrW7u398
        CrZ3Wry3ZrnrGjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbqxYjsxI4VWxJwAYFVCjjxCrM7AC8VAFwI0_Wr0E3s1l1xkIjI8I
        6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7
        IE14v26r15M28IrcIa0xkI8VCY1x0267AKxVW8JVW5JwA2ocxC64kIII0Yj41l84x0c7CE
        w4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6x
        kF7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv
        6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c
        02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVW8JVWxJwAm72CE
        4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1lc2xSY4
        AK67AK6r4xMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8C
        rVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8Zw
        CIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x02
        67AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr
        0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU090
        ePUUUUU==
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According include/uapi/linux/bpf.h:

  #define BPF_FROM_LE	BPF_TO_LE
  #define BPF_FROM_BE	BPF_TO_BE

BPF_FROM_BE exists as alias for BPF_TO_BE instead of BPF_TO_LE.

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---
 Documentation/bpf/instruction-set.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/bpf/instruction-set.rst b/Documentation/bpf/instruction-set.rst
index 30b019c..00b0800 100644
--- a/Documentation/bpf/instruction-set.rst
+++ b/Documentation/bpf/instruction-set.rst
@@ -157,7 +157,7 @@ Examples:
   dst_reg = htobe64(dst_reg)
 
 ``BPF_FROM_LE`` and ``BPF_FROM_BE`` exist as aliases for ``BPF_TO_LE`` and
-``BPF_TO_LE`` respetively.
+``BPF_TO_BE`` respetively.
 
 
 Jump instructions
-- 
2.1.0

