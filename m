Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2AC058955F
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 02:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238429AbiHDAha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 20:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237066AbiHDAh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 20:37:29 -0400
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A3E3190B;
        Wed,  3 Aug 2022 17:37:27 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R971e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VLJRyKp_1659573444;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0VLJRyKp_1659573444)
          by smtp.aliyun-inc.com;
          Thu, 04 Aug 2022 08:37:24 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     michael.chan@broadcom.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH net-next] bnxt_en: Remove duplicated include bnxt_devlink.c
Date:   Thu,  4 Aug 2022 08:37:22 +0800
Message-Id: <20220804003722.54088-1-yang.lee@linux.alibaba.com>
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

bnxt_ethtool.h is included twice in bnxt_devlink.c,
remove one of them.

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=1817
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 14df8cfc2946..059f96f7a96f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -21,7 +21,6 @@
 #include "bnxt_ptp.h"
 #include "bnxt_coredump.h"
 #include "bnxt_nvm_defs.h"
-#include "bnxt_ethtool.h"
 
 static void __bnxt_fw_recover(struct bnxt *bp)
 {
-- 
2.20.1.7.g153144c

