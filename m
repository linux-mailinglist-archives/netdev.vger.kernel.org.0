Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50C862AB189
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 08:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729626AbgKIHDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 02:03:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728873AbgKIHDu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 02:03:50 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02FD8C0613CF;
        Sun,  8 Nov 2020 23:03:49 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id z24so6350863pgk.3;
        Sun, 08 Nov 2020 23:03:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:from:to:cc:subject:date;
        bh=0SbHVnsQQJvFkpVHbZIgWsO8nmWw6A8xVPT2RRJaTF4=;
        b=sXrXAtxaQsNwLQrjsirXFAXfgcEDfyLl046kKuCQJCPfLW4RImPZdmLKHmwsiRbwsO
         TGXq6CcaMVMNN59wi02OWgAwqFL7vq/ikha5GinDnoRBZWIOaqTCvmfa6QWbI6Xy81xu
         JiDLhwigHbs2nnSqhvnRKM+p+L9SSXDBEhfm9br74gWctkETZAxNbMLC5Qau2KHi5OR8
         ZIgRe11dgRwRdfvvRfjQjDgXgOt+yBSTqCbJZUZ260kCtUl/wpc4lxOpdB7fJgy3GaQT
         xGEQndK3KG3YrgdENx9NQ4NfcpYsBj6/HAIBSGNuVT0eauFYgYGyvKYsIyZ4P7Y4cd9F
         7Kig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:from:to:cc:subject:date;
        bh=0SbHVnsQQJvFkpVHbZIgWsO8nmWw6A8xVPT2RRJaTF4=;
        b=Mczm0ty9xj061KlaE9LWuKGYfCFk5ZodXyqez4pQdB2EDHA9ejzZoPQRxcTdDpG9We
         dB7drpb/JHVFV8mEzagznF4kcauj7Pa8+Q4n/vFbeFOIhW0IasdLe3cIF7eHtBCjOw3K
         IkJFlp/0brielOdukH4wLJBD28BBmzPcdWskoCbYhX92PMnecv6fGSoB82lYYlH0Jdg8
         5x9dNBTweQvbzNfJwV7owXjUPpEERxeBQvDey5UmhFYNgAHE60LyhzS/k0B/K/rgBp+Q
         0uOEjZqKyGcxbllAK2+jZD+uf0zibkFoTRem6p8TkHhvjgTTcSKL0Segqs1ZDom1e3DS
         5qKw==
X-Gm-Message-State: AOAM533gv2R0gmjffSLsSp99JN1WMR29SVuulzg7tTyP4uNRr1ASxEVi
        ypWmxNelK+WoYV+WCeqBU5Y=
X-Google-Smtp-Source: ABdhPJykN4eRZUlXagLIeSA0gYzMHpZjuWYX/x8HGLm8sWYxkLF0yxyFWqFX0epGvDoQrabTiyUOJg==
X-Received: by 2002:a62:77c3:0:b029:18b:b3df:8c6c with SMTP id s186-20020a6277c30000b029018bb3df8c6cmr12493084pfc.17.1604905429464;
        Sun, 08 Nov 2020 23:03:49 -0800 (PST)
Received: from localhost.localdomain ([154.93.3.113])
        by smtp.gmail.com with ESMTPSA id d18sm10029776pfo.133.2020.11.08.23.03.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Nov 2020 23:03:48 -0800 (PST)
Message-ID: <5fa8e9d4.1c69fb81.5d889.5c64@mx.google.com>
X-Google-Original-Message-ID: <1604905337-57491-1-git-send-email---global>
From:   menglong8.dong@gmail.com
X-Google-Original-From: --global
To:     kuba@kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andrii@kernel.org,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Menglong Dong <dong.menglong@zte.com.cn>
Subject: [PATCH] net: sched: fix misspellings using misspell-fixer tool
Date:   Mon,  9 Nov 2020 02:02:17 -0500
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>

