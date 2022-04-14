Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1573500C18
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 13:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242265AbiDNL1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 07:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242259AbiDNL1C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 07:27:02 -0400
Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14452C64C
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 04:24:34 -0700 (PDT)
X-QQ-mid: bizesmtp78t1649935458tg597fgm
Received: from wuhui-virtual-machine.localdoma ( [116.7.245.180])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 14 Apr 2022 19:23:56 +0800 (CST)
X-QQ-SSF: 01400000002000D0P000000A0000000
X-QQ-FEAT: ZHWZeLXy+8fe6XHMMc9WnsFu6wWzmmPbc2rC0zHdooyfRO1y5qb+Gd0rvxLlY
        lcdXfDXo4VWGZXjupnSF1BQGpxbqeE+dunVITG1c0ZybKRMwXbZcBhww1baYLSF6yQYV1hC
        riJNxWJ3WsnQ8zSIDNrkyyeDrPddstq5wEuaoIo0e8NPnkxKymVHCRDINR9M9FigGEXTFQe
        mUULy43HX3J/q7XImC7fG+wMWnNglZ1kguXWK6SvS754MD4dALqvegI6GBYudM+WzPDWkPd
        5t8GRBCn+p/mSMoa2wHqa5uAz2FM3XCCX8PlNdm6e4RmhVpV/fxg1ow+UsT4cpFX+9UI3M0
        hTkG/P4S9B/V5MFK9+1vcx9xAjRu70WvlwQfPmf
X-QQ-GoodBg: 2
From:   Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
To:     mingo@redhat.com
Cc:     peterz@infradead.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Subject: [PATCH] include/linux/sched.h: fix a comment
Date:   Thu, 14 Apr 2022 19:23:52 +0800
Message-Id: <20220414112352.2866-1-caoyixuan2019@email.szu.edu.cn>
X-Mailer: git-send-email 2.17.1
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:email.szu.edu.cn:qybgforeign:qybgforeign9
X-QQ-Bgrelay: 1
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_VALIDITY_RPBL,RCVD_IN_XBL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a language error, it is better to fix it.

Signed-off-by: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
---
 include/linux/sched.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0a56c9b4467c..4f26021f3b66 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -73,7 +73,7 @@ struct task_group;
  * encoded in fs/proc/array.c: get_task_state().
  *
  * We have two separate sets of flags: task->state
- * is about runnability, while task->exit_state are
+ * is about runnability, while task->exit_state is
  * about the task exiting. Confusing, but this way
  * modifying one set can't modify the other one by
  * mistake.
-- 
2.17.1



