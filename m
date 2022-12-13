Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A931F64B02D
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 08:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234533AbiLMHHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 02:07:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbiLMHHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 02:07:21 -0500
Received: from out30-6.freemail.mail.aliyun.com (out30-6.freemail.mail.aliyun.com [115.124.30.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6076BFCF4;
        Mon, 12 Dec 2022 23:07:19 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R901e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=jiapeng.chong@linux.alibaba.com;NM=0;PH=DS;RN=11;SR=0;TI=SMTPD_---0VXCoiVi_1670915230;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0VXCoiVi_1670915230)
          by smtp.aliyun-inc.com;
          Tue, 13 Dec 2022 15:07:16 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     gregory.greenman@intel.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] iwlwifi: mvm: Remove the unused function iwl_dbgfs_is_match()
Date:   Tue, 13 Dec 2022 15:07:08 +0800
Message-Id: <20221213070708.13619-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function iwl_dbgfs_is_match is defined in the debugfs-vif.c file,
but not called elsewhere, so remove this unused function.

drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c:441:21: warning: unused function 'iwl_dbgfs_is_match'.

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3433
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
index 78d8b37eb71a..3779ac040ba0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
@@ -438,13 +438,6 @@ static ssize_t iwl_dbgfs_bf_params_read(struct file *file,
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
-static inline char *iwl_dbgfs_is_match(char *name, char *buf)
-{
-	int len = strlen(name);
-
-	return !strncmp(name, buf, len) ? buf + len : NULL;
-}
-
 static ssize_t iwl_dbgfs_os_device_timediff_read(struct file *file,
 						 char __user *user_buf,
 						 size_t count, loff_t *ppos)
-- 
2.20.1.7.g153144c

