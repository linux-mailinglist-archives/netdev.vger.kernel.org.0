Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 150B56C5EC3
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 06:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbjCWF2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 01:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjCWF2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 01:28:36 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D45C2E38C;
        Wed, 22 Mar 2023 22:28:35 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id x15so10168099pjk.2;
        Wed, 22 Mar 2023 22:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679549315;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4oNiPMgT2WF79XbVwtiVFhrIxGhEGUWaydA7Ji4BcuE=;
        b=KC7JB6eopXoSFvO1k+5gYA1IQdc87NBFl1W0lAl436lxLjHMYuH+qcxLSVCjWMPSiA
         xxOGa28Y++kNho9z+oOICpONkVhNekyPvLiR/CLjni6IPgcdg5hJADH7JaoEDy6Y2NQP
         DczF2MMQebnhTf5x2LIt56R9nOWQPgSQDiUHJxDx6LVwRyEQtCTxPXzUkfuC9pOXW/3M
         7gJioiFhKGr1eDRl1up3O24uoUq+5Wia5fdKNR373PFxI5YWDivRSY8ZKb4EzJ/Zzdb2
         X0XZ8kSamxyqCQBmRVSCLbkuLbGGVVckhr35ftlR0zxOTYsbUX0nVN7t1fVE1xV8xUsg
         +HMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679549315;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4oNiPMgT2WF79XbVwtiVFhrIxGhEGUWaydA7Ji4BcuE=;
        b=BpQTUSSPasPhv3sJEPZjh14hSPiEBEDzfI6oyM/nfvKGh7H+ulxd3Olf6NSKY4s/7P
         zUGF5xePdSeNT8H/WMUdxBdXso+4BBRRWgC0PlP7TdNR+UR2JLhBGti8bSjsnERAZHna
         WeJqVx3E+JjhqwwvkUo/+oIB/CO1InToi1ep3NRalvRo2N+rUKvhXxao+T6LI/d52Lj4
         OX7d9WfLu3BnTJJRLYrYy086oI3m9MvTnby2Z2MVv0RbiKYFuAJ6jKqskn/K1tCb7Eok
         Uug+C5BgYAs1RZAkNYDoBBXXM4znq2JZSQ3cp/G+4eEiKXfsIqc/43dsuXo7oMI2uME4
         HBhQ==
X-Gm-Message-State: AO0yUKVPf9iJRPGkNh1HFifxm3OCzpoZXcTHfDiHWrsHr8I5UycSDSf7
        h6iW5SK6IYhY+Oq07QoXfCs=
X-Google-Smtp-Source: AK7set9hcPb2iDVHxzi7DMbLrgA63WpFcMrKIoo58Cv0WKXK5QP9vHI8NhhwOIfYCKCj+Z8kq82q1A==
X-Received: by 2002:a05:6a20:1e48:b0:da:f525:e629 with SMTP id cy8-20020a056a201e4800b000daf525e629mr1989720pzb.53.1679549312427;
        Wed, 22 Mar 2023 22:28:32 -0700 (PDT)
Received: from awk.. (arc.lsta.media.kyoto-u.ac.jp. [130.54.10.65])
        by smtp.gmail.com with ESMTPSA id n6-20020aa79046000000b005ae02dc5b94sm10846015pfo.219.2023.03.22.22.28.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 22:28:32 -0700 (PDT)
From:   Taichi Nishimura <awkrail01@gmail.com>
To:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        shuah@kernel.org, Taichi Nishimura <awkrail01@gmail.com>
Subject: [PATCH] fix typos in net/sched/* files
Date:   Thu, 23 Mar 2023 14:27:13 +0900
Message-Id: <20230323052713.858987-1-awkrail01@gmail.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes typos in net/sched/* files.

Signed-off-by: Taichi Nishimura <awkrail01@gmail.com>
---
 net/sched/cls_flower.c | 2 +-
 net/sched/em_meta.c    | 2 +-
 net/sched/sch_pie.c    | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 475fe222a855..cc49256d5318 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -1057,7 +1057,7 @@ static void fl_set_key_pppoe(struct nlattr **tb,
 	 * because ETH_P_PPP_SES was stored in basic.n_proto
 	 * which might get overwritten by ppp_proto
 	 * or might be set to 0, the role of key_val::type
-	 * is simmilar to vlan_key::tpid
+	 * is similar to vlan_key::tpid
 	 */
 	key_val->type = htons(ETH_P_PPP_SES);
 	key_mask->type = cpu_to_be16(~0);
diff --git a/net/sched/em_meta.c b/net/sched/em_meta.c
index 49bae3d5006b..af85a73c4c54 100644
--- a/net/sched/em_meta.c
+++ b/net/sched/em_meta.c
@@ -44,7 +44,7 @@
  * 	be provided for non-numeric types.
  *
  * 	Additionally, type dependent modifiers such as shift operators
- * 	or mask may be applied to extend the functionaliy. As of now,
+ * 	or mask may be applied to extend the functionality. As of now,
  * 	the variable length type supports shifting the byte string to
  * 	the right, eating up any number of octets and thus supporting
  * 	wildcard interface name comparisons such as "ppp%" matching
diff --git a/net/sched/sch_pie.c b/net/sched/sch_pie.c
index 265c238047a4..2152a56d73f8 100644
--- a/net/sched/sch_pie.c
+++ b/net/sched/sch_pie.c
@@ -319,7 +319,7 @@ void pie_calculate_probability(struct pie_params *params, struct pie_vars *vars,
 	}
 
 	/* If qdelay is zero and backlog is not, it means backlog is very small,
-	 * so we do not update probabilty in this round.
+	 * so we do not update probability in this round.
 	 */
 	if (qdelay == 0 && backlog != 0)
 		update_prob = false;
-- 
2.37.3