Some typos are found out by misspell-fixer tool:

$ misspell-fixer -rnv ./net/sched/
./net/sched/act_api.c:686
./net/sched/act_bpf.c:68
./net/sched/cls_rsvp.h:241
./net/sched/em_cmp.c:44
./net/sched/sch_pie.c:408

Fix typos found by misspell-fixer.

Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
---
 net/sched/act_api.c  | 2 +-
 net/sched/act_bpf.c  | 2 +-
 net/sched/cls_rsvp.h | 2 +-
 net/sched/em_cmp.c   | 2 +-
 net/sched/sch_pie.c  | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 1341c59c2f40..60e1572ba606 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -683,7 +683,7 @@ static struct tc_action_ops *tc_lookup_action(struct nlattr *kind)
 	return res;
 }
 
-/*TCA_ACT_MAX_PRIO is 32, there count upto 32 */
+/*TCA_ACT_MAX_PRIO is 32, there count up to 32 */
 #define TCA_ACT_MAX_PRIO_MASK 0x1FF
 int tcf_action_exec(struct sk_buff *skb, struct tc_action **actions,
 		    int nr_actions, struct tcf_result *res)
diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
index a4c7ba35a343..e48e980c3b93 100644
--- a/net/sched/act_bpf.c
+++ b/net/sched/act_bpf.c
@@ -65,7 +65,7 @@ static int tcf_bpf_act(struct sk_buff *skb, const struct tc_action *act,
 	 * In case a different well-known TC_ACT opcode has been
 	 * returned, it will overwrite the default one.
 	 *
-	 * For everything else that is unkown, TC_ACT_UNSPEC is
+	 * For everything else that is unknown, TC_ACT_UNSPEC is
 	 * returned.
 	 */
 	switch (filter_res) {
diff --git a/net/sched/cls_rsvp.h b/net/sched/cls_rsvp.h
index d36949d9382c..2e288f88ff02 100644
--- a/net/sched/cls_rsvp.h
+++ b/net/sched/cls_rsvp.h
@@ -238,7 +238,7 @@ static void rsvp_replace(struct tcf_proto *tp, struct rsvp_filter *n, u32 h)
 		}
 	}
 
-	/* Something went wrong if we are trying to replace a non-existant
+	/* Something went wrong if we are trying to replace a non-existent
 	 * node. Mind as well halt instead of silently failing.
 	 */
 	BUG_ON(1);
diff --git a/net/sched/em_cmp.c b/net/sched/em_cmp.c
index a4d09b1fb66a..f17b049ea530 100644
--- a/net/sched/em_cmp.c
+++ b/net/sched/em_cmp.c
@@ -41,7 +41,7 @@ static int em_cmp_match(struct sk_buff *skb, struct tcf_ematch *em,
 		break;
 
 	case TCF_EM_ALIGN_U32:
-		/* Worth checking boundries? The branching seems
+		/* Worth checking boundaries? The branching seems
 		 * to get worse. Visit again.
 		 */
 		val = get_unaligned_be32(ptr);
diff --git a/net/sched/sch_pie.c b/net/sched/sch_pie.c
index c65077f0c0f3..5a457ff61acd 100644
--- a/net/sched/sch_pie.c
+++ b/net/sched/sch_pie.c
@@ -405,7 +405,7 @@ void pie_calculate_probability(struct pie_params *params, struct pie_vars *vars,
 	/* We restart the measurement cycle if the following conditions are met
 	 * 1. If the delay has been low for 2 consecutive Tupdate periods
 	 * 2. Calculated drop probability is zero
-	 * 3. If average dq_rate_estimator is enabled, we have atleast one
+	 * 3. If average dq_rate_estimator is enabled, we have at least one
 	 *    estimate for the avg_dq_rate ie., is a non-zero value
 	 */
 	if ((vars->qdelay < params->target / 2) &&
-- 
2.25.1


