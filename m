Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 478FC5F8466
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 10:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiJHIsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Oct 2022 04:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiJHIsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Oct 2022 04:48:22 -0400
Received: from mail.nfschina.com (mail.nfschina.com [124.16.136.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C848B4C027;
        Sat,  8 Oct 2022 01:48:20 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 7EBBE1E80D72;
        Sat,  8 Oct 2022 16:42:33 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 0ndyINIC0L9d; Sat,  8 Oct 2022 16:42:30 +0800 (CST)
Received: from localhost.localdomain (unknown [219.141.250.2])
        (Authenticated sender: zeming@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id C5B121E80D4D;
        Sat,  8 Oct 2022 16:42:30 +0800 (CST)
From:   Li zeming <zeming@nfschina.com>
To:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li zeming <zeming@nfschina.com>
Subject: [PATCH] =?UTF-8?q?net:=20sched:=20Remove=20unnecessary=20?= =?UTF-8?q?=E2=80=980=E2=80=99=20values=20from=20err?=
Date:   Sat,  8 Oct 2022 16:48:08 +0800
Message-Id: <20221008084808.4650-1-zeming@nfschina.com>
X-Mailer: git-send-email 2.18.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The err variable is assigned as it is used, it does not need to
initialize the assignment.

Signed-off-by: Li zeming <zeming@nfschina.com>
---
 net/sched/act_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 817065aa2833..19e4cef35e09 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -257,7 +257,7 @@ static int tcf_action_offload_add_ex(struct tc_action *action,
 	};
 	struct flow_offload_action *fl_action;
 	u32 in_hw_count = 0;
-	int num, err = 0;
+	int num, err;
 
 	if (tc_act_skip_hw(action->tcfa_flags))
 		return 0;
-- 
2.18.2

