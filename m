Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFDB76A5269
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 05:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjB1Epi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 23:45:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbjB1Eph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 23:45:37 -0500
X-Greylist: delayed 5507 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 27 Feb 2023 20:45:34 PST
Received: from m126.mail.126.com (m126.mail.126.com [220.181.12.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D21BEF77C;
        Mon, 27 Feb 2023 20:45:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version:
        Content-Type; bh=MFeVxAwYz/xvNoTdPBvnkTBXbkgPV+SNjLbq1nLISn0=;
        b=Va6I7s/AXVBe67xgtNJU8J8fvtHw5HS3aLMkQxuzudUyYTnkzPpAn2ksfskrpQ
        mRAvbkwhp/E/1hw2ykSoWGuD6es+XUYMNd36EKQUZdemu7Safq7nSCR8udocEn/I
        vLDznIAhvD2n+x+navz0KqvxxCPckOKhmviXusdsARouI=
Received: from localhost.localdomain (unknown [116.128.244.169])
        by zwqz-smtp-mta-g2-1 (Coremail) with SMTP id _____wDHFI4scf1jHWq2AQ--.18152S2;
        Tue, 28 Feb 2023 11:12:45 +0800 (CST)
From:   lingfuyi <lingfuyi@126.com>
To:     jhs@mojatatu.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lingfuyi <lingfuyi@kylinos.cn>, k2ci <kernel-bot@kylinos.cn>
Subject: [PATCH] sched: delete some api is not used
Date:   Tue, 28 Feb 2023 11:12:41 +0800
Message-Id: <20230228031241.1675263-1-lingfuyi@126.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wDHFI4scf1jHWq2AQ--.18152S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7JFW7ZFy7WF4fJr4kKF1fCrg_yoWfXFc_W3
        Wjgw48GFWq9F10k3y2gw45tFWFqF42k3y8Gwn2ga98Aay8W3y8uF4kCan5Ar1DGFn2v3W5
        Za1DZF98Gw4IgjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUj_OzDUUUUU==
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: polqwwxx1lqiyswou0bp/1tbiqB4jR1pD-vTo8AABsY
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: lingfuyi <lingfuyi@kylinos.cn>

fix compile errors like this:
net/sched/cls_api.c:141:13: error: ‘tcf_exts_miss_cookie_base_destroy’
defined but not used [-Werror=unused-function]

Reported-by: k2ci <kernel-bot@kylinos.cn>
Signed-off-by: lingfuyi <lingfuyi@kylinos.cn>
---
 net/sched/cls_api.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 3569e2c3660c..eca9e60440df 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -138,9 +138,6 @@ tcf_exts_miss_cookie_base_alloc(struct tcf_exts *exts, struct tcf_proto *tp,
 	return 0;
 }
 
-static void tcf_exts_miss_cookie_base_destroy(struct tcf_exts *exts)
-{
-}
 #endif /* IS_ENABLED(CONFIG_NET_TC_SKB_EXT) */
 
 static u64 tcf_exts_miss_cookie_get(u32 miss_cookie_base, int act_index)
-- 
2.25.1

