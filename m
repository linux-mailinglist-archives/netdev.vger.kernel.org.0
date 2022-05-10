Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA4C520C32
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 05:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235660AbiEJDmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 23:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235507AbiEJDkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 23:40:37 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 903C7208F6F;
        Mon,  9 May 2022 20:35:10 -0700 (PDT)
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Axythn3XliaKoPAA--.50059S3;
        Tue, 10 May 2022 11:35:04 +0800 (CST)
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
To:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Xuefeng Li <lixuefeng@loongson.cn>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v2 1/2] net: sysctl: Use SYSCTL_TWO instead of &two
Date:   Tue, 10 May 2022 11:35:02 +0800
Message-Id: <1652153703-22729-2-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1652153703-22729-1-git-send-email-yangtiezhu@loongson.cn>
References: <1652153703-22729-1-git-send-email-yangtiezhu@loongson.cn>
X-CM-TRANSID: AQAAf9Axythn3XliaKoPAA--.50059S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Zr1xtw4UXr13CrWkKw1rWFg_yoW8JFWxpr
        n3G3yUKF98GryxAa95CFZ8Krn8Jr4DuF4UWF9FkayFka4qgr95JF1kWryjqrWUAFWjgFyx
        XrW0yr98W3yIy3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUPE14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
        x26xkF7I0E14v26r1I6r4UM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
        Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
        A2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26F4UJVW0
        owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
        IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
        M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
        kIc2xKxwCY02Avz4vE14v_Gr4l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_
        Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17
        CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0
        I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I
        8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73
        UjIFyTuYvjfUn3kuDUUUU
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is better to use SYSCTL_TWO instead of &two, and then we can
remove the variable "two" in net/core/sysctl_net_core.c.

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---
 net/core/sysctl_net_core.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 8295e58..cf00dd7 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -25,7 +25,6 @@
 
 #include "dev.h"
 
-static int two = 2;
 static int three = 3;
 static int int_3600 = 3600;
 static int min_sndbuf = SOCK_MIN_SNDBUF;
@@ -390,7 +389,7 @@ static struct ctl_table net_core_table[] = {
 		.extra2		= SYSCTL_ONE,
 # else
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &two,
+		.extra2		= SYSCTL_TWO,
 # endif
 	},
 # ifdef CONFIG_HAVE_EBPF_JIT
@@ -401,7 +400,7 @@ static struct ctl_table net_core_table[] = {
 		.mode		= 0600,
 		.proc_handler	= proc_dointvec_minmax_bpf_restricted,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &two,
+		.extra2		= SYSCTL_TWO,
 	},
 	{
 		.procname	= "bpf_jit_kallsyms",
@@ -546,7 +545,7 @@ static struct ctl_table net_core_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &two,
+		.extra2		= SYSCTL_TWO,
 	},
 	{
 		.procname	= "devconf_inherit_init_net",
-- 
2.1.0

