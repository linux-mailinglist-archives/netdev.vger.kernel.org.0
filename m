Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA7A2512CB7
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 09:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245201AbiD1H3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 03:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245099AbiD1H2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 03:28:48 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 108C630F78;
        Thu, 28 Apr 2022 00:25:28 -0700 (PDT)
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9BxMNpjQWpidk8BAA--.6695S3;
        Thu, 28 Apr 2022 15:25:25 +0800 (CST)
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] bpf, docs: Remove duplicated word "instructions"
Date:   Thu, 28 Apr 2022 15:25:22 +0800
Message-Id: <1651130723-23635-2-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1651130723-23635-1-git-send-email-yangtiezhu@loongson.cn>
References: <1651130723-23635-1-git-send-email-yangtiezhu@loongson.cn>
X-CM-TRANSID: AQAAf9BxMNpjQWpidk8BAA--.6695S3
X-Coremail-Antispam: 1UD129KBjvdXoWrtF4UCryftFy3XF18Wr1UAwb_yoWfArg_CF
        y7tFW5C3Z8Ka4rKr4UCr1UXF97uFWrCr18Ar1jyrsFq34DXa1DAFZ8tryqy343Cr4xuFn8
        JrZ7Xr13ArnxCjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbfkYjsxI4VWxJwAYFVCjjxCrM7AC8VAFwI0_Xr0_Wr1l1xkIjI8I
        6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7
        IE14v26r18M28IrcIa0xkI8VCY1x0267AKxVWUCVW8JwA2ocxC64kIII0Yj41l84x0c7CE
        w4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6x
        kF7I0E14v26F4j6r4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIE
        c7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I
        8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCF
        s4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCY02Avz4vE14v_GF4l42xK82IYc2Ij64
        vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
        jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
        x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK
        8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
        0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUxYLvDUUUU
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The word "instructions" is duplicated, remove it.

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---
 Documentation/bpf/instruction-set.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/bpf/instruction-set.rst b/Documentation/bpf/instruction-set.rst
index 5300837..30b019c 100644
--- a/Documentation/bpf/instruction-set.rst
+++ b/Documentation/bpf/instruction-set.rst
@@ -130,7 +130,7 @@ Byte swap instructions
 The byte swap instructions use an instruction class of ``BFP_ALU`` and a 4-bit
 code field of ``BPF_END``.
 
-The byte swap instructions instructions operate on the destination register
+The byte swap instructions operate on the destination register
 only and do not use a separate source register or immediate value.
 
 The 1-bit source operand field in the opcode is used to to select what byte
-- 
2.1.0

