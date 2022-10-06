Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A39FA5F6580
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 14:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbiJFMBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 08:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbiJFMBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 08:01:45 -0400
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 572B431EF4;
        Thu,  6 Oct 2022 05:01:42 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VRQLcOW_1665057698;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0VRQLcOW_1665057698)
          by smtp.aliyun-inc.com;
          Thu, 06 Oct 2022 20:01:39 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     claudiu.manoil@nxp.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] net: enetc: Remove duplicated include in enetc_qos.c
Date:   Thu,  6 Oct 2022 20:01:36 +0800
Message-Id: <20221006120136.27020-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net/pkt_sched.h is included twice in enetc_qos.c,
remove one of them.

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2334
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_qos.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index e6416332ec79..a842e1999122 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -7,7 +7,6 @@
 #include <linux/math64.h>
 #include <linux/refcount.h>
 #include <net/pkt_cls.h>
-#include <net/pkt_sched.h>
 #include <net/tc_act/tc_gate.h>
 
 static u16 enetc_get_max_gcl_len(struct enetc_hw *hw)
-- 
2.20.1.7.g153144c

