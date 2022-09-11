Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 072705B4CD0
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 11:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbiIKJCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 05:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbiIKJCs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 05:02:48 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C68BC39BB8;
        Sun, 11 Sep 2022 02:02:45 -0700 (PDT)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MQNtB2JsbzNm9f;
        Sun, 11 Sep 2022 16:58:10 +0800 (CST)
Received: from cgs.huawei.com (10.244.148.83) by
 kwepemi500012.china.huawei.com (7.221.188.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sun, 11 Sep 2022 17:02:42 +0800
From:   Gaosheng Cui <cuigaosheng1@huawei.com>
To:     <gregory.greenman@intel.com>, <kvalo@kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <luciano.coelho@intel.com>,
        <johannes.berg@intel.com>, <cuigaosheng1@huawei.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH 2/2] iwlwifi: remove unused no_sleep_autoadjust declaration
Date:   Sun, 11 Sep 2022 17:02:41 +0800
Message-ID: <20220911090241.3207201-3-cuigaosheng1@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220911090241.3207201-1-cuigaosheng1@huawei.com>
References: <20220911090241.3207201-1-cuigaosheng1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.244.148.83]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

no_sleep_autoadjust has been removed since
commit 84965795b290 ("iwlwifi: remove no_sleep_autoadjust"),
so remove it.

Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/power.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/power.h b/drivers/net/wireless/intel/iwlwifi/dvm/power.h
index f38201ce1e99..1a688d942bca 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/power.h
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/power.h
@@ -23,6 +23,4 @@ int iwl_power_set_mode(struct iwl_priv *priv, struct iwl_powertable_cmd *cmd,
 int iwl_power_update_mode(struct iwl_priv *priv, bool force);
 void iwl_power_initialize(struct iwl_priv *priv);
 
-extern bool no_sleep_autoadjust;
-
 #endif  /* __iwl_power_setting_h__ */
-- 
2.25.1

